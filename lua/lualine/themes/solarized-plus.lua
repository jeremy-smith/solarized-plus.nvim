local c = require("solarized-plus").colors(vim.o.background)

local function mode(color)
  return {
    a = { fg = c.bg, bg = color, gui = "bold" },
    b = { fg = c.fg_bright, bg = c.bg_hl },
    c = { fg = c.fg, bg = c.bg_status },
  }
end

return {
  normal = mode(c.blue),
  insert = mode(c.green),
  visual = mode(c.magenta),
  replace = mode(c.red),
  command = mode(c.yellow),
  terminal = mode(c.cyan),
  inactive = {
    a = { fg = c.fg_dim, bg = c.bg_status },
    b = { fg = c.fg_dim, bg = c.bg_status },
    c = { fg = c.fg_dim, bg = c.bg_status },
  },
}
