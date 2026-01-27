# Neovim Plugins Guide

Complete reference for all plugins in your Neovim setup, including what they do and how to use them.

---

## Table of Contents

1. [Core Framework](#core-framework)
2. [Plugin Management](#plugin-management)
3. [LSP & Completion](#lsp--completion)
4. [AI Autocomplete](#ai-autocomplete)
5. [File & Code Search](#file--code-search)
6. [Syntax & Highlighting](#syntax--highlighting)
7. [Git Integration](#git-integration)
8. [Code Editing](#code-editing)
9. [UI Enhancements](#ui-enhancements)
10. [Formatting](#formatting)

---

## Core Framework

### NvChad
**Plugin**: `NvChad/NvChad`

**What it does**: Base framework that provides a beautiful, pre-configured Neovim setup with themes, statusline, and sensible defaults.

**Features**:
- Beautiful UI with multiple themes
- Pre-configured statusline
- Optimized for performance
- Modular configuration structure

**Usage**:
```vim
:NvChad          " Open NvChad menu
```

**Theme Switcher**:
- Launch NvChad menu
- Select "Theme switcher"
- Preview and select themes in real-time

**File**: Configured in `init.lua` line 33-42

---

## Plugin Management

### Lazy.nvim
**Plugin**: `folke/lazy.nvim`

**What it does**: Modern plugin manager with lazy loading for fast startup times.

**Features**:
- Lazy loading of plugins (loads only when needed)
- Lock file for reproducible installs
- Built-in profiler
- Clean UI for plugin management

**Usage**:
```vim
:Lazy                " Open plugin manager UI
:Lazy sync           " Install/update all plugins
:Lazy clean          " Remove unused plugins
:Lazy update         " Update all plugins
:Lazy restore        " Restore from lockfile
:Lazy profile        " Show startup profile
:Lazy log            " Show recent updates
```

**Tips**:
- Press `?` in Lazy UI for help
- Press `U` to update all plugins
- Press `X` to clear finished tasks

**File**: Bootstrapped in `init.lua` line 22-28

---

## LSP & Completion

### Mason
**Plugin**: `williamboman/mason.nvim`

**What it does**: LSP server installer and manager. Automatically downloads and manages language servers.

**Features**:
- Easy LSP server installation
- Automatic updates
- Cross-platform support
- DAP and linter support

**Usage**:
```vim
:Mason               " Open Mason UI
:MasonInstall gopls  " Install specific server
:MasonUpdate         " Update all servers
```

**Servers Auto-Installed**:
- `lua_ls` - Lua language server
- `ts_ls` - TypeScript/JavaScript
- `gopls` - Go
- `clangd` - C/C++
- `jsonls` - JSON
- `pyright` - Python

**File**: Configured in `init.lua` line 276-287

---

### Mason-LSPconfig
**Plugin**: `williamboman/mason-lspconfig.nvim`

**What it does**: Bridge between Mason and nvim-lspconfig for automatic setup.

**Features**:
- Automatic LSP server installation
- Seamless integration with lspconfig

**File**: Configured in `init.lua` line 289-301

---

### nvim-lspconfig
**Plugin**: `neovim/nvim-lspconfig`

**What it does**: Quickstart configurations for Neovim's built-in LSP client.

**Features**:
- Pre-configured settings for 100+ language servers
- Handles server initialization and attachment
- Provides default keybindings

**Configured Servers**:
- **ts_ls**: TypeScript/JavaScript/React/Next.js
- **gopls**: Go with auto-imports
- **clangd**: C/C++ with IntelliSense
- **lua_ls**: Lua with Neovim API support
- **jsonls**: JSON with schema validation
- **pyright**: Python with type checking
- **html**: HTML
- **cssls**: CSS

**LSP Features Available**:
- Code completion
- Go to definition
- Find references
- Hover documentation
- Code actions
- Rename symbol
- Diagnostics (errors/warnings)

**File**: Configured in `lua/configs/lspconfig.lua`

---

### LSPSaga
**Plugin**: `nvimdev/lspsaga.nvim`

**What it does**: Enhanced UI for LSP features with beautiful floating windows.

**Features**:
- Beautiful hover documentation
- Lightbulb for code actions
- Better rename UI
- Peek definition windows
- Diagnostic navigation

**Keybindings**:
```vim
K                    " Hover documentation
<leader>ca           " Code actions
<leader>rn           " Rename symbol
<leader>pd           " Peek definition
<leader>pt           " Peek type definition
[d                   " Previous diagnostic
]d                   " Next diagnostic
<leader>e            " Show line diagnostics
```

**File**: Configured in `init.lua` line 44-56

---

### nvim-cmp
**Plugin**: `hrsh7th/nvim-cmp`

**What it does**: Completion engine with multiple sources.

**Features**:
- Intelligent completion
- Snippet support
- Multiple sources (LSP, buffer, path)
- Customizable appearance

**Keybindings**:
```vim
<Tab>                " Next completion item
<Shift-Tab>          " Previous completion item
<CR>                 " Confirm selection
<C-Space>            " Trigger completion
<C-e>                " Abort completion
<C-b>                " Scroll docs up
<C-f>                " Scroll docs down
```

**Sources**:
- `cmp-nvim-lsp` - LSP completions
- `cmp-buffer` - Words from current buffer
- `cmp-path` - File paths
- `cmp-cmdline` - Command line completions
- `cmp_luasnip` - Snippet completions

**File**: Configured in `init.lua` line 323-367

---

### LuaSnip
**Plugin**: `L3MON4D3/LuaSnip`

**What it does**: Snippet engine for expanding code templates.

**Features**:
- Fast snippet expansion
- Jump between snippet placeholders
- Supports multiple snippet formats

**Keybindings**:
```vim
<Tab>                " Expand snippet or jump forward
<Shift-Tab>          " Jump backward in snippet
```

**File**: Configured in `init.lua` as part of nvim-cmp

---

## AI Autocomplete

### GitHub Copilot
**Plugin**: `github/copilot.vim`

**What it does**: AI-powered code completion from GitHub.

**Features**:
- Context-aware code suggestions
- Multi-line completions
- Learns from public code

**Keybindings**:
```vim
<Tab>                " Accept suggestion
<C-]>                " Dismiss suggestion
<M-]>                " Next suggestion
<M-[>                " Previous suggestion
```

**Commands**:
```vim
:Copilot setup       " Initial setup
:Copilot status      " Check status
:Copilot enable      " Enable Copilot
:Copilot disable     " Disable Copilot
:Copilot signout     " Sign out
```

**File**: Configured in `init.lua` line 179-182

---

### Supermaven
**Plugin**: `supermaven-inc/supermaven-nvim`

**What it does**: Fast, free AI code completion alternative/backup to Copilot.

**Features**:
- Very fast inference
- Free tier available
- Works alongside Copilot
- No API key required

**Keybindings**:
```vim
<C-y>                " Accept suggestion
<C-e>                " Clear suggestion
<C-j>                " Accept word
```

**File**: Configured in `init.lua` line 184-199

**Note**: Both Copilot and Supermaven can work together. Copilot takes priority, Supermaven provides fallback.

---

## File & Code Search

### FZF
**Plugin**: `junegunn/fzf`

**What it does**: Command-line fuzzy finder (base tool).

**Features**:
- Lightning-fast fuzzy matching
- Used by fzf-lua plugin

**File**: Configured in `init.lua` line 242-246

---

### FZF-lua
**Plugin**: `ibhagwan/fzf-lua`

**What it does**: Lua wrapper for FZF with Neovim integration.

**Features**:
- Blazing fast file search
- Live grep across project
- Buffer search
- Command history
- Old files (recently opened)

**Keybindings**:
```vim
<leader>ff           " Find files
<leader>fg           " Live grep (search in files)
<leader>fb           " Find buffers
<leader>fh           " Help tags
<leader>fo           " Old files (recently opened)
<leader>ft           " Find tabs
<leader>fw           " Grep word under cursor
```

**Usage Tips**:
- Type to fuzzy match
- Use spaces for AND search
- `!` for NOT search
- `^` for start of line
- `$` for end of line

**File**: Configured in `init.lua` line 248-260

---

### Telescope
**Plugin**: `nvim-telescope/telescope.nvim`

**What it does**: Highly extendable fuzzy finder over lists, optimized for LSP features.

**Features**:
- LSP-specific searches
- Better for code navigation
- Previews with syntax highlighting
- Extensible with plugins

**Keybindings**:
```vim
gd                   " Go to definition
gr                   " Find references
gi                   " Go to implementation
gt                   " Go to type definition
<leader>fs           " Document symbols
<leader>fS           " Workspace symbols
```

**In Telescope UI**:
```vim
<C-n>/<Down>         " Next item
<C-p>/<Up>           " Previous item
<CR>                 " Select item
<C-x>                " Open in horizontal split
<C-v>                " Open in vertical split
<C-t>                " Open in new tab
<C-u>                " Scroll preview up
<C-d>                " Scroll preview down
<Esc>                " Close Telescope
```

**File**: Configured in `init.lua` line 262-290

**Best Practices**:
- Use **FZF-lua** for file search (faster)
- Use **Telescope** for LSP features (better integration)

---

## Syntax & Highlighting

### nvim-treesitter
**Plugin**: `nvim-treesitter/nvim-treesitter`

**What it does**: Advanced syntax highlighting using tree-sitter parsers.

**Features**:
- Semantic syntax highlighting
- Better code understanding
- Faster than regex-based highlighting
- Code folding support
- Incremental selection

**Languages Configured**:
- TypeScript, TSX, JavaScript, JSX
- Go, C, C++, Lua
- JSON, HTML, CSS
- Markdown, Python, Bash

**Keybindings**:
```vim
<C-space>            " Init/expand selection
<bs>                 " Shrink selection
```

**Commands**:
```vim
:TSUpdate            " Update parser
:TSUpdate all        " Update all parsers
:TSInstall python    " Install specific parser
:TSInstallInfo       " Show installed parsers
```

**File**: Configured in `init.lua` line 58-86

---

### nvim-ts-context-commentstring
**Plugin**: `JoosepAlviste/nvim-ts-context-commentstring`

**What it does**: Sets correct comment string based on cursor position in file.

**Features**:
- Smart commenting in JSX/TSX
- Uses `//` in JS sections
- Uses `{/* */}` in JSX sections
- Works with vim-commentary

**Usage**: Automatic - just use `gcc` to comment lines

**File**: Configured in `init.lua` line 88-97

---

### nvim-colorizer
**Plugin**: `norcalli/nvim-colorizer.lua`

**What it does**: Displays color codes with actual colors.

**Features**:
- Shows colors for hex codes (#ff0000)
- CSS color names (red, blue)
- RGB values (rgb(255, 0, 0))
- Real-time preview

**Example**:
```css
/* These will show with actual colors */
background: #ff5733;
color: rgb(255, 87, 51);
border: blue;
```

**Commands**:
```vim
:ColorizerToggle     " Toggle colorizer
:ColorizerAttachToBuffer  " Enable for buffer
:ColorizerDetachFromBuffer " Disable for buffer
```

**File**: Configured in `init.lua` line 127-132

---

## Git Integration

### vim-fugitive
**Plugin**: `tpope/vim-fugitive`

**What it does**: Git wrapper for Neovim - complete Git integration.

**Features**:
- Git commands from Neovim
- Diff viewing
- Commit history
- Conflict resolution
- Blame annotations

**Commands**:
```vim
:Git                 " Run git command
:Git status          " Git status
:Git commit          " Commit
:Git push            " Push
:Git pull            " Pull
:Git blame           " Show blame
:Gvdiffsplit         " Vertical diff split
:Gdiffsplit          " Horizontal diff split
:Gread               " Git checkout current file
:Gwrite              " Git add current file
:GMove               " Git mv
:GDelete             " Git rm
:GBrowse             " Open in GitHub
```

**Keybindings**:
```vim
<leader>D            " Git diff split (mapped in mappings.lua)
```

**Diff Mode Keys**:
```vim
]c                   " Next hunk
[c                   " Previous hunk
do                   " Diff obtain (get changes from other)
dp                   " Diff put (put changes to other)
```

**File**: Configured in `init.lua` line 134-137

---

### gitsigns
**Plugin**: `lewis6991/gitsigns.nvim`

**What it does**: Shows git diff indicators in the sign column.

**Features**:
- Visual git status in gutter
- Inline blame
- Hunk navigation
- Stage/unstage hunks
- Preview changes

**Sign Indicators**:
- `│` - Added line
- `│` - Changed line
- `_` - Deleted line
- `~` - Changed + deleted
- `┆` - Untracked line

**Default Commands**:
```vim
:Gitsigns stage_hunk        " Stage current hunk
:Gitsigns undo_stage_hunk   " Undo stage
:Gitsigns reset_hunk        " Reset hunk
:Gitsigns preview_hunk      " Preview hunk
:Gitsigns blame_line        " Show blame
:Gitsigns toggle_signs      " Toggle signs
:Gitsigns toggle_linehl     " Toggle line highlight
```

**File**: Configured in `init.lua` line 139-156

---

### gitlinker
**Plugin**: `ruifm/gitlinker.nvim`

**What it does**: Generate shareable links to GitHub/GitLab for current code.

**Features**:
- Generate GitHub URLs
- Share specific lines
- Works with multiple remotes

**Usage**:
Select code in visual mode and run:
```vim
:lua require"gitlinker".get_buf_range_url("v")
```

**File**: Configured in `init.lua` line 158-165

---

## Code Editing

### nvim-autopairs
**Plugin**: `windwp/nvim-autopairs`

**What it does**: Automatically closes brackets, quotes, and parentheses.

**Features**:
- Auto-close: `(`, `[`, `{`, `"`, `'`
- Auto-delete pairs
- Fast wrap
- Works with treesitter

**Examples**:
```
Type: (         →  (|)
Type: [         →  [|]
Type: {         →  {|}
Type: "         →  "|"
Backspace: (|)  →  (empty)
```

**File**: Configured in `init.lua` line 115-120

---

### nvim-ts-autotag
**Plugin**: `windwp/nvim-ts-autotag`

**What it does**: Automatically closes and renames HTML/JSX tags.

**Features**:
- Auto-close tags in HTML/JSX/TSX
- Auto-rename paired tags
- Treesitter-powered

**Examples**:
```jsx
Type: <div>       →  <div>|</div>
Rename: <div>     →  Changes closing tag too
Type: <input>     →  <input />  (self-closing)
```

**Supported Languages**:
- HTML
- XML
- JSX (React)
- TSX (React with TypeScript)
- Vue

**File**: Configured in `init.lua` line 99-113

---

### vim-commentary
**Plugin**: `tpope/vim-commentary`

**What it does**: Toggle comments on lines and blocks.

**Features**:
- Comment/uncomment lines
- Works with all file types
- Respects commentstring

**Keybindings**:
```vim
gcc                  " Toggle comment on current line
gc{motion}           " Comment motion
gcap                 " Comment paragraph
gc3j                 " Comment next 3 lines
```

**Visual Mode**:
```vim
gc                   " Toggle comment on selection
```

**Examples**:
```javascript
// Before: const x = 10;
// After gcc: // const x = 10;

// In JSX:
// Before: <div>Hello</div>
// After gcc: {/* <div>Hello</div> */}
```

**File**: Configured in `init.lua` line 167-170

---

### vim-visual-multi
**Plugin**: `mg979/vim-visual-multi`

**What it does**: Multiple cursors support (like Sublime Text / VSCode).

**Features**:
- Multiple cursors
- Multiple selections
- Visual operations on multiple locations

**Keybindings**:
```vim
<C-n>                " Select word, add next occurrence
<C-Down>             " Create cursor below
<C-Up>               " Create cursor above
<Tab>                " Switch between cursor and extend mode
q                    " Skip current and get next occurrence
Q                    " Remove current cursor
```

**In Visual Mode**:
1. Select text
2. Press `<C-n>` to select next occurrence
3. Keep pressing `<C-n>` for more
4. Edit all at once

**File**: Configured in `init.lua` line 172-176

---

## UI Enhancements

### which-key
**Plugin**: `folke/which-key.nvim`

**What it does**: Displays available keybindings in a popup.

**Features**:
- Shows keybinding hints
- Triggered after delay
- Organized by prefix
- Helps discover commands

**Usage**:
1. Press `<leader>` (space)
2. Wait ~500ms
3. Popup shows available commands
4. Continue typing or select

**Example**:
```
Type: <space>       →  Shows all <leader> commands
Type: <space>f      →  Shows all file commands
Type: g             →  Shows all g commands
```

**File**: Configured in `init.lua` line 234-240

---

### indent-blankline
**Plugin**: `lukas-reineke/indent-blankline.nvim`

**What it does**: Displays indent guides (vertical lines).

**Features**:
- Visual indent guides
- Shows scope
- Multiple indent levels
- Customizable characters

**Visual Example**:
```javascript
function example() {
│ if (true) {
│ │ console.log("Indented");
│ │ if (nested) {
│ │ │ console.log("More indented");
│ │ }
│ }
}
```

**File**: Configured in `init.lua` line 201-223

---

### nvim-web-devicons
**Plugin**: `nvim-tree/nvim-web-devicons`

**What it does**: Provides file type icons.

**Features**:
- File type icons
- Color-coded
- Used by many plugins

**File**: Dependency of multiple plugins

---

## Formatting

### conform.nvim
**Plugin**: `stevearc/conform.nvim`

**What it does**: Fast formatter with async support.

**Features**:
- Format on save
- Multiple formatters per language
- Async formatting (non-blocking)
- Fallback to LSP formatting

**Configured Formatters**:

| Language | Formatter(s) |
|----------|-------------|
| TypeScript/JavaScript | prettierd → prettier |
| JSX/TSX | prettierd → prettier |
| Go | gofmt → goimports |
| C/C++ | clang-format |
| Lua | stylua |
| Python | isort → black |
| JSON | prettierd → prettier |
| HTML/CSS | prettierd → prettier |
| Markdown | prettierd → prettier |
| SQL | sqlfmt |

**Usage**:
```vim
:ConformInfo         " Show formatter info
<leader>fp           " Format file manually
```

**Auto-format**: Enabled on save for all languages

**Installing Formatters**:
```bash
# Node.js formatters
npm install -g prettier prettierd

# Go formatters
go install golang.org/x/tools/cmd/goimports@latest

# Python formatters
pip install black isort

# Lua formatter
cargo install stylua
# or: brew install stylua
```

**File**: Configured in `lua/configs/conform.lua`

---

## Additional Configuration Files

### schemastore.nvim
**Plugin**: `b0o/schemastore.nvim`

**What it does**: Provides JSON schemas for validation.

**Features**:
- Auto-completion for JSON files
- Validation against schemas
- Hundreds of schema definitions

**Supported Files**:
- `package.json`
- `tsconfig.json`
- `.eslintrc.json`
- GitHub workflows
- Many more

**File**: Configured in `lua/plugins/init.lua`

---

## Plugin File Locations

```
~/.config/nvim/
├── init.lua                          # Main plugin definitions
├── lua/
│   ├── plugins/
│   │   └── init.lua                  # conform, schemastore
│   └── configs/
│       ├── conform.lua               # Formatter configuration
│       ├── lspconfig.lua             # LSP server configuration
│       └── lazy.lua                  # Lazy.nvim settings
```

---

## Quick Reference

### Most Used Commands

```vim
" Plugin Management
:Lazy                " Manage plugins
:Mason               " Manage LSP servers

" File Search
<leader>ff           " Find files
<leader>fg           " Search in files
<leader>fw           " Search word under cursor

" Code Navigation
gd                   " Go to definition
gr                   " Find references
K                    " Hover docs
<leader>ca           " Code actions

" Editing
gcc                  " Comment line
<C-n>                " Multiple cursors

" Git
:Git                 " Git command
<leader>D            " Git diff

" Formatting
<leader>fp           " Format file
```

### Learning Tips

1. **Use which-key**: Press `<leader>` and wait to see all commands
2. **Explore Lazy**: Run `:Lazy` to see all plugins
3. **Check LSP**: Run `:LspInfo` to verify language servers
4. **Read docs**: Use `:help plugin-name` for more info

---

## Troubleshooting Plugins

### Plugin not loading
```vim
:Lazy sync           " Reinstall plugins
:Lazy restore        " Restore from lockfile
```

### LSP not working
```vim
:LspInfo             " Check LSP status
:Mason               " Verify server installed
:e!                  " Reload file
```

### Formatter not working
1. Check if formatter is installed (see conform.nvim section)
2. Run `:ConformInfo` to see status
3. Try manual format: `<leader>fp`

### Clear cache
```bash
rm -rf ~/.local/share/nvim
rm -rf ~/.cache/nvim
nvim  # Reinstall everything
```

---

## Custom Plugin Configuration

To add your own plugins, edit:
```
~/.config/nvim/lua/plugins/init.lua
```

Example:
```lua
return {
  -- Your plugins here
  {
    "username/plugin-name",
    config = function()
      require("plugin-name").setup {}
    end,
  },
}
```

---

## Resources

- [Lazy.nvim docs](https://github.com/folke/lazy.nvim)
- [LSP config](https://github.com/neovim/nvim-lspconfig)
- [Treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [NvChad docs](https://nvchad.com)

---

**Last Updated**: January 24, 2026
**Total Plugins**: 35+
**Configuration**: Modern, lazy-loaded, optimized for speed
