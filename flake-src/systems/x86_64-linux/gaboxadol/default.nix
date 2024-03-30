{ pkgs, lib, ... }:
let
  meta = (builtins.fromTOML
    (builtins.readFile (lib.snowfall.get-file "systems.toml")));
in {
  imports = [ # Include the results of the hardware scan.
    ./hardware.nix
  ];

  xeta.system = {
    user = {
      username = "jules";
      fullname = "Jules Sommer";
      home = /home/jules;
    };
    hostname = "xeta";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-e84e03e4-9df5-4bdf-8d37-5a7cd25e435b".device =
    "/dev/disk/by-uuid/e84e03e4-9df5-4bdf-8d37-5a7cd25e435b";
  networking.hostName = "gaboxadol"; # Define your hostname.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Configure keymap in X11

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    busybox
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    jujutsu
    git
    lazygit
    starship
    rnr
    macchina
    btop
    gh
    nil
    github-copilot-cli
    gitoxide
    helix
    pzip
    nixfmt
    nushell
    alacritty
    kitty
  ];

  # Some programs need SUID wrappers, can be configured further or are
  #  started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
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
