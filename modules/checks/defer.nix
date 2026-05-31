{ config, lib, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      zshrc = config.flake.lib.zshConfiguration {
        inherit pkgs;
        modules = [
          ({ config, ... }: {
            options.zsh.test-plugin.enable = lib.mkEnableOption "test-plugin";
            config = lib.mkIf config.zsh.test-plugin.enable {
              addons.test-plugin = {
                package = pkgs.writeTextDir "noop.zsh" "";
                init = "echo 1 > $NIX_ZSH_MARKER_FILE && exit 0";
                defer = "idle";
              };
            };
          })
          {
            zsh.test-plugin.enable = true;
          }
        ];
      };
      zdotdir = pkgs.runCommand "zdotdir" { } "mkdir -p $out && cp ${zshrc} $out/.zshrc";
      zsh = pkgs.symlinkJoin {
        name = "nix-zsh-defer";
        paths = [ pkgs.zsh ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = "wrapProgram $out/bin/zsh --set ZDOTDIR ${zdotdir}";
        meta.mainProgram = "zsh";
      };
    in
    {
      checks.defer = pkgs.runCommand "nix-zsh-defer" { nativeBuildInputs = [ pkgs.util-linux ]; } ''
        export HOME="$(mktemp -d)"
        export NIX_ZSH_MARKER_FILE="$(mktemp)"
        trap 'rm -f "$NIX_ZSH_MARKER_FILE"' EXIT
        timeout 5 script -qfec "${lib.getExe zsh} -i" /dev/null > /dev/null 2>&1
        if [ -s "$NIX_ZSH_MARKER_FILE" ]; then
          echo "SUCCESS" > $out
        else
          echo "FAIL: Plugin did not initialize"
          exit 1
        fi
      '';
    };
}
