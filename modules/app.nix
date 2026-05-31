{ self, lib, ... }:

{
  perSystem =
    { pkgs, ... }:
    let
      zsh = self.lib.zshConfiguration {
        inherit pkgs;
        modules = [
          {
            vi-mode.enable = true;
            autosuggestions.enable = true;
            syntax-highlighting.enable = true;
            fzf-tab.enable = true;
            fzf-history-search.enable = true;
            omz.git.enable = true;
            initExtra = ''
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
