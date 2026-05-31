{ config, lib, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      zshrc = config.flake.lib.zshConfiguration {
        inherit pkgs;
        modules = [{ initExtra = "export NIX_ZSH_SMOKE=42"; }];
      };
      zdotdir = pkgs.runCommand "zdotdir" { } "mkdir -p $out && cp ${zshrc} $out/.zshrc";
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
    };
}
