{...}: {
  imports = [
    ./chromium.nix
    # ./firefox # TODO firefox webapps, but there is really no reason to do it when chromium works fine
  ];
}
