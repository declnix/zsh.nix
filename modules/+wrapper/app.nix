{ self, lib, ... }:

{
  perSystem =
    { pkgs, ... }:
    let
      zsh = self.lib.zshConfiguration {
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
