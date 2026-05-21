# Desktop Prettification Design

**Date:** 2026-05-21  
**Goal:** Prettify the Hyprland desktop for a screensharing event. Aesthetic: cozy. Color scheme: Catppuccin Macchiato purple/mauve with pink→mauve animated gradient borders and subtle glow.

---

## 1. Wallpaper — swww

**Problem:** hyprpaper broke after a system update.  
**Solution:** Replace with swww, which also supports animated GIFs.

- Remove `exec-once = hyprpaper` from `.config/hypr/hyprland.conf`
- Remove `xdg.configFile."hypr/hyprpaper.conf"` symlink from `modules/ui/hypr/default.nix`
- Add `swww` to home packages in `modules/home.nix`
- Add to hyprland.conf:
  ```
  exec-once = swww-daemon && sleep 0.5 && swww img /etc/nixos/assets/rooftop2.gif --outputs DP-4 --transition-type fade && swww img /etc/nixos/assets/night2.jpg --outputs HDMI-A-2 --transition-type fade && swww img /etc/nixos/assets/night2.jpg --outputs DP-5 --transition-type fade
  ```
- Primary (DP-4): `rooftop2.gif` (animated, cozy)
- Secondaries (HDMI-A-2, DP-5): `night2.jpg` (static, less distracting)

---

## 2. Hyprland Window Decorations

File: `.config/hypr/hyprland.conf`

- **Active border:** animated pink→mauve gradient
  ```
  col.active_border = rgb(f5bde6) rgb(c6a0f6) 45deg
  col.inactive_border = rgba(363a4faa)
  ```
- **Blur:** `size = 5`, `passes = 2`
- **Shadow:** mauve-tinted glow
  ```
  shadow.color = rgba(c6a0f688)
  shadow.range = 12
  shadow.render_power = 2
  ```
- **Rounding:** `10` → `14`
- **Inactive opacity:** keep `0.95`

---

## 3. Waybar — Primary Monitor (DP-4)

File: `.config/waybar/waybar.conf`

- `output: "DP-4"`
- `position: "top"`, `height: 36`
- All modules in `modules-center` as a single pill:
  ```
  weather · temperature · workspaces · spotify · cava · wireplumber · language · clock · powermenu
  ```

File: `.config/waybar/style.css`

- `.modules-center`:
  ```css
  border-radius: 999px;
  border: 1px solid rgba(245,189,230,0.5);
  box-shadow: 0 0 12px rgba(198,160,246,0.3);
  background: rgba(30,30,46,0.75);
  ```
- `#workspaces button.active`: filled mauve dot `#c6a0f6`
- `#workspaces button`: dim outline circle

File: `.config/waybar/modules.json`

- Add `hyprland/workspaces` with `format: "{icon}"` and icon map `{"1":"●","2":"●",...}`

---

## 4. Waybar — Secondary Monitors (HDMI-A-2, DP-5)

New file: `.config/waybar/waybar-secondary.conf`

- `output: ["HDMI-A-2", "DP-5"]`
- `position: "top"`, `height: 32`
- `modules-left: ["hyprland/workspaces"]`
- `modules-right: ["clock"]`
- Same `style.css`, smaller padding

File: `.config/waybar/launch.sh`

```bash
waybar -c ~/.config/waybar/waybar.conf &
waybar -c ~/.config/waybar/waybar-secondary.conf &
```

---

## 5. Wofi Theme

File: `.config/wofi/style.css`

- `window`: border `#c6a0f6` (mauve), `border-radius: 14px`, `box-shadow: 0 0 16px rgba(198,160,246,0.25)`, font `FiraCode Nerd Font`
- `#input`: transparent bg, `border-bottom: 1px solid #c6a0f6` on focus, text `#cad3f5`
- `#entry:selected`: `background: rgba(198,160,246,0.2)`, `border-radius: 8px`
- `#text:selected`: color `#f5bde6` (pink)

No changes to `.config/wofi/config`.

---

## 6. Dunst Notifications

File: `.config/dunst/dunstrc`

- `corner_radius = 14`
- `frame_width = 2`
- `font = FiraCode Nerd Font 11`
- `offset = 15x55` (clears pill bar)
- Urgency colors:
  - low: `frame_color = "#c6a0f6"`, `background = "#24273a"`
  - normal: `frame_color = "#f5bde6"`, `background = "#24273a"`
  - critical: `frame_color = "#ed8796"`, `background = "#24273a"`
- `foreground`: keep `#f5e0dc` for all urgencies
- `timeout`: keep `0` for all urgencies

---

## 7. Cursor Theme

Use the official Catppuccin NixOS module (https://nix.catppuccin.com/getting-started/) rather than individual packages.

- Add the `catppuccin` flake input to `flake.nix`
- Add the Home Manager module from `inputs.catppuccin.homeManagerModules.catppuccin`
- Configure in `modules/home.nix`:
  ```nix
  catppuccin.flavor = "macchiato";
  catppuccin.accent = "mauve";
  catppuccin.cursors.enable = true;
  ```
- This handles cursor name, package, and gtk cursor config automatically
- Keep `env = XCURSOR_SIZE,24` in hyprland.conf as fallback

---

## Summary

| # | Component | Change |
|---|-----------|--------|
| 1 | Wallpaper | hyprpaper → swww, rooftop2.gif primary, night2.jpg secondaries |
| 2 | Hyprland borders | pink→mauve gradient + mauve shadow glow, rounding 14 |
| 3 | Waybar primary | Centered floating pill, all modules center, workspace dots |
| 4 | Waybar secondary | Minimal bar on HDMI-A-2 + DP-5, workspaces + clock |
| 5 | Wofi | Mauve border + glow, pink selected, FiraCode font |
| 6 | Dunst | Mauve/pink frames, dark base bg, FiraCode font, corner 14 |
| 7 | Cursor | catppuccin-macchiato-mauve-cursors via Nix |
