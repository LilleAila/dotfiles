lib: rec {
  mkOption' = type: default: lib.mkOption {inherit type default;};

  mkStrOption = default: mkOption' lib.types.str default;
}
