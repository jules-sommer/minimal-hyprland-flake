{ lib, inputs, ... }: rec {
  assertAttrs = key: attrSet: type:
    assert (builtins.isAttrs attrSet);
    assert (builtins.typeOf key == "string");

    let
      found = {
        value = attrSet.${key};
        type = builtins.typeOf found.value;
      };
    in assert (found.type == type)
      "getConfigValue: expected type ${type}, got ${found.type}";
    found.value;

  types = {
    editor = types.enum [ "helix" "neovim" ];
    file_manager = types.enum [ "joshuto" "yazi" "thunar" ];
  };

  toHomeFile = path: text:
    let attrPath = lib.splitString "/" path;
    in lib.mkMerge
    [ (lib.setAttrByPath ([ "home" "file" ] ++ attrPath) { text = text; }) ];

  hyprlandPkgs = inputs.hyprland.packages;
  getHyprlandPkg = system:
    lib.mkAssert
    (builtins.isAttrs hyprlandPkgs && hyprlandPkgs.${system} != null)
    "getHyprlandPkg: this flake requires hyprland to be an input, could not find attrset @ 'hyprland.packages'."
    (hyprlandPkgs.${system}.hyprland);

  getTheme = theme:
    assert lib.assertMsg (theme != null && builtins.typeOf theme == "string")
      "getConfigValue: theme is null or not of type string";
    inputs.nix-colors.colorSchemes.${theme}.palette;
}

