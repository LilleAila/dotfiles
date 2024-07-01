{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  packages = with pkgs; [
    alejandra
    typescript
    nodePackages.typescript-language-server
    prettierd
    emmet-ls
    vscode-langservers-extracted
  ];
}
