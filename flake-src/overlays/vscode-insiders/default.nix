{ channels, ... }:

(final: prev: {
  # Override for using Vscode Insiders edition, basically nightly/unstable release instead
  vscode-with-extensions =
    (prev.vscode.override { isInsiders = true; }).overrideAttrs (oldAttrs: rec {
      src = (builtins.fetchTarball {
        url = "https://update.code.visualstudio.com/latest/linux-x64/insider";
        sha256 = "0yi11c7kj4cz1f0glsmrkqk8x1l0dwcdwbkr5lkj7pavanrnbl4w";
      });
      version = "latest";
    });
})
