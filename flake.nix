{
  description = "Jules' Xetamine Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-23.11";
    staging.url = "github:nixos/nixpkgs/staging-next";

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

    zig-overlay = {
      url = "github:mitchellh/zig-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zls = {
      url = "github:zigtools/zls";
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

    nix-std = { url = "github:chessai/nix-std"; };
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

          channels-config = { allowUnfree = true; };

          meta = {
            name = meta;
            title = "Xetamine (jules@xeta) Sys Flake";
          };
        };
      };
      meta = (lib.getMeta ./systems.toml);
    in (lib.mkFlake {
      channels-config = {
        allowUnfree = lib.mkDefault true;
        permittedUnfreePackages = [
          "electron"
          "nix-2.15.3"
          "github-copilot-cli-0.1.36"
          "warp-terminal-0.2024.03.19.08.01.stable_01"
        ];
        allowUnfreePredicate = pkg:
          builtins.elem (lib.getName pkg) [
            "github-copilot-cli-0.1.36"
            "warp-terminal-0.2024.03.19.08.01.stable_01"
          ];
      };

      # Applies to all home-manager configs
      home.modules = with inputs; [ hyprland.homeManagerModules.default ];

      # Applies to all nixos systems
      systems.modules.nixos = with inputs;
        [ home-manager.nixosModules.home-manager ];

      overlays = with inputs; [
        fenix.overlays.default
        snowfall-flake.overlays.default
        snowfall-thaw.overlays.default
        snowfall-drift.overlays.default
      ];
    }) // {
      inherit meta;
    };
}
