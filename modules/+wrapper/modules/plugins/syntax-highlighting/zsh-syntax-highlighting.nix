{ lib, ... }:
{
  zsh.modules = [
    ({ lib, ... }: {
      options.zsh.syntaxHighlighting.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        internal = true;
        description = "Enable the zsh-syntax-highlighting implementation.";
      };
    })

    ({ config, lib, pkgs, ... }: {
      config = lib.mkIf config.zsh.syntaxHighlighting.enable {
        zsh.startPlugins.syntax-highlighting = {
          package = pkgs.zsh-syntax-highlighting;
          source = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
          after = [ "autosuggestions" ];
        };
      };
    })
  ];
}
