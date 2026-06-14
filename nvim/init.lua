-- luarocks パスを追加（image.nvim の magick 用）
package.path = package.path
  .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua"
  .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua"
package.cpath = package.cpath
  .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/lib/lua/5.1/?.so"

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
      require("tokyonight").setup({
        transparent = false,
        styles = {
          sidebars = "dark",
          floats = "dark",
        },
      })
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
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "ファイルツリーを開閉" },
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
      { "<C-f>", "<cmd>Telescope find_files<cr>", desc = "ファイル検索" },
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
          { name = "crates" },
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
        pattern = { "rust", "python", "java", "lua", "toml", "json", "markdown", "mermaid", "html", "css" },
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

  -- Rust拡張機能
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    ft = { "rust" },
    config = function()
      vim.g.rustaceanvim = {
        server = {
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = {
                command = "clippy",
              },
              cargo = {
                allFeatures = true,
              },
            },
          },
        },
      }
    end,
  },

  -- Cargo.toml依存関係管理
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    config = function()
      require("crates").setup({
        completion = {
          cmp = {
            enabled = true,
          },
        },
      })
    end,
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

  -- Markdownプレビュー（ブラウザ表示、Mermaid対応）
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown", "mermaid" },
    build = function() vim.fn["mkdp#util#install"]() end,
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdownプレビュー", ft = "markdown" },
    },
    config = function()
      vim.g.mkdp_auto_close = 0
      vim.g.mkdp_theme = "dark"
      vim.g.mkdp_filetypes = { "markdown", "mermaid" }
      vim.g.mkdp_preview_options = {
        mkit = {},
        katex = {},
        uml = {},
        maid = {},  -- Mermaid対応
        disable_sync_scroll = 0,
        sync_scroll_type = "middle",
        hide_yaml_meta = 1,
        sequence_diagrams = {},
        flowchart_diagrams = {},
        content_editable = false,
        disable_filename = 0,
        toc = {}
      }
    end,
  },

  -- 画像インライン表示（Kitty Graphics Protocol）
  {
    "3rd/image.nvim",
    build = false,
    opts = {
      backend = "kitty",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "vimwiki" },
        },
      },
      max_width = 100,
      max_height = 12,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    },
  },

  -- NeoVim内でのMarkdownレンダリング
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "mermaid" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>mr", "<cmd>RenderMarkdown toggle<cr>", desc = "Markdownレンダリング", ft = "markdown" },
    },
    config = function()
      require("render-markdown").setup({
        heading = {
          enabled = true,
          sign = true,
          icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
          backgrounds = { "RenderMarkdownH1Bg", "RenderMarkdownH2Bg", "RenderMarkdownH3Bg", "RenderMarkdownH4Bg", "RenderMarkdownH5Bg", "RenderMarkdownH6Bg" },
          foregrounds = { "RenderMarkdownH1", "RenderMarkdownH2", "RenderMarkdownH3", "RenderMarkdownH4", "RenderMarkdownH5", "RenderMarkdownH6" },
        },
        code = {
          enabled = true,
          sign = false,
          style = "full",
          left_pad = 2,
          right_pad = 2,
        },
        bullet = {
          enabled = true,
          icons = { "●", "○", "◆", "◇" },
        },
      })
    end,
  },
})

-- LSP設定（Neovim 0.11+ の新しいAPI）
-- 注: rust_analyzerはrustaceanvimプラグインで管理されます
local capabilities = require("cmp_nvim_lsp").default_capabilities()

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

vim.lsp.enable({ "pyright", "lua_ls" })

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

-- Markdown固有の設定
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    -- 折りたたみ設定
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
    vim.opt_local.foldenable = false  -- デフォルトでは折りたたまない

    -- テキスト幅とラップ設定
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true

    -- Markdownリンクを簡単にコンシールする
    vim.opt_local.conceallevel = 2
    vim.opt_local.concealcursor = ""

    -- インデント設定
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true

    -- スペルチェック（オプション、英語のみ）
    -- vim.opt_local.spell = true
    -- vim.opt_local.spelllang = "en"
  end
})

-- .mermaidファイルをMarkdownとして認識
vim.filetype.add({
  extension = {
    mmd = "mermaid",
  },
  pattern = {
    [".*%.mermaid"] = "mermaid",
  },
})