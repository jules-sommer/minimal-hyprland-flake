let flake_dir = $env.FLAKE;
let files_list = (ls $env.FLAKE | where name =~ "flake.lock");

let now = date now;
let flake_locked_at = (($files_list | get Modified) | get 0 );

let duration_since_update = ($now - $flake_locked_at)

if $duration_since_update > 1day {
  print $"\n\nIt's been (ansi magenta_bold)($duration_since_update)(ansi reset) since this flake's lockfile has been updated, update now? [y/n]:"
  let user_agrees = (input --numchar 1) 

  if $user_agrees == 'y' {
    print "Updating flake..."
    # let update = (nix flake update) 
  } else {
    print "Skipping update..."    
  } 
}


