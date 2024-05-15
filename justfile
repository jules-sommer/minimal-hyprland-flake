base-rebuild update="false":
  #!/run/current-system/sw/bin/nu
  print "Building system flake..."
  with-env [FLAKE $"(pwd)"] {
    print $env.FLAKE
    nu ./.build/rebuild.nu
  }


# Default NixOS rebuild command

rebuild:
    sudo nixos-rebuild switch --flake .#

# Rebuild and update the flake lock file
rebuild-update:
    sudo nixos-rebuild switch --flake .# --update-input

# Rebuild for a specific host or configuration
rebuild-host host:
    sudo nixos-rebuild switch --flake .#{{host}}

# Update flake inputs
update:
    nix flake update

# Garbage collection to free up space
gc:
    sudo nix-collect-garbage -d

# Build the flake without switching to it, useful for testing
build:
    nix build .#

# Building a specific package within the flake
build-package package:
    nix build .#{{package}}

# Show flake outputs
show-outputs:
    nix flake show

# Just an example of rolling back
rollback:
    sudo nixos-rebuild switch --rollback

