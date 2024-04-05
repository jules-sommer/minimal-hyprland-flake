{ lib, inputs, ... }:
let inherit (lib) assertMsg;
in rec {
  dispatch = cmd: "hyprctl dispatch ${cmd};";
  active_top = cmd: "hyprctl dispatch bringactivetotop;";
  launch = cmd: ''
    hyprctl dispatch exec ${cmd};
    hyprctl dispatch bringactivetotop;
  '';
  pypr = cmd: "pypr exec ${cmd}; ${active_top}";
  scratch = cmd: "pypr toggle ${cmd}; ${active_top}";
  bind = { mod ? null, shift ? null, exec ? true, key, cmd, ... }:
    assert lib.assertMsg (key != null && cmd != null && builtins.typeOf key
      == "string" && builtins.typeOf cmd == "string")
      "bind(): key and cmd are required";
    let
      final = {
        mod = if (mod == null || mod == false) then "$mod" else mod;
        hasShift = if (shift == null || shift == false) then true else false;

        shift = if (shift == null || shift == false) then "," else "SHIFT, ";
        hasExec = if (exec == null || exec == false) then false else true;
        
        key = lib.toUpper "${key}, ";
        exec = if exec == false then "" else "exec, ";
      };
    in if "${final.mod} ${final.shift}${final.key}${final.exec}${cmd};";
  # "$mod SHIFT, J, exec, pypr shift_monitors -1";

}

