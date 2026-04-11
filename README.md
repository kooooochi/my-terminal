# Terminal Configuration

Personal terminal configuration files for WezTerm, Starship prompt, Neovim, and fzf shell search.

## Contents

- `wezterm.lua` - WezTerm main configuration
- `keybinds.lua` - WezTerm keybindings
- `starship.toml` - Starship prompt configuration
- `nvim/init.lua` - Neovim configuration
- `nvim/lazy-lock.json` - Neovim plugin lock file

## Prerequisites

- [WezTerm](https://wezfurlong.org/wezterm/) - GPU-accelerated terminal emulator
- [Starship](https://starship.rs/) - Cross-shell prompt
- [Neovim](https://neovim.io/) - Hyperextensible Vim-based text editor
- [fzf](https://github.com/junegunn/fzf) - Command-line fuzzy finder for interactive search

## Installation

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

**fzf:**
```bash
# macOS
brew install fzf
```

**Neovim and dependencies:**
```bash
# macOS
# Neovim本体
brew install neovim

# 必須の依存関係
brew install ripgrep    # Telescope検索機能に必要
brew install fd         # Telescopeファイル検索に必要
brew install node       # LSPサーバーのインストールに必要

# オプション（使用する言語に応じて）
brew install rust-analyzer  # Rust開発に必要

# Nerd Font（アイコン表示に必要）
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font
```

## Setup

### WezTerm Configuration

Create symlinks from this repository to WezTerm's config directory:

```bash
# Create config directory if it doesn't exist
mkdir -p ~/.config/wezterm

# Create symlinks
ln -sf "$(pwd)/wezterm.lua" ~/.config/wezterm/wezterm.lua
ln -sf "$(pwd)/keybinds.lua" ~/.config/wezterm/keybinds.lua
```

### Starship Configuration

Create a symlink for Starship config:

```bash
# Create config directory if it doesn't exist
mkdir -p ~/.config

# Create symlink
ln -sf "$(pwd)/starship.toml" ~/.config/starship.toml
```

Add to your shell profile (`~/.zshrc` or `~/.bashrc`):

```bash
eval "$(starship init zsh)"  # for zsh
# or
eval "$(starship init bash)" # for bash
```

### fzf Shell Integration

Enable fzf key bindings and shell completion:

```bash
/opt/homebrew/opt/fzf/install --all
```

This installer generates `~/.fzf.zsh` and `~/.fzf.bash`, then appends the appropriate source line to your shell profile.

If you want to add the zsh integration manually, place this line in `~/.zshrc`:

```bash
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
```

Reload your shell after installation:

```bash
source ~/.zshrc
```

Common shortcuts after setup:

- `Ctrl-R` - Fuzzy search shell history
- `**` then `Tab` - Trigger fuzzy path completion
- `fzf` - Start an interactive fuzzy finder directly

### Neovim Configuration

Create a symlink for Neovim config:

```bash
# Create config directory if it doesn't exist
mkdir -p ~/.config/nvim

# Create symlink
ln -sf "$(pwd)/nvim/init.lua" ~/.config/nvim/init.lua
```

Launch Neovim to automatically install plugins (managed by lazy.nvim):

```bash
nvim
```

The first launch will install all plugins automatically. LSP servers (rust-analyzer, pyright, lua_ls) will be installed via Mason on demand.

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

# Check Neovim config location
ls -la ~/.config/nvim/

# Check fzf installation
command -v fzf

# Check fzf zsh integration
ls -la ~/.fzf.zsh

# Check Neovim installation
nvim --version
```

Restart your terminal for changes to take effect.
