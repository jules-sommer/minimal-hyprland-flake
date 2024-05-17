{
  description = "Jules' Xetamine Flake";

  inputs = {
    stable.url = "github:nixos/nixpkgs/nixos-23.11";
    staging.url = "github:nixos/nixpkgs/staging-next";
    master.url = "github:nixos/nixpkgs/master";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    oxalica.url = "github:oxalica/rust-overlay";

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
      inputs.flake-utils-plus.follows = "flake-utils-plus";
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
      inputs.nixpkgs.follows = "master";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprkeys = {
      url = "github:hyprland-community/hyprkeys";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zjharpoon = {
      url = "path:/home/jules/000_dev/010_rust/200_zellij/harpoon";
    };

    zjmonocle = {
      url = "path:/home/jules/000_dev/010_rust/200_zellij/monocle";
    };

    zjstatus = {
      url = "github:dj95/zjstatus";
    };

    nix-std = {
      url = "github:chessai/nix-std";
    };

    nix-colors = {
      url = "github:misterio77/nix-colors";
    };

    systems.url = "github:nix-systems/x86_64-linux";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    flake-utils-plus = {
      url = "/home/jules/030_sandbox/020_flake-utils-plus";
      # url = "github:gytis-ivaskevicius/flake-utils-plus";
      inputs.nixpkgs.follows = "master";
    };

    pyprland = {
      url = "github:hyprland-community/pyprland";
      # url = "/home/jules/000_dev/060_python/000_pyprland";
      inputs.flake-utils.follows = "flake-utils";
    };

    neovim-flake = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "master";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "master";
    };

    neovim-git = {
      url = "github:neovim/neovim";
      flake = false;
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "master";
    };

    hyprland-vdesk = {
      url = "github:levnikmyskin/hyprland-virtual-desktops";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      # url = "/home/jules/000_dev/015_C/000_hyprland";
      inputs.nixpkgs.follows = "master";
    };
  };

  outputs =
    inputs:
    let
      lib = inputs.snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;
        snowfall = {
          namespace = "xeta";
          # Move .nix files to  `./nixos/` dir for organization.
          root = ./flake-src;

          channels-config = {
            allowUnfree = true;
          };

          meta = {
            name = meta;
            title = "Xetamine (jules@xeta) Sys Flake";
          };
        };
      };
      meta = (lib.getMeta ./systems.toml);
    in
    (lib.mkFlake {
      channels-config = {
        allowUnfree = lib.mkDefault true;
        permittedUnfreePackages = [
          "electron"
          "nix-2.15.3"
          "github-copilot-cli-0.1.36"
          "warp-terminal-0.2024.03.19.08.01.stable_01"
        ];
        allowUnfreePredicate =
          pkg:
          builtins.elem (lib.getName pkg) [
            "github-copilot-cli-0.1.36"
            "warp-terminal-0.2024.03.19.08.01.stable_01"
          ];
      };

      # Applies to all home-manager configs
      home.modules = with inputs; [
        nixvim.homeManagerModules.nixvim
        ({
          home-manager.users.jules.programs.nixvim.enable = true;
        })
        hyprland.homeManagerModules.default
        xremap-flake.homeManagerModules.default
      ];

      # Applies to all nixos systems
      systems.modules.nixos = with inputs; [
        nixvim.nixosModules.nixvim
        hyprland.nixosModules.default
        home-manager.nixosModules.home-manager
        xremap-flake.nixosModules.default
      ];

      overlays = with inputs; [
        neovim-nightly-overlay.overlay
        fenix.overlays.default
        oxalica.overlays.default
        snowfall-flake.overlays.default
        snowfall-thaw.overlays.default
        snowfall-drift.overlays.default
      ];
    })
    // {
      inherit meta;
    };
}
