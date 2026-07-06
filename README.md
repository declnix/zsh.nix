# zsh.nix

## Disclaimer

⚠️ **This is a personal hobby project** developed in spare time.

- The API surface is **unstable** and may change without notice
- **Pin a revision** in your flake if you depend on zsh.nix
- Built with **AI assistance**
- No support commitment or warranty

## Configuration

```nix
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
}
```

### Extending Zsh with Custom Modules

#### How to add a custom module

You can define a module directly in your configuration and add it to the `imports` list. This approach gives you full access to the NixOS module system.

```nix
{
  imports = [
    ({ config, lib, pkgs, ... }: {
      # Define your module's logic
      zsh.startPlugins.my-plugin = {
        package = pkgs.zsh-autosuggestions;
        source = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      };

      initConfig = "echo 'Hello from my custom module!'";
    })
  ];
}
```
