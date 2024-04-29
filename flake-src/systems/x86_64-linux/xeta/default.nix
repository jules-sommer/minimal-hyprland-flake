{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib.xeta) enabled;
  home = config.xeta.system.user.home;
in
{

  imports = [ ./hardware.nix ];

  # our custom namespace where we defined
  # config settings for modularity :3
  xeta = {
    system = {
      user = {
        username = "jules";
        fullname = "Jules Sommer";
        home = "/home/jules";
        dotfiles = "${home}/070_dotfiles/010_nix-managed";
      };

      portals = enabled;
      desktop = {
        hyprland = enabled;
        greeter = enabled;
      };

      graphics = {
        enable = true;
        opengl = true;
        amd = enabled;
        electron_support = enabled;
      };

      hostname = "xeta";
      fonts = enabled;
      env = enabled;
    };

    nixvim = enabled;

    services = {
      audio.pipewire = {
        enable = true;
        support = {
          alsa = true;
          pulse = true;
          jack = true;
        };
      };
      filesystem = enabled;
      polkit = enabled;
      ollama = enabled;
    };
    input = {
      kbd = {
        enable = true;
        layout = "us";
      };
    };
    programs = {
      chat = enabled;
      media = enabled;
      dconf = enabled;
      misc = enabled;
      snowfall-utils = enabled;
      distrobox = enabled;
      metasploit = enabled;
      rustdesk = {
        enable = true;
        relayIP = "24.141.46.69";
      };
    };
    # kernel = {
    #   enable = true;
    #   v4l2loopback = true;
    #   package = pkgs.linuxPackages_latest;
    # };
    networking = enabled;
    security = {
      doas = enabled;
      keyring = enabled;
      tor = {
        enable = true;
        settings = {
          proxychains = true;
          torsocks = true;
        };
      };
    };
    development = {
      nix = enabled;
      go = enabled;
      rust = enabled;
      zig = enabled;
    };
    crypto = {
      enable = true;
      monero = {
        enable = true;
        mining = {
          enable = false;
          address = "83Dt82wJ8T98f39nMV11av8CePi4UPhfz1to5uCB6i5cUhWyJvgVRJGPuj1NVkYckPboqkKc7PVSiT4zUUQBaRZQ9qZXxEt";
        };
      };
      bitcoin = {
        enable = true;
      };
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
      font = "${pkgs.jetbrains-mono}/share/fonts/truetype/JetBrainsMono-Regular.ttf";
    };
  };

  users.defaultUserShell = pkgs.nushell;
  environment.shells = with pkgs; [
    nushell
    zsh
  ];

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

  # Enable sound with pipewire.

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # CLI & Development Tools

    webcord-vencord
  ];

  # Some programs need SUID wrappers, can be configured further or are
  #  started in user sessions.
  programs = {
    steam = {
      enable = true;
      gamescopeSession = enabled;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };

  security.pam.services.tuigreet = {
    text = ''
      auth include login
    '';
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  system.stateVersion = "23.11"; # This is not the system version, don't change it!!
}
