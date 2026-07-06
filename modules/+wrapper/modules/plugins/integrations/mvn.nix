{ lib, ... }:
{
  zsh.modules = [
    ({ lib, ... }: {
      options.omz.mvn.enable = lib.mkEnableOption "Maven integration";
    })

    ({ config, lib, pkgs, ... }: {
      config = lib.mkIf config.omz.mvn.enable {
        zsh.optPlugins.omz-mvn = {
          package = pkgs.oh-my-zsh;
          source = "share/oh-my-zsh/plugins/mvn/mvn.plugin.zsh";
        };
      };
    })
  ];
}
