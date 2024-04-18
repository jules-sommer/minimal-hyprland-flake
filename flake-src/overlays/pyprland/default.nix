{ ... }:
(final: prev: {
  pyprland = prev.pyprland.overrideAttrs (oldAttrs: {
    src = (builtins.fetchGit { url = "https://github.com/hyprland-community/pyprland"; });
    version = "latest";
  });
})
