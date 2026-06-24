{ lib, ... }:
{
  zsh.modules = [
    ({ lib, ... }: {
      options.shell.highlighting.enable = lib.mkEnableOption "zsh-syntax-highlighting";
    })

    ({ config, lib, pkgs, ... }: {
      config = lib.mkIf config.shell.highlighting.enable {
        zsh.startPlugins.syntax-highlighting = {
          package = pkgs.zsh-syntax-highlighting;
          source = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
          after = [ "autosuggestions" ];
        };
      };
    })
  ];
}
