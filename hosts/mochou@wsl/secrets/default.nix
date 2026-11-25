{
  lib,
  options,
  ...
}:
{
  config = lib.optionalAttrs (options ? age) {

    home-manager.sharedModules = [
      {
        age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGZ/55qfEl93PzcMW3rGAAtClPYFloVkMpwvxVUr6Xyu";
      }
    ];

    age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHfewQe8VmrB89USJfu5MVmsO0yFi2G6BqwdPr/Njljp";
  };

}
