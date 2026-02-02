_: {
  # FIXME: do this in a better way such that if it fails, the flake will still be usable.
  # Atm i don't think anyone can use this flake because this causes it to fail
  flake.secrets = import ../secrets/tokens.nix;
}
