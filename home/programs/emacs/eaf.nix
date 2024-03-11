{ pkgs ? import <nixpkgs> {} }:
# This all *kind of* works
# it installs, but is missing steps like npm install
# and potentially some other dependencies (system, python, node etc.)

let
	eaf-demo = pkgs.fetchFromGitHub {
		owner = "emacs-eaf";
		repo = "eaf-demo";
		rev = "d210ef3834b2e4726299c99a4e2284dd0659e84c";
		hash = "sha256-R3Xui5MW9S1mLnUeV0WYE1mnNy7KiLiNqYp1/Rpd0Z8=";
	};
	eaf-browser = pkgs.fetchFromGitHub {
		owner = "emacs-eaf";
		repo = "eaf-browser";
		rev = "26a88c4d0e106b8ac7ae29e62fef42c636fbe8a6";
		hash = "sha256-lfFkz55aG5DhU6p6p/pLCE8UKe9281C8Znwc4HTyY8c=";
	};
in
pkgs.stdenv.mkDerivation {
	name = "emacs-application-framework";

	src = pkgs.fetchFromGitHub {
		owner = "emacs-eaf";
		repo = "emacs-application-framework";
		rev = "ac135be35220786df1e0bcb4f1a1a95d7c0c7183";
		hash = "sha256-12gVfkWhoc9y4UKfhp2n+iM8nyCetVgviyShm4mhmDA=";
	};

	buildInputs = with pkgs; [
		git nodejs wmctrl xdotool
		aria # eaf-browser
		fd # eaf-file-manager
	];

	nativeBuildInputs = with pkgs; [
		pkg-config
		gcc
		libinput
		libevdev
		# libudev
		nodejs
		nodePackages.npm
	];

	buildPhase = ''
		mkdir -p app
		cp -r ${eaf-demo} app/demo
		cp -r ${eaf-browser} app/browser
		# npm install ./app/browser

		gcc reinput/main.c -o reinput/reinput `pkg-config --cflags --libs libinput libevdev libudev`
	'';

  installPhase = ''
		mkdir -p $out/share/emacs/site-lisp/elpa/emacs-application-framework
		cp -r * $out/share/emacs/site-lisp/elpa/emacs-application-framework/
  '';
}
