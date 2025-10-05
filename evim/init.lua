vim.o.signcolumn = "yes"
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.spell = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.grepprg = "rg --vimgrep"
vim.o.scrolloff = 2
vim.o.sidescrolloff = 5
vim.o.laststatus = 3
vim.o.winborder = "rounded"
vim.opt.suffixes:remove(".h")

vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.format_on_save = true
vim.g.wordmotion_nomap = 1

vim.keymap.set("i", "jk", "<Esc>", { desc = "Quick Escape" })
vim.keymap.set("n", "<C-s>", "<cmd>update<cr>", { desc = "Quick Save" })
vim.keymap.set("n", "<Esc>", "<cmd>noh<cr>", { desc = "Quick noh" })

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Quick Switch Windows" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Quick Switch Windows" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Quick Switch Windows" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Quick Switch Windows" })

vim.keymap.set("c", "<C-k>", "<Up>", { desc = "Quick Scroll History" })
vim.keymap.set("c", "<C-j>", "<Down>", { desc = "Quick Scroll History" })

vim.keymap.set("n", "<Leader>q", "<cmd>ToggleQf<cr>", { desc = "Toggle Quickfix List" })
vim.keymap.set("n", "<Leader>l", "<cmd>ToggleLoc<cr>", { desc = "Toggle Location List" })

require("user_commands")
require("autocmds")

vim.cmd.cabbr("h", "vert help")
vim.cmd.cabbr("Man", "vert Man")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		"tpope/vim-fugitive",
		"tpope/vim-sleuth",
		"tpope/vim-dispatch",
		"tpope/vim-speeddating",
		"tpope/vim-abolish",
		"tpope/vim-repeat",
		"tpope/vim-unimpaired",
		"tpope/vim-projectionist",
		"tpope/vim-endwise",
		"tpope/vim-eunuch",
		"tpope/vim-obsession",
		"justinmk/vim-sneak",
		"justinmk/vim-dirvish",
		"wellle/targets.vim",
		"junegunn/vim-easy-align",
		"chaoren/vim-wordmotion",

		{
			"saghen/blink.cmp",
			version = "*",
			opts = {
				keymap = {
					["<C-l>"] = { "snippet_forward", "fallback" },
					["<C-h>"] = { "snippet_backward", "fallback" },
				},
				sources = {
					per_filetype = {
						codecompanion = { "codecompanion" },
					},
				},
				completion = { list = { selection = { preselect = false } } },
			},
		},
		{ "saghen/blink.pairs", version = "*", dependencies = { "saghen/blink.download" }, opts = {} },
		{ "saghen/blink.indent", opts = {} },

		{ "nvim-treesitter/nvim-treesitter", branch = "master", build = ":TSUpdate" },
		{ "nvim-treesitter/nvim-treesitter-context", opts = { max_lines = 3 } },
		{ "nvim-treesitter/nvim-treesitter-textobjects" },

		{
			"EdenEast/nightfox.nvim",
			opts = {
				options = {
					-- transparent = true,
					styles = {
						comments = "italic",
						strings = "italic",
						functions = "bold",
					},
				},
			},
			priority = 1000,
		},

		{ "kylechui/nvim-surround", opts = {} },
		{ "nvim-tree/nvim-web-devicons", opts = {} },
		{ "lewis6991/gitsigns.nvim" },
		{ "nvim-lualine/lualine.nvim", opts = {} },
		{ "stevearc/aerial.nvim", opts = {} },
		{ "stevearc/quicker.nvim", opts = {} },
		{ "neovim/nvim-lspconfig" },
		{ "mason-org/mason.nvim", opts = {} },
		{ "ibhagwan/fzf-lua", opts = {} },
		{ "chentoast/marks.nvim", opts = {} },
		{ "olimorris/codecompanion.nvim", opts = {}, dependencies = { "nvim-lua/plenary.nvim" } },
		{ "stevearc/conform.nvim" },
		{ "nvimtools/hydra.nvim" },
		{
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {
				library = {
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
		{
			"kawre/leetcode.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"MunifTanjim/nui.nvim",
			},
			opts = {
				injector = {
					["cpp"] = {
						imports = function()
							return { "#include <bits/stdc++.h>", "using namespace std;" }
						end,
						after = "int main() {}",
					},
				},
			},
		},
		{
			"ggml-org/llama.vim",
			init = function()
				vim.g.llama_config = {
					auto_fim = false,
				}
			end,
		},

		-- "github/copilot.vim",
		-- { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } },
		-- { "OXY2DEV/helpview.nvim", opts = {} },
		-- { "OXY2DEV/markview.nvim", opts = {} },
		-- "axkirillov/unified.nvim"
	},
	install = { colorscheme = { "nightfox", "default" } },
	checker = { enabled = false },
	rocks = { enabled = false },
})

vim.cmd.colorscheme("nightfox")

vim.lsp.enable({ "clangd", "lua_ls" })

require("conform").setup({
	formatters_by_ft = { lua = { "stylua" }, cpp = { "clang-format" }, json = { "prettier" } },
	format_on_save = function()
		return vim.g.format_on_save and {} or nil
	end,
})
vim.keymap.set("n", "grf", function()
	require("conform").format()
end)

vim.keymap.set("n", "<leader><leader>", function()
	require("fzf-lua").global()
end)
vim.keymap.set({ "n", "v", "i" }, "<C-x><C-f>", function()
	require("fzf-lua").complete_path()
end, { silent = true, desc = "Fuzzy complete path" })
require("fzf-lua").register_ui_select()

vim.keymap.set(
	{ "n", "x" },
	"<Leader>cc",
	"<cmd>CodeCompanionChat Toggle<cr>",
	{ silent = true, desc = "Code Companion Chat" }
)
vim.keymap.set({ "n", "x" }, "<Leader>ca", ":CodeCompanion ", { desc = "Code Companion" })
vim.keymap.set({ "n", "v" }, "ga", "<Plug>(EasyAlign)", { desc = "Easy Align" })

-- Treesitter {{{
---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup({
	ensure_installed = { "markdown", "markdown_inline", "comment", "yaml", "html" },
	auto_install = true,
	highlight = { enable = true },
	indent = { enable = true },
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
				["aa"] = "@parameter.outer",
				["ia"] = "@parameter.inner",
			},
			selection_modes = {
				["@function.*"] = "V",
				["@class.*"] = "V",
			},
		},
		move = {
			enable = true,
			goto_next_start = {
				["]m"] = "@function.outer",
				["]f"] = "@function.outer",
				["]]"] = "@class.outer",
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]F"] = "@function.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[f"] = "@function.outer",
				["[["] = "@class.outer",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[f"] = "@function.outer",
				["[]"] = "@class.outer",
			},
		},
	},
})
-- }}}

-- Hydra {{{
local Hydra = require("hydra")
local gitsigns = require("gitsigns")

local hint = [[
 _J_ : next hunk      _s_ : stage/unstage hunk _d_ : show deleted _b_ : blame line
 _K_ : prev hunk      _S_ : stage buffer       _p_ : preview hunk _B_ : blame show full
 _/_ : show base file _q_ : exit
]]
Hydra({
	name = "Git",
	hint = hint,
	config = {
		color = "pink",
		invoke_on_body = true,
		hint = {
			float_opts = {
				border = "rounded",
			},
		},
		on_enter = function()
			vim.cmd("mkview")
			vim.cmd("silent! %foldopen!")
			vim.bo.modifiable = false
			gitsigns.toggle_signs(true)
			gitsigns.toggle_linehl(true)
		end,
		on_exit = function()
			local cursor_pos = vim.api.nvim_win_get_cursor(0)
			vim.cmd("loadview")
			vim.api.nvim_win_set_cursor(0, cursor_pos)
			vim.cmd("normal zv")
			gitsigns.toggle_signs(false)
			gitsigns.toggle_linehl(false)
			gitsigns.toggle_deleted(false)
		end,
	},
	mode = { "n", "x" },
	body = "<leader>hg",
	heads = {
		{
			"J",
			function()
				if vim.wo.diff then
					return "]c"
				end
				vim.schedule(function()
					gitsigns.nav_hunk("next")
				end)
				return "<Ignore>"
			end,
			{ expr = true, desc = "next hunk" },
		},
		{
			"K",
			function()
				if vim.wo.diff then
					return "[c"
				end
				vim.schedule(function()
					gitsigns.nav_hunk("prev")
				end)
				return "<Ignore>"
			end,
			{ expr = true, desc = "prev hunk" },
		},
		{ "s", ":Gitsigns stage_hunk<CR>", { silent = true, desc = "stage hunk" } },
		{ "S", gitsigns.stage_buffer, { desc = "stage buffer" } },
		{ "p", gitsigns.preview_hunk, { desc = "preview hunk" } },
		{ "d", gitsigns.toggle_deleted, { nowait = true, desc = "toggle deleted" } },
		{ "b", gitsigns.blame_line, { desc = "blame" } },
		{
			"B",
			function()
				gitsigns.blame_line({ full = true })
			end,
			{ desc = "blame show full" },
		},
		{ "/", gitsigns.show, { exit = true, desc = "show base file" } },
		{ "q", nil, { exit = true, nowait = true, desc = "exit" } },
	},
})

Hydra({
	name = "Quick words",
	hint = "statusline",
	config = {
		color = "pink",
	},
	mode = { "n", "x", "o" },
	body = "<leader>hw",
	heads = {
		{ "w", "<Plug>(WordMotion_w)" },
		{ "b", "<Plug>(WordMotion_b)" },
		{ "e", "<Plug>(WordMotion_e)" },
		{ "ge", "<Plug>(WordMotion_ge)" },
		{ "iw", "<Plug>(WordMotion_iw)" },
		{ "aw", "<Plug>(WordMotion_aw)" },
		{ "q", nil, { exit = true, mode = "n" } },
	},
})

Hydra({
	name = "Centered Scroll",
	mode = "n",
	body = "<leader>hs",
	hint = "statusline",
	invoke_on_body = true,
	config = {
		color = "pink",
		on_enter = function()
			vim.cmd("mkview")
			vim.o.scrolloff = 100
			vim.o.sidescrolloff = 100
		end,
		on_exit = function()
			local cursor_pos = vim.api.nvim_win_get_cursor(0)
			vim.cmd("loadview")
			vim.api.nvim_win_set_cursor(0, cursor_pos)
		end,
	},
	heads = {
		{ "j", "5j" },
		{ "k", "5k" },
		{ "J", "<C-d>" },
		{ "K", "<C-u>" },
		{ "h", "5zh" },
		{ "l", "5zl" },
		{ "H", "zH" },
		{ "L", "zL" },
		{ "q", nil, { exit = true, desc = "Exit" } },
	},
})

Hydra({
	name = "Window Resize",
	mode = "n",
	body = "<leader>hr",
	hint = "statusline",
	config = {
		color = "pink",
	},
	heads = {
		{ "h", "<cmd>vertical resize -2<cr>", { desc = "Resize Left" } },
		{ "j", "<cmd>resize +2<cr>", { desc = "Resize Down" } },
		{ "k", "<cmd>resize -2<cr>", { desc = "Resize Up" } },
		{ "l", "<cmd>vertical resize +2<cr>", { desc = "Resize Right" } },
		{ "q", nil, { exit = true, desc = "Exit" } },
	},
})

-- }}}

-- Gitsigns {{{
local gitsigns = require("gitsigns")
gitsigns.setup({
	word_diff = true,
	on_attach = function(bufnr)
		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map("n", "]c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "]c", bang = true })
			else
				gitsigns.nav_hunk("next")
			end
		end)

		map("n", "[c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[c", bang = true })
			else
				gitsigns.nav_hunk("prev")
			end
		end)

		-- Actions
		map("n", "<leader>gs", gitsigns.stage_hunk)
		map("n", "<leader>gr", gitsigns.reset_hunk)

		map("v", "<leader>gs", function()
			gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end)
		map("v", "<leader>gr", function()
			gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end)

		map("n", "<leader>gS", gitsigns.stage_buffer)
		map("n", "<leader>gR", gitsigns.reset_buffer)
		map("n", "<leader>gp", gitsigns.preview_hunk)
		map("n", "<leader>gi", gitsigns.preview_hunk_inline)

		map("n", "<leader>gb", function()
			gitsigns.blame_line({ full = true })
		end)

		map("n", "<leader>gd", gitsigns.diffthis)

		map("n", "<leader>gD", function()
			gitsigns.diffthis("~")
		end)

		map("n", "<leader>gQ", function()
			gitsigns.setqflist("all")
		end)
		map("n", "<leader>gq", gitsigns.setqflist)

		-- Text object
		map({ "o", "x" }, "ih", gitsigns.select_hunk)
	end,
	worktrees = {
		{
			toplevel = vim.env.HOME .. "/.config",
			gitdir = vim.env.HOME .. "/.cfg",
		},
	},
})

-- }}}

-- vim: sw=2 ts=2 foldmethod=marker
