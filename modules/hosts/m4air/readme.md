Install program as a homebrew cask in `nix-darwin`. Configure it in `home-manager`. Set either `package = null`, or `package = pkgs.emptyDirectory`, depending on what the module in question supports.

https://github.com/nix-community/home-manager/issues/4763

I usually use home-manager to configure programs if possible, but nix-darwin is used when there is no other option, or when it has a module that home-manager does not.
