# Documentation for LilleAila's dotfiles

## Usage after first downloading
My NixOS configuration relies heavily on secrets management with [sops-nix](https://github.com/Mic92/sops-nix) and my own secrets repository. As such, other people will not be able to use it directly. The secrets are defined in a separate private git repo `git+ssh://git@github.com/LilleAila/dotfiles-secrets.git`. The structure of it is something like this:
```nix
# flake.nix
{
  description = "My NixOS secrets";

  inputs = {};

  outputs = {...}: {
    email = "your.email@example.com";
    syncthing = import ./syncthing.nix;
    gpg = import ./gpg.nix;
    sops = import ./sops.nix;
    ssh = import ./ssh.nix;
  };
}
```
Secrets that do not rely on "inline" values in the NixOS configuration, are managed with SOPS.

### Setting up a new machine.
1. Connect to the internet and enter a `nix-shell` with a text editor and `git`.
2. `git clone git@github.com:LilleAila/dotfiles` or `git clone https://github.com/LilleAila/dotfiles`
3. Create a new SSH key and add it to the GitHub profile, or use an existing one
4. `nixos-rebuild switch --flake .#configuration-name` This is only needed once, afterwards, run `osbuild`
5. Rebuild the system again to decrypt SOPS secrets

### `home-manager` only
This flake also provides a configuration that only uses home-manager. This also depends on sops and a private secrets repo, and can be built with:
```bash
home-manager switch --flake "github:LilleAila/dotfiles"
```
after installing [`home-manager`](https://nix-community.github.io/home-manager).

## Directory structure
```bash
.
├── docs
├── home # home-manager config (separate from system)
│   ├── modules
│   │   ├── desktop
│   │   │   ├── programs
│   │   │   └── wm
│   │   ├── other
│   │   └── shell
│   └── wallpapers
├── hosts # configuration.nix of all the hosts
│   ├── legion
│   ├── mac-nix
│   ├── oci
│   └── t420
├── nixosModules
│   └── services
├── pkgs
└── secrets # secrets managed with SOPS-nix
```
