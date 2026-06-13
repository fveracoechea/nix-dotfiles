# Per-Application Manual Theming

Themes are configured per-application in each module rather than via a unified theming framework like Stylix. A shared `customUtils.catppuccin` attribute set provides a single source of truth for the color palette, but each module applies it manually to its respective application.

This trade-off favors granular control and avoids the complexity of a theming framework. It also makes future multi-theme support easier — a module can be updated to accept a different palette without touching a framework's global configuration.
