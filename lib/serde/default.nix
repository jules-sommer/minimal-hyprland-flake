{ lib, inputs, ... }: {
  serialize = inputs.nix-std.outputs.lib.serde;
  std = inputs.nix-std.outputs.lib;
}

