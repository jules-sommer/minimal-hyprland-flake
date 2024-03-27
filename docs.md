## Theming

Theming in this flake is done through nix-colors, a flake that returns base16 colour palettes for common and open-source themes such as tokyo-night, etc. Several library wrappers exist in this flake to assist with theming, including the `getTheme: theme:` function that fetches and returns the specified nix-colors base16 theme while also asserting some type validation to ensure the theme exists.

```nix
# using nix-colors with this helper looks like this! :3
lib.xeta.getTheme (config.xeta.home.desktop.hyprland.theme)
```

Here this helper is shown used with the setting specified in `xeta.home.desktop.hyprland.theme` which takes a `types.enum ([ ... @theme-strings ])` and therefore can be used as a global flake reference to the specified desktop environment theme.

## Essential system components

- [] Hyprland
- [] Nushell
- [] Alacritty
- [] Starship
- [] Zellij
- [] Git, GitHub Desktop, jujutsu, lazygit, gh, graphite-cli
- [] Rust, Cargo, Rust Analyzer
- [] VSCode
- [] Floorp
- [] Helix
- [] Networking tweaks
