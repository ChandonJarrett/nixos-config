local M = {}

M.colors = {
  base00 = "@base00@",
  base01 = "@base01@",
  base02 = "@base02@",
  base03 = "@base03@",
  base04 = "@base04@",
  base05 = "@base05@",
  base06 = "@base06@",
  base07 = "@base07@",
  base08 = "@base08@",
  base09 = "@base09@",
  base0A = "@base0A@",
  base0B = "@base0B@",
  base0C = "@base0C@",
  base0D = "@base0D@",
  base0E = "@base0E@",
  base0F = "@base0F@",
}

function M.setup()
  local c = M.colors

  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end

  vim.g.colors_name = "flake-theme"
  vim.o.termguicolors = true

  local function hi(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi("Normal", { fg = c.base05, bg = c.base00 })
  hi("NormalNC", { fg = c.base05, bg = c.base00 })
  hi("NormalFloat", { fg = c.base05, bg = c.base01 })
  hi("FloatBorder", { fg = c.base03, bg = c.base01 })
  hi("FloatTitle", { fg = c.base0D, bg = c.base01, bold = true })

  hi("Cursor", { fg = c.base00, bg = c.base07 })
  hi("CursorLine", { bg = c.base01 })
  hi("CursorColumn", { bg = c.base01 })
  hi("ColorColumn", { bg = c.base01 })

  hi("LineNr", { fg = c.base03 })
  hi("CursorLineNr", { fg = c.base0A, bold = true })
  hi("SignColumn", { bg = c.base00 })

  hi("Visual", { bg = c.base02 })
  hi("Search", { fg = c.base00, bg = c.base0A })
  hi("IncSearch", { fg = c.base00, bg = c.base09 })

  hi("Comment", { fg = c.base03, italic = true })
  hi("Constant", { fg = c.base09 })
  hi("String", { fg = c.base0B })
  hi("Character", { fg = c.base0B })
  hi("Number", { fg = c.base09 })
  hi("Boolean", { fg = c.base09 })
  hi("Float", { fg = c.base09 })

  hi("Identifier", { fg = c.base05 })
  hi("Function", { fg = c.base0D })

  hi("Statement", { fg = c.base0E })
  hi("Conditional", { fg = c.base0E })
  hi("Repeat", { fg = c.base0E })
  hi("Label", { fg = c.base0E })
  hi("Operator", { fg = c.base0C })
  hi("Keyword", { fg = c.base0E })
  hi("Exception", { fg = c.base08 })

  hi("PreProc", { fg = c.base0C })
  hi("Include", { fg = c.base0D })
  hi("Define", { fg = c.base0E })
  hi("Macro", { fg = c.base0E })

  hi("Type", { fg = c.base0A })
  hi("StorageClass", { fg = c.base0A })
  hi("Structure", { fg = c.base0A })
  hi("Typedef", { fg = c.base0A })

  hi("Special", { fg = c.base0C })
  hi("SpecialChar", { fg = c.base0C })
  hi("Tag", { fg = c.base0A })
  hi("Delimiter", { fg = c.base04 })
  hi("SpecialComment", { fg = c.base03, italic = true })
  hi("Debug", { fg = c.base08 })

  hi("Error", { fg = c.base08 })
  hi("Todo", { fg = c.base0A, bold = true })

  hi("Pmenu", { fg = c.base05, bg = c.base01 })
  hi("PmenuSel", { fg = c.base07, bg = c.base02 })
  hi("PmenuSbar", { bg = c.base01 })
  hi("PmenuThumb", { bg = c.base03 })

  hi("StatusLine", { fg = c.base06, bg = c.base01 })
  hi("StatusLineNC", { fg = c.base04, bg = c.base01 })
  hi("WinSeparator", { fg = c.base02 })

  hi("TabLine", { fg = c.base04, bg = c.base01 })
  hi("TabLineSel", { fg = c.base07, bg = c.base02, bold = true })
  hi("TabLineFill", { bg = c.base00 })

  hi("Directory", { fg = c.base0D })
  hi("MatchParen", { fg = c.base0A, bg = c.base02, bold = true })

  hi("DiagnosticError", { fg = c.base08 })
  hi("DiagnosticWarn", { fg = c.base0A })
  hi("DiagnosticInfo", { fg = c.base0D })
  hi("DiagnosticHint", { fg = c.base0C })

  hi("DiagnosticVirtualTextError", { fg = c.base08, bg = c.base01 })
  hi("DiagnosticVirtualTextWarn", { fg = c.base0A, bg = c.base01 })
  hi("DiagnosticVirtualTextInfo", { fg = c.base0D, bg = c.base01 })
  hi("DiagnosticVirtualTextHint", { fg = c.base0C, bg = c.base01 })

  hi("GitSignsAdd", { fg = c.base0B })
  hi("GitSignsChange", { fg = c.base0A })
  hi("GitSignsDelete", { fg = c.base08 })

  hi("TelescopeNormal", { fg = c.base05, bg = c.base01 })
  hi("TelescopeBorder", { fg = c.base03, bg = c.base01 })
  hi("TelescopePromptNormal", { fg = c.base05, bg = c.base02 })
  hi("TelescopePromptBorder", { fg = c.base02, bg = c.base02 })
  hi("TelescopePromptTitle", { fg = c.base00, bg = c.base0B, bold = true })
  hi("TelescopePreviewTitle", { fg = c.base00, bg = c.base0D, bold = true })
  hi("TelescopeResultsTitle", { fg = c.base00, bg = c.base0E, bold = true })
  hi("TelescopeSelection", { fg = c.base07, bg = c.base02 })

  hi("NvimTreeNormal", { fg = c.base05, bg = c.base00 })
  hi("NvimTreeFolderName", { fg = c.base0D })
  hi("NvimTreeOpenedFolderName", { fg = c.base0D, bold = true })
  hi("NvimTreeRootFolder", { fg = c.base0E, bold = true })
  hi("NvimTreeGitDirty", { fg = c.base0A })
  hi("NvimTreeGitNew", { fg = c.base0B })
  hi("NvimTreeGitDeleted", { fg = c.base08 })

  hi("WhichKey", { fg = c.base0E })
  hi("WhichKeyGroup", { fg = c.base0D })
  hi("WhichKeyDesc", { fg = c.base05 })
  hi("WhichKeySeparator", { fg = c.base03 })
  hi("WhichKeyFloat", { bg = c.base01 })
end

return M
