{ lib, ... }:
with lib; rec {
  # Transform a list of keymaps into an attribute set.
  #
  # `transformKeymaps` converts a list of attribute sets, where each attribute set
  # represents a neovim key binding, and returns an attrset of key->value pairs where
  # key is the keybinding and value is the corresponding action.
  # 
  # This is useful for `startup` neovim plugin where bindings are displayed in start screen.
  #
  # Args:
  #   keymaps (list of attr sets): A list of attribute sets where each item contains at least
  #                                a 'key' and an 'action' attribute.
  # Returns:
  #   attr set: An attribute set where each key is a string representing the key binding, and
  #             the value is the corresponding action as a string.
  # Example:
  # ```nix
  #   transformKeymaps [
  #     { key = "gD"; action = "<cmd>lua vim.lsp.buf.declaration()<CR>"; }
  #     { key = "gd"; action = "<cmd>Telescope lsp_definitions<CR>"; }
  #   ]
  #   # This would result in:
  #   {
  #     "gD" = "<cmd>lua vim.lsp.buf.declaration()<CR>";
  #     "gd" = "<cmd>Telescope lsp_definitions<CR>";
  #   }
  # ```
  transformKeymaps = keymaps:
    lib.foldl'
      (acc: elem:
        let
          key = lib.attrByPath [ "key" ] "" elem;
          action = lib.attrByPath [ "action" ] "" elem;
        in
        # Ignore entries without key or action
        if key == "" || action == "" then acc
        else lib.attrsets.recursiveUpdate acc { ${key} = action; }
      )
      { }
      keymaps;
}
