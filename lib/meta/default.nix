{ lib, ... }: {
  getMeta = path:
    assert lib.assertMsg (builtins.pathExists path) "File does not exist";
    let
      file = builtins.readFile path;
      meta = builtins.fromTOML file;
    in meta;
}
