local M = {}

M.options = {
  -- "dark" or "light"; `:colorscheme solarized-plus` uses this (or 'background' if nil)
  style = nil,
  transparent = false,
  -- VS Code paints the gutter (line numbers / signs) with base02
  gutter_background = true,
  ---@type fun(groups: table, colors: table)|nil
  on_highlights = nil,
}

function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", M.options, opts or {})
end

function M.colors(style)
  return require("solarized-plus.palette")[style or M.options.style or vim.o.background]
end

function M.load(style)
  style = style or M.options.style or vim.o.background
  local c = M.colors(style)

  if vim.g.colors_name then
    vim.cmd("hi clear")
  end
  vim.o.termguicolors = true
  vim.o.background = style
  vim.g.colors_name = style == "light" and "solarized-plus-light" or "solarized-plus"

  local groups = require("solarized-plus.groups").get(c, M.options)
  if M.options.on_highlights then
    M.options.on_highlights(groups, c)
  end
  for name, spec in pairs(groups) do
    vim.api.nvim_set_hl(0, name, spec)
  end

  for i, color in ipairs(c.terminal) do
    vim.g["terminal_color_" .. (i - 1)] = color
  end
end

return M
