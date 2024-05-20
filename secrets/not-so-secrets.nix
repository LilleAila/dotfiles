# TODO: also put some stuff like usernames etc. here
{
  gpg = {
    id = "D1ACCDCF2B9B9799";
    public = ''
      -----BEGIN PGP PUBLIC KEY BLOCK-----

      mDMEZktZNBYJKwYBBAHaRw8BAQdA/k7C6pIGPE4nCgwNUM7OL0LnUcf0cs1ArUGR
      g801yAi0JU9sYWkgU29sc3ZpayA8b2xhaS5zb2xzdmlrQGdtYWlsLmNvbT6IjgQT
      FgoANhYhBIGFKfm7TDPwabuXgtGszc8rm5eZBQJmS1k0AhsDBAsJCAcEFQoJCAUW
      AgMBAAIeBQIXgAAKCRDRrM3PK5uXmf6ZAQCPCQwsETzoF97MvsnoEdQF+caJnhAT
      WtLu2/tMeGgrrgEA7IIjWtioKFmjXZ8WKLvYMD62K2CzqqosiJsThh8hPQ64OARm
      S1k0EgorBgEEAZdVAQUBAQdAToXMwH0rNAlrjZRsYwDPsoqqLVkyeWH0IxWbf1WU
      FFQDAQgHiHgEGBYKACAWIQSBhSn5u0wz8Gm7l4LRrM3PK5uXmQUCZktZNAIbDAAK
      CRDRrM3PK5uXmT6iAQDNKvvIYSMQtE6zDr2ufSC7J7jq6AjJKYDO4TXn2kDKuwD/
      e5moeoEIiVZq29ePgv+zvgJmP8r06yZfwsVjUdzOOgM=
      =PT4y
      -----END PGP PUBLIC KEY BLOCK-----
    '';
    # other = {
    #   ildenh = ''
    #     -----BEGIN PGP PUBLIC KEY BLOCK-----
    #
    #     mDMEZks8NRYJKwYBBAHaRw8BAQdAChhh9N+FhQ+O3EE4Lj50HrndVlCxO+Pbjfom
    #     kX9pzTi0JElsZGVuSCAoR2l0aHViKSA8SWxkZW5ILjFAcHJvdG9uLm1lPoiOBBMW
    #     CgA2FiEEojdtMBkxiw/r///63l3ojLZWlToFAmZLPDUCGwMECwkIBwQVCgkIBRYC
    #     AwEAAh4FAheAAAoJEN5d6Iy2VpU6ZPgA/3oRczab/GAKTL3AgdFCMXx1DwNr0lVs
    #     QtU0f0lTb0EPAQCLpIM77BCRSnoc1VRqWJRirg7CA8VXYLEnAotrwOsDC7g4BGZL
    #     PDUSCisGAQQBl1UBBQEBB0DInzcqiIT0CD0A8hBYMNAUUoYYWmDamdS14h7XZ/mP
    #     DgMBCAeIeAQYFgoAIBYhBKI3bTAZMYsP6///+t5d6Iy2VpU6BQJmSzw1AhsMAAoJ
    #     EN5d6Iy2VpU6GGgA/2azrjnKBKA4F9f0j2jvPdXVQELm1os0I5XfLxjLSPTgAP9P
    #     OKFOEOOhv5l0PK+oZgIVBsuRo/D/Fg0CCcOl/N90CQ==
    #     =/t3z
    #     -----END PGP PUBLIC KEY BLOCK-----
    #   '';
    # };
  };

  ssh = {
    # Same here. private keys are encrypted
    mac.public = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC8kaSCUCHrIhpwp5tU6vWeQ/dFX+f3/B7XU31Kl51vG olai.solsvik@gmail.com";
    legion.public = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN5Z52ibKQO2mugbjo8x4+EvWFSCf+rFg8cOd9Zl7Xj2 olai.solsvik@gmail.com legion";
    t420.public = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJHIpVw9hUyEkO/b4qmkpumxceN1vZQKKm6HAJC87NW olai.solsvik@gmail.com T420";
    oci.public = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAflP4pHO9TpdmFmqdrnhWgBH3JsZqZJ8cnBZKabGANg olai.solsvik@gmail.com OCI";
    installer.public = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ/cCDWazpsY+tkCHJ8NJX3/s+jJgEQnlL+P2APqcr2Q olai.solsvik@gmail.com NixOS installer";
  };
}
