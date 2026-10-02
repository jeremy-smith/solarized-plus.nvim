local M = {}

-- Alpha-blend `fg` over `bg` (VS Code uses #rrggbbaa; Neovim needs opaque colours).
local function blend(fg, bg, alpha)
  local function rgb(hex)
    return tonumber(hex:sub(2, 3), 16), tonumber(hex:sub(4, 5), 16), tonumber(hex:sub(6, 7), 16)
  end
  local fr, fg_, fb = rgb(fg)
  local br, bg_, bb = rgb(bg)
  local function mix(a, b)
    return math.floor(a * alpha + b * (1 - alpha) + 0.5)
  end
  return string.format("#%02x%02x%02x", mix(fr, br), mix(fg_, bg_), mix(fb, bb))
end

M.blend = blend

---@param c table palette
---@param opts table
function M.get(c, opts)
  local bg = opts.transparent and "NONE" or c.bg
  local bg_side = opts.transparent and "NONE" or c.bg_dark
  local gutter = opts.gutter_background and c.bg_hl or bg

  local visual = blend(c.blue, c.bg, c.selection_alpha)
  local border = blend(c.border, c.bg_dark, c.border_alpha)
  local indent = blend(c.border, c.bg, 0x24 / 255)
  local indent_active = blend(c.border, c.bg, 0x66 / 255)
  local whitespace = blend(c.fg_dim, c.bg, 0.5)

  local g = {
    -- Editor -------------------------------------------------------------------------
    Normal = { fg = c.fg, bg = bg },
    NormalNC = { fg = c.fg, bg = bg },
    NormalFloat = { fg = c.fg, bg = c.bg_dark },
    FloatBorder = { fg = border, bg = c.bg_dark },
    FloatTitle = { fg = c.blue, bg = c.bg_dark, bold = true },
    FloatFooter = { fg = c.fg_dim, bg = c.bg_dark },
    Cursor = { fg = c.bg, bg = c.fg },
    lCursor = { link = "Cursor" },
    CursorIM = { link = "Cursor" },
    TermCursor = { fg = c.bg, bg = c.blue },
    CursorLine = { bg = c.bg_hl },
    CursorColumn = { bg = c.bg_hl },
    ColorColumn = { bg = c.bg_hl },
    CursorLineNr = { fg = c.linenr_active, bg = gutter },
    LineNr = { fg = c.linenr, bg = gutter },
    LineNrAbove = { link = "LineNr" },
    LineNrBelow = { link = "LineNr" },
    SignColumn = { fg = c.fg_dim, bg = gutter },
    CursorLineSign = { link = "SignColumn" },
    FoldColumn = { fg = c.fg_dim, bg = gutter },
    CursorLineFold = { link = "FoldColumn" },
    Folded = { fg = c.fg_bright, bg = blend(c.blue, c.bg, 0.15) },
    Visual = { bg = visual },
    VisualNOS = { link = "Visual" },
    Search = { fg = c.bg, bg = c.yellow },
    IncSearch = { fg = c.bg, bg = c.orange },
    CurSearch = { link = "IncSearch" },
    Substitute = { fg = c.bg, bg = c.red },
    MatchParen = { bg = blend(c.blue, c.bg, 0.25), bold = true },
    NonText = { fg = whitespace },
    Whitespace = { fg = whitespace },
    SpecialKey = { fg = whitespace },
    EndOfBuffer = { fg = c.bg },
    Conceal = { fg = c.fg_dim },
    Directory = { fg = c.blue },
    Title = { fg = c.blue, bold = true },
    WinSeparator = { fg = c.separator },
    VertSplit = { link = "WinSeparator" },
    WinBar = { fg = c.fg, bg = bg },
    WinBarNC = { fg = c.fg_dim, bg = bg },

    StatusLine = { fg = c.fg, bg = c.bg_status },
    StatusLineNC = { fg = c.fg_dim, bg = c.bg_status },
    TabLine = { fg = c.fg_dim, bg = c.bg_tab_inactive },
    TabLineFill = { bg = c.bg_dark },
    TabLineSel = { fg = c.fg_tab_active, bg = c.bg },

    Pmenu = { fg = c.fg, bg = c.bg_dark },
    PmenuSel = { fg = c.fg_sel, bg = c.bg_list_sel },
    PmenuMatch = { fg = c.blue, bold = true },
    PmenuMatchSel = { fg = c.blue, bg = c.bg_list_sel, bold = true },
    PmenuKind = { fg = c.yellow, bg = c.bg_dark },
    PmenuKindSel = { fg = c.yellow, bg = c.bg_list_sel },
    PmenuExtra = { fg = c.fg_dim, bg = c.bg_dark },
    PmenuExtraSel = { fg = c.fg_dim, bg = c.bg_list_sel },
    PmenuSbar = { bg = c.bg_dark },
    PmenuThumb = { bg = c.fg_dim },
    WildMenu = { link = "PmenuSel" },
    QuickFixLine = { bg = c.bg_list_sel },

    ModeMsg = { fg = c.fg, bold = true },
    MsgArea = { fg = c.fg },
    MoreMsg = { fg = c.blue },
    Question = { fg = c.cyan },
    ErrorMsg = { fg = c.error },
    WarningMsg = { fg = c.warning },

    SpellBad = { sp = c.error, undercurl = true },
    SpellCap = { sp = c.warning, undercurl = true },
    SpellLocal = { sp = c.info, undercurl = true },
    SpellRare = { sp = c.hint, undercurl = true },

    DiffAdd = { bg = blend("#9bb955", c.bg, 0x33 / 255) },
    DiffDelete = { bg = blend("#ff0000", c.bg, 0x33 / 255) },
    DiffChange = { bg = blend(c.blue, c.bg, 0.15) },
    DiffText = { bg = blend(c.blue, c.bg, 0.35) },
    Added = { fg = c.git_add },
    Changed = { fg = c.git_change },
    Removed = { fg = c.git_delete },

    -- Syntax (legacy groups) -----------------------------------------------------------
    Comment = { fg = c.fg_dim },
    Constant = { fg = c.cyan },
    String = { fg = c.cyan },
    Character = { fg = c.cyan },
    Number = { fg = c.cyan },
    Boolean = { fg = c.cyan },
    Float = { fg = c.cyan },
    Identifier = { fg = c.fg },
    Function = { fg = c.blue },
    Statement = { fg = c.green },
    Conditional = { fg = c.green },
    Repeat = { fg = c.green },
    Label = { fg = c.green },
    Operator = { fg = c.green },
    Keyword = { fg = c.green },
    Exception = { fg = c.green },
    PreProc = { fg = c.orange },
    Include = { fg = c.orange },
    Define = { fg = c.orange },
    Macro = { fg = c.orange },
    PreCondit = { fg = c.orange },
    Type = { fg = c.yellow },
    StorageClass = { fg = c.green },
    Structure = { fg = c.yellow },
    Typedef = { fg = c.yellow },
    Special = { fg = c.cyan },
    SpecialChar = { fg = c.cyan },
    Tag = { fg = c.blue },
    Delimiter = { fg = c.fg },
    SpecialComment = { fg = c.fg_dim },
    Debug = { fg = c.orange },
    Underlined = { underline = true },
    Bold = { bold = true },
    Italic = { italic = true },
    Ignore = { fg = c.fg_dim },
    Error = { fg = c.red },
    Todo = { fg = c.magenta, bold = true },

    -- Treesitter -----------------------------------------------------------------------
    -- Mirrors the Dark+ token rules: definitions are blue, calls are plain foreground,
    -- keywords/operators green, types yellow, literals cyan, imports orange.
    ["@variable"] = { fg = c.fg },
    ["@variable.builtin"] = { fg = c.fg },
    ["@variable.builtin.python"] = { fg = c.blue }, -- self / cls
    ["@variable.parameter"] = { fg = c.fg },
    ["@variable.member"] = { fg = c.fg },
    ["@constant"] = { fg = c.fg },
    ["@constant.builtin"] = { fg = c.cyan },
    ["@constant.macro"] = { fg = c.orange },
    ["@module"] = { fg = c.fg },
    ["@module.builtin"] = { fg = c.fg },
    ["@label"] = { fg = c.fg },

    ["@string"] = { fg = c.cyan },
    ["@string.documentation"] = { fg = c.cyan },
    ["@string.regexp"] = { fg = c.red },
    ["@string.escape"] = { fg = c.cyan },
    ["@string.special"] = { fg = c.cyan },
    ["@string.special.symbol"] = { fg = c.cyan },
    ["@string.special.url"] = { fg = c.cyan, underline = true },
    ["@character"] = { fg = c.cyan },
    ["@character.special"] = { fg = c.cyan },
    ["@boolean"] = { fg = c.cyan },
    ["@number"] = { fg = c.cyan },
    ["@number.float"] = { fg = c.cyan },

    ["@type"] = { fg = c.yellow },
    ["@type.builtin"] = { fg = c.yellow },
    ["@type.builtin.go"] = { fg = c.green }, -- Go primitives are storage.type in VS Code
    ["@type.definition"] = { fg = c.yellow },
    ["@attribute"] = { fg = c.fg },
    ["@attribute.builtin"] = { fg = c.fg },
    ["@property"] = { fg = c.fg },
    ["@property.json"] = { fg = c.yellow },
    ["@property.jsonc"] = { fg = c.yellow },
    ["@property.toml"] = { fg = c.yellow },
    ["@property.yaml"] = { fg = c.blue },
    ["@property.css"] = { fg = c.yellow },
    ["@property.scss"] = { fg = c.yellow },

    ["@function"] = { fg = c.blue },
    ["@function.builtin"] = { fg = c.fg },
    ["@function.call"] = { fg = c.fg },
    ["@function.macro"] = { fg = c.orange },
    ["@function.method"] = { fg = c.blue },
    ["@function.method.call"] = { fg = c.fg },
    ["@constructor"] = { fg = c.yellow },
    ["@constructor.lua"] = { fg = c.fg }, -- table braces
    ["@operator"] = { fg = c.green },

    ["@keyword"] = { fg = c.green },
    ["@keyword.coroutine"] = { fg = c.green },
    ["@keyword.function"] = { fg = c.green },
    ["@keyword.operator"] = { fg = c.green },
    ["@keyword.import"] = { fg = c.orange },
    ["@keyword.type"] = { fg = c.green },
    ["@keyword.modifier"] = { fg = c.green },
    ["@keyword.repeat"] = { fg = c.green },
    ["@keyword.return"] = { fg = c.green },
    ["@keyword.debug"] = { fg = c.orange },
    ["@keyword.exception"] = { fg = c.green },
    ["@keyword.conditional"] = { fg = c.green },
    ["@keyword.directive"] = { fg = c.orange },
    ["@keyword.directive.define"] = { fg = c.orange },

    ["@punctuation.delimiter"] = { fg = c.fg },
    ["@punctuation.bracket"] = { fg = c.fg },
    ["@punctuation.special"] = { fg = c.fg },

    ["@comment"] = { link = "Comment" },
    ["@comment.documentation"] = { link = "Comment" },
    ["@comment.error"] = { fg = c.error, bold = true },
    ["@comment.warning"] = { fg = c.warning, bold = true },
    ["@comment.todo"] = { fg = c.magenta, bold = true },
    ["@comment.note"] = { fg = c.info, bold = true },

    ["@tag"] = { fg = c.blue },
    ["@tag.builtin"] = { fg = c.blue },
    ["@tag.attribute"] = { fg = c.fg },
    ["@tag.delimiter"] = { fg = c.fg_dim },
    ["@tag.css"] = { fg = c.green },
    ["@type.css"] = { fg = c.blue }, -- .class selectors

    ["@markup.strong"] = { bold = true },
    ["@markup.italic"] = { italic = true },
    ["@markup.strikethrough"] = { strikethrough = true },
    ["@markup.underline"] = { underline = true },
    ["@markup.heading"] = { fg = c.fg_bright, bold = true },
    ["@markup.quote"] = { fg = c.fg_dim, italic = true },
    ["@markup.math"] = { fg = c.cyan },
    ["@markup.link"] = { fg = c.fg },
    ["@markup.link.label"] = { fg = c.blue },
    ["@markup.link.url"] = { fg = c.cyan, underline = true },
    ["@markup.raw"] = { fg = c.cyan },
    ["@markup.list"] = { fg = c.orange },
    ["@markup.list.checked"] = { fg = c.green },
    ["@markup.list.unchecked"] = { fg = c.fg_dim },

    ["@diff.plus"] = { fg = c.green },
    ["@diff.minus"] = { fg = c.red },
    ["@diff.delta"] = { fg = c.blue },

    -- LSP semantic tokens --------------------------------------------------------------
    -- Leave most to treesitter so calls stay foreground and only declarations go blue.
    ["@lsp.type.function"] = {},
    ["@lsp.type.method"] = {},
    ["@lsp.type.variable"] = {},
    ["@lsp.type.parameter"] = {},
    ["@lsp.type.property"] = {},
    ["@lsp.type.comment"] = {},
    ["@lsp.type.string"] = {},
    ["@lsp.type.keyword"] = {},
    ["@lsp.type.namespace"] = { fg = c.fg },
    ["@lsp.type.type"] = { fg = c.yellow },
    ["@lsp.type.class"] = { fg = c.yellow },
    ["@lsp.type.struct"] = { fg = c.yellow },
    ["@lsp.type.interface"] = { fg = c.yellow },
    ["@lsp.type.enum"] = { fg = c.yellow },
    ["@lsp.type.typeParameter"] = { fg = c.yellow },
    ["@lsp.type.enumMember"] = { fg = c.fg },
    ["@lsp.type.number"] = { fg = c.cyan },
    ["@lsp.type.operator"] = { fg = c.green },
    ["@lsp.type.macro"] = { fg = c.orange },
    ["@lsp.typemod.function.declaration"] = { fg = c.blue },
    ["@lsp.typemod.method.declaration"] = { fg = c.blue },
    ["@lsp.typemod.function.definition"] = { fg = c.blue },
    ["@lsp.typemod.method.definition"] = { fg = c.blue },
    ["@lsp.typemod.type.defaultLibrary.go"] = { fg = c.green },
    ["@lsp.typemod.variable.readonly"] = {},
    ["@lsp.typemod.variable.defaultLibrary"] = {},

    LspReferenceText = { bg = blend(c.blue, c.bg, 0.2) },
    LspReferenceRead = { link = "LspReferenceText" },
    LspReferenceWrite = { bg = blend(c.blue, c.bg, 0.3) },
    LspSignatureActiveParameter = { fg = c.blue, bold = true },
    LspInlayHint = { fg = c.fg_dim, bg = blend(c.fg_dim, c.bg, 0.12), italic = true },
    LspCodeLens = { fg = c.fg_dim },
    LspInfoBorder = { link = "FloatBorder" },

    -- Diagnostics ----------------------------------------------------------------------
    DiagnosticError = { fg = c.error },
    DiagnosticWarn = { fg = c.warning },
    DiagnosticInfo = { fg = c.info },
    DiagnosticHint = { fg = c.hint },
    DiagnosticOk = { fg = c.green },
    DiagnosticUnderlineError = { sp = c.error, undercurl = true },
    DiagnosticUnderlineWarn = { sp = c.warning, undercurl = true },
    DiagnosticUnderlineInfo = { sp = c.info, undercurl = true },
    DiagnosticUnderlineHint = { sp = c.hint, undercurl = true },
    DiagnosticVirtualTextError = { fg = c.error, bg = blend(c.error, c.bg, 0.1) },
    DiagnosticVirtualTextWarn = { fg = c.warning, bg = blend(c.warning, c.bg, 0.1) },
    DiagnosticVirtualTextInfo = { fg = c.info, bg = blend(c.info, c.bg, 0.1) },
    DiagnosticVirtualTextHint = { fg = c.hint, bg = blend(c.hint, c.bg, 0.1) },
    DiagnosticUnnecessary = { fg = c.fg_dim },
    DiagnosticDeprecated = { strikethrough = true },

    -- Plugins --------------------------------------------------------------------------
    -- gitsigns
    GitSignsAdd = { fg = c.git_add, bg = gutter },
    GitSignsChange = { fg = c.git_change, bg = gutter },
    GitSignsDelete = { fg = c.git_delete, bg = gutter },

    -- blink.cmp
    BlinkCmpMenu = { link = "Pmenu" },
    BlinkCmpMenuBorder = { link = "FloatBorder" },
    BlinkCmpMenuSelection = { link = "PmenuSel" },
    BlinkCmpLabel = { fg = c.fg },
    BlinkCmpLabelMatch = { fg = c.blue, bold = true },
    BlinkCmpLabelDeprecated = { fg = c.fg_dim, strikethrough = true },
    BlinkCmpLabelDetail = { fg = c.fg_dim },
    BlinkCmpLabelDescription = { fg = c.fg_dim },
    BlinkCmpSource = { fg = c.fg_dim },
    BlinkCmpKind = { fg = c.yellow },
    BlinkCmpDoc = { link = "NormalFloat" },
    BlinkCmpDocBorder = { link = "FloatBorder" },
    BlinkCmpDocSeparator = { fg = border, bg = c.bg_dark },
    BlinkCmpSignatureHelp = { link = "NormalFloat" },
    BlinkCmpSignatureHelpBorder = { link = "FloatBorder" },
    BlinkCmpGhostText = { fg = c.fg_dim },

    -- snacks
    SnacksNormal = { link = "NormalFloat" },
    SnacksPicker = { link = "NormalFloat" },
    SnacksPickerBorder = { link = "FloatBorder" },
    SnacksPickerTitle = { link = "FloatTitle" },
    SnacksPickerMatch = { fg = c.blue, bold = true },
    SnacksPickerDir = { fg = c.fg_dim },
    SnacksPickerPathHidden = { fg = c.fg_dim },
    SnacksPickerListCursorLine = { bg = c.bg_list_sel },
    SnacksPickerPrompt = { fg = c.cyan },
    SnacksPickerGitStatusAdded = { fg = c.file_added },
    SnacksPickerGitStatusModified = { fg = c.file_modified },
    SnacksPickerGitStatusDeleted = { fg = c.file_deleted },
    SnacksPickerGitStatusUntracked = { fg = c.file_untracked },
    SnacksPickerGitStatusIgnored = { fg = c.file_ignored },
    SnacksPickerGitStatusUnmerged = { fg = c.file_conflict },
    SnacksIndent = { fg = indent },
    SnacksIndentScope = { fg = indent_active },
    SnacksDashboardHeader = { fg = c.blue },
    SnacksDashboardIcon = { fg = c.cyan },
    SnacksDashboardKey = { fg = c.orange },
    SnacksDashboardDesc = { fg = c.fg },
    SnacksDashboardFooter = { fg = c.fg_dim },
    SnacksDashboardSpecial = { fg = c.violet },
    SnacksNotifierError = { fg = c.error },
    SnacksNotifierWarn = { fg = c.warning },
    SnacksNotifierInfo = { fg = c.info },
    SnacksNotifierBorderError = { fg = c.error },
    SnacksNotifierBorderWarn = { fg = c.warning },
    SnacksNotifierBorderInfo = { fg = c.info },
    SnacksNotifierTitleError = { fg = c.error, bold = true },
    SnacksNotifierTitleWarn = { fg = c.warning, bold = true },
    SnacksNotifierTitleInfo = { fg = c.info, bold = true },

    -- sidebars (snacks explorer, neo-tree, nvim-tree)
    NeoTreeNormal = { fg = c.fg, bg = bg_side },
    NeoTreeNormalNC = { fg = c.fg, bg = bg_side },
    NeoTreeGitAdded = { fg = c.file_added },
    NeoTreeGitModified = { fg = c.file_modified },
    NeoTreeGitDeleted = { fg = c.file_deleted },
    NeoTreeGitUntracked = { fg = c.file_untracked },
    NeoTreeGitIgnored = { fg = c.file_ignored },
    NeoTreeGitConflict = { fg = c.file_conflict },
    NvimTreeNormal = { fg = c.fg, bg = bg_side },

    -- bufferline
    BufferLineFill = { bg = c.bg_dark },
    BufferLineBackground = { fg = c.fg_dim, bg = c.bg_tab_inactive },
    BufferLineBufferSelected = { fg = c.fg_tab_active, bg = c.bg, bold = true },
    BufferLineBufferVisible = { fg = c.fg, bg = c.bg_tab_inactive },
    BufferLineIndicatorSelected = { fg = c.blue, bg = c.bg },
    BufferLineSeparator = { fg = c.bg_dark, bg = c.bg_tab_inactive },
    BufferLineSeparatorSelected = { fg = c.bg_dark, bg = c.bg },
    BufferLineSeparatorVisible = { fg = c.bg_dark, bg = c.bg_tab_inactive },
    BufferLineOffsetSeparator = { fg = c.separator, bg = c.bg_dark },

    -- which-key
    WhichKey = { fg = c.cyan },
    WhichKeyGroup = { fg = c.blue },
    WhichKeyDesc = { fg = c.fg },
    WhichKeySeparator = { fg = c.fg_dim },
    WhichKeyValue = { fg = c.fg_dim },
    WhichKeyNormal = { link = "NormalFloat" },
    WhichKeyBorder = { link = "FloatBorder" },

    -- noice
    NoiceCmdlinePopupBorder = { fg = c.blue },
    NoiceCmdlineIcon = { fg = c.blue },
    NoiceCmdlinePopupTitle = { fg = c.blue },
    NoiceCmdlinePopupBorderSearch = { fg = c.yellow },
    NoiceCmdlineIconSearch = { fg = c.yellow },

    -- flash
    FlashLabel = { fg = c.bg, bg = c.magenta, bold = true },
    FlashMatch = { fg = c.fg_bright, bg = blend(c.blue, c.bg, 0.3) },
    FlashCurrent = { fg = c.bg, bg = c.orange },
    FlashBackdrop = { fg = c.fg_dim },

    -- trouble
    TroubleNormal = { fg = c.fg, bg = bg_side },
    TroubleNormalNC = { fg = c.fg, bg = bg_side },

    -- todo-comments
    TodoBgTODO = { fg = c.bg, bg = c.blue, bold = true },
    TodoFgTODO = { fg = c.blue },
    TodoBgFIX = { fg = c.bg, bg = c.red, bold = true },
    TodoFgFIX = { fg = c.red },
    TodoBgWARN = { fg = c.bg, bg = c.yellow, bold = true },
    TodoFgWARN = { fg = c.yellow },
    TodoBgNOTE = { fg = c.bg, bg = c.cyan, bold = true },
    TodoFgNOTE = { fg = c.cyan },
    TodoBgHACK = { fg = c.bg, bg = c.orange, bold = true },
    TodoFgHACK = { fg = c.orange },
    TodoBgPERF = { fg = c.bg, bg = c.violet, bold = true },
    TodoFgPERF = { fg = c.violet },
    TodoBgTEST = { fg = c.bg, bg = c.magenta, bold = true },
    TodoFgTEST = { fg = c.magenta },

    -- mini.icons
    MiniIconsAzure = { fg = c.blue },
    MiniIconsBlue = { fg = c.blue },
    MiniIconsCyan = { fg = c.cyan },
    MiniIconsGreen = { fg = c.green },
    MiniIconsGrey = { fg = c.fg },
    MiniIconsOrange = { fg = c.orange },
    MiniIconsPurple = { fg = c.violet },
    MiniIconsRed = { fg = c.red },
    MiniIconsYellow = { fg = c.yellow },

    -- bracket pair colourisation (editorBracketHighlight.foreground1-3)
    RainbowDelimiterBlue = { fg = c.blue },
    RainbowDelimiterYellow = { fg = c.yellow },
    RainbowDelimiterViolet = { fg = c.magenta },
    RainbowDelimiterRed = { fg = c.blue },
    RainbowDelimiterOrange = { fg = c.yellow },
    RainbowDelimiterGreen = { fg = c.magenta },
    RainbowDelimiterCyan = { fg = c.blue },
  }

  return g
end

return M
