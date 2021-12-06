#
# Modifies desktop files to launch as native Wayland app
#
final: prev: {
  vscodium = prev.vscodium.overrideAttrs (oldAttrs: rec {
    desktopItem = oldAttrs.desktopItem.overrideAttrs (desktopAttrs: {
      buildCommand =
          builtins.replaceStrings
          [ "Exec=${oldAttrs.passthru.executableName}" ]
          [ "Exec=${oldAttrs.passthru.executableName} --enable-features=UseOzonePlatform --ozone-platform=wayland" ]
          desktopAttrs.buildCommand;
    });
    urlHandlerDesktopItem = oldAttrs.urlHandlerDesktopItem.overrideAttrs (desktopAttrs: {
      buildCommand =
        builtins.replaceStrings
          [ "Exec=${oldAttrs.passthru.executableName}" ]
          [ "Exec=${oldAttrs.passthru.executableName} --enable-features=UseOzonePlatform --ozone-platform=wayland" ]
          desktopAttrs.buildCommand;
    });
    installPhase = builtins.replaceStrings [ "${oldAttrs.desktopItem}" ] [ "${desktopItem}" ] oldAttrs.installPhase;
  });
}
