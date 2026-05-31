{ lib, ... }:
{
  zsh.modules = [
    ({ lib, ... }: {
      options.integrations.npm.enable = lib.mkEnableOption "npm integration";
    })

    ({ config, lib, pkgs, ... }: {
      config = lib.mkIf config.integrations.npm.enable {
        zsh.optPlugins.omz-npm = {
          package = pkgs.oh-my-zsh;
          source = "share/oh-my-zsh/plugins/npm/npm.plugin.zsh";
        };
      };
    })
  ];
}
