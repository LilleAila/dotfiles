# TODO: maybe do inside pkgs.writeShellApplication instead of settings home.file and reading those from here
gpg --import-key gpg-key.asc
git clone git@github.com:LilleAila/dotfiles
cd dotfiles
git-crypt unlock
