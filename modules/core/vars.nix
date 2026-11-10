{ lib, ... }:
{

  options.myvars = {
    githubUsername = lib.mkOption { type = lib.types.str; };
    useremail = lib.mkOption { type = lib.types.str; };
    initialHashedPassword = lib.mkOption { type = lib.types.str; };
    dotfilePath = lib.mkOption { type = lib.types.str; };
  };

  config = {
    myvars = {
      githubUsername = "mochouaaaaa";
      useremail = "nn.mochou+github@gmail.com";
      initialHashedPassword = "$y$j9T$FblQdc6JW7sQSTdMjh2kQ1$GqXMmWVt86ooa4xe8wvt9gNN20urtxyFJf4VCYqWmmB";
      dotfilePath = "dotfile";
    };

  };
}
