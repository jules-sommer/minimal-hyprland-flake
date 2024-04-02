{ lib, inputs, config, pkgs, ... }: {
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
