{
  general = {
    askForConfirmationOnLogout = true; # 关机重启时弹出确认框
  };
  sessionRestore = {
    restoreOpenApplicationsOnLogin = "onLastLogout"; # 登录时恢复上次打开的应用
    excludeApplications = []; # 不要恢复的应用
  };
}
