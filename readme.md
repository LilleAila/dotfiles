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

| Type                   | Name      | Architecture | Note                        |
| ---------------------- | --------- | ------------ | --------------------------- |
| Apple MacBook Pro 14"  | `m1pro14` | `aarch64`    | Main, Build with `--impure` |
| Lenovo ThinkPad T420   | `t420`    | `x86_64`     |                             |
| Lenovo Legion Y540     | `legion`  | `x86_64`     |                             |
| Oracle cloud A1        | `oci`     | `aarch64`    |                             |
| Lenovo ThinkPad e540   | `e540`    | `x86_64`     | Not configured yet          |
| Raspberry pi 400       | `pi4`     | `aarch64`    | Hardware conf missing       |

Currently, all the systems use the excact same configuration. This is all in one flake, so you should be able to install it with `sudo nixos-rebuild switch --flake "github:LilleAila/dotfiles"#<name>`.

### Non-nixOS
If you're not using NixOS, there is a home-manager-only output that can be used normally with `home-manager switch --flake "github:LilleAila/dotfiles"`, assuming you already have set up home-manager following the [manual](https://nix-community.github.io/home-manager).

## Inspiration
- [tpwrules/nixos-apple-silicon](https://github.com/tpwrules/nixos-apple-silicon/tree/main) - Installing NixOS on m1
- [NixOS on oracle cloud](https://blog.korfuri.fr/posts/2022/08/nixos-on-an-oracle-free-tier-ampere-machine/)
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
- [IldenH/dotfiles](https://github.com/IldenH/dotfiles) (sånn pittelitt) (sånn veldig lite) (så vidt)
- [fufexan/dotfiles](https://github.com/fufexan/dotfiles)
- [Aylur/dotfiles](https://github.com/Aylur/dotfiles)
- [ircurry/cfg](https://github.com/ircurry/cfg)
- [chadcat7/crystal](https://github.com/chadcat7/crystal)
- [anotherhadi/nixy](https://github.com/anotherhadi/nixy)
- [Misterio77/nix-config](https://github.com/Misterio77/nix-config)
- [iynaix/dotfiles](https://github.com/iynaix/dotfiles)
- [vimjoyer/nixconf](https://github.com/vimjoyer/nixconf)
- [matt1432/nixos-configs](https://git.nelim.org/matt1432/nixos-configs)
- [BANanaD3V/nixos-config](https://github.com/BANanaD3V/nixos-config)
- [0fie/Maika](https://github.com/0fie/Maika)
- [noib3/dotfiles](https://github.com/noib3/dotfiles)
- [rice-cracker-dev/nixos-config](https://github.com/rice-cracker-dev/nixos-config)
### People not using NixOS:
- [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland)
### TABLES!!!
| User | WM | Bar | NixOS |
| ---- | -- | --- | ----- |
| [IldenH](https://github.com/IldenH/dotfiles) | Hyprland | Waybar | x |
| [fufexan](https://github.com/fufexan/dotfiles) | Hyprland | AGS | x |
| [Aylur](https://github.com/Aylur/dotfiles)| Hyprland | AGS | x |
| [ircurry](https://github.com/ircurry/cfg) | Hyprland | Waybar | x |
| [chadcat7](https://github.com/chadcat7/crystal) | Hyprland | All?? | x |
| [anotherhadi](https://github.com/anotherhadi/nixy) | Hyprland | Waybar | x |
| [Misterio77](https://github.com/Misterio77/nix-config) | Hyprland | Waybar | x |
| [iynaix](https://github.com/iynaix/dotfiles) | Hyprland | Waybar | x |
| [vimjoyer](https://github.com/vimjoyer/nixconf) | Hyprland | Waybar | x |
| [matt1432](https://git.nelim.org/matt1432/nixos-configs) | Hyprland | AGS | x |
| [BANanaD3V](https://github.com/BANanaD3V/nixos-config) | Hyprland | Waybar | x |
| [0fie/Maika](https://github.com/0fie/maika) | Hyprland | Waybar | x |
| [noib3/dotfiles](https://github.com/noib3/dotfiles) | BSPWM | Polybar | x |
| [rice-cracker-dev](https://github.com/rice-cracker-dev/nixos-config) | Hyprland | AGS | x |
| [end-4](https://github.com/end-4/dots-hyprland) | Hyprland | AGS |  |
## Notes
### Nix repl
Open REPL and load nixpkgs:
```bash
nix repl # open repl
:l <nixpkgs> # load nixpkgs from system channel
```
Using it:
```bash
:? # get help
:e lib.mkEnableOption # see source
:q # quit
```

### Nix flakes
A new project can be created using one of the available templates (completion with tab). Example with rust:
```bash
mkdir new-project
cd new-project
nix flake init --template templates\#rust
cargo init .
git add -A && git commit -m "Initial commit"
nvim flake.nix # add rust-analyzer and start coding
```
There are not that many templates, and most of them are not that good, so I should create a repo containing my own templates at some point.

### SSH
```bash
# Generate a new key:
ssh-keygen -t ed25519 -C "your_email@example.com"
```
SSH-ing into a server can often result in errors because kitty terminfo files are unavailable. To fix this, run `kitten ssh` instead of `ssh`.

### SOPS
```bash
# Generate age key:
nix shell nixpkgs#age -c age-keygen -o ~/.config/sops/age/keys.txt # Random
## From SSH key: (I used the SSH key from `m1pro14`)
nix run nixpkgs#ssh-to-age -- -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt

# Get the public key:
nix shell nixpkgs#age -c age-keygen -y ~/.config/sops/age/keys.txt
```
You will need the private key file at `~/.config/sops/age/keys.txt` before building!

### Writable files?
Some prograps may need a writable file for some reason. This is probably one of the worst ways of doing it with a lot of downsides:

#### Writable file
Changes to the file are ignored when rebuilding.
```nix
home.file."test_hm.txt" = {
 text = ''
    abd
    def
    ghi
    jkl
    1234567890
  '';
  onChange = ''
    rm -f $HOME/test.txt
    cp $HOME/test_hm.txt $HOME/test.txt
    chmod u+w $HOME/test.txt
  '';
};
```

#### Symlinked file
When edited, changes are reflected in the source flake.
```nix
home.activation.symlinkCustomFiles = lib.hm.dag.entryAfter ["writeBoundary"] ''
  run rm -f $HOME/testFile.txt && ln -s $HOME/dotfiles/home/testFile.txt $HOME/testFile.txt
'';
```
(pls don't actually use this)
