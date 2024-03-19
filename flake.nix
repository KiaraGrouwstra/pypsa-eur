{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        targetPkgs = pkgs: with pkgs; [
          micromamba
          libstdcxx5
          highs
          hdf5
        ];
        pkgs = nixpkgs.legacyPackages.${system};
        mamba = "${pkgs.micromamba}/bin/micromamba";
      in {
        # $ nix develop
        devShells.default = (pkgs.buildFHSUserEnv {
          inherit targetPkgs;
          name = "fhs-shell";
          runScript = ''
            ${mamba} --rc-file envs/environment.yaml shell
          '';
          # eval "$(micromamba shell hook --shell zsh)" && micromamba activate pypsa-eur
        }).env;
      });
}
