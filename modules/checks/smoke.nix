{ config, lib, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      zshrc = config.flake.lib.zshConfiguration {
        inherit pkgs;
        modules = [{ initConfig = "export NIX_ZSH_SMOKE=42"; }];
      };
      attrsetApiZsh = config.flake.lib.zshConfiguration {
        inherit pkgs;
        modules = [
          {
            vi.enable = true;
            autosuggestion.enable = true;
            syntaxHighlighting.integrations.patina.enable = true;

            completion = {
              enable = true;
              integrations.fzf.enable = true;
            };

            history.integrations.fzf.enable = true;

            integrations = {
              git.enable = true;
              docker.enable = true;
              npm.enable = true;
              mvn.enable = true;
            };

            aliases = {
              ll = "ls -l";
              gs = "git status";
            };
          }
        ];
      };
      completionFzfWithoutCompletion = config.flake.lib.zshConfiguration {
        inherit pkgs;
        modules = [
          {
            completion.integrations.fzf.enable = true;
          }
        ];
      };
      completionFzfWithoutCompletionEval = builtins.tryEval completionFzfWithoutCompletion.drvPath;
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

        grep -q 'autoload -Uz compinit' "$zshrc"
        grep -q '^compinit$' "$zshrc"
        grep -q "^alias ll='ls -l'$" "$zshrc"
        grep -q "^alias gs='git status'$" "$zshrc"
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

        line() {
          grep -n "$1" "$zshrc" | head -n1 | cut -d: -f1
        }

        test "$(line 'zsh-vi-mode.plugin.zsh')" -lt "$(line 'zsh-autosuggestions.zsh')"
        test "$(line 'zsh-autosuggestions.zsh')" -lt "$(line 'zsh-patina activate')"
        test "$(line 'fzf-tab.plugin.zsh')" -lt "$(line 'zsh-fzf-history-search.plugin.zsh')"
        test "$(line 'zsh-fzf-history-search.plugin.zsh')" -lt "$(line 'plugins/git/git.plugin.zsh')"
        test "$(line 'plugins/git/git.plugin.zsh')" -lt "$(line 'plugins/docker/docker.plugin.zsh')"
        test "$(line 'plugins/docker/docker.plugin.zsh')" -lt "$(line 'plugins/docker-compose/docker-compose.plugin.zsh')"
        test "$(line 'plugins/docker-compose/docker-compose.plugin.zsh')" -lt "$(line 'plugins/npm/npm.plugin.zsh')"
        test "$(line 'plugins/npm/npm.plugin.zsh')" -lt "$(line 'plugins/mvn/mvn.plugin.zsh')"

        touch $out
      '';

      checks.completion-fzf-requires-completion =
        pkgs.runCommand "nix-zsh-completion-fzf-requires-completion" { } ''
          if ${lib.boolToString completionFzfWithoutCompletionEval.success}; then
            echo "expected completion.integrations.fzf.enable without completion.enable to fail evaluation"
            exit 1
          fi

          touch $out
        '';
    };
}
