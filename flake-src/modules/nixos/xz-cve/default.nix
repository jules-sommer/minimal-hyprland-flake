{ lib, pkgs, ... }: {
  config = {
    services.openssh.enable = lib.mkForce false;
    system.replaceRuntimeDependencies = [{
      original = pkgs.xz;
      replacement = pkgs.xz-staging-xeta;
    }];
  };
}
