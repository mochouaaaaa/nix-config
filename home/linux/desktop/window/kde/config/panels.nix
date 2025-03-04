{
  MacOSXPanel = {
    height = 39;
    lengthMode = "fill"; # 填充屏幕
    location = "top"; # 置顶 floating top left right bottom
    floating = true; # 窗口模式
    alignment = "center"; # 居中
    opacity = "adaptive"; # 自适应
    screen = null; # 屏幕编号0123或者all
    widgets = []; # 自定义面板
  };

  xdg.configFile."plasma-org.kde.plasma.desktop-appletsrc" = {
    force = true;
    text = ''
      [ActionPlugins][0]
      MiddleButton;NoModifier=org.kde.paste
      RightButton;NoModifier=org.kde.contextmenu

      [ActionPlugins][1]
      RightButton;NoModifier=org.kde.contextmenu

      [Containments][200]
      ItemGeometries-2560x1440=
      ItemGeometriesHorizontal=
      activityId=2f311b7b-d87c-47ca-8423-e5de48e8305d
      formfactor=0
      immutability=1
      lastScreen=0
      location=0
      plugin=org.kde.plasma.folder
      wallpaperplugin=org.kde.image

      [Containments][200][ConfigDialog]
      DialogHeight=540
      DialogWidth=720

      [Containments][200][Configuration]
      PreloadWeight=0

      [Containments][200][General]
      ToolBoxButtonState=bottom
      ToolBoxButtonX=739
      ToolBoxButtonY=983
      positions={"2560x1440":["1","23"]}
      sortMode=-1

      [Containments][200][Wallpaper][org.kde.image][General]
      Image=file:///home/vince/Pictures/WhiteSur.png

      [Containments][201]
      activityId=
      formfactor=2
      immutability=1
      lastScreen=0
      location=3
      plugin=org.kde.panel
      wallpaperplugin=org.kde.image

      [Containments][201][Applets][204]
      immutability=1
      plugin=org.kde.plasma.panelspacer

      [Containments][201][Applets][204][Configuration]
      immutability=1

      [Containments][201][Applets][204][Configuration][Configuration]
      PreloadWeight=0

      [Containments][201][Applets][205]
      immutability=1
      plugin=org.kde.plasma.systemtray

      [Containments][201][Applets][205][Configuration]
      PreloadWeight=60
      SystrayContainmentId=206
      immutability=1

      [Containments][201][Applets][205][Configuration][Configuration]
      PreloadWeight=100

      [Containments][201][Applets][218][Configuration]
      immutability=1

      [Containments][201][Applets][218][Configuration][Configuration]
      PreloadWeight=100

      [Containments][201][Applets][218][Configuration][Configuration][Appearance]
      fontFamily=Cantarell
      showDate=true
      spinboxHorizontalPercentage=50
      use24hFormat=2

      [Containments][201][Applets][218][Configuration][Configuration][ConfigDialog]
      DialogHeight=540
      DialogWidth=720

      [Containments][201][Applets][225]
      immutability=1
      plugin=com.github.chrtall.kppleMenu

      [Containments][201][Applets][225][Configuration]
      PreloadWeight=80
      popupHeight=288
      popupWidth=226

      [Containments][201][Applets][225][Configuration][Advanced]
      lockScreenSettings=qdbus org.freedesktop.ScreenSaver /ScreenSaver Lock
      logOutSettings=qdbus org.kde.Shutdown /Shutdown logout
      restartSettings=qdbus org.kde.Shutdown /Shutdown org.kde.Shutdown.logoutAndReboot
      showAdvancedMode=true
      shutDownSettings=qdbus org.kde.Shutdown /Shutdown org.kde.Shutdown.logoutAndReboot

      [Containments][201][Applets][225][Configuration][ConfigDialog]
      DialogHeight=540
      DialogWidth=720

      [Containments][201][Applets][226]
      immutability=1
      plugin=org.kde.windowtitle

      [Containments][201][Applets][226][Configuration]
      PreloadWeight=70
      popupHeight=432
      popupWidth=432

      [Containments][201][Applets][226][Configuration][Appearance]
      altTxt=
      txt=%a
      txtSameFound=
      visible=false

      [Containments][201][Applets][226][Configuration][Behavior]
      closeAllowed=false
      maxminAllowed=false
      scrollAllowed=false
      showTooltip=false

      [Containments][201][Applets][226][Configuration][ConfigDialog]
      DialogHeight=540
      DialogWidth=720

      [Containments][201][Applets][227]
      immutability=1
      plugin=KdeControlStation

      [Containments][201][Applets][227][Configuration]
      PreloadWeight=100
      popupHeight=564
      popupWidth=432

      [Containments][201][Applets][229]
      immutability=1
      plugin=org.kde.netspeedWidget

      [Containments][201][Applets][229][Configuration][ConfigDialog]
      DialogHeight=540
      DialogWidth=720

      [Containments][201][Applets][229][Configuration][General]
      showLowSpeeds=true
      speedUnits=bits
      swapDownUp=true

      [Containments][201][Applets][230]
      immutability=1
      plugin=org.kde.plasma.appmenu

      [Containments][201][Applets][230][Configuration]
      PreloadWeight=60
      popupHeight=432
      popupWidth=432

      [Containments][201][Applets][232]
      immutability=1
      plugin=org.kde.plasma.resources-monitor

      [Containments][201][Applets][232][Configuration][Appearance]
      enableShadows=false
      fontScale=33
      graphHeight=20
      graphWidth=20

      [Containments][201][Applets][232][Configuration][ConfigDialog]
      DialogHeight=540
      DialogWidth=720

      [Containments][201][Applets][233]
      immutability=1
      plugin=org.kde.plasma.panelspacer

      [Containments][201][Applets][233][Configuration][General]
      expanding=false
      length=5

      [Containments][201][Applets][234]
      immutability=1
      plugin=org.kde.plasma.digitalclock

      [Containments][201][Applets][235]
      immutability=1
      plugin=org.kde.plasma.panelspacer

      [Containments][201][Applets][235][Configuration][General]
      expanding=false
      length=10

      [Containments][201][ConfigDialog]
      DialogHeight=74
      DialogWidth=1920

      [Containments][201][Configuration]
      PreloadWeight=0

      [Containments][201][General]
      AppletOrder=225;226;230;204;232;233;229;235;205;227;234

      [Containments][206]
      activityId=
      formfactor=2
      immutability=1
      lastScreen=0
      location=3
      plugin=org.kde.plasma.private.systemtray
      popupHeight=432
      popupWidth=432
      wallpaperplugin=org.kde.image

      [Containments][206][Applets][207]
      immutability=1
      plugin=org.kde.plasma.cameraindicator

      [Containments][206][Applets][208]
      immutability=1
      plugin=org.kde.plasma.clipboard

      [Containments][206][Applets][208][Configuration]
      PreloadWeight=55

      [Containments][206][Applets][209]
      immutability=1
      plugin=org.kde.plasma.devicenotifier

      [Containments][206][Applets][210]
      immutability=1
      plugin=org.kde.plasma.manage-inputmethod

      [Containments][206][Applets][211]
      immutability=1
      plugin=org.kde.plasma.notifications

      [Containments][206][Applets][211][Configuration]
      PreloadWeight=55

      [Containments][206][Applets][212]
      immutability=1
      plugin=org.kde.kdeconnect

      [Containments][206][Applets][213]
      immutability=1
      plugin=org.kde.kscreen

      [Containments][206][Applets][214]
      immutability=1
      plugin=org.kde.plasma.keyboardindicator

      [Containments][206][Applets][215]
      immutability=1
      plugin=org.kde.plasma.keyboardlayout

      [Containments][206][Applets][216]
      immutability=1
      plugin=org.kde.plasma.printmanager

      [Containments][206][Applets][217]
      immutability=1
      plugin=org.kde.plasma.volume

      [Containments][206][Applets][217][Configuration]
      PreloadWeight=55

      [Containments][206][Applets][217][Configuration][General]
      migrated=true

      [Containments][206][Applets][220]
      immutability=1
      plugin=org.kde.plasma.battery

      [Containments][206][Applets][221]
      immutability=1
      plugin=org.kde.plasma.brightness

      [Containments][206][Applets][221][Configuration]
      PreloadWeight=65

      [Containments][206][Applets][222]
      immutability=1
      plugin=org.kde.plasma.mediacontroller

      [Containments][206][Applets][223]
      immutability=1
      plugin=org.kde.plasma.networkmanagement

      [Containments][206][Applets][223][Configuration]
      PreloadWeight=55

      [Containments][206][Applets][224]
      immutability=1
      plugin=org.kde.plasma.bluetooth

      [Containments][206][Applets][224][Configuration]
      PreloadWeight=70

      [Containments][206][General]
      extraItems=org.kde.plasma.cameraindicator,org.kde.plasma.clipboard,org.kde.plasma.devicenotifier,org.kde.plasma.manage-inputmethod,org.kde.plasma.mediacontroller,org.kde.plasma.notifications,org.kde.kdeconnect,org.kde.kscreen,org.kde.plasma.battery,org.kde.plasma.bluetooth,org.kde.plasma.brightness,org.kde.plasma.keyboardindicator,org.kde.plasma.keyboardlayout,org.kde.plasma.networkmanagement,org.kde.plasma.printmanager,org.kde.plasma.volume
      knownItems=org.kde.plasma.cameraindicator,org.kde.plasma.clipboard,org.kde.plasma.devicenotifier,org.kde.plasma.manage-inputmethod,org.kde.plasma.mediacontroller,org.kde.plasma.notifications,org.kde.kdeconnect,org.kde.kscreen,org.kde.plasma.battery,org.kde.plasma.bluetooth,org.kde.plasma.brightness,org.kde.plasma.keyboardindicator,org.kde.plasma.keyboardlayout,org.kde.plasma.networkmanagement,org.kde.plasma.printmanager,org.kde.plasma.volume

      [ScreenMapping]
      itemsOnDisabledScreens=
    '';
  };
}
