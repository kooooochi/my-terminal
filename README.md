# Terminal Configuration

Personal terminal configuration files for WezTerm and Starship prompt.

## Contents

- `wezterm.lua` - WezTerm main configuration
- `keybinds.lua` - WezTerm keybindings
- `starship.toml` - Starship prompt configuration

## Prerequisites

- [WezTerm](https://wezfurlong.org/wezterm/) - GPU-accelerated terminal emulator
- [Starship](https://starship.rs/) - Cross-shell prompt

### Installation

**WezTerm:**
```bash
# macOS
brew install --cask wezterm
```

**Starship:**
```bash
# macOS
brew install starship
```

## Setup

### WezTerm Configuration

Create symlinks from this repository to WezTerm's config directory:

```bash
# Create config directory if it doesn't exist
mkdir -p ~/.config/wezterm

# Create symlinks
ln -sf $(pwd)/wezterm.lua ~/.config/wezterm/wezterm.lua
ln -sf $(pwd)/keybinds.lua ~/.config/wezterm/keybinds.lua
```

### Starship Configuration

Create a symlink for Starship config:

```bash
# Create config directory if it doesn't exist
mkdir -p ~/.config

# Create symlink
ln -sf $(pwd)/starship.toml ~/.config/starship.toml
```

Add to your shell profile (`~/.zshrc` or `~/.bashrc`):

```bash
eval "$(starship init zsh)"  # for zsh
# or
eval "$(starship init bash)" # for bash
```

## WezTerm Keybindings

Leader key: `Ctrl+q`

### Tabs
- `Leader + t` - New tab
- `Leader + w` - Close tab
- `Leader + [` - Previous tab
- `Leader + ]` - Next tab
- `Leader + 1-9` - Jump to tab by number
- `Ctrl + Tab` - Next tab
- `Ctrl + Shift + Tab` - Previous tab

### Panes
- `Leader + -` - Split vertically
- `Leader + =` - Split horizontally
- `Leader + x` - Close pane
- `Leader + h/j/k/l` - Navigate panes (vim-style)

### Other
- `Leader + f` - Search
- `Leader + r` - Reload configuration
- `Cmd + c/v` - Copy/Paste
- `Cmd + +/-/0` - Increase/Decrease/Reset font size

## Verification

After setup, verify the configurations are loaded:

```bash
# Check WezTerm config location
ls -la ~/.config/wezterm/

# Check Starship config location
ls -la ~/.config/starship.toml
```

Restart your terminal for changes to take effect.
