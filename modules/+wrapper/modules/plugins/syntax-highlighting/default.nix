{ lib, ... }:

{
  zsh.modules = [
    ({ config, ... }: {
      assertions = [
        {
          assertion = ! (config.shell.highlighting.patina.enable && config.shell.highlighting.enable);
          message = "shell.highlighting.patina.enable and shell.highlighting.enable are mutually exclusive.";
        }
      ];
    })
  ];
}
