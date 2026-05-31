{ lib, ... }:
{
  zsh.modules = [
    ({ config, lib, pkgs, ... }: {
      options.syntax-highlighting.enable = lib.mkEnableOption "zsh-syntax-highlighting";

      config = lib.mkIf config.syntax-highlighting.enable {
        addons.syntax-highlighting = {
          package = pkgs.zsh-syntax-highlighting;
          source = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
          defer = "eager";
          after = [ "autosuggestions" ];
        };
      };
    })
  ];
}
