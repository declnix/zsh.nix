{ lib, ... }:
{
  zsh.modules = [
    ({ lib, ... }: {
      options.integrations.mvn.enable = lib.mkEnableOption "Maven integration";
    })

    ({ config, lib, pkgs, ... }: {
      config = lib.mkIf config.integrations.mvn.enable {
        zsh.optPlugins.omz-mvn = {
          package = pkgs.oh-my-zsh;
          source = "share/oh-my-zsh/plugins/mvn/mvn.plugin.zsh";
        };
      };
    })
  ];
}
