{ lib, ... }:
{
  zsh.modules = [
    ({ config, lib, pkgs, ... }:
      let
        name = "docker";
      in
      {
        options.omz.${name} = {
          enable = lib.mkEnableOption "OMZ ${name} plugin";
          after = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "Plugins that must load before OMZ ${name}.";
          };
          defer = lib.mkOption {
            type = lib.types.enum [
              "eager"
              "prompt"
              "idle"
              "lazy"
            ];
            default = "idle";
            description = "Load strategy for OMZ ${name}.";
          };
        };

        config = lib.mkIf config.omz.${name}.enable {
          addons."omz-${name}" = {
            package = pkgs.oh-my-zsh;
            source = "share/oh-my-zsh/plugins/${name}/${name}.plugin.zsh";
            inherit (config.omz.${name}) after defer;
          };
        };
      })
  ];
}
