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
			require("catppuccin").setup({
				auto_integrations = true,
				transparent_background = true, -- disables setting the background color.
				float = {
					transparent = true, -- enable transparent floating windows
				},
			})
			vim.cmd("colorscheme catppuccin-mocha")
		end,
	},

	-- Treesitter config
	{
		"romus204/tree-sitter-manager.nvim",
		dependencies = {}, -- tree-sitter CLI must be installed system-wide
		config = function()
			require("tree-sitter-manager").setup({
				auto_install = true,
			})
		end,
	},

	-- LSP config
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Mason for easy LSP installation
			{ "mason-org/mason.nvim", opts = {} },
			{
				"mason-org/mason-lspconfig.nvim",
				opts = {
					handlers = {
						-- Make it play with nvim-cmp
						function(server_name)
							require("lspconfig")[server_name].setup({
								capabilities = require("cmp_nvim_lsp").default_capabilities(),
							})
						end,
					},
				},
			},

			-- Autocompletion (nvim-cmp)
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
			"L3MON4D3/LuaSnip", -- Snippet engine
		},
		config = function()
			-- Setup nvim-cmp
			local cmp = require("cmp")
			cmp.setup({
				sources = {
					{ name = "nvim_lsp" },
				},
				completion = {
					-- Highlight first item in completion menu automatically
					completeopt = "menu,menuone,noinsert",
				},
				mapping = cmp.mapping.preset.insert({
					-- Enter key confirms completion item
					["<CR>"] = cmp.mapping.confirm({ select = false }),

					-- Ctrl + space triggers LSP completion menu
					["<C-Space>"] = cmp.mapping.complete(),

					-- Ctrl + a triggers AI autocompletion
					["<C-a>"] = cmp.mapping.complete({
						config = {
							sources = {
								{ name = "supermaven" },
							},
						},
					}),
				}),
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
			})

			-- Keymaps
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(event)
					local opts = { buffer = event.buf }

					vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
					vim.keymap.set("n", "gh", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
				end,
			})

			-- Close quickfix menu after selecting choice
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "qf" },
				command = [[nnoremap <buffer> <CR> <CR>:cclose<CR>]],
			})
		end,
	},

	-- Formatting with null-ls
	{
		"nvimtools/none-ls.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local null_ls = require("null-ls")
			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.prettierd.with({
						extra_filetypes = { "astro", "svelte" },
					}),
					null_ls.builtins.formatting.black,
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.gofmt,
				},
				on_attach = function(client, bufnr)
					if client:supports_method("textDocument/formatting") then
						vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = augroup,
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.format({
									async = false,
									filter = function(client)
										return client.name == "null-ls"
									end,
								})
							end,
						})
					end
				end,
			})
		end,
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
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},

	-- AI autocompletion
	{
		"supermaven-inc/supermaven-nvim",
		init = function()
			vim.api.nvim_create_user_command("CPE", "SupermavenStart", {})
			vim.api.nvim_create_user_command("CPD", "SupermavenStop", {})
		end,
		config = function()
			require("supermaven-nvim").setup({
				disable_inline_completion = true,
			})
		end,
	},

	{
		"NickvanDyke/opencode.nvim",
		dependencies = {
			-- Recommended for better prompt input, and required to use `opencode.nvim`'s embedded terminal — otherwise optional
			{ "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
		},
		config = function()
			local opencode_cmd = "opencode --port"
			---@type snacks.terminal.Opts
			local snacks_terminal_opts = {
				win = {
					position = "right",
					enter = true,
				},
			}

			---@type opencode.Opts
			vim.g.opencode_opts = {
				-- Your configuration, if any — see `lua/opencode/config.lua`
				server = {
					start = function()
						require("snacks.terminal").open(opencode_cmd, snacks_terminal_opts)
					end,
					stop = function()
						require("snacks.terminal").get(opencode_cmd, snacks_terminal_opts):close()
					end,
					toggle = function()
						require("snacks.terminal").toggle(opencode_cmd, snacks_terminal_opts)
					end,
				},
			}

			-- Required for `opts.auto_reload`
			vim.opt.autoread = true

			-- Toggle with Ctrl + ,
			vim.keymap.set({ "n", "v", "i", "t" }, "<C-,>", function()
				require("opencode").toggle()
			end, { desc = "Toggle" })

			-- Ask inline with <leader>aa
			vim.keymap.set("n", "<leader>aa", function()
				require("opencode").ask("@this: ", { submit = true })
			end, { desc = "Ask about this" })
			vim.keymap.set("v", "<leader>aa", function()
				require("opencode").ask("@this: ", { submit = true })
			end, { desc = "Ask about selection" })

			-- Add to context with <leader>a+
			vim.keymap.set("n", "<leader>a+", function()
				require("opencode").prompt("@buffer")
			end, { desc = "Add buffer to prompt" })
			vim.keymap.set("v", "<leader>a+", function()
				require("opencode").prompt("@this")
			end, { desc = "Add selection to prompt" })
		end,
	},

	-- Auto-restore session when opening Neovim
	{
		"rmagatti/auto-session",
		opts = {
			log_level = "error",
		},
		init = function()
			vim.o.sessionoptions = "blank,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
		end,
	},

	-- File explorer sidebar
	{
		"kyazdani42/nvim-tree.lua",
		dependencies = {
			"kyazdani42/nvim-web-devicons",
		},
		opts = {
			actions = {
				open_file = {
					quit_on_open = true,
				},
			},
			update_focused_file = {
				enable = true,
			},
			view = {
				signcolumn = "auto",
				adaptive_size = true,
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
		tag = "v0.2.1",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		keys = {
			{ "<leader>p", "<cmd>Telescope find_files<CR>", noremap = true, silent = true },
			{ "<leader>f", "<cmd>Telescope live_grep<CR>", noremap = true, silent = true },
			{ "<leader>b", "<cmd>Telescope buffers<CR>", noremap = true, silent = true },
			{ "<leader>o", "<cmd>Telescope oldfiles<CR>", noremap = true, silent = true },
			{ "<leader>t", "<cmd>Telescope lsp_workspace_symbols<CR>", noremap = true, silent = true },
			{ "<leader>c", "<cmd>Telescope commands<CR>", noremap = true, silent = true },
			{ "<leader>:", "<cmd>Telescope commands<CR>", noremap = true, silent = true },
			{ "<leader>d", "<cmd>Telescope git_status<CR>", noremap = true, silent = true },
			{ "<leader><leader>", "<cmd>Telescope resume<CR>", noremap = true, silent = true },
			{ "grr", "<cmd>Telescope lsp_references<CR>", noremap = true, silent = true },
		},
		config = function()
			require("telescope").setup({
				pickers = {
					oldfiles = {
						cwd_only = true,
					},
				},
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
					},
				},
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
				direction = "float",
				open_mapping = [[<C-j>]],
				shell = "fish",
			})
		end,
	},

	-- Run code with a keybinding
	{
		"CRAG666/code_runner.nvim",
		cmd = "RunCode",
		dependencies = {
			"akinsho/nvim-toggleterm.lua",
		},
		opts = {
			mode = "toggleterm",
			filetype = {
				python = "python3",
				javascript = "bun",
				typescript = "bun",
				go = "go run",
			},
		},
		init = function()
			vim.keymap.set("n", "<leader><CR>", ":RunCode<CR>", { noremap = true })
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
		},
	},
})
