# Current Font Setup

This document records the current font assignment on this machine (CachyOS KDE, captured 2026-08-22).

## Font usage

| Area | Font | Size | Notes |
| --- | --- | --- | --- |
| KDE / Qt general UI | Noto Sans CJK SC | 11 | Main application UI font, weight 400 |
| KDE window title | Noto Sans CJK SC | 11 | Weight 500 (slightly heavier than normal UI) |
| KDE menu | Noto Sans CJK SC | 11 | Menu text |
| KDE toolbar | Noto Sans CJK SC | 11 | Toolbar text |
| KDE taskbar | Noto Sans CJK SC | 11 | Task manager / panel text |
| KDE smallest readable font | Noto Sans CJK SC | 10 | Small UI text |
| KDE fixed-width font | Hack Nerd Font Mono | 10 | Monospace font configured in KDE |
| GTK2 | Noto Sans CJK SC | 11 | GTK2 application UI font |
| GTK3 | Noto Sans CJK SC | 11 | GTK3 application UI font |
| GTK4 | Noto Sans CJK SC | 11 | GTK4 application UI font |
| Kitty terminal | Hack Nerd Font Mono | 10.5 | Latin / Nerd glyphs; CJK via `symbol_map` |
| Kitty CJK fallback | Maple Mono NF CN | 10.5 | CJK / CJK punctuation ranges only |
| Cursor / VS Code OSS editor | Hack Nerd Font Mono | default | Fallback: Maple Mono NF CN |
| Cursor integrated terminal | Hack Nerd Font Mono | default | Fallback: Maple Mono NF CN |
| Neovim GUI (`guifont`) | Hack Nerd Font Mono | 14 | TUI ignores this and follows the terminal |

## Summary

- **UI font:** Noto Sans CJK SC 11pt (window title weight 500)
- **Latin / Nerd monospace:** Hack Nerd Font Mono
- **CJK monospace fallback:** Maple Mono NF CN
- **Hinting / rendering:** antialias on, `hintslight`, RGB subpixel
- **GTK DPI:** `gtk-xft-dpi=147456` (144 dpi)

## fontconfig fallbacks

`~/.config/fontconfig/conf.d/99-prefer-fonts.conf` sets family preference and CJK fallback:

| Generic family | Prefer order |
| --- | --- |
| sans-serif | Noto Sans → Noto Sans CJK SC → Noto Sans CJK TC → Noto Color Emoji |
| serif | Noto Serif → Noto Serif CJK SC → Noto Serif CJK TC → Noto Color Emoji |
| monospace | Hack Nerd Font Mono → Maple Mono NF CN → Noto Sans Mono CJK SC → Noto Color Emoji |
| emoji | Noto Color Emoji |

Chinese (`lang` contains `zh`):

- sans-serif → Noto Sans CJK SC
- serif → Noto Serif CJK SC
- monospace → Maple Mono NF CN → Noto Sans Mono CJK SC

`fc-match` currently resolves:

- `sans` → Noto Sans Regular
- `serif` → Noto Serif Regular
- `monospace` → Hack Nerd Font Mono Regular

## Config sources

- KDE / Qt: `~/.config/kdeglobals`
- Qt4 / Trolltech: `~/.config/Trolltech.conf`
- GTK2: `~/.gtkrc-2.0`
- GTK3: `~/.config/gtk-3.0/settings.ini`
- GTK4: `~/.config/gtk-4.0/settings.ini`
- fontconfig hinting: `~/.config/fontconfig/fonts.conf`
- fontconfig family prefer: `~/.config/fontconfig/conf.d/99-prefer-fonts.conf`
- Kitty: `~/.config/kitty/kitty.conf`
- Cursor: `~/.config/Cursor/User/settings.json`
- VS Code OSS: `~/.config/Code - OSS/User/settings.json`
- Neovim GUI: `~/.config/nvim/lua/config/options.lua`

## Notes

- `fastfetch` currently reports:
  - `Noto Sans CJK SC (11pt) [Qt]`
  - `Noto Sans CJK SC (11pt) [GTK2/3/4]`
- Kitty uses `Hack Nerd Font Mono` as `font_family`. Hack has no CJK glyphs, so `symbol_map` sends CJK / CJK punctuation ranges to `Maple Mono NF CN`.
- Cursor and VS Code OSS use the same stack: `'Hack Nerd Font Mono', 'Maple Mono NF CN', monospace`.
- Neovim TUI follows Kitty; GUI / WSLg only uses `Hack Nerd Font Mono:h14`.
