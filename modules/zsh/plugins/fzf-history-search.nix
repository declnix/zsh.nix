{ lib, ... }:
{
  zsh.modules = [
    ({ config, lib, pkgs, ... }: {
      options.fzf-history-search.enable = lib.mkEnableOption "fzf-history-search";

      config = lib.mkIf config.fzf-history-search.enable {
        addons.fzf-history-search = {
          package = pkgs.zsh-fzf-history-search;
          source = "share/zsh-fzf-history-search/zsh-fzf-history-search.plugin.zsh";
          defer = "idle";
        };
      };
    })
  ];
}
