## Wacom
- [Wacom dual monitor](https://askubuntu.com/questions/270156/how-to-map-wacom-correctly-to-monitor)`: xinput list | grep -i wacom`, `xsetwacom --set "17" MapToOutput HDMI-1 ; xsetwacom --set "6" MapToOutput HDMI-1` change the numbers to corresponding out put of previous command.

## LaTeX
- `https://yihui.org/tinytex/install-bin-unix.sh`
- ```
  bash
  pon
  chmod +x install-bin-unix.sh
  ./install-bin-unix.sh
  ```

## Wayland
- [微信中的fcitx5和鼠标缩放异常](https://forum.archlinuxcn.org/t/topic/13893)

## Settings
- System Font: GTK-Settings → Widgets → Widget style preview
- `tf233.top`
-
- copy `~/.local/share/fonts` before installation
- install `libtiff5` for WPS to export PDF

## Packages
- [USTC CachyOs](https://mirrors.ustc.edu.cn/help/cachyos.html)

- ### Main
- ```
  kitty fcitx5 fcitx5-rime catfish mousepad mpv pdfarranger rnote zathura nwg-look zen-browser cliphist translate-shell wlsunset pwvucontrol pipewire deepseek-tui marker-enhanced-bin 
  clash-verge-rev-bin nutstore zotero-bin wps-office epsonscan2 ttf-lxgw-wenkai logseq-desktop-bin wemeet-bin wechat-universal-bwrap linuxqq-nt-bwrap celluloid downgrade fcitx5-skin-fluentdark-git fcitx5-skin-fluentlight-git freetype2-wps jupyterlab mosek nauty minder ncdu thunderbird wget yt-dlp gThumb
  ```
- Notice that CachyOs has its own versions.
- remove `pavucontrol, alacritty`, replace firefox with `zen-browser`
- 
- WPS: `some formula symbols might not be displayed ...`
- From Windows `cp cambria.ttc msyh.ttc msyhbd.ttc msyhl.ttc simfang.ttf simhei.ttf simkai.ttf simsun.ttc simsunb.ttf SimsunExtG.ttf ~/.local/share/fonts/` and `fc-cache -fv`
- [SDDM themes](https://github.com/ArtemSmaznov/SDDM-themes)
- [SDDM themes simple](https://github.com/stepanzubkov/where-is-my-sddm-theme)
- `/boot/limine.conf` to set `quiet`
- firefox: `about:config` -> `pdfjs.sidebarViewOnLoad` to `0`, `pdfjs.defaultZoomValue` to `page-width`


### Python
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

### Fonts
- ```
  ttf-nerd-fonts-symbols
  ttf-times-new-roman
  ttf-wps-fonts
  ttf-dejavu
  ```

### Others
- ```
  tropy
  webkit2gtk-is-webkit2gtk-4-1
  work-break
  xwayland-satellite
  xdg-desktop-portal-hyprland
  epson-inkjet-printer-escpr
  ```
