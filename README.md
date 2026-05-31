# nix-zsh

## Disclaimer

⚠️ **This is a personal hobby project** developed in spare time.

- The API surface is **unstable** and may change without notice
- **Pin a revision** in your flake if you depend on NIX-ZSH
- Built with **AI assistance**
- No support commitment or warranty

### Extending Zsh with Custom Modules

#### How to add a custom module

You can define a module directly in your configuration and add it to the `imports` list. This approach gives you full access to the NixOS module system.

```nix
{
  imports = [
    ({ config, lib, pkgs, ... }: {
      # Define your module's logic
      addons.my-plugin = {
        package = pkgs.zsh-autosuggestions;
        source = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
        defer = "eager";
      };

      initExtra = "echo 'Hello from my custom module!'";
    })
  ];
}
```
