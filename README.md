# solarized-plus.nvim

A Neovim port of the VS Code theme
[Solarized (ryanolsonx)](https://github.com/ryanolsonx/vscode-solarized-theme) —
"Solarized Dark+" and "Solarized Light+".

- Colours taken directly from the VS Code theme (translucent colours pre-blended)
- Same token rules: definitions blue, calls plain, keywords/operators green, types yellow,
  literals cyan, imports orange, regex red
- Treesitter + LSP semantic tokens tuned so semantic highlighting doesn't override those rules
- Plugin support: blink.cmp, snacks.nvim, bufferline, gitsigns, which-key, noice, flash,
  trouble, todo-comments, mini.icons, neo-tree, nvim-tree, rainbow-delimiters
- Bundled lualine theme (picked up automatically with `theme = "auto"`)

Requires Neovim 0.9+ and `termguicolors`.

## Install

### lazy.nvim

```lua
{
  "jeremy-smith/solarized-plus.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("solarized-plus").setup({})
    vim.cmd.colorscheme("solarized-plus")
  end,
}
```

### LazyVim

Create `lua/plugins/solarized-plus.lua`:

```lua
return {
  { "jeremy-smith/solarized-plus.nvim", lazy = false, priority = 1000, opts = {},
    config = function(_, opts) require("solarized-plus").setup(opts) end },
  { "LazyVim/LazyVim", opts = { colorscheme = "solarized-plus" } },
}
```

### vim-plug

```vim
Plug 'jeremy-smith/solarized-plus.nvim'
colorscheme solarized-plus
```

### Native packages

```sh
git clone https://github.com/jeremy-smith/solarized-plus.nvim \
  ~/.local/share/nvim/site/pack/themes/start/solarized-plus.nvim
```

## Usage

```vim
:colorscheme solarized-plus        " dark
:colorscheme solarized-plus-light  " light
```

## Configuration

Call `setup` before `:colorscheme`. Defaults:

```lua
require("solarized-plus").setup({
  style = nil,               -- "dark" | "light"; default variant for `:colorscheme solarized-plus`
  transparent = false,       -- don't paint editor / sidebar backgrounds
  gutter_background = true,  -- base02 gutter behind line numbers & signs, like VS Code
  on_highlights = nil,       -- function(hl, c) ... end to tweak highlight groups
})
```

Example override:

```lua
on_highlights = function(hl, c)
  hl.Comment = { fg = c.fg_dim, italic = true }
end
```

The palette is available via `require("solarized-plus").colors("dark")`.

## Credits

Colours and token rules from [ryanolsonx/vscode-solarized-theme](https://github.com/ryanolsonx/vscode-solarized-theme),
based on [Solarized](https://ethanschoonover.com/solarized/) by Ethan Schoonover.

## License

MIT
