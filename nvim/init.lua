-- lazy.nvim インストール
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- 基本設定
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.updatetime = 250
vim.opt.cursorline = true
vim.g.mapleader = " "

require("lazy").setup({
  -- カラースキーム
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      vim.cmd("colorscheme tokyonight")
    end,
  },

  -- ファイルツリー（サイドバー）
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "ファイルツリー" },
    },
    config = function()
      require("neo-tree").setup({
        window = { width = 30 },
      })
    end,
  },

  -- ファイル検索・文字列検索
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "ファイル検索" },
      { "<C-S-f>", "<cmd>Telescope live_grep<cr>", desc = "文字列検索" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>" },
      { "<leader>fr", "<cmd>Telescope lsp_references<cr>" },
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>" },
    },
  },

  -- タブライン（バッファをタブ表示）
  {
    "akinsho/bufferline.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          diagnostics = "nvim_lsp",
          offsets = {{ filetype = "neo-tree", text = "Explorer", padding = 1 }},
        },
      })
    end,
  },

  -- ステータスライン
  {
    "nvim-lualine/lualine.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("lualine").setup({
        options = { theme = "tokyonight" },
      })
    end,
  },

  -- mason（LSPインストーラー）
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "rust_analyzer", "pyright", "lua_ls" }
      })
    end
  },

  -- 補完
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind.nvim",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        },
        formatting = {
          format = lspkind.cmp_format({ mode = "symbol_text" }),
        },
      })
    end
  },

  -- シンタックスハイライト
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      -- Neovim 0.11+ ではビルトインのtreesitter設定を使う
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "rust", "python", "java", "lua", "toml", "json" },
        callback = function()
          pcall(vim.treesitter.start)
        end
      })
    end
  },

  -- Git表示
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end
  },

  -- ターミナル
  {
    "akinsho/toggleterm.nvim",
    keys = {
      { "<C-`>", "<cmd>ToggleTerm<cr>", desc = "ターミナル" },
      { "<leader>t", "<cmd>ToggleTerm<cr>", desc = "ターミナル" },
    },
    config = function()
      require("toggleterm").setup({
        direction = "horizontal",
        size = 15,
      })
    end
  },

  -- インデントガイド
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup()
    end
  },

  -- 括弧自動閉じ
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },

  -- コメントトグル
  {
    "numToStr/Comment.nvim",
    keys = {
      { "<C-/>", "<cmd>lua require('Comment.api').toggle.linewise.current()<cr>", desc = "コメント" },
      { "<C-/>", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", mode = "v" },
    },
    config = true,
  },

  -- which-key（キーバインドヘルプ）
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup()
    end
  },
})

-- LSP設定（Neovim 0.11+ の新しいAPI）
local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config.rust_analyzer = {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", ".git" },
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = { command = "clippy" },
      cargo = { allFeatures = true },
    }
  }
}

vim.lsp.config.pyright = {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "setup.py", ".git" },
  capabilities = capabilities,
}

vim.lsp.config.lua_ls = {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".git" },
  capabilities = capabilities,
}

vim.lsp.enable({ "rust_analyzer", "pyright", "lua_ls" })

-- LSPキーマップ
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local opts = { buffer = args.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>f", function()
      vim.lsp.buf.format({ async = true })
    end, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
  end
})

-- バッファ操作キーマップ
vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>")
vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>")
vim.keymap.set("n", "<leader>x", "<cmd>bdelete<cr>")

-- 保存
vim.keymap.set("n", "<C-s>", "<cmd>w<cr>")
vim.keymap.set("i", "<C-s>", "<esc><cmd>w<cr>")