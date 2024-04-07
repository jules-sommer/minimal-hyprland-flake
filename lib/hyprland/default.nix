{ lib, inputs, ... }:
let inherit (lib) assertMsg mkIf;
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
        mod = if (mod != null || mod == true) then mod else "$mod";
        shift = mkIf (shift != null || shift == true) "SHIFT";
        key = lib.toUpper key;
        exec = mkIf (exec == true) "exec";
      };

      hasShift = (shift != null && shift == true);
      hasExec = (exec != null && exec == true);
    in { inherit final hasShift hasExec; };
  #if hasShift then ("${final.mod} ${final.shift},") else "${final.mod},";
  # "$mod SHIFT, J, exec, pypr shift_monitors -1";

}

