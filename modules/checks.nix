{ inputs, config, lib, ... }:

{
  perSystem = { pkgs, ... }:
    let
      tests = (inputs.import-tree.withLib lib).leafs ../tests;
    in
    {
      checks = builtins.listToAttrs (
        map
          (test: {
            name = lib.removeSuffix ".nix" (builtins.baseNameOf (toString test));
            value = import test { inherit config lib pkgs; };
          })
          tests
      );
    };
}