{ lib
, pkgs
, config
, inputs
, system
, ...
}:
let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.xeta) mkOpt;

  cfg = config.xeta.system;
in
{
  options.xeta.system = {
    user = {
      username = mkOpt (types.nullOr types.str) null "The username of the user";
      fullname = mkOpt (types.nullOr types.str) null "The full name of the user";
      home = mkOpt
        (types.nullOr (
          types.either types.path types.str
        ))
        null "The home directory of the user";
      dotfiles = mkOpt (types.nullOr types.str) null "The dotfiles directory for the user's config.";
    };
    hostname = mkOpt (types.nullOr types.str) null "The hostname of the system";
  };

  config = {
    assertions = [
      {
        assertion = cfg.user.username != null;
        message = "You must set a username to use this flake @ config.xeta.system.user.username";
      }
      {
        assertion = cfg.user.fullname != null;
        message = "You must set a full name to use this flake @ config.xeta.system.user.fullname";
      }
      {
        assertion = cfg.user.home != null;
        message = "You must set a home directory to use this flake @ config.xeta.system.user.home";
      }
      {
        assertion = cfg.hostname != null;
        message = "You must set a hostname to use this flake @ config.xeta.system.hostname";
      }
    ];
    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    environment.etc = lib.mapAttrs'
      (name: value: {
        name = "${cfg.user.home}/.nix-defexpr/channels_root/nixos/${name}";
        value.source = value.flake;
      })
      config.nix.registry;

    # Configure the Nix package manager
    nix = {
      # This will add each flake input as a registry
      # To make nix3 commands consistent with your flake
      registry = (lib.mapAttrs (_: flake: { inherit flake; })) (
        (lib.filterAttrs (_: lib.isType "flake")) inputs
      );
      nixPath = [ "${cfg.user.home}/.nix-defexpr/channels_root/nixos" ];

      settings =
        let
          users = [
            "root"
            config.xeta.system.user.username
          ];
        in
        {
          warn-dirty = false;
          # Enable flakes and new 'nix' command
          experimental-features = "nix-command flakes";
          # Deduplicate and optimize nix store
          auto-optimise-store = true;
          # Use binary caches
          substituters = [ "https://hyprland.cachix.org" "https://cache.nixos.org" ];
          trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
          http-connections = 50;
          log-lines = 50;
          sandbox = "relaxed";

          trusted-users = users;
          allowed-users = users;
        };
      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 7d";
      };
      # flake-utils-plus
      generateRegistryFromInputs = true;
      generateNixPathFromInputs = true;
      linkInputs = true;
    };

    time.timeZone = "America/Toronto";
    i18n.defaultLocale = "en_CA.UTF-8";

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.${cfg.user.username} = {
      isNormalUser = true;
      homeMode = "755";
      uid = 1000;
      useDefaultShell = true;
      description = cfg.user.fullname;
      extraGroups = [
        "networkmanager"
        "wheel"
        "vboxusers"
        "docker"
        "wireshark"
        "libvirtd"
        "fuse"
      ];
    };

    snowfallorg.user.${cfg.user.username}.home.config = {
      programs.home-manager.enable = true;
      home.username = cfg.user.username;
      home.homeDirectory = cfg.user.home;
      home.stateVersion = config.system.stateVersion;
    };
  };
}
