{ lib, ... }:
{
  zsh.modules = [
    ({ lib, ... }: {
      options.integrations.git.enable = lib.mkEnableOption "git integration";
    })

    ({ config, lib, pkgs, ... }: {
      config = lib.mkIf config.integrations.git.enable {
        zsh.optPlugins.omz-git = {
          package = pkgs.oh-my-zsh;
          sources = [
            "share/oh-my-zsh/lib/git.zsh"
            "share/oh-my-zsh/plugins/git/git.plugin.zsh"
          ];
        };
      };
    })
  ];
}
