# TODO: also put some stuff like usernames etc. here
{
  gpg = {
    id = "D2C70E07095CF5E5";
    public = ''
      -----BEGIN PGP PUBLIC KEY BLOCK-----

      mDMEZkMQcxYJKwYBBAHaRw8BAQdAlnnAHEPyN0sWGPh5rBU+tqb7hTJWqIRZ6R0/
      KNYQ4Hq0JU9sYWkgU29sc3ZpayA8b2xhaS5zb2xzdmlrQGdtYWlsLmNvbT6IjgQT
      FgoANhYhBLkD2pZAWFGJvVUgQdLHDgcJXPXlBQJmQxBzAhsDBAsJCAcEFQoJCAUW
      AgMBAAIeBQIXgAAKCRDSxw4HCVz15d6GAQCwGbMzg5tXqZYVkTF2nloF5IL2B6LG
      g/0GR/w1d+5WjwEAgu+pcOPOfEULsy5EGQwqxt6u+MgcMgzcmanjElDtRwS4OARm
      QxBzEgorBgEEAZdVAQUBAQdAxjw/I0sxyV6QlSliNTgf3lQWWYmGj1W9HXUv56VR
      QRgDAQgHiHgEGBYKACAWIQS5A9qWQFhRib1VIEHSxw4HCVz15QUCZkMQcwIbDAAK
      CRDSxw4HCVz15SARAP9HHEALCHk5q2YxArqkOePFsBhVjUYGyY3bs1mOEo+B8gD7
      B0n6R15RlRvaIVta4u7ppi8HKkfvlEoJd7SUK6qrBQY=
      =c5Io
      -----END PGP PUBLIC KEY BLOCK-----
    '';
    # Private key names. The keys themselves are encrypted with sops
    primary = "3A99EF8882EB73173BFD911D6690E3465C901012";
    subkey = "7011A0A00F1933CFC7C70B41EDFCDC6221B14F69";
  };

  ssh = {
    # Same here. private keys are encrypted
    mac.public = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC8kaSCUCHrIhpwp5tU6vWeQ/dFX+f3/B7XU31Kl51vG olai.solsvik@gmail.com";
    legion.public = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN5Z52ibKQO2mugbjo8x4+EvWFSCf+rFg8cOd9Zl7Xj2 olai.solsvik@gmail.com legion";
    t420.public = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJHIpVw9hUyEkO/b4qmkpumxceN1vZQKKm6HAJC87NW olai.solsvik@gmail.com T420";
    oci.public = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAflP4pHO9TpdmFmqdrnhWgBH3JsZqZJ8cnBZKabGANg olai.solsvik@gmail.com OCI";
  };
}
