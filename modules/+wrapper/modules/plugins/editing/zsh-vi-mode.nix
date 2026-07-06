{ lib, ... }:
{
  zsh.modules = [
    ({ lib, ... }: {
      options.zsh-vi-mode.enable = lib.mkEnableOption "vi-mode";
    })

    ({ config, lib, pkgs, ... }: {
      config = lib.mkIf config.zsh-vi-mode.enable {
        zsh.startPlugins.vi-mode = {
          package = pkgs.zsh-vi-mode;
          source = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
        };
      };
    })
  ];
}
