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
        dotfiles = "${config.xeta.system.user.home}/.config";
      };

      development = {
        rust = enabled;
        zig = enabled;
      };

      portals = enabled;
      desktop = {
        hyprland = enabled;
        greeter = enabled;
      };

      programs = {
        dconf = enabled;
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

      input = {
        kbd = {
          enable = true;
          layout = "us";
        };
      };

      services = {
        filesystem = enabled;
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
  environment.shells = with pkgs; [ nushell zsh ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_CA.UTF-8";

  services.printing.enable = true;

  environment.systemPackages = with pkgs; [
    busybox
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    jujutsu
    git
    lazygit
    starship
    rnr
    btop
    gh
    nil
    zoxide
    broot
    ripgrep
    fd
    bat
    github-copilot-cli
    gitoxide
    helix
    pzip
    nixfmt-rfc-style
    helvum
    webcord-vencord

    nushell
    alacritty
    ntfs3g
    fuseiso
    kitty

    nufmt

    xz
    jq
    fd
    jql
    jq-lsp
    zoxide
    apx

    obsidian
    grim
    grimblast
    slurp

    networkmanagerapplet
    polkit_gnome

    lcsync
    librespot
    libresprite

    # broken due to 'freeimage-unstable-2021-11-01',
    # see /overlays/librepcb-stable/default.nix
    librepcb

    ungoogled-chromium

    deploy-rs
    nixfmt
    nix-index
    nix-prefetch-git
    nix-output-monitor
    flake-checker

  ];

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

  services.openssh.enable = true;

  networking.firewall.enable = false;

  system.stateVersion =
    "23.11"; # This is not the system version, don't change it!!
}
