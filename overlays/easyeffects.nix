# #
# EASYEFFECTS OVERLAY
#
# Sets the GTK theme explicitly in the `gappsWrapperArgs` since EasyEffects is being an asshole.
# #

final: prev: {
  easyeffects = prev.easyeffects.overrideAttrs (drv: {
    preFixup = ''
      ${drv.preFixup}
      gappsWrapperArgs+=(
        --set GTK_THEME "Catppuccin-Latte-Yellow"
      )
    '';
  });
}
