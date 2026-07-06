{ ... }:

{
  zsh.modules = [
    ({ lib, ... }: {
      options.zsh-patina.enable = lib.mkEnableOption "zsh-patina";
    })

    ({ config, inputs, lib, pkgs, ... }:
      let
        src = inputs.zsh-patina;
        manifest = (lib.importTOML (src + "/Cargo.toml")).package;
        package = pkgs.rustPlatform.buildRustPackage {
          pname = manifest.name;
          version = manifest.version;
          inherit src;
          cargoLock.lockFile = src + "/Cargo.lock";
        };
      in
      {
        config = lib.mkIf config.zsh-patina.enable {
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
