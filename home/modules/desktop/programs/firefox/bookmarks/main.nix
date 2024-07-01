[
  {
    name = "Wikipedia";
    tags = [ "wiki" ];
    keyword = "wiki";
    url = "https://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go";
  }
  {
    name = "Toolbar";
    toolbar = true;
    bookmarks = [
      {
        name = "NixOS";
        url = "https://nixos.org";
      }
      {
        name = "NixOS wiki";
        tags = [
          "wiki"
          "nix"
        ];
        url = "https://nixos.wiki/";
      }
    ];
  }
]
