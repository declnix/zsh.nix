{ ... }:

{
  zsh.modules = [
    ({ lib, ... }: {
      options.shell.highlighting.patina.enable = lib.mkEnableOption "zsh-patina";
    })

    ({ config, inputs, lib, pkgs, ... }:
      let
        package = inputs.zsh-patina.packages.${pkgs.stdenv.hostPlatform.system}.default;
      in
      {
        config = lib.mkIf config.shell.highlighting.patina.enable {
          zsh.startPlugins.syntax-highlighting = {
            package = lib.mkForce package;
            source = lib.mkForce null;
            init = lib.mkForce ''
              eval "$(${package}/bin/zsh-patina activate)"
            '';
            after = lib.mkForce [ "autosuggestions" ];
          };
        };
      })
  ];

  flake-file.inputs.zsh-patina = {
    url = "github:michel-kraemer/zsh-patina";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}
