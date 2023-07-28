-- Install lazy.nvim (plugin manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Install plugins
require("lazy").setup({
  -- Color scheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function(plugin)
      vim.cmd.colorscheme "catppuccin-macchiato"
    end
  },

  -- VSCode-like language server
  {
    "neoclide/coc.nvim",
    branch = "release",
    init = function()
      vim.g.coc_global_extensions = {
        "coc-pyright", 
        "coc-clangd", 
        "coc-tsserver", 
        "@yaegassy/coc-volar", 
        "coc-svelte",
        "@yaegassy/coc-tailwindcss3",
        "coc-emmet", 
        "coc-prettier", 
        "coc-eslint",
      }
    end
  },

  -- Syntax highlighting for almost every language
  {
    "sheerun/vim-polyglot",
    init = function()
      vim.g.vim_svelte_plugin_load_full_syntax = 1
      vim.g.vim_svelte_plugin_use_typescript = 1
      vim.g.vim_svelte_plugin_use_sass = 1
    end
  },

  -- Add two-character motions with s and S
  {
    "ggandor/leap.nvim",
    keys = { "s", "S" },
    dependencies = {
      "tpope/vim-repeat",
    },
    config = function()
      require('leap').add_default_mappings()
    end
  },

  -- Easy commenting/uncommenting
  {
    "numToStr/Comment.nvim",
    config = true,
  },

  -- Easy handling of surroundings
  {
    "tpope/vim-surround",
    dependencies = {
      "tpope/vim-repeat",
    },
  },

  -- Auto-match brackets, quotes etc.
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {},
    -- Make it play well with CoC
    init = function()
      local remap = vim.api.nvim_set_keymap
      local npairs = require('nvim-autopairs')
      npairs.setup({map_cr=false})

      _G.MUtils= {}

      MUtils.completion_confirm=function()
        if vim.fn["coc#pum#visible"]() ~= 0  then
            return vim.fn["coc#pum#confirm"]()
        else
            return npairs.autopairs_cr()
        end
      end

      remap('i' , '<CR>','v:lua.MUtils.completion_confirm()', {expr = true , noremap = true})
    end
  },

  -- VSCode-like multi-cursor support
  {
    "mg979/vim-visual-multi",
    branch = "master",
  },

  -- GitHub Copilot
  {
    "github/copilot.vim",
    cmd = "CPE", -- Don't load until enable command is run
    config = function()
      vim.api.nvim_create_user_command("CPE", "Copilot enable", {})
      vim.api.nvim_create_user_command("CPD", "Copilot disable", {})

      vim.g.copilot_filetypes = {
        TelescopePrompt = false,
      }
    end
  },

  -- Auto-restore session when opening Neovim
  {
    "rmagatti/auto-session",
    opts = {
      log_level = "error",
    },
  },

  -- File explorer sidebar
  {
    "kyazdani42/nvim-tree.lua",
    commit = "e14989c", -- newer versions break auto-session
    dependencies = {
      "kyazdani42/nvim-web-devicons",
    },
    opts = {
      update_focused_file = {
        enable = true,
      },
      view = {
        signcolumn = "auto",
        adaptive_size = true,
        mappings = {
          list = {
            { key = "+", action = "cd" },
          },      
        },
      },
    },
    init = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      vim.keymap.set("n", "<leader>n", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
    end,
  }, 

  -- Fuzzy finder for files, buffers, etc.
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.1",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {"nvim-telescope/telescope-fzf-native.nvim", build = "make"},
    },
    keys = {
      {"<leader>p", "<cmd>Telescope find_files<CR>", noremap = true, silent = true},
      {"<leader>f", "<cmd>Telescope live_grep<CR>", noremap = true, silent = true},
      {"<leader>b", "<cmd>Telescope buffers<CR>", noremap = true, silent = true},
      {"<leader>o", "<cmd>Telescope oldfiles<CR>", noremap = true, silent = true},
      {"<leader>t", "<cmd>Telescope tags<CR>", noremap = true, silent = true},
      {"<leader>c", "<cmd>Telescope commands<CR>", noremap = true, silent = true},
      {"<leader>:", "<cmd>Telescope commands<CR>", noremap = true, silent = true},
      {"<leader>d", "<cmd>Telescope git_status<CR>", noremap = true, silent = true},
      {"<leader><leader>", "<cmd>Telescope resume<CR>", noremap = true, silent = true},
    },
    config = function()
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<esc>"] = require("telescope.actions").close, -- Disable normal mode
            },
          },
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--fixed-strings",
          }
        }       
      })
      require("telescope").load_extension("fzf")
    end,
  },

  -- Persistent terminal that can be toggled with a keybinding
  {
    "akinsho/nvim-toggleterm.lua",
    tag = "2.4.0",
    keys = "<C-j>",
    config = function()
      require("toggleterm").setup({
        hide_numbers = true,
        direction = 'float',
        open_mapping = [[<C-j>]],
        shell = 'fish',
      })
    end,
  },

  -- Run code with a keybinding
  {
    "CRAG666/code_runner.nvim",
    cmd = "RunCode",
    dependencies = {
      "akinsho/nvim-toggleterm.lua"
    },
    opts = {
      mode = "toggleterm",
      filetype = {
        python = "python",
        javascript = "node",
        typescript = "ts-node --esm",
        c = "gcc -o main % && ./main",
      },
    },
    init = function()
      vim.keymap.set("n", "<leader><CR>", ":RunCode<CR>", { noremap = true })
    end,
  },

  -- Live Markdown preview in browser
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    ft = "markdown",
    init = function()
      vim.g.mkdp_auto_close = 0
    end,
  },

  -- Git integration - show modified lines next to line numbers
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
      require("scrollbar.handlers.gitsigns").setup()
    end,
  },

  -- Tool for resolving Git merge conflicts
  {
    "akinsho/git-conflict.nvim",
    tag = "v1.0.0",
    config = true,
  },
  
  -- VSCode-like scrollbar with Git and diagnostic markers
  {
    "petertriho/nvim-scrollbar",
    config = true,
  },

  -- Smooth scrolling
  {
    "karb94/neoscroll.nvim",
    opts = {
      easing_function = "sine",
    }
  },
})
