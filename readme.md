<div align="center">

# LilleAila's Dotfiles

**My personal configuration files for Linux, using NixOS with Home-Manager.**

Riced with [nix-colors](https://github.com/Misterio77/nix-colors) using [gruvbox](https://github.com/morhetz/gruvbox) as the color scheme.

</div>

The configuration is written using a dendritic structure in which every nix file represents a flake-parts module, as opposed to using relative imports across the files. This means that all the modules are reusable and exported from this flake under `modules`. You can use them in your own flake by adding this to the inputs, then importing the desired modules as such:

```nix
imports = [
    inputs.lilleaila-dotfiles.modules.nixos.some-module
];
```

## Using

- Window Manager: [Niri](https://github.com/YaLTeR/niri)
- Bar: [Waybar](https://github.com/Alexays/Waybar)
- Terminal Emulator: [Ghostty](https://github.com/ghostty-org/ghostty)
- Shell: [Zsh](https://www.zsh.org/) with [starship](https://starship.rs/)
- Editor: [Neovim](https://neovim.io) ([config](https://github.com/LilleAila/nvf-config))
- Discord: [Vesktop](https://github.com/Vencord/Vesktop)
- Terminal font: [JetBrains Mono](https://www.jetbrains.com/lp/mono/)

## Hardware

I use the following computers with my dotfiles:

| Name                                                         | Hostname       | Architecture | Note                                                                                                              |
| ------------------------------------------------------------ | -------------- | ------------ | ----------------------------------------------------------------------------------------------------------------- |
| [Apple MacBook Air m4](./modules/hosts/m4air/readme.md)      | `m1pro-darwin` | `aarch64`    |                                                                                                                   |
| [Desktop](./modules/hosts/desktop/readme.md)                 | `nixdesktop`   | `x86_64`     |                                                                                                                   |
| [Lenovo ThinkPad E14 Gen 5](./modules/hosts/e14g5/readme.md) | `e14g5-nix`    | `x86_64`     |                                                                                                                   |
| [Lenovo ThinkPad X220](./modules/hosts/x220/readme.md)       | `x220-nix`     | `x86_64`     |                                                                                                                   |
| [Lenovo ThinkPad T420](./modules/hosts/t420/readme.md)       | `t420-nix`     | `x86_64`     |                                                                                                                   |
| [Oracle cloud](./modules/hosts/oci/readme.md)                | `oci-nix`      | `aarch64`    |                                                                                                                   |
| Apple MacBook Pro 14"                                        | `m1pro-nix`    | `aarch64`    | Deprecated as of [f7c0989](https://github.com/LilleAila/dotfiles/commit/f7c09896473236ccc84c5513cc27c4368efc3090) |
| Apple MacBook Pro 14"                                        | `mac-nix`      | `aarch64`    | Deprecated as of [30c156f](https://github.com/LilleAila/dotfiles/commit/30c156fd9a3cf98db7e0f58d10df9b841800ca54) |
| Lenovo Legion Y540                                           | `legion-nix`   | `x86_64`     | Deprecated as of [2a8641e](https://github.com/LilleAila/dotfiles/commit/2a8641eaf5bdf22d609baf2021100634dd83c5ad) |
