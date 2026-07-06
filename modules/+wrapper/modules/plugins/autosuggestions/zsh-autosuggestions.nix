{ lib, ... }:
{
  zsh.modules = [
    ({ lib, ... }: {
      options.zsh-autosuggestions.enable = lib.mkEnableOption "zsh-autosuggestions";
    })

    ({ config, lib, pkgs, ... }: {
      config = lib.mkIf config.zsh-autosuggestions.enable {
        zsh.startPlugins.autosuggestions = {
          package = pkgs.zsh-autosuggestions;
          source = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
        };
      };
    })
  ];
}
