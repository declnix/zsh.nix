{ lib, ... }:
{
  zsh.modules = [
    ({ lib, ... }:
      let
        name = "docker";
      in
      {
        options.integrations.${name}.enable = lib.mkEnableOption "Docker integration";
      })

    ({ config, lib, pkgs, ... }:
      let
        name = "docker";
        plugin = pkgs.runCommand "oh-my-zsh-${name}-plugin" { } ''
          plugin_dir=$out/share/oh-my-zsh/plugins/${name}
          mkdir -p "$plugin_dir"
          cp -R ${pkgs.oh-my-zsh}/share/oh-my-zsh/plugins/${name}/. "$plugin_dir/"
          chmod -R u+w "$plugin_dir"

          sed -i '/^# If the completion file/,$d' "$plugin_dir/${name}.plugin.zsh"
        '';
      in
      {
        config = lib.mkIf config.integrations.${name}.enable {
          zsh.integrations.docker-compose.enable = lib.mkDefault true;

          zsh.optPlugins."omz-${name}" = {
            package = plugin;
            source = "share/oh-my-zsh/plugins/${name}/${name}.plugin.zsh";
            init = ''
              fpath=("${plugin}/share/oh-my-zsh/plugins/${name}/completions" $fpath)
            '';
          };
        };
      })
  ];
}
