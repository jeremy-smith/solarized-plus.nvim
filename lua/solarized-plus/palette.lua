-- Colours lifted from ryanolsonx.solarized (VS Code "Solarized Dark+" / "Solarized Light+").
local M = {}

local accents = {
  yellow = "#b58900",
  orange = "#cb4b16",
  red = "#dc322f",
  magenta = "#d33682",
  violet = "#6c71c4",
  blue = "#268bd2",
  cyan = "#2aa198",
  green = "#859900",
}

M.dark = vim.tbl_extend("force", accents, {
  bg = "#002b36", -- editor.background
  bg_dark = "#001f26", -- sideBar / editorWidget / tabs background
  bg_status = "#001b21", -- statusBar.background
  bg_hl = "#073642", -- editor.lineHighlightBackground / editorGutter.background
  bg_tab_inactive = "#001f26",
  bg_list_sel = "#184c71", -- list.activeSelectionBackground
  fg = "#839496", -- editor.foreground
  fg_dim = "#586e75", -- comments / line numbers
  fg_bright = "#93a1a1",
  fg_sel = "#b9cdcd", -- list.activeSelectionForeground
  fg_tab_active = "#b4c6c6",
  linenr = "#586e75",
  linenr_active = "#839496",
  border = "#657b83",
  border_alpha = 0x59 / 255, -- editorHoverWidget.border
  separator = "#444444", -- editorGroup.border
  error = "#e35957",
  warning = "#cb9a07",
  info = "#2faca1",
  hint = "#6c71c4",
  git_add = "#587c0c",
  git_change = "#0c7d9d",
  git_delete = "#94151b",
  file_added = "#7a8a0d",
  file_modified = "#9f7b0c",
  file_deleted = "#b65933",
  file_untracked = "#729492",
  file_ignored = "#788688",
  file_conflict = "#7679a9",
  selection_alpha = 0x5b / 255,
  terminal = {
    "#14181d", "#dc322f", "#859900", "#b58900", "#268bd2", "#d33682", "#2aa198", "#e5e5e5",
    "#676767", "#dc322f", "#859900", "#b58900", "#268bd2", "#d33682", "#2aa198", "#e5e5e5",
  },
})

M.light = vim.tbl_extend("force", accents, {
  bg = "#fdf6e3",
  bg_dark = "#eee8d5",
  bg_status = "#eee8d5",
  bg_hl = "#eee8d5",
  bg_tab_inactive = "#d3cbb7",
  bg_list_sel = "#dfca88",
  fg = "#657b83",
  fg_dim = "#93a1a1",
  fg_bright = "#586e75",
  fg_sel = "#073642",
  fg_tab_active = "#586e75",
  linenr = "#9ca8a6",
  linenr_active = "#6f7776",
  border = "#ccc4b0",
  border_alpha = 1,
  separator = "#ddd6c1",
  error = "#dc322f",
  warning = "#b58900",
  info = "#2aa198",
  hint = "#6c71c4",
  git_add = "#859900",
  git_change = "#268bd2",
  git_delete = "#dc322f",
  file_added = "#859900",
  file_modified = "#b58900",
  file_deleted = "#cb4b16",
  file_untracked = "#2aa198",
  file_ignored = "#93a1a1",
  file_conflict = "#6c71c4",
  selection_alpha = 0x30 / 255,
  terminal = {
    "#073642", "#dc322f", "#859900", "#b58900", "#268bd2", "#d33682", "#2aa198", "#eee8d5",
    "#002b36", "#cb4b16", "#586e75", "#657b83", "#839496", "#6c71c4", "#93a1a1", "#fdf6e3",
  },
})

return M
