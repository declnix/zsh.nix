{ lib, ... }:
{
  zsh.modules = [
    ({ lib, ... }:
      let
        name = "docker-compose";
      in
      {
        options.integrations.${name}.enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable the OMZ ${name} plugin.";
        };
      })

    ({ config, lib, pkgs, ... }:
      let
        name = "docker-compose";
      in
      {
        config = lib.mkIf config.integrations.${name}.enable {
          zsh.optPlugins."omz-${name}" = {
            package = pkgs.oh-my-zsh;
            source = "share/oh-my-zsh/plugins/${name}/${name}.plugin.zsh";
            after = [ "omz-docker" ];
            before = [ "omz-npm" ];
          };
        };
      })
  ];
}
