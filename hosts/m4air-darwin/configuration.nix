{
  user,
  ...
}:
{
  settings = {
    aerospace.enable = true;
    brew.enable = true;
    home-manager.enable = true;
    jankyborders.enable = true;
    misc.enable = true;
    nix.enable = true;
    system.enable = true;
  };

  home-manager.users.${user} = import ./home.nix;
}
