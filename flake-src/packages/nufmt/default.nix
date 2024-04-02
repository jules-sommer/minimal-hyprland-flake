{ lib, inputs, pkgs, stdenv, ... }:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "nufmt";
  version = "0.1.0";

  src = pkgs.fetchFromGitHub {
    owner = "nushell";
    repo = pname;
    rev = version;
    hash = "sha256-jtBw4ahSl88L0iuCXxQgZVm1EcboWRJMNtjxLVTtzts=";
  };

  nativeBuildInputs = with pkgs; [
    rust-bin.stable.latest.default
    rust-analyzer
    nushell
  ];

  cargoHash = "sha256-jtBw4ahSl88L0iuCXxQgZVm1EcboWRJMNtjxLVTtzts=";

  meta = with lib; {
    description = "A tool for formatting Nushell code.";
    homepage = "https://github.com/nushell/nufmt";
    license = licenses.mit;
    maintainers = [ "The NuShell Contributors" ];
  };
}
