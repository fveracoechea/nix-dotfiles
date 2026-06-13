# Thin Hosts with Focused Modules

Host configurations are thin orchestrators that only import modules. All actual configuration lives in focused modules under `modules/{nixos,darwin,home-manager}/`. This separates machine-specific wiring from reusable, concern-separated configuration.

Home Manager modules are shared across platforms (NixOS and macOS), while system modules are platform-specific. This trade-off favors modularity over self-contained host configs — a host can be understood by reading its imports list, and any module can be reused or disabled independently.
