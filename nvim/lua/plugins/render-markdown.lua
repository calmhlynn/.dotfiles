-- rustdoc treats a fenced block without an info string as Rust code
vim.treesitter.query.add_predicate("rust-doc-code?", function(match, _, source, pred)
	if type(source) ~= "number" or vim.bo[source].filetype ~= "rust" then
		return false
	end
	local node = (match[pred[2]] or {})[1]
	if not node then
		return false
	end
	for child in node:iter_children() do
		if child:type() == "info_string" then
			return false
		end
	end
	return true
end, { force = true })

vim.treesitter.query.set(
	"markdown",
	"injections",
	[[;; extends
((fenced_code_block
  (code_fence_content) @injection.content) @_block
  (#rust-doc-code? @_block)
  (#set! injection.language "rust"))]]
)

require("render-markdown").setup({
	file_types = { "markdown", "rust" },
	render_modes = { "n", "v", "i", "c" },
	injections = {
		rust = {
			enabled = true,
			query = [[
				((line_comment (doc_comment) @injection.content)
					(#set! injection.combined)
					(#set! injection.language "markdown"))
			]],
		},
	},
	heading = {
		enabled = true,
		render_modes = false,
		atx = true,
		setext = true,
		sign = true,
		icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
		position = "overlay",
		signs = { "󰫎 " },
		width = "full",
		left_margin = 0,
		left_pad = 0,
		right_pad = 0,
		min_width = 0,
		border = false,
		border_virtual = false,
		border_prefix = false,
		above = "▄",
		below = "▀",
		backgrounds = {
			"RenderMarkdownH1Bg",
			"RenderMarkdownH2Bg",
			"RenderMarkdownH3Bg",
			"RenderMarkdownH4Bg",
			"RenderMarkdownH5Bg",
			"RenderMarkdownH6Bg",
		},
		foregrounds = {
			"RenderMarkdownH1",
			"RenderMarkdownH2",
			"RenderMarkdownH3",
			"RenderMarkdownH4",
			"RenderMarkdownH5",
			"RenderMarkdownH6",
		},
		custom = {},
	},

	overrides = {
		filetype = {
			rust = {
				sign = { enabled = false },
				heading = {
					width = "block",
					left_pad = 1,
					right_pad = 1,
					min_width = 40,
				},
				code = {
					width = "block",
					left_pad = 2,
					right_pad = 2,
					min_width = 50,
					sign = false,
				},
			},
		},
	},

	latex = { enabled = false },
	completions = { lsp = { enabled = true } },
})
