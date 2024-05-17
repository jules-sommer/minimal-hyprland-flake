let flake_dir = $env.FLAKE;
let files_list = (ls $env.FLAKE | where name =~ "flake.lock");

let flake_lock = (get_flake_lock --dir $flake_dir);
let time_since_update = ($flake_lock | get Modified) | get 0;

print $"Last update was @ (ansi magenta_bold)($time_since_update)(ansi reset)."

if $time_since_update > 1day {
  print $"\n\nIt's been (ansi magenta_bold)($time_since_update)(ansi reset) since this flake's lockfile has been updated, update now? [y/n]:"
  let user_agrees = (input --numchar 1) 
  
  if $user_agrees == 'y' {
    print "Updating flake..."
    # let update = (nix flake update) 
  } else {
    print "Skipping update..."    
  } 
} else {
  print $"This flake is up to date, lock updated @ (ansi green_bold)($time_since_update)(ansi reset)."
}

def get_flake_lock [
  --dir (-d): path
] {
  let flake = if ($dir != null) {
    $dir
  } else {
    $env.FLAKE
  }

  let files_list = (ls $flake | where name =~ "flake.lock");
  if ($files_list | is-empty) {
    error make {
      msg: $"No flake.lock found in flake directory."
      label: {
        text: $"You passed in ($flake)"
        span: (metadata $flake).span
      }
    }
  }

  return $files_list;  
}

export def rebuild [
  --dir (-d): path
  --hostname (-h): string
] {
  if $hostname == null {
    $hostname = $env.HOSTNAME
  }
  print $"Rebuilding @ (ansi magenta_bold)($hostname)(ansi reset)..."
  # sudo nixos-rebuild switch --cores 12 --flake
}
