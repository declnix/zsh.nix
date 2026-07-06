{ lib, inputs, config, ... }:

let
  compileZshPlugin =
    { pkgs, plugin }:
    pkgs.runCommand "${plugin.name}-compiled" { } ''
      set -euo pipefail
      cp -r ${plugin} $out
      chmod -R u+w $out
      find "$out" \
        -type f \
        \( -name "*.zsh" -o -name "*.plugin.zsh" -o -name "*.zsh-theme" \) \
        -exec ${pkgs.zsh}/bin/zsh -fc '
          for f in "$@"; do
            zcompile "$f"
          done
        ' zsh {} +
    '';

  zshConfiguration =
    { pkgs
    , modules ? [ ]
    , specialArgs ? { }
    ,
    }:
    let
      evaluated = lib.evalModules {
        modules = config.zsh.modules ++ modules;
        specialArgs = {
          inherit pkgs inputs compileZshPlugin;
          dag = inputs.dag.lib { inherit lib; };
        } // specialArgs;
      };
      failedAssertions = builtins.filter (a: ! a.assertion) evaluated.config.assertions;
      zshrc =
        assert lib.assertMsg
          (failedAssertions == [ ])
          (lib.concatMapStringsSep "\n" (a: a.message) failedAssertions);
        pkgs.writeText "zshrc" evaluated.config.zsh.rc;
    in
    pkgs.runCommand "zsh-config" { buildInputs = [ pkgs.makeWrapper ]; } ''
      mkdir -p $out/bin
      cp ${zshrc} $out/.zshrc
      makeWrapper ${pkgs.zsh}/bin/zsh $out/bin/zsh \
        --set ZDOTDIR $out
    '';
in
{
  flake.lib.zshConfiguration = zshConfiguration;
  flake-file.inputs.dag = {
    url = "github:denful/dag";
  };
}
