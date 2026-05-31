{ config, lib, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      zshrc = config.flake.lib.zshConfiguration {
        inherit pkgs;
        modules = [{ initExtra = "export NIX_ZSH_SMOKE=42"; }];
      };
      attrsetApiZsh = config.flake.lib.zshConfiguration {
        inherit pkgs;
        modules = [
          {
            shell = {
              editing = {
                viMode.enable = true;
                autosuggestions.enable = true;
              };

              highlighting.patina.enable = true;

              completion = {
                fzfTab.enable = true;
                fzfHistory.enable = true;
              };
            };

            integrations = {
              git.enable = true;
              docker.enable = true;
              npm.enable = true;
              mvn.enable = true;
            };
          }
        ];
      };
      zdotdir = pkgs.runCommand "zdotdir" { } "mkdir -p $out && cp ${zshrc}/.zshrc $out/.zshrc";
      zsh = pkgs.symlinkJoin {
        name = "nix-zsh-smoke";
        paths = [ pkgs.zsh ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = "wrapProgram $out/bin/zsh --set ZDOTDIR ${zdotdir}";
        meta.mainProgram = "zsh";
      };
    in
    {
      checks.smoke = pkgs.runCommand "nix-zsh-smoke" { nativeBuildInputs = [ pkgs.zsh ]; } ''
        export HOME="$(mktemp -d)"
        output=$(${lib.getExe zsh} -i -c 'print -- "RESULT=$NIX_ZSH_SMOKE"' 2>/dev/null)
        echo "$output" | grep -q '^RESULT=42$'
        touch $out
      '';

      checks.attrset-api = pkgs.runCommand "nix-zsh-attrset-api" { } ''
        zshrc=${attrsetApiZsh}/.zshrc

        grep -q 'zsh-vi-mode.plugin.zsh' "$zshrc"
        grep -q 'zsh-autosuggestions.zsh' "$zshrc"
        grep -q 'zsh-patina activate' "$zshrc"
        grep -q 'fzf-tab.plugin.zsh' "$zshrc"
        grep -q 'zsh-fzf-history-search.plugin.zsh' "$zshrc"
        grep -q 'plugins/git/git.plugin.zsh' "$zshrc"
        grep -q 'plugins/docker/docker.plugin.zsh' "$zshrc"
        grep -q 'plugins/docker-compose/docker-compose.plugin.zsh' "$zshrc"
        grep -q 'plugins/npm/npm.plugin.zsh' "$zshrc"
        grep -q 'plugins/mvn/mvn.plugin.zsh' "$zshrc"

        touch $out
      '';
    };
}
