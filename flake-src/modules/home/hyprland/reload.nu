watch ~/020_config/waybar --debounce-ms 1000 --recursive true {|op, path, new_path|
  print $op;
  print $path;
  print $new_path;
}