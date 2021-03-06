# My Dotsies

**Warning:** The install scripts overwrite existing configurations.

![Screenshot](https://raw.githubusercontent.com/dnordstrom/dotfiles/master/screenshots/20190919-mirage-main.png)

My first rice. I wanted to make it as simple and out of the way as possible,
with colors from the three different [Ayu color
schemes](https://github.com/ayu-theme/ayu-colors).

[Outdated screenshots (mirage, dark, and light)](https://github.com/dnordstrom/dotfiles#screenshots)  

**OS:** Arch  
**WM:** Sway  
**Terminal:** Alacritty  
**Shell:** fish  
**Bar:** Waybar  
**Fonts:** Input *(UI)*, Input *(Terminal)*, Iosevka *(Bar)*  
**GTK:** [Ayu-Mirage-Dark](https://github.com/dnordstrom/ayu-theme/tree/ayu-mirage)
*(Customized [Arc](https://github.com/horst3180/arc-theme))*  
**Kvantum:** [AyuMirage](https://github.com/dnordstrom/ayu-kde) *(Customized
[Arc](https://github.com/PapirusDevelopmentTeam/arc-kde/tree/master/Kvantum))*  
**wofi:** [ayu-mirage](https://github.com/dnordstrom/dotfiles/tree/master/wofi)  
**Icons:** [Tela](https://github.com/vinceliuice/Tela-icon-theme)  
**Wallpaper:**
[Lost in Tokyo](https://unsplash.com/photos/cXU6tNxhub0) by [Andre Benz](https://unsplash.com/@trapnation)  
**Dotfiles:** https://github.com/dnordstrom/dotfiles

* GTK theme is a customized Arc with a few colors changed to match
  Ayu/Mirage/Dark (in different Git branches). For QT, a customized Arc Kvantum
  theme (a tad bit too dark, SVG needs work).
* Papirus icons (now using Tela) changed to orange with [papirus-folders](https://aur.archlinux.org/packages/papirus-folders-git/).
* Created light, mirage, and dark versions for GTK (separate branches in the
  repo), QT, rofi, and Xresources. Haven't really used the light ones yet, so they
  may be sub-optimal. For Xresources there's also a reduced brightness light
  version that is more legible as terminal color scheme.
* Also ported the Ayu colors to Termite and added them to the Alacritty configuration.

**Note:** Only the GTK (and Kvantum) themes have been edited from Arc, not stuff I
don't use (XFWM, etc.). I disable the rest when building the GTK theme.

## More

Here's a list of useful things not created by me:

* [Add transparency](https://github.com/swaywm/sway/blob/master/contrib/inactive-windows-transparency.py) to inactive windows.

## Screenshots (outdated)

### Mirage

![Screenshot](https://raw.githubusercontent.com/dnordstrom/dotfiles/master/screenshots/20190919-mirage-apps-launcher.png)
![Screenshot](https://raw.githubusercontent.com/dnordstrom/dotfiles/master/screenshots/20190919-mirage-comparison.png)
![Screenshot](https://raw.githubusercontent.com/dnordstrom/dotfiles/master/screenshots/20190919-mirage-media.png)
![Screenshot](https://raw.githubusercontent.com/dnordstrom/dotfiles/master/screenshots/20190919-mirage-neofetch.png)

### Dark

![Screenshot](https://raw.githubusercontent.com/dnordstrom/dotfiles/master/screenshots/20190921-dark-code-neofetch.png)
![Screenshot](https://raw.githubusercontent.com/dnordstrom/dotfiles/master/screenshots/20190921-dark-code-files.png)
![Screenshot](https://raw.githubusercontent.com/dnordstrom/dotfiles/master/screenshots/20190919-dark-comparison.png)

### Light

![Screenshot](https://raw.githubusercontent.com/dnordstrom/dotfiles/master/screenshots/20190921-light-code-files.png)
![Screenshot](https://raw.githubusercontent.com/dnordstrom/dotfiles/master/screenshots/20190919-light-comparison.png)
![Screenshot](https://raw.githubusercontent.com/dnordstrom/dotfiles/master/screenshots/20190921-light-firefox-term.png)
