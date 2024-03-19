<div align="center">

# LilleAila's Dotfiles
**My personal configuration files for GNU/Linux<sub>, or as I've recently taken to calling it, GNU plus Linux</sub>, using NixOS with Home-Manager.**

Riced with [nix-colors](https://github.com/Misterio77/nix-colors) using [gruvbox](https://github.com/morhetz/gruvbox) as the color scheme.

</div>

## Using
- Window Manager: [Hyprland](https://hyprland.org)
- Bar: [AGS](https://aylur.github.io/ags-docs/)
- Terminal Emulator: [kitty](https://sw.kovidgoyal.net/kitty)
- Shell: [Zsh](https://www.zsh.org/) with [Oh my Zsh](https://ohmyz.sh/), and the [nanotech](https://github.com/ohmyzsh/ohmyzsh/wiki/Themes#nanotech) theme
- Editor(s): [Neovim](https://neovim.io) and [Emacs](https://www.gnu.org/software/emacs/)
- Discord: [Vesktop](https://github.com/Vencord/Vesktop)
- Wallpapers: [AngelJumbo/gruvbox-wallpapers](https://github.com/AngelJumbo/gruvbox-wallpapers)

## Hardware
I use the following computers with this configuration:

| Type                   | Name      | Architecture | Note                  |
| ---------------------- | --------- | ------------ | --------------------- |
| Apple MacBook Pro 14"  | `m1pro14` | `aarch64`    | Build with `--impure` |
| Lenovo ThinkPad T420   | `t420`    | `x86_64`     |                       |
| Lenovo Legion Y540     | `legion`  | `x86_64`     |                       |
| Lenovo ThinkPad e540   | `e540`    | `x86_64`     | Not configured yet    |
| Raspberry pi 400       | `pi4`     | `aarch64`    | Not configured yet    |

Currently, all the systems use the excact same configuration. This is all in one flake, so you should be able to install it with `sudo nixos-rebuild switch --flake "github:LilleAila/dotfiles"#<name>`.

### Non-nixOS
If you're not using NixOS, there is a home-manager-only output that can be used normally with `home-manager switch --flake "github:LilleAila/dotfiles"`, assuming you already have set up home-manager following the [manual](https://nix-community.github.io/home-manager).

## Inspiration
- [tpwrules/nixos-apple-silicon](https://github.com/tpwrules/nixos-apple-silicon/tree/main) - Installing NixOS on m1
- [Vimjoyer](https://www.youtube.com/@vimjoyer/featured) - Learning nix
- [System Crafters](https://www.youtube.com/watch?v=74zOY-vgkyw&list=PLEoMzSkcN8oPH1au7H6B7bBJ4ZO7BXjSZ) - Emacs from scratch
- [natpen/awesome-wayland](https://github.com/natpen/awesome-wayland)
- [hyprland-community/awesome-hyprland](https://github.com/hyprland-community/awesome-hyprland)
- [nix-community/awesome-nix](https://github.com/nix-community/awesome-nix)
### Other peoples' dotfiles:
- [IldenH/dotfiles](https://github.com/IldenH/dotfiles) (sånn pittelitt) (sånn veldig lite) (så vidt)
- [fufexan/dotfiles](https://github.com/fufexan/dotfiles)
- [Aylur/dotfiles](https://github.com/Aylur/dotfiles)
- [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland)
- [ircurry/cfg](https://github.com/ircurry/cfg)
- [chadcat7/crystal](https://github.com/chadcat7/crystal)
- [anotherhadi/nixy](https://github.com/anotherhadi/nixy)
- [Misterio77/nix-config](https://github.com/Misterio77/nix-config)
- [iynaix/dotfiles](https://github.com/iynaix/dotfiles)
- [vimjoyer/nixconf](https://github.com/vimjoyer/nixconf)
