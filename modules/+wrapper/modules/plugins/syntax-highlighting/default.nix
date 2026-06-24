{ lib, ... }:

{
  zsh.modules = [
    ({ config, ... }:
      assert lib.assertMsg
        (! (config.shell.highlighting.patina.enable && config.shell.highlighting.enable))
        "shell.highlighting.patina.enable and shell.highlighting.enable are mutually exclusive.";
      { })
  ];
}
