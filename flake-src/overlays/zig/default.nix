{ channels, zig-overlay, zls, ... }:

(final: prev: { zig = zig-overlay.packages.${prev.system}.master; })
