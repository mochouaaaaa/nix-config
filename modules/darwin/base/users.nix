{ self, ... }:
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."${self.myvars.username}" = {
    home = "/Users/${self.myvars.username}";
  };
}
