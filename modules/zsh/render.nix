{ lib, ... }:
{
  zsh.modules = [
    ({ config, lib, dag, pkgs, ... }:
      let
        plugins = config.addons;

        sourceLines = p:
          map (s: "source ${p.package}/${s}") (lib.optional (p.source != null) p.source ++ p.sources);

        pluginScript = name: p:
          lib.concatStringsSep "\n" (
            (sourceLines p) ++
            (lib.optional (p.init != "") p.init)
          );

        toEntry = name: p: {
          inherit name;
          value = dag.entryAfter p.after (pluginScript name p);
        };

        eagerPlugins = lib.filterAttrs (_: p: p.defer == "eager") plugins;
        idlePlugins = lib.filterAttrs (_: p: p.defer == "idle") plugins;

        eagerEntries = lib.listToAttrs (lib.mapAttrsToList toEntry eagerPlugins);

        idlePluginsScript =
          lib.concatStringsSep "\n" (
            lib.mapAttrsToList (name: p: pluginScript name p) idlePlugins
          );

        idleHookScript = ''
          autoload -Uz add-zsh-hook
          _nix_zsh_idle_check() {
            if (( KEYS_QUEUED_COUNT || PENDING )); then
              sched +1 _nix_zsh_idle_check
            else
              ${idlePluginsScript}
            fi
          }
          _nix_zsh_idle_init() {
            add-zsh-hook -d precmd _nix_zsh_idle_init
            _nix_zsh_idle_check
          }
          add-zsh-hook precmd _nix_zsh_idle_init
        '';
      in
      {
        options.zsh.rc = lib.mkOption { type = lib.types.lines; internal = true; };
        config.zsh.rc = lib.mkOrder 50 ''
          ${dag.render { entries = eagerEntries; }}
          ${lib.optionalString (idlePlugins != {}) idleHookScript}
        '';
      })
  ];
}
