{ lib, ... }:
{
  zsh.modules = [
    ({ lib, ... }: {
      options.fzf-history-search.enable = lib.mkEnableOption "fzf-history-search";
    })

    ({ config, lib, pkgs, ... }: {
      config = lib.mkIf config.fzf-history-search.enable {
        zsh.optPlugins.fzf-history-search = {
          package = pkgs.zsh-fzf-history-search;
          source = "share/zsh-fzf-history-search/zsh-fzf-history-search.plugin.zsh";
        };
      };
    })
  ];
}
