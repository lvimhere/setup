# Current Font Setup

This document records the current font assignment on this machine.

## Font usage

| Area | Font | Size | Notes |
| --- | --- | --- | --- |
| KDE / Qt general UI | Noto Sans CJK SC | 10 | Main application UI font |
| KDE window title | Noto Sans CJK SC | 10 | Slightly heavier weight than normal UI |
| KDE menu | Noto Sans CJK SC | 10 | Menu text |
| KDE toolbar | Noto Sans CJK SC | 10 | Toolbar text |
| KDE taskbar | Noto Sans CJK SC | 10 | Task manager / panel text |
| KDE smallest readable font | Noto Sans CJK SC | 9 | Small UI text |
| KDE fixed-width font | Maple Mono NF CN | 10 | Monospace font configured in KDE |
| GTK2 | Noto Sans CJK SC | 10 | GTK2 application UI font |
| GTK3 | Noto Sans CJK SC | 10 | GTK3 application UI font |
| GTK4 | Noto Sans CJK SC | 10 | GTK4 application UI font |
| Kitty terminal | Maple Mono NF CN | 10.5 | Terminal and Neovim code font |

## Summary

- **UI font:** Noto Sans CJK SC
- **Code / terminal monospace font:** Maple Mono NF CN

## Config sources

- KDE / Qt: `~/.config/kdeglobals`
- GTK2: `~/.gtkrc-2.0`
- GTK3: `~/.config/gtk-3.0/settings.ini`
- GTK4: `~/.config/gtk-4.0/settings.ini`
- Kitty: `~/.config/kitty/kitty.conf`

## Notes

- `fastfetch` currently reports:
  - `Noto Sans CJK SC (10pt) [Qt]`
  - `Noto Sans CJK SC (10pt) [GTK2/3/4]`
- Kitty is configured to use `Maple Mono NF CN` directly.
