{ self, lib, ... }:

{
  perSystem =
    { pkgs, ... }:
    let
      zsh = self.lib.zshConfiguration {
        inherit pkgs;
        modules = [
          {
            zsh-vi-mode.enable = true;
            zsh-autosuggestions.enable = true;
            zsh-patina.enable = true;
            fzf-tab.enable = true;
            fzf-history-search.enable = true;

            omz = {
              git.enable = true;
              docker.enable = true;
              npm.enable = true;
              mvn.enable = true;
            };

            initConfig = ''
              if [[ -n $SSH_CLIENT ]]; then
                PROMPT="%F{cyan}[zsh.nix]%f %F{green}%n@%m%f %B%F{magenta}❯%f%b "
              else
                PROMPT="%F{cyan}[zsh.nix]%f %B%F{magenta}❯%f%b "
              fi
            '';
          }
        ];
      };
    in
    { apps.default = { type = "app"; program = "${zsh}/bin/zsh"; }; };
}
