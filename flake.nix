{
  description = "Nix flake for Helm and Helmfile with plugins";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/master";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        system = system;
        overlays = [
          (final: prev: rec {
            kubernetes-helm-wrapped = prev.wrapHelm prev.kubernetes-helm {
              plugins = with prev.kubernetes-helmPlugins; [
                helm-diff
                helm-secrets
                helm-s3
              ];
            };
          })
        ];
      };
    in {
      devShells.default = pkgs.mkShell {
        name = "helmfile devShell";
        nativeBuildInputs = with pkgs; [
          bashInteractive
        ];
        buildInputs = with pkgs; [
          kubernetes-helm-wrapped
          helmfile-wrapped
        ];
        shellHook = ''
          export SHELL=$(which zsh)
          export NVIM_APPNAME=nvim-chad
          exec zsh
        '';
      };
    });
}
