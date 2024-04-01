{ pkgs, lib, system, config, ... }:
let
  meta = (builtins.fromTOML
    (builtins.readFile (lib.snowfall.get-file "systems.toml")));
  inherit (lib.xeta) enabled;
in {

  imports = [ ./hardware.nix ];

  boot.initrd.luks.devices."luks-e84e03e4-9df5-4bdf-8d37-5a7cd25e435b".device =
    "/dev/disk/by-uuid/e84e03e4-9df5-4bdf-8d37-5a7cd25e435b";
  networking.hostName = "gaboxadol"; # Define your hostname.

  # our custom namespace where we defined
  # config settings for modularity :3
  xeta = {
    system = {
      user = {
        username = "jules";
        fullname = "Jules Sommer";
        home = "/home/jules";
        dotfiles =
          "${config.xeta.system.user.home}/.config";
      };

      portals = enabled;

      development = {
        rust = enabled;
        zig = enabled;
      };

      desktop = {
        hyprland = enabled;
        greeter = enabled;
      };

      programs = {
        misc = enabled;
        snowfall-utils = enabled;
        distrobox = enabled;
        rustdesk = {
          enable = true;
          relayIP = "24.141.46.69";
        };
      };

      graphics = {
        nvidia = {
          enable = true;
          drivers = [ "nouveau" ];
          channel = "stable";
        };
        opengl = true;
        electron_support = enabled;
      };

      hostname = "gaboxadol";
      fonts = enabled;
      env = enabled;
      networking = enabled;

      kbd = {
        enable = true;
        layout = "us";
      };

      services = {
        polkit = enabled;
        audio.pipewire = {
          enable = true;
          support = {
            alsa = true;
            pulse = true;
            jack = true;
          };
        };
      };
    };
    security = {
      doas = enabled;
      keyring = enabled;
    };
  };

  # Bootloader
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "auto";
        editor = false;
        netbootxyz = enabled;
        memtest86 = enabled;
      };
      efi.canTouchEfiVariables = true;
    };
    plymouth = {
      enable = true;
      font =
        "${pkgs.jetbrains-mono}/share/fonts/truetype/JetBrainsMono-Regular.ttf";
    };
  };

  users.defaultUserShell = pkgs.nushell;
  environment.shells = [ pkgs.nushell pkgs.zsh pkgs.bash ];
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  #  started in user sessions.
  programs = {
    xfconf = enabled;
    dconf = enabled;
    mtr = enabled;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    steam = {
      enable = true;
      gamescopeSession = enabled;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  system.stateVersion =
    "23.11"; # This is not the system version, don't change it!!
}
