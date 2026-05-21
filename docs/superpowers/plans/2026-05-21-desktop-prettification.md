# Desktop Prettification Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace hyprpaper with swww, apply a Catppuccin Macchiato pink→mauve cozy theme across Hyprland borders, Waybar (floating pill layout), Wofi, and Dunst, and add a Catppuccin cursor via the official NixOS module.

**Architecture:** Config-only changes — no new programs written. All visual changes live in `.config/` source files (symlinked to `~/.config` by Home Manager). NixOS flake gets a new `catppuccin` input for the cursor module. After all changes, the user runs `sudo nixos-rebuild switch --flake .#foxfurry`.

**Tech Stack:** NixOS flakes, Home Manager, Hyprland, swww, Waybar, Wofi, Dunst, Catppuccin NixOS module.

---

## File Map

| File | Action | Purpose |
|------|--------|---------|
| `flake.nix` | Modify | Add catppuccin flake input |
| `modules/home.nix` | Modify | Add catppuccin HM module + swww package |
| `modules/ui/hypr/default.nix` | Modify | Remove hyprpaper symlink |
| `.config/hypr/hyprland.conf` | Modify | swww exec, border colors, blur, rounding, shadow |
| `.config/waybar/waybar.conf` | Modify | Pill layout, output filter, center-only modules |
| `.config/waybar/waybar-secondary.conf` | Create | Minimal bar for secondary monitors |
| `.config/waybar/modules.json` | Modify | Add hyprland/workspaces module |
| `.config/waybar/style.css` | Modify | Pill styling, glow, workspace dots, secondary padding |
| `.config/waybar/launch.sh` | Modify | Launch both bars |
| `.config/wofi/style.css` | Modify | Mauve border + glow, pink selected, FiraCode font |
| `.config/dunst/dunstrc` | Modify | Corner radius, frame colors, font, bg color, offset |

---

## Task 1: Add swww, remove hyprpaper from Nix

**Files:**
- Modify: `modules/home.nix`
- Modify: `modules/ui/hypr/default.nix`

- [ ] **Step 1: Add swww to home packages**

In `modules/home.nix`, add `home.packages` block after `programs.home-manager.enable = true;`:

```nix
  home.packages = with pkgs; [
    swww
  ];
```

- [ ] **Step 2: Remove hyprpaper symlink from hypr module**

In `modules/ui/hypr/default.nix`, remove the hyprpaper line. The file should become:

```nix
{ inputs, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
    extraConfig = builtins.readFile ./../../../.config/hypr/hyprland.conf;
  };
}
```

- [ ] **Step 3: Commit**

```bash
git add modules/home.nix modules/ui/hypr/default.nix
git commit -m "feat: replace hyprpaper with swww in nix config"
```

---

## Task 2: Add Catppuccin NixOS module for cursor

**Files:**
- Modify: `flake.nix`
- Modify: `modules/home.nix`

- [ ] **Step 1: Add catppuccin input to flake.nix**

In `flake.nix`, add inside the `inputs` block after the `quickshell` block:

```nix
    catppuccin = {
      url = "github:catppuccin/nix";
    };
```

- [ ] **Step 2: Wire catppuccin Home Manager module into home.nix**

In `modules/home.nix`, add the catppuccin module import and cursor config. The full file becomes:

```nix
{ inputs, config, pkgs, ... }:

{
   imports = [
     ./development
     ./mimes
     ./programs
     ./ui
     inputs.catppuccin.homeManagerModules.catppuccin
   ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };
  home.username = "foxfurry";
  home.homeDirectory = "/home/foxfurry";

  home.packages = with pkgs; [
    swww
  ];

  catppuccin.flavor = "macchiato";
  catppuccin.accent = "mauve";
  catppuccin.cursors.enable = true;

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;
}
```

- [ ] **Step 3: Commit**

```bash
git add flake.nix modules/home.nix
git commit -m "feat: add catppuccin nix module for cursor theme"
```

---

## Task 3: Update hyprland.conf — swww + decorations

**Files:**
- Modify: `.config/hypr/hyprland.conf`

- [ ] **Step 1: Replace hyprpaper exec with swww, update borders**

In `.config/hypr/hyprland.conf`:

Replace:
```
exec-once = hyprpaper
```
With:
```
exec-once = swww-daemon && sleep 0.5 && swww img /etc/nixos/assets/rooftop2.gif --outputs DP-4 --transition-type fade && swww img /etc/nixos/assets/night2.jpg --outputs HDMI-A-2 --transition-type fade && swww img /etc/nixos/assets/night2.jpg --outputs DP-5 --transition-type fade
```

- [ ] **Step 2: Update border colors in general block**

Replace:
```
col.active_border = rgb(C5FFF8) rgb(5FBDFF) 45deg
col.inactive_border = rgba(595959aa)
```
With:
```
col.active_border = rgb(f5bde6) rgb(c6a0f6) 45deg
col.inactive_border = rgba(363a4faa)
```

- [ ] **Step 3: Update decoration block**

Replace the entire `decoration` block:
```
decoration {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more

    rounding = 10
    
    blur {
        enabled = true
        size = 3
        passes = 1
    }
    
    active_opacity = 1
    inactive_opacity = 0.95

    shadow {
        enabled = yes
        range = 4
        render_power = 3
        color = rgba(1a1a1aee)
    }
}
```
With:
```
decoration {
    rounding = 14

    blur {
        enabled = true
        size = 5
        passes = 2
    }

    active_opacity = 1
    inactive_opacity = 0.95

    shadow {
        enabled = yes
        range = 12
        render_power = 2
        color = rgba(c6a0f688)
    }
}
```

- [ ] **Step 4: Commit**

```bash
git add .config/hypr/hyprland.conf
git commit -m "feat: swww wallpaper + mauve border theme + updated decorations"
```

---

## Task 4: Waybar primary — floating pill layout

**Files:**
- Modify: `.config/waybar/waybar.conf`
- Modify: `.config/waybar/modules.json`

- [ ] **Step 1: Rewrite waybar.conf for pill layout**

Replace the entire contents of `.config/waybar/waybar.conf` with:

```json
{
    "layer": "top",
    "output": "DP-4",
    "position": "top",
    "height": 36,
    "spacing": 4,
    "exclusive": true,

    "include": ["~/.config/waybar/modules.json"],

    "modules-left": [],

    "modules-center": [
        "custom/weather",
        "temperature",
        "hyprland/workspaces",
        "custom/spotify",
        "cava",
        "custom/wireplumber",
        "hyprland/language",
        "clock",
        "custom/powermenu"
    ],

    "modules-right": []
}
```

- [ ] **Step 2: Add hyprland/workspaces to modules.json**

In `.config/waybar/modules.json`, add the following entry before the closing `}`:

```json
    "hyprland/workspaces": {
        "format": "{icon}",
        "format-icons": {
            "1": "●",
            "2": "●",
            "3": "●",
            "4": "●",
            "5": "●",
            "6": "●",
            "7": "●",
            "8": "●",
            "9": "●",
            "10": "●",
            "active": "●",
            "default": "○"
        },
        "persistent-workspaces": {
            "DP-4": [1, 2, 3, 4, 5]
        }
    }
```

- [ ] **Step 3: Commit**

```bash
git add .config/waybar/waybar.conf .config/waybar/modules.json
git commit -m "feat: waybar pill layout on primary monitor with workspace dots"
```

---

## Task 5: Waybar secondary monitors config

**Files:**
- Create: `.config/waybar/waybar-secondary.conf`
- Modify: `.config/waybar/launch.sh`

- [ ] **Step 1: Create waybar-secondary.conf**

Create `.config/waybar/waybar-secondary.conf` with:

```json
{
    "layer": "top",
    "output": ["HDMI-A-2", "DP-5"],
    "position": "top",
    "height": 32,
    "spacing": 4,
    "exclusive": true,

    "include": ["~/.config/waybar/modules.json"],

    "modules-left": [
        "hyprland/workspaces"
    ],

    "modules-center": [],

    "modules-right": [
        "clock"
    ]
}
```

- [ ] **Step 2: Update launch.sh to start both bars**

Replace the entire contents of `.config/waybar/launch.sh` with:

```bash
#!/usr/bin/env bash
#
#        ______           ______
#       / ____/___  _  __/ ____/_  ______________  __
#      / /_  / __ \| |/_/ /_  / / / / ___/ ___/ / / /
#     / __/ / /_/ />  </ __/ / /_/ / /  / /  / /_/ /
#    /_/    \____/_/|_/_/    \__,_/_/  /_/   \__, /
#                                           /____/

killall waybar

waybar -c $HOME/.config/waybar/waybar.conf -s $HOME/.config/waybar/style.css &
waybar -c $HOME/.config/waybar/waybar-secondary.conf -s $HOME/.config/waybar/style.css
```

- [ ] **Step 3: Commit**

```bash
git add .config/waybar/waybar-secondary.conf .config/waybar/launch.sh
git commit -m "feat: add secondary monitor waybar with workspaces + clock"
```

---

## Task 6: Waybar style — pill CSS + workspace dots

**Files:**
- Modify: `.config/waybar/style.css`

- [ ] **Step 1: Rewrite style.css**

Replace the entire contents of `.config/waybar/style.css` with:

```css
* {
    font-family: FiraCode Nerd Font;
    border: none;
    font-size: 1.1rem;
    border-radius: 1rem;
    transition-property: background-color;
    transition-duration: 0.5s;
    color: #b7bdf8;
}

window#waybar {
    background-color: transparent;
}

window > box {
    background-color: transparent;
    margin: 0.4rem 1.2rem 0;
}

/* Primary: floating pill — all modules in center */
.modules-center {
    background-color: rgba(30, 30, 46, 0.75);
    border-radius: 999px;
    border: 1px solid rgba(245, 189, 230, 0.5);
    box-shadow: 0 0 12px rgba(198, 160, 246, 0.3);
    padding: 0.2rem 1.2rem;
}

/* Secondary: left and right pill groups */
.modules-left,
.modules-right {
    background-color: rgba(30, 30, 46, 0.75);
    border-radius: 999px;
    border: 1px solid rgba(245, 189, 230, 0.3);
    box-shadow: 0 0 8px rgba(198, 160, 246, 0.2);
    padding: 0.15rem 0.8rem;
}

/* Hide empty left/right on primary pill bar */
.modules-left:empty,
.modules-right:empty {
    display: none;
}

#language,
#clock,
#wireplumber,
#tray,
#cava,
#custom-spotify,
#custom-wireplumber,
#custom-cava,
#custom-weather,
#custom-powermenu,
#custom-blank,
#temperature {
    margin: 0 0.4rem;
}

/* Workspace dots */
#workspaces {
    margin: 0 0.4rem;
}

#workspaces button {
    background: transparent;
    color: #494d64;
    border-radius: 50%;
    padding: 0 0.2rem;
    min-width: 0.6rem;
    font-size: 0.6rem;
}

#workspaces button.active {
    color: #c6a0f6;
    font-size: 0.75rem;
}

#workspaces button:hover {
    background: rgba(198, 160, 246, 0.15);
}

/* Module-specific colors */
#custom-weather {
    color: #f4dbd6;
}

#temperature {
    color: #f0c6c6;
}

#custom-spotify {
    color: #f5bde6;
}

#custom-cava,
#cava {
    color: #c6a0f6;
}

#wireplumber,
#custom-wireplumber {
    color: #f5bde6;
}

#tray {
    color: #ee99a0;
}

#language {
    color: #eed49f;
}

#clock {
    color: #eed49f;
}

#custom-powermenu {
    color: #a6da95;
}
```

- [ ] **Step 2: Commit**

```bash
git add .config/waybar/style.css
git commit -m "feat: waybar pill CSS with pink/mauve glow and workspace dots"
```

---

## Task 7: Wofi theme update

**Files:**
- Modify: `.config/wofi/style.css`

- [ ] **Step 1: Rewrite wofi style.css**

Replace the entire contents of `.config/wofi/style.css` with:

```css
window {
    margin: 2px;
    border: 2px solid #c6a0f6;
    background-color: #24273a;
    border-radius: 14px;
    font-family: FiraCode Nerd Font;
    font-size: 14px;
    box-shadow: 0 0 16px rgba(198, 160, 246, 0.25);
}

#input {
    padding: 6px;
    margin: 6px;
    margin-bottom: 10px;
    border: none;
    border-bottom: 1px solid #c6a0f6;
    color: #cad3f5;
    background-color: transparent;
    outline: none;
    border-radius: 0;
}

#input:focus {
    border-bottom: 1px solid #f5bde6;
}

#inner-box {
    margin: 2px;
    border: none;
    background-color: transparent;
    border-radius: 8px;
}

#outer-box {
    margin: 5px;
    border: none;
    border-radius: 8px;
    background-color: transparent;
}

#scroll {
    margin: 0;
    border: none;
}

#text {
    color: #cad3f5;
}

#text:selected {
    color: #f5bde6;
    margin: 0;
    border: none;
    border-radius: 8px;
}

#entry {
    margin: 0;
    border: none;
    border-radius: 0;
    background-color: transparent;
}

#entry:selected {
    margin: 0;
    border: none;
    border-radius: 8px;
    background-color: rgba(198, 160, 246, 0.2);
}
```

- [ ] **Step 2: Commit**

```bash
git add .config/wofi/style.css
git commit -m "feat: wofi mauve/pink theme with glow and FiraCode font"
```

---

## Task 8: Dunst notification style

**Files:**
- Modify: `.config/dunst/dunstrc`

- [ ] **Step 1: Update global section — corner_radius, font, frame_width, offset**

In `.config/dunst/dunstrc`, make these changes in the `[global]` section:

Replace:
```
    font = fixed 11
```
With:
```
    font = FiraCode Nerd Font 11
```

Replace:
```
    frame_width = 1
```
With:
```
    frame_width = 2
```

Replace:
```
    # frame_color = "#7bc5e4"
    frame_color = "#5c5c5c"
```
With:
```
    frame_color = "#c6a0f6"
```

Replace:
```
    offset = 15x40
```
With:
```
    offset = 15x55
```

Replace:
```
    corner_radius = 0
```
With:
```
    corner_radius = 14
```

- [ ] **Step 2: Update urgency colors**

Replace the `[urgency_low]` block:
```
[urgency_low]
    # IMPORTANT: colors have to be defined in quotation marks.
    # Otherwise the "#" and following would be interpreted as a comment.
    # background = "#181825"
	background = "#000000"
    foreground = "#f5e0dc"
    frame_color = "#5c5c5c"
    #frame_color = "#f5c2e7"
    timeout = 0
    # Icon for notifications with low urgency, uncomment to enable
    #default_icon = /path/to/icon
```
With:
```
[urgency_low]
    background = "#24273a"
    foreground = "#f5e0dc"
    frame_color = "#c6a0f6"
    timeout = 0
```

Replace the `[urgency_normal]` block:
```
[urgency_normal]
    # background = "#313244"
		background = "#000000"
    foreground = "#f5e0dc"
    frame_color = "#5c5c5c"
    #frame_color = "#b4befe"
    timeout = 0
    # Icon for notifications with normal urgency, uncomment to enable
    #default_icon = /path/to/icon
```
With:
```
[urgency_normal]
    background = "#24273a"
    foreground = "#f5e0dc"
    frame_color = "#f5bde6"
    timeout = 0
```

Replace the `[urgency_critical]` block:
```
[urgency_critical]
    # background = "#f5e0dc"
		background = "#000000"
    foreground = "#1e1e2e"
    frame_color = "#5c5c5c"
    #frame_color = "#f38ba8"
    timeout = 0
```
With:
```
[urgency_critical]
    background = "#24273a"
    foreground = "#f5e0dc"
    frame_color = "#ed8796"
    timeout = 0
```

- [ ] **Step 3: Commit**

```bash
git add .config/dunst/dunstrc
git commit -m "feat: dunst mauve/pink theme with rounded corners and FiraCode font"
```

---

## Task 9: Rebuild and verify

- [ ] **Step 1: Run nixos-rebuild**

> **NOTE: Do NOT run this command — tell the user to run it manually.**

```bash
sudo nixos-rebuild switch --flake .#foxfurry
```

- [ ] **Step 2: Verify wallpaper**

After login: `rooftop2.gif` should be animated on DP-4, `night2.jpg` static on the other two monitors. If swww-daemon didn't start, run manually:
```bash
swww-daemon &
sleep 0.5
swww img /etc/nixos/assets/rooftop2.gif --outputs DP-4 --transition-type fade
swww img /etc/nixos/assets/night2.jpg --outputs HDMI-A-2 --transition-type fade
swww img /etc/nixos/assets/night2.jpg --outputs DP-5 --transition-type fade
```

- [ ] **Step 3: Verify waybar**

Restart waybar to pick up new config:
```bash
~/.config/waybar/launch.sh
```
Expected: floating pill centered on DP-4, minimal bar on secondary monitors.

- [ ] **Step 4: Verify cursor**

Move cursor — should show Catppuccin Macchiato Mauve cursor theme.

- [ ] **Step 5: Verify wofi**

Press `Super+Space` — launcher should show dark bg with mauve border and glow.

- [ ] **Step 6: Verify dunst**

Trigger a test notification:
```bash
notify-send "Test" "Notification styling looks correct?"
```
Expected: dark `#24273a` background, mauve frame, rounded corners, FiraCode font.

- [ ] **Step 7: Verify borders**

Open two windows side by side. Active window should have animated pink→mauve gradient border with mauve glow shadow. Inactive window should have dim `#363a4f` border.
