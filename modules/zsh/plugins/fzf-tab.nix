{ inputs, ... }:

let
  module = { config, lib, pkgs, ... }: {
    options.fzf-tab.enable = lib.mkEnableOption "fzf-tab";

    config = lib.mkIf config.fzf-tab.enable {
      addons.fzf-tab = {
        package = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "e394092c17277c84cb3d234917c4ac1073102ba6";
          sha256 = "sha256-WlmWLKHrLeptc5rqlHbKvthD73it9ij7IDT9QxN4jCc=";
        };
        source = "fzf-tab.plugin.zsh";
        init = "enable-fzf-tab";
        defer = "idle";
      };
    };
  };
in
{
  zsh.modules = [ module ];
}
