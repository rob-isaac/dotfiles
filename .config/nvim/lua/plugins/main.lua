local map = require("utils").map

return {
  {
    "sainnhe/gruvbox-material",
    priority = 10000,
    config = function()
      vim.cmd.colorscheme([[gruvbox-material]])
    end,
  },
  { "max397574/better-escape.nvim", opts = {} },
  {
    "mrjones2014/smart-splits.nvim",
    dependencies = { { "kwkarlwang/bufresize.nvim", config = true } },
    config = function()
      local ss = require("smart-splits")
      ss.setup({
        resize_mode = {
          hooks = {
            on_leave = require("bufresize").register,
          },
        },
      })
      vim.keymap.set("n", "<A-h>", ss.resize_left)
      vim.keymap.set("n", "<A-j>", ss.resize_down)
      vim.keymap.set("n", "<A-k>", ss.resize_up)
      vim.keymap.set("n", "<A-l>", ss.resize_right)
      vim.keymap.set("n", "<C-h>", ss.move_cursor_left)
      vim.keymap.set("n", "<C-j>", ss.move_cursor_down)
      vim.keymap.set("n", "<C-k>", ss.move_cursor_up)
      vim.keymap.set("n", "<C-l>", ss.move_cursor_right)
      vim.keymap.set("n", "<leader><C-h>", ss.swap_buf_left)
      vim.keymap.set("n", "<leader><C-j>", ss.swap_buf_down)
      vim.keymap.set("n", "<leader><C-k>", ss.swap_buf_up)
      vim.keymap.set("n", "<leader><C-l>", ss.swap_buf_right)
    end,
  },
  {
    "echasnovski/mini.nvim",
    config = function()
      require("mini.align").setup()
      require("mini.basics").setup()
      require("mini.bracketed").setup()
      require("mini.bufremove").setup()
      require("mini.comment").setup()
      require("mini.cursorword").setup()
      require("mini.indentscope").setup()
      require("mini.map").setup()
      require("mini.pairs").setup({
        mappings = {
          ["<"] = { action = "open", pair = "<>", neigh_pattern = "[%a%d].", register = { cr = false } },
          [">"] = { action = "close", pair = "<>", register = { cr = false } },
        },
      })
      require("mini.starter").setup()
      require("mini.trailspace").setup()

      map("n", "<leader>bd", MiniBufremove.delete)
      map("i", "<S-CR>", "v:lua.MiniPairs.cr()", { noremap = true, expr = true, desc = "MiniPairs <CR>" })
      map("i", "<S-BS>", "v:lua.MiniPairs.bs()", { noremap = true, expr = true, desc = "MiniPairs <BS>" })
    end,
  },
  {
    "folke/noice.nvim",
    config = function()
      require("noice").setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = true,
          lsp_doc_border = true,
        },
      })
      vim.keymap.set({ "n", "i", "s" }, "<c-f>", function()
        if not require("noice.lsp").scroll(4) then
          return "<c-f>"
        end
      end, { silent = true, expr = true })

      vim.keymap.set({ "n", "i", "s" }, "<c-b>", function()
        if not require("noice.lsp").scroll(-4) then
          return "<c-b>"
        end
      end, { silent = true, expr = true })
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
      { "smjonas/inc-rename.nvim", opts = {} },
    },
  },
  "goerz/jupytext.vim",
  "lervag/vimtex",
  { "dhruvasagar/vim-table-mode", ft = { "markdown", "org", "norg" } },
  {
    "skywind3000/asyncrun.vim",
    init = function()
      vim.g["asyncrun_open"] = 8
      vim.cmd([[
        command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>
      ]])
    end,
  },
  "tpope/vim-fugitive",
  "tpope/vim-abolish",
  {
    "segeljakt/vim-silicon",
    init = function()
      vim.g.silicon = {
        theme = "gruvbox-dark",
        font = "JetBrainsMono Nerd Font",
        ["pad-vert"] = 0,
        ["pad-horiz"] = 0,
        ["line-number"] = false,
        ["round-corner"] = false,
        ["window-controls"] = false,
      }
    end,
  },
  {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup()
      require("which-key").register({
        ["<leader>"] = {
          f = { name = "+[F]ind..." },
          g = { name = "+[G]it" },
        },
      })
    end,
  },
  {
    "folke/todo-comments.nvim",
    opts = {
      highlight = {
        before = "",
        keyword = "bg",
        after = "",
        pattern = [[.*<(KEYWORDS).*:]], -- vim regex
      },
      search = {
        pattern = [[\b(KEYWORDS).*:]], -- ripgrep regex
      },
    },
  },
  {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup()
      map("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { desc = "Trouble Toggle" })
      map("n", "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", { desc = "Trouble Toggle (Workspace)" })
    end,
  },
  { "kevinhwang91/nvim-bqf", opts = {} },
  { "lukas-reineke/headlines.nvim", opts = {}, ft = { "markdown", "org", "norg" } },
  { "SmiteshP/nvim-navbuddy", opts = { lsp = { auto_attach = true } } },
  { "pwntester/octo.nvim", config = true, cmd = { "Octo" } },
  { "danymat/neogen", config = true },
  {
    "karb94/neoscroll.nvim",
    opts = { mappings = { "<C-u>", "<C-d>", "<C-y>", "<C-e>", "zt", "zz", "zb" } },
  },
  { "chentoast/marks.nvim", config = true },
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup({
        open_mapping = [[<C-\>]],
        direction = "float",
      })
      local Terminal = require("toggleterm.terminal").Terminal
      local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })
      map("n", "<leader>gg", function()
        lazygit:toggle()
      end, { desc = "Lazygit" })

      -- TODO(Rob): should avoid closing on exit and instead reuse the terminal
      local function xplr_term(dir)
        local prev_win = vim.api.nvim_get_current_win()
        local tmpname = os.tmpname()
        Terminal:new({
          cmd = "xplr " .. dir .. "> " .. tmpname,
          hidden = true,
          on_exit = function()
            vim.api.nvim_set_current_win(prev_win)
            for line in io.lines(tmpname) do
              vim.cmd("edit " .. line)
            end
            os.remove(tmpname)
          end,
        }):open()
      end

      map("n", "<leader>e", function()
        xplr_term(".")
      end, { desc = "File [E]xplorer" })

      map("n", "<leader>E", function()
        xplr_term(vim.fn.expand("%:p:h"))
      end, { desc = "File [E]xplorer (Buffer Path)" })
    end,
  },
  { "sindrets/diffview.nvim", config = true },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "SmiteshP/nvim-navic" },
    config = function()
      require("lualine").setup({
        options = {
          globalstatus = true,
        },
        sections = {
          lualine_c = {
            "navic",
            color_correction = nil,
            navic_opts = nil,
          },
        },
      })
    end,
  },
  {
    "akinsho/bufferline.nvim",
    config = function()
      require("bufferline").setup()
      map("n", "H", "<cmd>BufferLineCyclePrev<cr>", {})
      map("n", "L", "<cmd>BufferLineCycleNext<cr>", {})
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      on_attach = function()
        local gs = package.loaded.gitsigns
        map("n", "]h", function()
          if vim.wo.diff then
            return "]h"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, { expr = true })

        map("n", "[h", function()
          if vim.wo.diff then
            return "[h"
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end, { expr = true })
      end,
    },
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      -- don't use S b/c need it for leap.nvim
      require("nvim-surround").setup({
        keymaps = { visual = "Y", visual_line = "gY" },
      })
    end,
  },
  {
    "ggandor/flit.nvim",
    dependencies = { "ggandor/leap.nvim", "tpope/vim-repeat" },
    config = function()
      require("leap").setup({})
      require("leap").add_default_mappings()
      vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })
      require("flit").setup({})
    end,
  },
  {
    "rmagatti/auto-session",
    config = function()
      require("auto-session").setup({
        log_level = vim.log.levels.ERROR,
        auto_session_suppress_dirs = { "~/Projects", "~/Downloads", "/" },
        auto_session_use_git_branch = false,
        auto_session_enable_last_session = vim.loop.cwd() == vim.loop.os_homedir(),
        session_lens = {
          load_on_setup = true,
          theme_conf = { border = true },
          previewer = false,
        },
      })
      map(
        "n",
        "<leader>fp",
        require("auto-session.session-lens").search_session,
        { desc = "[F]ind [P]roject (Session)" }
      )
    end,
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
  -- { "mg979/vim-visual-multi", branch = "master" },
  -- { "kevinhwang91/nvim-ufo" },
  -- { "AckslD/muren.nvim" },
  -- { "mg979/vim-visual-multi" },
  -- { "nvim-pack/nvim-spectre" },
  -- { "chipsenkbeil/distant.nvim" },
  -- { "mrjones2014/legendary.nvim" },
  -- { "Konfekt/FastFold" }
  -- { "mbbill/undotree" }
  -- { "miversen33/netman.nvim" }
  -- { "folke/edgy.nvim" }
  -- { "folke/flash.nvim" }
  -- { "rafamadriz/friendly-snippets" }
  -- { "gbprod/yanky.nvim" }
  -- { "justinmk/vim-dirvish" }
  -- { "jbyuki/instant.nvim" }
  -- Look at other plugins included in lazyvim
  -- Setup DAP stuff
  -- Notes for remote dev:
  --   On remote machine: nvim --headless --listen 0.0.0.0:6666
  --   On local machine: neovide --remote-tcp=<host name>:6666
  --                     or
  --                     nvim --server <host name>:6666 --remote-ui
}
