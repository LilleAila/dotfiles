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
  };

  ssh = {
    # Same here. private keys are encrypted
    mac.public = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC8kaSCUCHrIhpwp5tU6vWeQ/dFX+f3/B7XU31Kl51vG olai.solsvik@gmail.com";
    legion.public = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN5Z52ibKQO2mugbjo8x4+EvWFSCf+rFg8cOd9Zl7Xj2 olai.solsvik@gmail.com legion";
    t420.public = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJHIpVw9hUyEkO/b4qmkpumxceN1vZQKKm6HAJC87NW olai.solsvik@gmail.com T420";
    oci.public = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAflP4pHO9TpdmFmqdrnhWgBH3JsZqZJ8cnBZKabGANg olai.solsvik@gmail.com OCI";
    installer.public = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ/cCDWazpsY+tkCHJ8NJX3/s+jJgEQnlL+P2APqcr2Q olai.solsvik@gmail.com NixOS installer";
    e14g5.public = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBELvMHga1OSBHxls4IpxNbmTAIzLNGT3rBOU9wp7KZr olai.solsvik@gmail.com e14g5";
  };
}
