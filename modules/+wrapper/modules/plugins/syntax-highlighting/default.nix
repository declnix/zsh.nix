{ lib, ... }:

{
  zsh.modules = [
    ({ config, ... }: {
      assertions = [
        {
          assertion = ! (config.zsh-patina.enable && config.zsh-syntax-highlighting.enable);
          message = "zsh-patina.enable and zsh-syntax-highlighting.enable are mutually exclusive.";
        }
      ];
    })
  ];
}
