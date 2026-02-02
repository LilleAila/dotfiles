_: {
  configurations.darwin."Olais-MacBook-Air".module = {
    nixpkgs.hostPlatform = "aarch64-darwin";
    system.stateVersion = 6;
  };

  configurations.home."olai".module = {
    programs.git.enable = true;
  };
}
