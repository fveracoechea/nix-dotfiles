# Ultrashell Theme input boundaries

Research date: 2026-08-29. Dotfiles revision researched:
`0a5836a287468de18a17b9e0d2e8eee26f85ddb4`. Ultrashell revision researched:
`ebb2d5ab499ed64d9fa375c04db5fee692e6b709`. AGS revision researched:
`e169694390548dfd38ff40f1ef2163d6c3ffe3ea` (v3.1.1).

## TL;DR verdict

The pinned Ultrashell has no public Theme input. Its effective Theme boundary is seven private
Sass variables: primary, secondary, text, subtext, base, crust, and border. AGS compiles the whole
SCSS graph while `ags bundle` builds the executable, inlines the resulting CSS into JavaScript,
and applies that CSS when Ultrashell starts. Ultrashell does not read a Theme file, environment
variable, command-line argument, or request at runtime.

The current package can be changed with `overrideAttrs`, but it cannot be changed with a package
argument through `override`. A dotfiles-side `postPatch` could replace
`styles/_variables.scss`, but that would make this repository depend on Ultrashell's private file
layout and private rendering roles. It would violate the ownership goal in ADR 0002.

The best boundary is a small upstream change: make the default Ultrashell package an overridable
package function with a `theme` argument. The argument should accept the stable,
application-neutral subset of the Selected Theme. Ultrashell must validate that input and map it
to its seven private Sass roles before `ags bundle` runs. The Home Manager Theme Adapter can then
install `dotfilesPkgs.ultrashell.override { theme = ...; }`. This keeps selection in the dotfiles
Home,
keeps shell-specific rendering in Ultrashell, and preserves rebuild-only switching.

## Decision context

The Wayfinder destination requires `dotfiles.theme.name` plus a system rebuild to be the complete
switching interface. Runtime Theme state, file watchers, signals, and hot reload are outside the
map. It also requires each application to own its Theme integration
(https://github.com/fveracoechea/dotfiles/issues/15). ADR 0002 states the same ownership rule:
each application applies the Theme itself rather than through a unified framework
(https://github.com/fveracoechea/dotfiles/blob/0a5836a287468de18a17b9e0d2e8eee26f85ddb4/docs/adr/0002-per-application-manual-theming.md#L1-L5).

Today, the repository pins Ultrashell as a flake input and makes its `nixpkgs` input follow the
repository's `nixpkgs`
(https://github.com/fveracoechea/dotfiles/blob/0a5836a287468de18a17b9e0d2e8eee26f85ddb4/flake.nix#L25-L26).
The lock selects the exact Ultrashell revision above
(https://github.com/fveracoechea/dotfiles/blob/0a5836a287468de18a17b9e0d2e8eee26f85ddb4/flake.lock#L976-L995).
`packages/default.nix` exposes only the fixed default package as `dotfilesPkgs.ultrashell`
(https://github.com/fveracoechea/dotfiles/blob/0a5836a287468de18a17b9e0d2e8eee26f85ddb4/packages/default.nix#L21-L32).
The Hyprland Home Manager module adds that package to `home.packages`
(https://github.com/fveracoechea/dotfiles/blob/0a5836a287468de18a17b9e0d2e8eee26f85ddb4/modules/home-manager/hyprland/packages.nix#L8-L18)
and starts its unqualified executable once with Hyprland
(https://github.com/fveracoechea/dotfiles/blob/0a5836a287468de18a17b9e0d2e8eee26f85ddb4/modules/home-manager/hyprland/settings.nix#L23-L31).
There is no Ultrashell Home Manager module, option, generated file, or runtime argument in the
current integration.

## 1. Theme inputs in the pinned source

The source has one concentrated set of color inputs:
`styles/_variables.scss` defines these seven values
(https://github.com/fveracoechea/ultrashell/blob/ebb2d5ab499ed64d9fa375c04db5fee692e6b709/styles/_variables.scss#L1-L8):

| Private Ultrashell role | Pinned value | Current meaning |
|---|---:|---|
| `$color-primary` | `hsl(217deg, 92%, 76%)` | Main accent and active state |
| `$color-secondary` | `hsl(0deg, 59%, 88%)` | Secondary accent |
| `$color-text` | `hsl(226deg, 64%, 88%)` | Main foreground |
| `$color-subtext` | `hsl(228deg, 24%, 72%)` | Muted foreground |
| `$color-base` | `hsl(240deg, 21%, 15%)` | Raised or main background |
| `$color-crust` | `hsl(240deg, 23%, 9%)` | Deep background and contrast foreground |
| `$color-border` | `hsl(233deg, 12%, 39%)` | Border, hover, and inactive surface |

These are rendering roles, not a complete Theme schema. The same file also owns type size,
icon size, spacing, radius, transition, opacity, and z-index constants
(https://github.com/fveracoechea/ultrashell/blob/ebb2d5ab499ed64d9fa375c04db5fee692e6b709/styles/_variables.scss#L10-L72).
The Wayfinder map excludes layout values such as spacing, rounding, and opacity from Theme scope
unless rendering requires them (https://github.com/fveracoechea/dotfiles/issues/15). A future input
must therefore replace only Theme values, not expose the whole Sass variable file as a dotfiles
contract.

`styles/main.scss` loads shared component styles and every widget stylesheet into one root style
graph
(https://github.com/fveracoechea/ultrashell/blob/ebb2d5ab499ed64d9fa375c04db5fee692e6b709/styles/main.scss#L1-L21).
The shared mixins consume private roles to define interaction rendering, for example active and
hover foreground/background pairs
(https://github.com/fveracoechea/ultrashell/blob/ebb2d5ab499ed64d9fa375c04db5fee692e6b709/styles/_mixins.scss#L1-L29).
Widget styles also consume those roles, for example workspaces
(https://github.com/fveracoechea/ultrashell/blob/ebb2d5ab499ed64d9fa375c04db5fee692e6b709/widgets/workspaces/workspaces.scss#L1-L22)
and volume/media surfaces
(https://github.com/fveracoechea/ultrashell/blob/ebb2d5ab499ed64d9fa375c04db5fee692e6b709/widgets/volume/volume.scss#L1-L114).
This is the correct ownership boundary: Ultrashell decides how generic Theme meaning becomes
active, hover, border, media, workspace, and other shell rendering.

## 2. Build-time extension points and style compilation boundary

Ultrashell's flake has only `packages` and `devShells`. The package is created directly with
`pkgs.stdenv.mkDerivation`, copies the complete source to `$out/share`, and runs
`ags bundle app.tsx $out/bin/ultrashell -d "SRC='$out/share'"` in `installPhase`
(https://github.com/fveracoechea/ultrashell/blob/ebb2d5ab499ed64d9fa375c04db5fee692e6b709/flake.nix#L12-L17,
https://github.com/fveracoechea/ultrashell/blob/ebb2d5ab499ed64d9fa375c04db5fee692e6b709/flake.nix#L61-L93).
There is no package function argument for a Theme, source override, extra stylesheet, build hook,
or generated Theme file.

`app.tsx` statically imports `styles/main.scss` and passes the imported string to `app.start`
(https://github.com/fveracoechea/ultrashell/blob/ebb2d5ab499ed64d9fa375c04db5fee692e6b709/app.tsx#L1-L22).
At the pinned AGS revision, the Sass plugin runs `sass` when esbuild loads an SCSS import and
returns the compiled output as text
(https://github.com/Aylur/ags/blob/e169694390548dfd38ff40f1ef2163d6c3ffe3ea/cli/lib/esbuild.go#L54-L88).
The bundle includes that plugin and bundles the application as one ES module
(https://github.com/Aylur/ags/blob/e169694390548dfd38ff40f1ef2163d6c3ffe3ea/cli/lib/esbuild.go#L154-L181,
https://github.com/Aylur/ags/blob/e169694390548dfd38ff40f1ef2163d6c3ffe3ea/cli/lib/esbuild.go#L198-L228).
Finally, `ags bundle` base64-embeds the generated JavaScript in the executable wrapper and writes
it to a runtime file before GJS starts
(https://github.com/Aylur/ags/blob/e169694390548dfd38ff40f1ef2163d6c3ffe3ea/cli/cmd/bundle.go#L15-L32,
https://github.com/Aylur/ags/blob/e169694390548dfd38ff40f1ef2163d6c3ffe3ea/cli/cmd/bundle.go#L96-L139).

Therefore, a change to any Sass Theme input changes the Ultrashell derivation and bundled
executable. That is a natural match for the rebuild-driven Selected Theme. It does not require a
runtime Theme subsystem.

## 3. Nix package override points

Evaluation of the pinned default package on `x86_64-linux` shows `overrideAttrs` is present and
`override` is absent. This follows from the source shape: the flake calls `mkDerivation` directly
instead of passing a package function through `callPackage`
(https://github.com/fveracoechea/ultrashell/blob/ebb2d5ab499ed64d9fa375c04db5fee692e6b709/flake.nix#L61-L93).

The available out-of-tree escape hatch is:

```nix
inputs.ultrashell.packages.${pkgs.system}.default.overrideAttrs (old: {
  # src, patches, postPatch, installPhase, or other derivation attributes
})
```

Nixpkgs documents `overrideAttrs` as useful for out-of-tree changes, but also calls it fragile
because the override is hidden from the package maintainer and can break when the package changes
(https://github.com/NixOS/nixpkgs/blob/f13ff45afd1bb73e640eaa08a7066dbed07e3238/pkgs/README.md#L527-L542).
That warning applies directly to replacing `_variables.scss` in this repository.

For a stable package argument, Nixpkgs `makeOverridable` adds `override` to a function result;
`callPackage` provides this behavior indirectly and preserves it across `overrideAttrs`
(https://github.com/NixOS/nixpkgs/blob/f13ff45afd1bb73e640eaa08a7066dbed07e3238/lib/customisation.nix#L113-L147,
https://github.com/NixOS/nixpkgs/blob/f13ff45afd1bb73e640eaa08a7066dbed07e3238/lib/customisation.nix#L151-L191).
Ultrashell can therefore expose a real Theme override by moving the derivation body to an
argument-taking package file and creating it with `pkgs.callPackage`.

The dotfiles package plumbing does not need an overlay. It can keep the upstream default package
in `dotfilesPkgs`, consistent with ADR 0004's rule that modules use `dotfilesPkgs` instead of
inputs or system-specific package lookup
(https://github.com/fveracoechea/dotfiles/blob/0a5836a287468de18a17b9e0d2e8eee26f85ddb4/docs/adr/0004-dotfiles-enable-namespace.md#L19-L25).
The Home Manager Theme Adapter can apply `.override { theme = ...; }` while module evaluation has
access to the Selected Theme. This avoids trying to make the earlier, host-independent
`dotfilesPkgsFor` construction read Home Manager configuration
(https://github.com/fveracoechea/dotfiles/blob/0a5836a287468de18a17b9e0d2e8eee26f85ddb4/flake.nix#L55-L62,
https://github.com/fveracoechea/dotfiles/blob/0a5836a287468de18a17b9e0d2e8eee26f85ddb4/flake.nix#L139-L163).

## 4. Runtime APIs

Ultrashell itself exposes no Theme runtime API. Its `app.start` call supplies only the static CSS
and `main`; it does not supply `requestHandler`, inspect command-line arguments, or read an
environment/configuration value
(https://github.com/fveracoechea/ultrashell/blob/ebb2d5ab499ed64d9fa375c04db5fee692e6b709/app.tsx#L6-L22).

The pinned AGS library has capabilities that Ultrashell does not use:

- `StartConfig` can receive CSS, Theme names, command-line arguments, and a request handler
  (https://github.com/Aylur/ags/blob/e169694390548dfd38ff40f1ef2163d6c3ffe3ea/lib/gtk4/app.ts#L23-L32).
- `app.apply_css` can load CSS from a path or string at runtime and add it at user priority
  (https://github.com/Aylur/ags/blob/e169694390548dfd38ff40f1ef2163d6c3ffe3ea/lib/gtk4/app.ts#L170-L210).
- `app.start` applies its initial CSS and can register a request handler
  (https://github.com/Aylur/ags/blob/e169694390548dfd38ff40f1ef2163d6c3ffe3ea/lib/gtk4/app.ts#L271-L315).

These are possible upstream extension mechanisms, not current Ultrashell contracts. Loading an
external CSS overlay would also require either the dotfiles repository to know Ultrashell
selectors or Ultrashell to define another stable runtime schema. The Wayfinder scope excludes
runtime switching, so adding that schema has no benefit over a build-time package input.

## 5. Upstream ownership constraints

The repository boundary is strong today. Ultrashell owns its components, Sass roles, selectors,
interaction states, and compilation. Dotfiles owns only the pinned package selection, Home
installation, and launch. This matches the repository rule that modules read wrapped packages
through `dotfilesPkgs`
(https://github.com/fveracoechea/dotfiles/blob/0a5836a287468de18a17b9e0d2e8eee26f85ddb4/CONTEXT.md#L21-L23)
and the per-application Theme ownership decision in ADR 0002.

The required stable extension does not exist at the pinned commit. Because Ultrashell is a
separate locked source, a maintainable contract must first land in Ultrashell and then enter this
repository through a lock update. A local source patch can prove the design, but it must not
become the production ownership boundary.

The upstream repository and this repository have the same GitHub owner. This makes a coordinated
upstream API change practical, but it does not make private Sass names a stable cross-repository
contract. The source of truth remains the upstream repository and pinned commit
(https://github.com/fveracoechea/ultrashell/tree/ebb2d5ab499ed64d9fa375c04db5fee692e6b709).

## 6. Viable integration options

| Option | Technically viable | Ownership result | Assessment |
|---|---|---|---|
| Upstream overridable `theme` package argument | Yes | Dotfiles passes the application-neutral Selected Theme subset; Ultrashell maps it to private roles and compiles SCSS | Recommended |
| Upstream named Theme argument and internal catalog | Yes | Ultrashell owns all values and rendering; dotfiles passes a name | Clean but duplicates the Theme Catalog and cannot accept arbitrary repository Themes without synchronized upstream changes |
| Upstream exported package builder function | Yes | Same ownership as the recommended option | Valid if a default derivation with `.override` cannot express the final contract, but it adds a second flake API |
| Dotfiles `overrideAttrs` plus `postPatch` | Yes | Dotfiles owns `_variables.scss` path and role mapping | Useful only as a short-lived prototype; fragile and not an acceptable production boundary |
| Dotfiles replaces `src` with a patched/forked tree | Yes | Dotfiles owns an upstream source delta | Worse than `postPatch`; upstream the change instead |
| External runtime CSS loaded with `app.apply_css` | Only after an upstream code change | Either dotfiles owns shell selectors, or Ultrashell must add a new runtime schema | Unnecessary for rebuild-only selection and easy to place ownership on the wrong side |
| CLI, environment, IPC, or watched Theme file | Only after an upstream code change | Requires a new runtime state and validation contract | Outside the Wayfinder scope and more complex than the build-time boundary |

## Recommendation

Add the Theme boundary upstream, then consume it through the package override in the Home Manager
Theme Adapter.

The upstream contract should have these properties:

1. The default package is built from an argument-taking package function through `callPackage`,
   so it retains the current default output and gains `.override`.
2. A `theme` argument accepts only the stable, application-neutral values that Ultrashell needs
   from the repository Theme contract. It must not accept a complete replacement SCSS file,
   selectors, widget rules, or the private names in `_variables.scss`.
3. Ultrashell validates required values and maps them to `$color-primary`, `$color-secondary`,
   `$color-text`, `$color-subtext`, `$color-base`, `$color-crust`, and `$color-border` in upstream
   build code. That mapping is shell rendering and stays upstream.
4. The generated Sass input exists before `ags bundle` runs. The normal AGS Sass and bundle path
   then produces one immutable, Theme-specific package.
5. The upstream default reproduces the pinned appearance for standalone users and consumers that
   do not pass a Theme.
6. Dotfiles keeps the upstream default derivation in `dotfilesPkgs`. Its Ultrashell Home Manager
   Theme Adapter installs a specialized derivation equivalent to
   `dotfilesPkgs.ultrashell.override { theme = selectedThemeSubset; }`.
7. A Theme change must alter the derivation and must require only the normal system rebuild. Do
   not add a runtime selector, watcher, mutable Theme state, or fallback to hidden Catppuccin
   values.

This is a deep boundary: dotfiles states what the Selected Theme means; Ultrashell decides how its
surfaces render that meaning.

## Unresolved questions

1. What exact semantic Palette roles will issue 16 define? The upstream argument cannot be named
   precisely until those roles are stable. It should not copy the current Catppuccin names from
   `dotfiles.palette`, which is explicitly hardcoded and temporary
   (https://github.com/fveracoechea/dotfiles/blob/0a5836a287468de18a17b9e0d2e8eee26f85ddb4/modules/core/palette.nix#L1-L33).
2. Does Ultrashell need the Selected Theme's explicit dark/light mode in addition to semantic
   colors? The pinned rendering uses only fixed colors, but future GTK or icon behavior could need
   mode.
3. Should the upstream input receive the complete canonical Palette or a validated smaller
   projection? A complete Palette reduces adapter mapping, while a projection makes the build
   dependency and required roles explicit.
4. Where should input validation live? A plain package function can use Nix assertions, but issue
   20 must decide the failure messages and whether upstream exports a reusable validator.
5. Should the package expose its resolved private Theme mapping in `passthru` for evaluation-only
   tests, or should tests inspect generated Sass/CSS? The answer depends on the validation design
   from issue 21.
6. Should Ultrashell become its own atomic Home Manager module instead of remaining inside the
   Hyprland package and settings files? That ownership question is independent of the package
   boundary but affects where the Theme Adapter lives.
7. Must the first upstream contract support only the two proof Themes, or any valid Theme that
   follows the canonical schema? The recommended attrset boundary supports either policy without
   exposing shell rendering.

## Research checks

- Resolved the local flake input through Nix and confirmed its store source matches lock revision
  `ebb2d5ab499ed64d9fa375c04db5fee692e6b709`.
- Evaluated the pinned package attributes without building it; `overrideAttrs` was present and
  `override` was absent.
- Searched the pinned Ultrashell TypeScript, Nix, and SCSS source for Theme, CSS, environment,
  argument, request, and configuration boundaries.
- Read the pinned AGS Sass plugin, bundler wrapper, GTK4 application CSS API, and Nix packaging
  guide as primary implementation sources.
- No System configuration was built or activated.
