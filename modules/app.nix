{ self, lib, ... }:

{
  perSystem =
    { pkgs, ... }:
    let
      zshrc = self.lib.zshConfiguration {
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
                PROMPT="%F{cyan}[nix-zsh]%f %F{green}%n@%m%f %B%F{magenta}❯%f%b "
              else
                PROMPT="%F{cyan}[nix-zsh]%f %B%F{magenta}❯%f%b "
              fi
            '';
          }
        ];
      };
      zdotdir = pkgs.runCommand "zdotdir" { } "mkdir -p $out && cp ${zshrc} $out/.zshrc";
      zsh = pkgs.symlinkJoin {
        name = "nix-zsh";
        paths = [ pkgs.zsh ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = "wrapProgram $out/bin/zsh --set ZDOTDIR ${zdotdir}";
        meta.mainProgram = "zsh";
      };
    in
    { apps.default = { type = "app"; program = lib.getExe zsh; }; };
}
