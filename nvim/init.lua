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

vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.format_on_save = true

vim.keymap.set("i", "jk", "<Esc>", { desc = "Quick Escape" })
vim.keymap.set("n", "<C-s>", "<cmd>update<cr>", { desc = "Quick Save" })

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Switch Windows" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Switch Windows" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Switch Windows" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Switch Windows" })
vim.keymap.set("n", "<Esc>", "<cmd>noh<cr>", { desc = "Switch Windows" })

vim.keymap.set("c", "<C-k>", "<Up>", { desc = "Scroll History" })
vim.keymap.set("c", "<C-j>", "<Down>", { desc = "Scroll History" })

vim.api.nvim_create_user_command("ConfigEdit", "e $MYVIMRC", { desc = "Edit Config" })
vim.api.nvim_create_user_command("SwapWords", function(opts)
	if #opts.fargs ~= 2 then
		print("Usage SwapWords <word1> <word2>")
		return
	end
	local word1 = vim.fn.escape(opts.fargs[1], [[\/]])
	local word2 = vim.fn.escape(opts.fargs[2], [[\/]])
	vim.cmd(
		string.format(
			[[:%d,%ds/\<%s\>\|\<%s\>/\={'%s':'%s','%s':'%s'}[submatch(0)]/g]],
			opts.line1,
			opts.line2,
			word1,
			word2,
			word1,
			word2,
			word2,
			word1
		)
	)
end, { nargs = "*", range = true, desc = "Swap Two Words" })

vim.api.nvim_create_autocmd("BufRead", {
	callback = function(opts)
		vim.api.nvim_create_autocmd("BufWinEnter", {
			once = true,
			buffer = opts.buf,
			callback = function()
				local ft = vim.bo[opts.buf].filetype
				local last_known_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
				if
					not (ft:match("commit") and ft:match("rebase"))
					and last_known_line > 1
					and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
				then
					vim.api.nvim_feedkeys([[g`"]], "nx", false)
				end
			end,
		})
	end,
	desc = "Restore Cursor Position",
})
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.hl.on_yank()
	end,
	desc = "Highlight on Yank",
})

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

		{
			"saghen/blink.cmp",
			version = "*",
			opts = {
				keymap = {
					["<C-l>"] = { "snippet_forward", "fallback" },
					["<C-h>"] = { "snippet_backward", "fallback" },
				},
			},
		},
		{ "saghen/blink.pairs", version = "*", dependencies = { "saghen/blink.download" }, opts = {} },
		{ "saghen/blink.indent", opts = {} },

		{ "nvim-treesitter/nvim-treesitter", branch = "master", build = ":TSUpdate" },
		{ "nvim-treesitter/nvim-treesitter-context", opts = {} },
		{ "nvim-treesitter/nvim-treesitter-textobjects" },

		{ "kylechui/nvim-surround", opts = {} },
		{ "nvim-tree/nvim-web-devicons", opts = {} },
		{ "lewis6991/gitsigns.nvim", opts = {} },
		{ "nvim-lualine/lualine.nvim", opts = {} },
		{ "EdenEast/nightfox.nvim", opts = { options = { transparent = true } }, priority = 1000 },
		{ "neovim/nvim-lspconfig" },
		{ "mason-org/mason.nvim", opts = {} },
		{ "ibhagwan/fzf-lua", opts = {} },
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
			"stevearc/conform.nvim",
			opts = {
				formatters_by_ft = { lua = { "stylua" }, cpp = { "clang-format" }, json = { "prettier" } },
				format_on_save = function()
					return vim.g.format_on_save and {} or nil
				end,
			},
		},
		{ "stevearc/aerial.nvim", opts = {} },
		{
			"olimorris/codecompanion.nvim",
			opts = {},
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-treesitter/nvim-treesitter",
				"github/copilot.vim",
			},
			enabled = false,
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
	},
	install = { colorscheme = { "nightfox", "default" } },
	checker = { enabled = false },
	rocks = { enabled = false },
})

vim.cmd.colorscheme("nightfox")

vim.lsp.enable({ "clangd", "lua_ls" })

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
				["]]"] = "@class.outer",
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[["] = "@class.outer",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[]"] = "@class.outer",
			},
		},
	},
})

vim.g.projectionist_heuristics = {
	["CMakeLists.txt|Makefile"] = {
		["*"] = {
			make = "make -C build",
			dispatch = "make -C build && make -C build test",
		},
		["*.h"] = {
			type = "header",
			template = { "#pragma once" },
		},
		["*.cpp"] = {
			type = "source",
			template = { '#include "{}.h"' },
		},
		["*-test.cpp"] = {
			type = "test",
			template = { '#include "{}.h"' },
		},
	},
}

-- vim: sw=2 ts=2
