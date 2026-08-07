vim.treesitter.query.set(
	"rust",
	"highlights",
	[[;; extends
((line_comment (doc_comment) @comment.documentation)
  (#set! priority 200))

((block_comment (doc_comment) @comment.documentation)
  (#set! priority 200))]]
)

vim.treesitter.query.set(
	"markdown",
	"highlights",
	[[;; extends
((atx_heading (atx_h1_marker)) @markup.heading.1 (#set! priority 250))
((atx_heading (atx_h2_marker)) @markup.heading.2 (#set! priority 250))
((atx_heading (atx_h3_marker)) @markup.heading.3 (#set! priority 250))
((atx_heading (atx_h4_marker)) @markup.heading.4 (#set! priority 250))
((atx_heading (atx_h5_marker)) @markup.heading.5 (#set! priority 250))
((atx_heading (atx_h6_marker)) @markup.heading.6 (#set! priority 250))
((info_string) @label (#set! priority 250))]]
)

vim.treesitter.query.set(
	"markdown_inline",
	"highlights",
	[[;; extends
((code_span) @markup.raw (#set! priority 250))
((emphasis) @markup.italic (#set! priority 250))
((strong_emphasis) @markup.strong (#set! priority 250))
((strikethrough) @markup.strikethrough (#set! priority 250))

([
  (link_label)
  (link_text)
  (link_title)
  (image_description)
] @markup.link.label
  (#set! priority 250))]]
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
