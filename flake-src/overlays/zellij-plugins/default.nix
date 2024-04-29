{
  self,
  zjstatus,
  zjharpoon,
  zjmonocle,
  ...
}:
(final: prev: {
  zjstatus = zjstatus.packages.${prev.system}.default;
  zjmonocle = zjmonocle.packages.${prev.system}.default;
  zjharpoon = zjharpoon.packages.${prev.system}.default;
})
