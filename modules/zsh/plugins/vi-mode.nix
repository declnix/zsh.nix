{ lib, ... }:
{
  zsh.modules = [
    ({ config, lib, pkgs, ... }: {
      options.vi-mode.enable = lib.mkEnableOption "vi-mode";

      config = lib.mkIf config.vi-mode.enable {
        addons.vi-mode = {
          package = pkgs.zsh-vi-mode;
          source = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
          defer = "eager";
        };
      };
    })
  ];
}
