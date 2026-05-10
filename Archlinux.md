## Wacom
- [Wacom dual monitor](https://askubuntu.com/questions/270156/how-to-map-wacom-correctly-to-monitor)`: xinput list | grep -i wacom`, `xsetwacom --set "17" MapToOutput HDMI-1 ; xsetwacom --set "6" MapToOutput HDMI-1` change the numbers to corresponding out put of previous command.
- ## LaTeX
- `https://yihui.org/tinytex/install-bin-unix.sh`
- ```
  bash
  pon
  chmod +x install-bin-unix.sh
  ./install-bin-unix.sh
  ```
- ## Wayland
- [微信中的fcitx5和鼠标缩放异常](https://forum.archlinuxcn.org/t/topic/13893)
- ## Settings
- System Font: GTK-Settings → Widgets → Widget style preview
- `tf233.top`
-
- ## Packages
- ### Main
- ```
  kitty fcitx5 fcitx5-rime catfish mousepad mpv pdfarranger rnote zathura nwg-look zen-browser cliphist translate-shell
  clash-verge-rev-bin nutstore zotero-bin wps-office epsonscan2 ttf-lxgw-wenkai logseq-desktop-bin wemeet-bin wechat-universal-bwrap linuxqq-nt-bwrap celluloid downgrade fcitx5-skin-fluentdark-git fcitx5-skin-fluentlight-git freetype2-wps jupyterlab mosek nauty minder ncdu thunderbird wget yt-dlp
  ```
- Notice that CachyOs has its own versions.
- ### Python
- ```
  python-igraph
  python-networkx
  python-numpy
  python-picos
  python-pip
  python-pyperclip
  python-pywalfox
  python-scipy
  ```
- ### Fonts
- ```
  ttf-nerd-fonts-symbols
  ttf-times-new-roman
  ttf-wps-fonts
  ttf-dejavu
  ```
- ### Others
- ```
  tropy
  webkit2gtk-is-webkit2gtk-4-1
  work-break
  xwayland-satellite
  xdg-desktop-portal-hyprland
  epson-inkjet-printer-escpr
  ```