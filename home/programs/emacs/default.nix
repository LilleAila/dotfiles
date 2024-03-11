{ config, pkgs, inputs, lib, ... }:
# https://github.com/ircurry/cfg/blob/master/home/programs/emacs/default.nix

let
	# The -pgtk version does NOT work with EXWM
	# emacs-package = with pkgs; ((emacsPackagesFor emacs29-pgtk).emacsWithPackages (
	emacs-package = with pkgs; ((emacsPackagesFor emacs29).emacsWithPackages (
		epkgs: [
			# === Use-package ===
			epkgs.use-package
			# ( import ./eaf.nix { inherit pkgs; })

			# === Completion ===
			epkgs.ivy
			epkgs.ivy-rich
			epkgs.counsel
			epkgs.swiper
			epkgs.helpful

			# === UI ===
			epkgs.doom-themes
			epkgs.all-the-icons
			epkgs.doom-modeline

			# === Keybinds ===
			epkgs.evil
			epkgs.evil-collection
			epkgs.which-key
			epkgs.general
			epkgs.hydra

			# === IDE ===
			epkgs.lsp-mode
			epkgs.lsp-ui
			epkgs.lsp-treemacs
			epkgs.lsp-ivy
			epkgs.company
			epkgs.company-box
			epkgs.undo-tree
			epkgs.evil-nerd-commenter
			epkgs.typescript-mode

			# === Org-mode ===
			epkgs.org
			epkgs.org-bullets
			epkgs.visual-fill-column

			# === EXWM ===
			epkgs.exwm
			epkgs.exwm-modeline
		]
	));
	eaf-python-pkgs = python-pkgs: with python-pkgs; [
    pandas
    requests
    sexpdata tld
    pyqt6 pyqt6-sip
    pyqt6-webengine epc lxml # for eaf
    qrcode # eaf-file-browser
    pysocks # eaf-browser
    pymupdf # eaf-pdf-viewer
    pypinyin # eaf-file-manager
    psutil # eaf-system-monitor
    retry # eaf-markdown-previewer
    markdown
  ];
	emacs-deps = with pkgs; [
		# === EAF (does not work) ===
		# ( python311.withPackages eaf-python-pkgs )
		# git nodejs wmctrl xdotool aria fd jq

		# === TypeScript ===
		nodejs
		nodePackages.npm
		nodePackages.typescript
		nodePackages.typescript-language-server

		# xorg.xinit
		xorg.xmodmap
		# arandr
	];
	emacs-wrapped = inputs.wrapper-manager.lib.build {
		inherit pkgs;
		modules = [{
			wrappers.emacs = {
				basePackage = emacs-package;
				pathAdd = emacs-deps;
			};
		}];
	};
in
{
	# === TODO: move all deps to emacs-wrapped ===
	# home.packages = with pkgs; [
	# 	# === TypeScript ===
	# 	nodejs
	# 	nodePackages.npm
	# 	nodePackages.typescript
	# 	nodePackages.typescript-language-server
	#
	# 	xorg.xinit
	# 	xorg.xmodmap
	# 	# arandr
	# ];

	programs.emacs = {
		enable = true;
		package = emacs-wrapped;
		# ==========
		# Works if all code is in a single file
		# I just declare manually because i get more control
		# ==========
		# package = (pkgs.emacsWithPackagesFromUsePackage {
		# 	config = ./init.el;
		# 	defaultInitFile = true;
		# 	package = pkgs.emacs;
		# 	alwaysEnsure = true;
		# 	# alwaysTangle = true;
		# 	# extraEmacsPackages = epkgs: [
		# 	# 	epkgs.doom-themes
		# 	# ];
		# });
	};

	home.file.".emacs.d" = {
		source = lib.cleanSourceWith {
			filter = name: _type: let
				baseName = baseNameOf (toString name);
			in
				!(lib.hasSuffix ".nix" baseName);
			src = lib.cleanSource ./.;
		};
		recursive = true;
	};

	# Command to find the code to use:
	# https://github.com/emacs-eaf/emacs-application-framework/wiki/NixOS
	# nix run nixpkgs#nurl "https://github.com/emacs-eaf/emacs-application-framework"
	# Used flake input with flake = false instead
	# home.file.".emacs.d/site-lisp/emacs-application-framework".source = pkgs.fetchFromGitHub {
	# 	owner = "emacs-eaf";
	# 	repo = "emacs-application-framework";
	# 	rev = "ac135be35220786df1e0bcb4f1a1a95d7c0c7183";
	# 	hash = "sha256-12gVfkWhoc9y4UKfhp2n+iM8nyCetVgviyShm4mhmDA=";
	# }
	# With flakes instead:
	# home.file.".emacs.d/site-lisp/emacs-application-framework".source = inputs.eaf;

	# home.file.".emacs.d/site-lisp/emacs-application-framework".source = pkgs.runCommand "emacs-eaf" {
	# 	buildInputs = [ pkgs.python311 ];
	# 	src = pkgs.fetchFromGitHub {
	# 		owner = "emacs-eaf";
	# 		repo = "emacs-application-framework";
	# 		rev = "ac135be35220786df1e0bcb4f1a1a95d7c0c7183";
	# 		hash = "sha256-12gVfkWhoc9y4UKfhp2n+iM8nyCetVgviyShm4mhmDA=";
	# 	};
	# } ''
	# 	mkdir -p $out
	# 	cp -r $src/* $out
	# 	cd $out
	# 	chmod +x install-eaf.py
	# 	${pkgs.python311}/bin/python3 install-eaf.py --ignore-core-deps --ignore-py-deps --ignore-node-deps --install-all-apps
	# '';

	# Restart with systemctl --user restart emacs
	services.emacs = {
		enable = true;
		package = emacs-wrapped;
		client.enable = true;
	};
}
