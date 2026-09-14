--- Alabaster Dark colorscheme: Neovim port of the VSCode theme of the same name.
---
--- Minimal highlighting (comments, strings, constants, definitions, punctuation)
--- plus editor UI and terminal ANSI from the VSCode JSON. Departures: editor/panel
--- are darkened so the field is inky, not lifted gray; strings use a matte sage
--- instead of the JSON lime. Dark only. Load via `:colorscheme alabaster-dark`.
--- Does not implement rainbow delimiters.

local M = {}

local function hex_rgb(hex)
  hex = hex:gsub("^#", "")
  return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
end

--- Blend `#RRGGBB` or `#RRGGBBAA` onto an opaque `#RRGGBB` background.
local function blend(fg, bg)
  local hex = fg:gsub("^#", "")
  local alpha = 1
  if #hex == 8 then
    alpha = tonumber(hex:sub(7, 8), 16) / 255
    hex = hex:sub(1, 6)
  end
  local r1, g1, b1 = hex_rgb(hex)
  local r2, g2, b2 = hex_rgb(bg)
  return string.format(
    "#%02X%02X%02X",
    math.floor(r1 * alpha + r2 * (1 - alpha) + 0.5),
    math.floor(g1 * alpha + g2 * (1 - alpha) + 0.5),
    math.floor(b1 * alpha + b2 * (1 - alpha) + 0.5)
  )
end

-- VSCode JSON editor was #21252B (L* ~14.5). #15181C keeps the same cool hue.
local BG = "#15181C"

local function palette()
  local p = {
    bg = BG,
    fg = "#ABB2BF",
    panel = "#0F1114",
    cursor = "#A9B2C3",
    linenr = "#5F6672",
    comment = "#E06C75",
    string = "#89A375",
    constant = "#BF79C3",
    definition = "#61AFEF",
    punct = "#737C8C",
    invalid_fg = "#DF334A",
    tab_active = "#D4D7D9",
    diff_fg = "#D2D6DB",
    yellow = "#D19A66",
    cyan = "#56B6C2",
    green = "#89A375",
    red = "#E06C75",
    blue = "#61AFEF",
    magenta = "#B57EDC",
    bright_yellow = "#E5C07B",
    bright_red = "#E34234",
    ansi = {
      BG,
      "#E06C75",
      "#98C379",
      "#D19A66",
      "#61AFEF",
      "#B57EDC",
      "#56B6C2",
      "#A9B2C3",
      "#5F6672",
      "#E34234",
      "#66FF00",
      "#E5C07B",
      "#007FFF",
      "#8B00FF",
      "#08E8DE",
      "#D4D7D9",
    },
  }
  p.cursorline = blend("#A9B2C31A", p.bg)
  p.search = blend("#D19A6640", p.bg)
  p.cursearch = blend("#d19a6680", p.bg)
  p.invalid_bg = blend("#C62D4233", p.bg)
  p.diff_add = blend("#56B6C233", p.bg)
  p.diff_delete = blend("#E06C7533", p.bg)
  p.diff_change = blend("#61AFEF33", p.bg)
  p.diag_error_bg = blend("#E06C7533", p.bg)
  p.diag_warn_bg = blend("#D19A6633", p.bg)
  p.diag_info_bg = blend("#61AFEF33", p.bg)
  p.diag_hint_bg = blend("#56B6C233", p.bg)
  p.diag_ok_bg = blend(p.green .. "33", p.bg)
  return p
end

M.palette = palette()

local function apply(groups)
  for name, spec in pairs(groups) do
    vim.api.nvim_set_hl(0, name, spec)
  end
end

local function highlights(p)
  local text = { fg = p.fg }
  local def = { fg = p.definition }
  local const = { fg = p.constant }
  local str = { fg = p.string }
  local comm = { fg = p.comment }
  local punct = { fg = p.punct }
  local err = { fg = p.invalid_fg, bg = p.invalid_bg }

  local groups = {
    -- UI
    Normal = { fg = p.fg, bg = p.bg },
    NormalNC = { fg = p.fg, bg = p.bg },
    NormalFloat = { fg = p.fg, bg = p.panel },
    FloatBorder = { fg = p.linenr, bg = p.panel },
    FloatTitle = { fg = p.definition, bg = p.panel },
    FloatFooter = { fg = p.linenr, bg = p.panel },
    ColorColumn = { bg = p.cursorline },
    Conceal = { fg = p.linenr },
    Cursor = { fg = p.bg, bg = p.cursor },
    lCursor = { fg = p.bg, bg = p.cursor },
    CursorIM = { fg = p.bg, bg = p.cursor },
    TermCursor = { fg = p.bg, bg = p.cursor },
    CursorLine = { bg = p.cursorline },
    CursorColumn = { bg = p.cursorline },
    Directory = { fg = p.definition },
    EndOfBuffer = { fg = p.bg },
    ErrorMsg = { fg = p.invalid_fg, bg = p.invalid_bg },
    WinSeparator = { fg = p.linenr, bg = p.bg },
    VertSplit = { fg = p.linenr, bg = p.bg },
    Folded = { fg = p.linenr, bg = p.cursorline },
    FoldColumn = { fg = p.linenr, bg = p.bg },
    SignColumn = { fg = p.linenr, bg = p.bg },
    IncSearch = { bg = p.cursearch, fg = p.fg },
    CurSearch = { bg = p.cursearch, fg = p.fg },
    Search = { bg = p.search, fg = p.fg },
    Substitute = { bg = p.cursearch, fg = p.fg },
    LineNr = { fg = p.linenr },
    LineNrAbove = { fg = p.linenr },
    LineNrBelow = { fg = p.linenr },
    CursorLineNr = { fg = p.cursor },
    CursorLineFold = { fg = p.linenr, bg = p.cursorline },
    CursorLineSign = { fg = p.linenr, bg = p.cursorline },
    MatchParen = { fg = p.yellow, underline = true },
    ModeMsg = { fg = p.fg },
    MsgArea = { fg = p.fg, bg = p.bg },
    MsgSeparator = { fg = p.linenr, bg = p.bg },
    MoreMsg = { fg = p.green },
    NonText = { fg = p.linenr },
    Whitespace = { fg = p.linenr },
    Pmenu = { fg = p.fg, bg = p.panel },
    PmenuSel = { fg = p.tab_active, bg = p.cursorline },
    PmenuSbar = { bg = p.panel },
    PmenuThumb = { bg = p.linenr },
    PmenuKind = { fg = p.definition, bg = p.panel },
    PmenuKindSel = { fg = p.definition, bg = p.cursorline },
    PmenuExtra = { fg = p.linenr, bg = p.panel },
    PmenuExtraSel = { fg = p.linenr, bg = p.cursorline },
    PmenuMatch = { fg = p.yellow, bg = p.panel },
    PmenuMatchSel = { fg = p.yellow, bg = p.cursorline },
    ComplMatchIns = { fg = p.yellow },
    Question = { fg = p.green },
    QuickFixLine = { bg = p.cursorline },
    SpecialKey = { fg = p.punct },
    SpellBad = { undercurl = true, sp = p.red },
    SpellCap = { undercurl = true, sp = p.blue },
    SpellLocal = { undercurl = true, sp = p.cyan },
    SpellRare = { undercurl = true, sp = p.magenta },
    StatusLine = { fg = p.cursor, bg = p.bg },
    StatusLineNC = { fg = p.linenr, bg = p.bg },
    TabLine = { fg = p.linenr, bg = p.panel },
    TabLineFill = { fg = p.linenr, bg = p.panel },
    TabLineSel = { fg = p.tab_active, bg = p.bg },
    Title = { fg = p.definition },
    Visual = { bg = p.cursorline },
    VisualNOS = { bg = p.cursorline },
    WarningMsg = { fg = p.yellow },
    WildMenu = { fg = p.tab_active, bg = p.cursorline },
    WinBar = { fg = p.tab_active, bg = p.bg },
    WinBarNC = { fg = p.linenr, bg = p.bg },
    SnippetTabstop = { bg = p.cursorline },

    -- Diff (VSCode Extra: Diff From/To/Range) and 0.10 sign groups
    DiffAdd = { fg = p.diff_fg, bg = p.diff_add },
    DiffDelete = { fg = p.diff_fg, bg = p.diff_delete },
    DiffChange = { fg = p.diff_fg, bg = p.diff_change },
    DiffText = { fg = p.fg, bg = p.cursearch },
    Added = { fg = p.green },
    Changed = { fg = p.yellow },
    Removed = { fg = p.red },

    -- Syntax: unlisted groups stay at editor foreground (Alabaster)
    Comment = comm,
    Constant = const,
    String = str,
    Character = const,
    Number = const,
    Boolean = const,
    Float = const,
    Identifier = text,
    Function = def,
    Statement = text,
    Conditional = text,
    Repeat = text,
    Label = def,
    Operator = punct,
    Keyword = text,
    Exception = text,
    PreProc = text,
    Include = text,
    Define = text,
    Macro = text,
    PreCondit = text,
    Type = text,
    StorageClass = text,
    Structure = def,
    Typedef = def,
    Special = punct,
    SpecialChar = punct,
    Tag = def,
    Delimiter = punct,
    SpecialComment = comm,
    Debug = { fg = p.yellow },
    Underlined = { underline = true },
    Ignore = { fg = p.linenr },
    Error = err,
    Todo = comm,

    -- Diagnostics (not in the VSCode JSON; from the same palette)
    DiagnosticError = { fg = p.red },
    DiagnosticWarn = { fg = p.yellow },
    DiagnosticInfo = { fg = p.blue },
    DiagnosticHint = { fg = p.cyan },
    DiagnosticOk = { fg = p.green },
    DiagnosticVirtualTextError = { fg = p.red, bg = p.diag_error_bg },
    DiagnosticVirtualTextWarn = { fg = p.yellow, bg = p.diag_warn_bg },
    DiagnosticVirtualTextInfo = { fg = p.blue, bg = p.diag_info_bg },
    DiagnosticVirtualTextHint = { fg = p.cyan, bg = p.diag_hint_bg },
    DiagnosticVirtualTextOk = { fg = p.green, bg = p.diag_ok_bg },
    DiagnosticUnderlineError = { undercurl = true, sp = p.red },
    DiagnosticUnderlineWarn = { undercurl = true, sp = p.yellow },
    DiagnosticUnderlineInfo = { undercurl = true, sp = p.blue },
    DiagnosticUnderlineHint = { undercurl = true, sp = p.cyan },
    DiagnosticUnderlineOk = { undercurl = true, sp = p.green },
    DiagnosticDeprecated = { strikethrough = true },
    DiagnosticUnnecessary = { fg = p.linenr },

    LspReferenceText = { bg = p.cursorline },
    LspReferenceRead = { bg = p.cursorline },
    LspReferenceWrite = { bg = p.cursorline },
    LspReferenceTarget = { bg = p.cursorline },
    LspCodeLens = { fg = p.linenr },
    LspCodeLensSeparator = { fg = p.linenr },
    LspInlayHint = { fg = p.linenr },
    LspSignatureActiveParameter = { bg = p.cursorline, underline = true },

    healthSuccess = { fg = p.green },
    healthWarning = { fg = p.yellow },
    healthError = { fg = p.red },
  }

  -- Treesitter: definitions blue; calls/uses/keywords stay foreground.
  local ts = {
    ["@variable"] = text,
    ["@variable.builtin"] = text,
    ["@variable.parameter"] = text,
    ["@variable.parameter.builtin"] = text,
    ["@variable.member"] = text,

    ["@constant"] = const,
    ["@constant.builtin"] = const,
    ["@constant.macro"] = const,

    ["@module"] = text,
    ["@module.builtin"] = text,
    ["@label"] = def,

    ["@string"] = str,
    ["@string.documentation"] = str,
    ["@string.regexp"] = str,
    ["@string.escape"] = punct,
    ["@string.special"] = str,
    ["@string.special.symbol"] = str,
    ["@string.special.url"] = { fg = p.punct, underline = true },
    ["@string.special.path"] = str,
    ["@symbol"] = str,

    ["@character"] = const,
    ["@character.special"] = punct,
    ["@boolean"] = const,
    ["@number"] = const,
    ["@number.float"] = const,

    ["@type"] = text,
    ["@type.builtin"] = text,
    ["@type.definition"] = def,

    ["@attribute"] = text,
    ["@attribute.builtin"] = text,
    ["@property"] = text,

    ["@function"] = def,
    ["@function.builtin"] = text,
    ["@function.call"] = text,
    ["@function.macro"] = text,
    ["@function.method"] = def,
    ["@function.method.call"] = text,
    ["@constructor"] = def,
    ["@operator"] = punct,

    ["@punctuation.delimiter"] = punct,
    ["@punctuation.bracket"] = punct,
    ["@punctuation.special"] = punct,

    ["@comment"] = comm,
    ["@comment.documentation"] = comm,
    ["@comment.error"] = comm,
    ["@comment.warning"] = comm,
    ["@comment.todo"] = comm,
    ["@comment.note"] = comm,

    ["@markup.strong"] = { fg = p.fg, bold = true },
    ["@markup.italic"] = { fg = p.fg, italic = true },
    ["@markup.strikethrough"] = { fg = p.fg, strikethrough = true },
    ["@markup.underline"] = { fg = p.fg, underline = true },
    ["@markup.heading"] = def,
    ["@markup.quote"] = { fg = p.punct },
    ["@markup.math"] = const,
    ["@markup.link"] = { fg = p.definition, underline = true },
    ["@markup.link.label"] = { fg = p.definition, underline = true },
    ["@markup.link.url"] = { fg = p.punct, underline = true },
    ["@markup.raw"] = str,
    ["@markup.raw.block"] = str,
    ["@markup.list"] = punct,
    ["@markup.list.checked"] = { fg = p.green },
    ["@markup.list.unchecked"] = punct,

    ["@diff.plus"] = { fg = p.green },
    ["@diff.minus"] = { fg = p.red },
    ["@diff.delta"] = { fg = p.yellow },

    ["@tag"] = def,
    ["@tag.builtin"] = def,
    ["@tag.attribute"] = text,
    ["@tag.delimiter"] = punct,
  }
  for name, spec in pairs(ts) do
    groups[name] = spec
  end

  for _, kw in ipairs({
    "@keyword",
    "@keyword.coroutine",
    "@keyword.function",
    "@keyword.operator",
    "@keyword.import",
    "@keyword.type",
    "@keyword.modifier",
    "@keyword.repeat",
    "@keyword.return",
    "@keyword.debug",
    "@keyword.exception",
    "@keyword.conditional",
    "@keyword.conditional.ternary",
    "@keyword.directive",
    "@keyword.directive.define",
  }) do
    groups[kw] = text
  end

  -- LSP: uses stay foreground; declaration/definition of named entities are blue.
  local lsp_type = {
    ["@lsp.type.class"] = text,
    ["@lsp.type.comment"] = comm,
    ["@lsp.type.decorator"] = text,
    ["@lsp.type.enum"] = text,
    ["@lsp.type.enumMember"] = const,
    ["@lsp.type.event"] = text,
    ["@lsp.type.function"] = text,
    ["@lsp.type.interface"] = text,
    ["@lsp.type.keyword"] = text,
    ["@lsp.type.macro"] = text,
    ["@lsp.type.method"] = text,
    ["@lsp.type.modifier"] = text,
    ["@lsp.type.namespace"] = text,
    ["@lsp.type.number"] = const,
    ["@lsp.type.operator"] = punct,
    ["@lsp.type.parameter"] = text,
    ["@lsp.type.property"] = text,
    ["@lsp.type.regexp"] = str,
    ["@lsp.type.string"] = str,
    ["@lsp.type.struct"] = text,
    ["@lsp.type.type"] = text,
    ["@lsp.type.typeParameter"] = text,
    ["@lsp.type.variable"] = text,
    ["@lsp.mod.deprecated"] = { strikethrough = true },
  }
  for name, spec in pairs(lsp_type) do
    groups[name] = spec
  end

  for _, kind in ipairs({
    "function",
    "method",
    "class",
    "struct",
    "enum",
    "type",
    "interface",
    "namespace",
    "macro",
    "decorator",
  }) do
    groups["@lsp.typemod." .. kind .. ".declaration"] = def
    groups["@lsp.typemod." .. kind .. ".definition"] = def
  end

  return groups
end

function M.load()
  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end

  vim.o.termguicolors = true
  vim.o.background = "dark"
  vim.g.colors_name = "alabaster-dark"

  local p = palette()
  M.palette = p

  for i, color in ipairs(p.ansi) do
    vim.g["terminal_color_" .. (i - 1)] = color
  end

  apply(highlights(p))
end

return M
