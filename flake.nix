{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/ccde02e9ff2";

  outputs = { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
    in
    {
      devShells.aarch64-darwin.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          helmfile
          (
            wrapHelm kubernetes-helm {
              plugins = with kubernetes-helmPlugins; [
                helm-diff
                helm-secrets
              ];
            }
          )
        ];
      };
    };
}
