{ lib, ... }:
{
  zsh.modules = [
    ({ config, lib, pkgs, ... }: {
      options.autosuggestions.enable = lib.mkEnableOption "zsh-autosuggestions";

      config = lib.mkIf config.autosuggestions.enable {
        addons.autosuggestions = {
          package = pkgs.zsh-autosuggestions;
          source = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
          defer = "eager";
        };
      };
    })
  ];
}
