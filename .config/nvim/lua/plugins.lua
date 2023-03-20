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
    "sonph/onehalf",
    lazy = false,
    priority = 1000,
    config = function(plugin)
      vim.opt.rtp:append(plugin.dir .. "/vim")
      vim.opt.termguicolors = true
      vim.cmd([[colorscheme onehalfdark]])
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

  -- Enable dot repeat for plugins
  {
    "tpope/vim-repeat",
  },

  -- Add two-character motions with s and S
  {
    "ggandor/leap.nvim",
    config = function()
      require('leap').add_default_mappings()
    end
  },

  -- VSCode-like multi-cursor support
  {
    "mg979/vim-visual-multi",
    branch = "master",
  },

  -- Easy commenting/uncommenting
  {
    "numToStr/Comment.nvim",
    config = true,
  },

  -- Easy handling of surroundings
  {
    "tpope/vim-surround",
  },

  -- GitHub Copilot
  {
    "github/copilot.vim",
    cmd = "CPE", -- Don't load until enable command is run
    config = function()
      vim.api.nvim_create_user_command("CPE", "Copilot enable", {})
      vim.api.nvim_create_user_command("CPD", "Copilot disable", {})
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
    config = function()
      require("telescope").setup{}
      require("telescope").load_extension("fzf")
      vim.keymap.set("n", "<leader>p", ":Telescope find_files<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>f", ":Telescope live_grep<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>b", ":Telescope buffers<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>o", ":Telescope oldfiles<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>t", ":Telescope tags<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>:", ":Telescope commands<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>d", ":Telescope git_status<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader><leader>", ":Telescope resume<CR>", { noremap = true, silent = true })
    end,
  },

  -- Persistent terminal that can be toggled with a keybinding
  {
    "akinsho/nvim-toggleterm.lua",
    tag = "2.3.0",
    keys = "<C-j>",
    opts = {
      size = 20,
      hide_numbers = true,
      direction = 'horizontal',
      open_mapping = [[<C-j>]],
      shade_terminals = true,
      shading_factor = 2,
      shell = 'fish'
    }
  },

  -- Run code with a keybinding
  {
    "CRAG666/code_runner.nvim",
    opts = {
      mode = "toggleterm",
      filetype = {
        python = "python",
        javascript = "node",
        typescript = "node",
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
    opts = {
      marks = {
        Search = { color = "#ff9e64" },
        Error = { color = "#db4b4b" },
        Warn = { color = "#e0af68" },
        Info = { color = "#0db9d7" },
        Hint = { color = "#1abc9c" },
        Misc = { color = "#9d7cd8" },
        GitAdd = { color = "#9ece6a" },
        GitChange = { color = "#e0af68" },
        GitDelete = { color = "#914c54" },
      }
    }
  },

  -- Smooth scrolling
  {
    "karb94/neoscroll.nvim",
    opts = {
      easing_function = "sine",
    }
  },
})
