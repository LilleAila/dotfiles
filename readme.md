<div align="center">

# LilleAila's Dotfiles

**My personal configuration files for Linux, using NixOS with Home-Manager.**

Riced with [nix-colors](https://github.com/Misterio77/nix-colors) using [gruvbox](https://github.com/morhetz/gruvbox) as the color scheme.

</div>

<div align="center">

<figure>
    <img src="assets/desktop.png" alt="Desktop screenshot"/>
    <figcaption><br>Hyprland, kitty and ags, all themed with nix-colors</figcaption>
</figure>
<br><br>
<figure>
    <img src="assets/firefox.png" alt="Firefox screenshot"/>
    <figcaption><br>Minimal firefox theme with nix-colors</figcaption>
</figure>
<br><br>
<figure>
    <img src="assets/discord.png" alt="Discord screenshot"/>
    <figcaption><br>Discord, with a tweaked UI and themed with nix-colors</figcaption>
</figure>

</div>

## Using

- Window Manager: [Sway](https://swaywm.org)
- Bar: [AGS](https://aylur.github.io/ags-docs/) ([config](https://github.com/LilleAila/ags-config))
- Terminal Emulator: [kitty](https://sw.kovidgoyal.net/kitty)
- Shell: [Zsh](https://www.zsh.org/) with [starship](https://starship.rs/)
- Editor: [Neovim](https://neovim.io) ([config](https://github.com/LilleAila/nvim-nix))
- Discord: [Vesktop](https://github.com/Vencord/Vesktop)
- Terminal font: [JetBrains Mono](https://www.jetbrains.com/lp/mono/)

## Hardware

I use the following computers with my dotfiles:

| Name                                                 | Hostname     | Architecture | Note                                                                                                              |
| ---------------------------------------------------- | ------------ | ------------ | ----------------------------------------------------------------------------------------------------------------- |
| [Desktop](./hosts/desktop/readme.md)                 | `nixdesktop` | `x86_64`     |                                                                                                                   |
| [Lenovo ThinkPad E14 Gen 5](./hosts/e14g5/readme.md) | `e14g5-nix`  | `x86_64`     | Main                                                                                                              |
| [Lenovo ThinkPad X220](./hosts/x220-nix/readme.md)   | `x220-nix`   | `x86_64`     |                                                                                                                   |
| [Lenovo ThinkPad T420](./hosts/t420/readme.md)       | `t420-nix`   | `x86_64`     |                                                                                                                   |
| [Oracle cloud](./hosts/oci/readme.md)                | `oci-nix`    | `aarch64`    |                                                                                                                   |
| Apple MacBook Pro 14"                                | `m1pro-nix`  | `aarch64`    | WIP                                                                                                               |
| Apple MacBook Pro 14"                                | `mac-nix`    | `aarch64`    | Deprecated as of [30c156f](https://github.com/LilleAila/dotfiles/commit/30c156fd9a3cf98db7e0f58d10df9b841800ca54) |
| Lenovo Legion Y540                                   | `legion-nix` | `x86_64`     | Deprecated as of [2a8641e](https://github.com/LilleAila/dotfiles/commit/2a8641eaf5bdf22d609baf2021100634dd83c5ad) |

## Inspiration

- [tpwrules/nixos-apple-silicon](https://github.com/tpwrules/nixos-apple-silicon/tree/main) - Installing NixOS on m1
- [Vimjoyer](https://www.youtube.com/@vimjoyer/featured) - Learning nix
- [System Crafters](https://www.youtube.com/watch?v=74zOY-vgkyw&list=PLEoMzSkcN8oPH1au7H6B7bBJ4ZO7BXjSZ) - Emacs from scratch
- [nix-workflow](https://ayats.org/blog/nix-workflow/)
- [natpen/awesome-wayland](https://github.com/natpen/awesome-wayland)
- [hyprland-community/awesome-hyprland](https://github.com/hyprland-community/awesome-hyprland)
- [nix-community/awesome-nix](https://github.com/nix-community/awesome-nix)
- [awsm.fish](https://github.com/jorgebucaran/awsm.fish)
- [thiscute - modularize the configuration](https://nixos-and-flakes.thiscute.world/nixos-with-flakes/modularize-the-configuration)
- [use nix repl effectively](https://aldoborrero.com/posts/2022/12/02/learn-how-to-use-the-nix-repl-effectively/)
- [Configuration Collection](https://nixos.wiki/wiki/Configuration_Collection)
- [riceyourride.com](https://riceyourride.com/best/1)

### Other peoples' dotfiles:

| User                                                                 | WM       | Bar     | NixOS |
| -------------------------------------------------------------------- | -------- | ------- | ----- |
| [IldenH](https://github.com/IldenH/dotfiles)                         | Hyprland | Waybar  | x     |
| [fufexan](https://github.com/fufexan/dotfiles)                       | Hyprland | AGS     | x     |
| [Aylur](https://github.com/Aylur/dotfiles)                           | Hyprland | AGS     | x     |
| [ircurry](https://github.com/ircurry/cfg)                            | Hyprland | Waybar  | x     |
| [chadcat7](https://github.com/chadcat7/crystal)                      | Hyprland | All??   | x     |
| [anotherhadi](https://github.com/anotherhadi/nixy)                   | Hyprland | Waybar  | x     |
| [Misterio77](https://github.com/Misterio77/nix-config)               | Hyprland | Waybar  | x     |
| [iynaix](https://github.com/iynaix/dotfiles)                         | Hyprland | Waybar  | x     |
| [vimjoyer](https://github.com/vimjoyer/nixconf)                      | Hyprland | Waybar  | x     |
| [matt1432](https://git.nelim.org/matt1432/nixos-configs)             | Hyprland | AGS     | x     |
| [BANanaD3V](https://github.com/BANanaD3V/nixos-config)               | Hyprland | Waybar  | x     |
| [0fie](https://github.com/0fie/maika)                                | Hyprland | Waybar  | x     |
| [noib3](https://github.com/noib3/dotfiles)                           | BSPWM    | Polybar | x     |
| [rice-cracker-dev](https://github.com/rice-cracker-dev/nixos-config) | Hyprland | AGS     | x     |
| [end-4](https://github.com/end-4/dots-hyprland)                      | Hyprland | AGS     |       |
| [SimonBradner](https://github.com/SimonBrandner/dotfiles)            | Hyprland | AGS     | x     |
| [alexhulbert](https://github.com/alexhulbert/seaglass)               | Hyprland | Waybar  | x     |
| [linuxmobile](https://github.com/linuxmobile/kaku)                   | Hyprland | AGS     | x     |
| [Kreyren](https://github.com/Kreyren/nixos-config)                   | Gnome    | Gnome   | x     |
| [jacekpoz](https://git.jacekpoz.pl/jacekpoz/niksos)                  | Hyprland | Waybar  | x     |
| [TheSmallTeaBoi](https://github.com/TheSmallTeaBoi/frogix/tree/main) | Awesome  | ?       | x     |
