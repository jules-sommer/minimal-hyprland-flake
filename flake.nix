{
  description = "Jules' Xetamine Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-23.11";

    nixos-conf-editor = {
      url = "github:snowfallorg/nixos-conf-editor";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snowfall-flake = {
      url = "github:snowfallorg/flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snowfall-drift = {
      url = "github:snowfallorg/drift";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snowfall-thaw = {
      url = "github:snowfallorg/thaw";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xremap-flake = {
      url = "github:xremap/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors = { url = "github:misterio77/nix-colors"; };

    systems.url = "github:nix-systems/x86_64-linux";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    let
      lib = inputs.snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;
        snowfall = {
          namespace = "xeta";
          # Move .nix files to  `./nixos/` dir for organization.
          root = ./flake-src;

          meta = {
            name = "xeta";
            title = "Xetamine (jules@xeta) Sys Flake";
          };
        };
      };
    in lib.mkFlake {
      channels-config = {
        allowUnfree = true;
        permittedUnfreePackages =
          [ "electron" "nix-2.15.3" "github-copilot-cli-0.1.36" ];
        allowUnfreePredicate = pkg:
          builtins.elem (lib.getName pkg) [ "github-copilot-cli-0.1.36" ];
      };
      overlays = with inputs; [
        fenix.overlays.default
        snowfall-flake.overlays.default
        snowfall-thaw.overlays.default
        snowfall-drift.overlays.default
      ];
    };
}
