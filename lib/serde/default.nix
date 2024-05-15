{ lib, inputs, ... }:
let
  std = inputs.nix-std.outputs.lib;
  getWorkDir = builtins.getEnv "PWD";
in
{
  serialize = std.serde;
  list = std.list;
  path = std.path;
  optional = std.optional;
  num = std.num;
  nullable = std.nullable;

  absolutise = { path, workDir ? getWorkDir}: if builtins.substring 0 1 path == "/" then
    path
  else
    "${getWorkDir}/${path}";
    
  normalizePath = path: builtins.path {
    path = path;
  };
}

