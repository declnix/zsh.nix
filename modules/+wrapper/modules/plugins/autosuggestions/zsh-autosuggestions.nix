{ lib, ... }:
{
  zsh.modules = [
    ({ lib, ... }: {
      options.shell.editing.autosuggestions.enable = lib.mkEnableOption "zsh-autosuggestions";
    })

    ({ config, lib, pkgs, ... }: {
      config = lib.mkIf config.shell.editing.autosuggestions.enable {
        zsh.startPlugins.autosuggestions = {
          package = pkgs.zsh-autosuggestions;
          source = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
        };
      };
    })
  ];
}
