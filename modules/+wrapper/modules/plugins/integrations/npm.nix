{ lib, ... }:
{
  zsh.modules = [
    ({ lib, ... }: {
      options.omz.npm.enable = lib.mkEnableOption "npm integration";
    })

    ({ config, lib, pkgs, ... }: {
      config = lib.mkIf config.omz.npm.enable {
        zsh.optPlugins.omz-npm = {
          package = pkgs.oh-my-zsh;
          source = "share/oh-my-zsh/plugins/npm/npm.plugin.zsh";
        };
      };
    })
  ];
}
