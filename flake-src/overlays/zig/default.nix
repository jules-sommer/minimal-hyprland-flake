{
  channels,
  zig-overlay,
  zls,
  ...
}:

(final: prev: {
  zig = zig-overlay.packages.${prev.system}.master;
  zls = zls.packages.${prev.system}.zls;
})
