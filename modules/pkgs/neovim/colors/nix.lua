-- Based on vimjoyer's theme: https://github.com/Goxore/nixconf/blob/a33777adcce4a55ce5d3d74c67695059e19a8f76/modules/wrappedPrograms/neovim/colors/gxvjbox.lua

local COLORSCHEME = require("colorscheme")

local highlights = {
	Bold = { style = "bold" },
	ColorColumn = { bg = COLORSCHEME.base01 },
	Conceal = { fg = COLORSCHEME.base0D, bg = COLORSCHEME.base00 },
	Cursor = { fg = COLORSCHEME.base00, bg = COLORSCHEME.base05 },
	CursorColumn = { bg = COLORSCHEME.base01 },
	CursorLine = { bg = COLORSCHEME.base02 },
	CursorLineNr = { fg = COLORSCHEME.base05, bg = COLORSCHEME.base02 },
	Debug = { fg = COLORSCHEME.base08 },
	Directory = { fg = COLORSCHEME.base0D },
	Error = { fg = COLORSCHEME.base00, bg = COLORSCHEME.base08 },
	ErrorMsg = { fg = COLORSCHEME.base08, bg = COLORSCHEME.base00 },
	Exception = { fg = COLORSCHEME.base08 },
	FoldColumn = { fg = COLORSCHEME.base0C, bg = COLORSCHEME.base01 },
	Folded = { fg = COLORSCHEME.base03, bg = COLORSCHEME.base01 },
	IncSearch = { fg = COLORSCHEME.base01, bg = COLORSCHEME.base09 },
	Italic = { style = "italic" },
	LineNr = { fg = COLORSCHEME.base03, bg = COLORSCHEME.base00 },
	Macro = { fg = COLORSCHEME.base09 },
	MatchParen = { bg = COLORSCHEME.base03 },
	ModeMsg = { fg = COLORSCHEME.base0B },
	MoreMsg = { fg = COLORSCHEME.base0B },
	NonText = { fg = COLORSCHEME.base03 },
	Normal = { fg = COLORSCHEME.base06, bg = COLORSCHEME.base00 },
	PMenu = { fg = COLORSCHEME.base05, bg = COLORSCHEME.base01 },
	PMenuSel = { bg = COLORSCHEME.base00, style = "none" },
	Question = { fg = COLORSCHEME.base0D },
	QuickFixLine = { bg = COLORSCHEME.base01 },
	Search = { fg = COLORSCHEME.base01, bg = COLORSCHEME.base0A },
	SignColumn = { fg = COLORSCHEME.base03, bg = COLORSCHEME.base00 },
	SpecialKey = { fg = COLORSCHEME.base03 },
	StatusLine = { fg = COLORSCHEME.base04, bg = COLORSCHEME.base02 },
	StatusLineNC = { fg = COLORSCHEME.base03, bg = COLORSCHEME.base01 },
	Substitute = { fg = COLORSCHEME.base01, bg = COLORSCHEME.base0A },
	TabLine = { fg = COLORSCHEME.base03, bg = COLORSCHEME.base01 },
	TabLineFill = { fg = COLORSCHEME.base03, bg = COLORSCHEME.base01 },
	TabLineSel = { fg = COLORSCHEME.base0B, bg = COLORSCHEME.base01 },
	Title = { fg = COLORSCHEME.base0D },
	TooLong = { fg = COLORSCHEME.base08 },
	Underlined = { fg = COLORSCHEME.base08 },
	VertSplit = { fg = COLORSCHEME.base02, bg = COLORSCHEME.base02 },
	Visual = { bg = COLORSCHEME.base02 },
	VisualNOS = { fg = COLORSCHEME.base08 },
	WarningMsg = { fg = COLORSCHEME.base08 },
	WildMenu = { fg = COLORSCHEME.base08, bg = COLORSCHEME.base0A },
	DiagnosticError = { fg = COLORSCHEME.base08 },
	DiagnosticHint = { fg = COLORSCHEME.base0A },
	DiagnosticInfo = { fg = COLORSCHEME.base0A },
	DiagnosticWarn = { fg = COLORSCHEME.base09 },
	NormalFloat = { bg = COLORSCHEME.base00 },

	-- Syntax
	Boolean = { fg = COLORSCHEME.base0E },
	Character = { fg = COLORSCHEME.base0E },
	Comment = { fg = COLORSCHEME.base04 },
	Conditional = { fg = COLORSCHEME.base08 },
	Constant = { fg = COLORSCHEME.base0E },
	Define = { fg = COLORSCHEME.base0C },
	Delimiter = { fg = COLORSCHEME.base09 },
	Float = { fg = COLORSCHEME.base0E },
	Function = { fg = COLORSCHEME.base0B },
	Identifier = { fg = COLORSCHEME.base0D },
	Include = { fg = COLORSCHEME.base0C },
	Keyword = { fg = COLORSCHEME.base08 },
	Label = { fg = COLORSCHEME.base08 },
	Number = { fg = COLORSCHEME.base0E },
	Operator = { fg = COLORSCHEME.base09 },
	PreProc = { fg = COLORSCHEME.base0C },
	Repeat = { fg = COLORSCHEME.base08 },
	Special = { fg = COLORSCHEME.base09 },
	SpecialChar = { fg = COLORSCHEME.base08 },
	Statement = { fg = COLORSCHEME.base08 },
	StorageClass = { fg = COLORSCHEME.base09 },
	String = { fg = COLORSCHEME.base0B, style = "italic" },
	Structure = { fg = COLORSCHEME.base0C },
	Tag = { fg = COLORSCHEME.base09 },
	Todo = { fg = COLORSCHEME.base0A, bg = COLORSCHEME.base01 },
	Type = { fg = COLORSCHEME.base0A },
	Typedef = { fg = COLORSCHEME.base0A },

	-- Diff
	DiffAdd = { fg = COLORSCHEME.base0B, bg = COLORSCHEME.base01 },
	DiffChange = { fg = COLORSCHEME.base03, bg = COLORSCHEME.base01 },
	DiffDelete = { fg = COLORSCHEME.base08, bg = COLORSCHEME.base01 },
	DiffText = { fg = COLORSCHEME.base0D, bg = COLORSCHEME.base01 },

	-- Plugin-specific
	AlphaButtons = { fg = COLORSCHEME.base0B },
	AlphaHeader = { fg = COLORSCHEME.base0A },
	BionicReadingHL = { fg = COLORSCHEME.base0D },
	FloatBorder = { fg = COLORSCHEME.base0D, bg = COLORSCHEME.base00 },
	GitSignsAdd = { fg = COLORSCHEME.base0B },
	GitSignsChange = { fg = COLORSCHEME.base0D },
	GitSignsDelete = { fg = COLORSCHEME.base08 },
	LspSagaCodeActionBorder = { fg = COLORSCHEME.base0E },
	LspSagaCodeActionContent = { fg = COLORSCHEME.base0D },
	LspSagaHoverBorder = { fg = COLORSCHEME.base0A },
	LspSagaLightBulb = { fg = COLORSCHEME.base06 },
	LspSagaRenameBorder = { fg = COLORSCHEME.base0E },
	LspSagaSignatureHelpBorder = { fg = COLORSCHEME.base0A },
	NvimTreeImageFile = { fg = COLORSCHEME.base0A },
	NvimTreeSpecialFile = { fg = COLORSCHEME.base08 },
	TelescopeBorder = { fg = COLORSCHEME.base08 },
	TelescopeMatching = { fg = COLORSCHEME.base09, style = "bold" },
	TelescopePreviewBorder = { fg = COLORSCHEME.base0C },
	TelescopePromptBorder = { fg = COLORSCHEME.base0C },
	TelescopePromptPrefix = { fg = COLORSCHEME.base0B },
	TelescopeResultsBorder = { fg = COLORSCHEME.base0C },

	["@vjv_embed"] = { bg = "#181818" },
	["@type"] = { fg = COLORSCHEME.base0C, style = "bold" },
	["@variable"] = { fg = COLORSCHEME.base0D },
	["@variable.parameter"] = { fg = COLORSCHEME.base0D, style = "bold" },
	["@tag"] = { fg = COLORSCHEME.base08 },
	["@tag.delimiter"] = { fg = COLORSCHEME.base08 },
	["@function"] = { fg = COLORSCHEME.green, style = "italic,bold" },
	["@text"] = { fg = COLORSCHEME.base06 },
	["@none"] = { fg = COLORSCHEME.base06 },
	["@punctuation"] = { fg = COLORSCHEME.base09 },
	["@lsp.type.class"] = { fg = COLORSCHEME.base0C },
	["@lsp.mod.annotation"] = { fg = COLORSCHEME.base09 },

	["@lsp.type.enum"] = { link = "@type" },
	["@lsp.type.interface"] = { link = "@type" },
	["@lsp.type.namespace"] = { link = "@namespace" },
	["@lsp.type.parameter"] = { link = "@variable.parameter" },
	["@lsp.type.property"] = { link = "@property" },
	["@lsp.type.variable"] = { link = "@variable" },

	["@markup.heading.1.markdown"] = { fg = COLORSCHEME.base08 },
	["@markup.heading.2.markdown"] = { fg = COLORSCHEME.base0A },
	["@markup.heading.3.markdown"] = { fg = COLORSCHEME.base0B },
	["@markup.heading.4.markdown"] = { fg = COLORSCHEME.base0C },
	["@markup.heading.5.markdown"] = { fg = COLORSCHEME.base0D },
	["@markup.heading.6.markdown"] = { fg = COLORSCHEME.base0E },

	["@function.latex"] = { fg = COLORSCHEME.base0B },
}

local lualine_theme = {
	normal = {
		a = { bg = COLORSCHEME.base0D, fg = COLORSCHEME.base00, gui = "bold" },
		b = { bg = COLORSCHEME.base04, fg = COLORSCHEME.base06 },
		c = { bg = COLORSCHEME.base04, fg = COLORSCHEME.base06 },
	},
	insert = {
		a = { bg = COLORSCHEME.green, fg = COLORSCHEME.base00, gui = "bold" },
		b = { bg = COLORSCHEME.base04, fg = COLORSCHEME.base06 },
		c = { bg = COLORSCHEME.base04, fg = COLORSCHEME.base06 },
	},
	visual = {
		a = { bg = COLORSCHEME.base0A, fg = COLORSCHEME.base00, gui = "bold" },
		b = { bg = COLORSCHEME.base04, fg = COLORSCHEME.base06 },
		c = { bg = COLORSCHEME.base04, fg = COLORSCHEME.base06 },
	},
	replace = {
		a = { bg = COLORSCHEME.base08, fg = COLORSCHEME.base00, gui = "bold" },
		b = { bg = COLORSCHEME.base04, fg = COLORSCHEME.base06 },
		c = { bg = COLORSCHEME.base00, fg = COLORSCHEME.base06 },
	},
	command = {
		a = { bg = COLORSCHEME.base0E, fg = COLORSCHEME.base00, gui = "bold" },
		b = { bg = COLORSCHEME.base04, fg = COLORSCHEME.base06 },
		c = { bg = COLORSCHEME.base04, fg = COLORSCHEME.base06 },
	},
	inactive = {
		a = { bg = COLORSCHEME.base00, fg = COLORSCHEME.base03, gui = "bold" },
		b = { bg = COLORSCHEME.base00, fg = COLORSCHEME.base03 },
		c = { bg = COLORSCHEME.base00, fg = COLORSCHEME.base03 },
	},
}

local function apply_highlights()
	vim.cmd("hi clear")
	if vim.fn.exists("syntax_on") == 1 then
		vim.cmd("syntax reset")
	end
	vim.o.termguicolors = true
	vim.g.colors_name = "vjbox"

	for group, settings in pairs(highlights) do
		local command = "highlight " .. group
		if settings.link then
			command = "highlight!" .. " link " .. group .. " " .. settings.link
		else
			if settings.fg then
				command = command .. " guifg=" .. settings.fg
			end
			if settings.bg then
				command = command .. " guibg=" .. settings.bg
			end
			if settings.style then
				command = command .. " gui=" .. settings.style
			end
			if settings.guisp then
				command = command .. " guisp=" .. settings.guisp
			end
		end
		vim.cmd(command)
	end

	-- Terminal colors
	vim.g.terminal_color_0 = COLORSCHEME.base00
	vim.g.terminal_color_1 = COLORSCHEME.base08
	vim.g.terminal_color_2 = COLORSCHEME.base0B
	vim.g.terminal_color_3 = COLORSCHEME.base0A
	vim.g.terminal_color_4 = COLORSCHEME.base0D
	vim.g.terminal_color_5 = COLORSCHEME.base0E
	vim.g.terminal_color_6 = COLORSCHEME.base0C
	vim.g.terminal_color_7 = COLORSCHEME.base05
	vim.g.terminal_color_8 = COLORSCHEME.base03
	vim.g.terminal_color_9 = COLORSCHEME.base08
	vim.g.terminal_color_10 = COLORSCHEME.base0B
	vim.g.terminal_color_11 = COLORSCHEME.base0A
	vim.g.terminal_color_12 = COLORSCHEME.base0D
	vim.g.terminal_color_13 = COLORSCHEME.base0E
	vim.g.terminal_color_14 = COLORSCHEME.base0C
	vim.g.terminal_color_15 = COLORSCHEME.base07
	vim.g.terminal_color_background = COLORSCHEME.base00
	vim.g.terminal_color_foreground = COLORSCHEME.base05
end

apply_highlights()

-- Additional config
vim.cmd([[
    set fillchars=fold:\ ,vert:\│,eob:\ ,msgsep:‾,diff:╱
]])
