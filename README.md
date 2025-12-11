# DZNLinux SDDM Theme

A custom SDDM (Simple Desktop Display Manager) theme for DZN Linux, designed for KDE Plasma with a clean, modern interface.

## Features

- Clean and modern login interface
- Custom DZN Linux branding and colors
- Seamless integration with KDE Plasma themes
- Compatible with Qt 5-based SDDM
- Session selection (Plasma, Hyprland, or any installed desktop/window manager)
- Keyboard layout switching
- System actions (shutdown, reboot, suspend)

## Compatibility

- **Desktop Environments**: Works with any desktop environment or window manager (Plasma 6, Hyprland, etc.)
- **Display Manager**: Requires SDDM
- **Qt Version**: Compatible with Qt 5-based SDDM (standard on most distributions)

## Installation

### From DZN Linux Repository (Recommended)

First, add the DZN Linux repository to your system:

```bash
# Add the PGP key
sudo pacman-key --recv-key BB31837564255477
sudo pacman-key --lsign-key BB31837564255477
```

Add the following to `/etc/pacman.conf`:

```ini
[dznlinux_repo]
SigLevel = Required DatabaseOptional
Server = https://repo.dozzen.me/archlinux/$repo/$arch

[dznlinux_repo_3party]
SigLevel = Required DatabaseOptional
Server = https://repo.dozzen.me/archlinux/$repo/$arch
```

Then install the package:

```bash
sudo pacman -Sy
sudo pacman -S dznlinux-sddm-theme-plasma-git
```

### Manual Installation

```bash
# Clone this repository
git clone https://github.com/DZN-Linux/dznlinux-sddm-theme-plasma.git
cd dznlinux-sddm-theme-plasma

# Copy theme files to SDDM themes directory
sudo cp -r usr/share/sddm/themes/dznlinux-sddm-theme /usr/share/sddm/themes/

# Optional: Copy default SDDM configuration
sudo cp etc/sddm.conf.d/dznlinux-theme.conf /etc/sddm.conf.d/
```

## Configuration

To activate the theme, edit `/etc/sddm.conf` or create `/etc/sddm.conf.d/theme.conf`:

```ini
[Theme]
Current=dznlinux-sddm-theme
```

Alternatively, if you installed the package, the configuration is automatically set in `/etc/sddm.conf.d/dznlinux-theme.conf`.

## Customization

### Change Background

Replace the background image:
```bash
sudo cp /path/to/your/image.jpg /usr/share/sddm/themes/dznlinux-sddm-theme/background.jpg
```

### Modify Theme Colors

Edit `/usr/share/sddm/themes/dznlinux-sddm-theme/theme.conf`:

```ini
[General]
type=image
color=#5657f5        # Primary color (hex)
fontSize=10          # Font size
background=background.jpg
```

## File Structure

```
usr/share/sddm/themes/dznlinux-sddm-theme/
├── Main.qml              # Main theme file
├── Login.qml             # Login form component
├── Background.qml        # Background handler
├── KeyboardButton.qml    # Keyboard layout switcher
├── BreezeMenuStyle.qml   # Menu styling
├── metadata.desktop      # Theme metadata
├── theme.conf            # Theme configuration
├── background.jpg        # Default background image
├── Preview.png           # Theme preview
├── components/           # Reusable QML components
│   └── UserList.qml
├── assets/               # Theme assets (icons, etc.)
└── faces/                # User avatar icons
```

## Development

To test changes without installing system-wide:

1. Edit files in your local clone
2. Copy to a temporary SDDM themes location
3. Configure SDDM to use the test theme
4. Restart SDDM: `sudo systemctl restart sddm`

## License

This theme is licensed under the GNU General Public License v3.0 or later (GPL-3.0-or-later).

See [LICENSE](LICENSE) file for details.

## Credits

- Based on KDE Plasma Breeze SDDM theme
- Original framework: Copyright 2016 David Edmundson
- DZN Linux customization: Seth Dawson

## Links

- GitHub: https://github.com/DZN-Linux/dznlinux-sddm-theme-plasma
- DZN Linux: https://github.com/DZN-Linux
- SDDM Documentation: https://github.com/sddm/sddm

## Troubleshooting

### Theme doesn't appear in SDDM

1. Verify theme installation: `ls /usr/share/sddm/themes/dznlinux-sddm-theme`
2. Check SDDM config: `cat /etc/sddm.conf.d/*.conf`
3. Restart SDDM: `sudo systemctl restart sddm`

### Login screen shows errors

Check SDDM logs:
```bash
journalctl -u sddm -b
```

### Background image doesn't show

Ensure the image exists and has proper permissions:
```bash
sudo chmod 644 /usr/share/sddm/themes/dznlinux-sddm-theme/background.jpg
```
