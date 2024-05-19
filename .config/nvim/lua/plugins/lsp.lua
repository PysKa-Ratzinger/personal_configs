local util = require("util")

return {
	-- neodev
	{
		"folke/neodev.nvim",
		opts = {
			debug = true,
			experimental = {
				pathStrict = true,
			},
		},
		library = {
			plugins = {
				"nvim-dap-ui",
			},
			types = true,
		},
	},

	-- tools
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"black",
				"eslint_d",
				"luacheck",
				"prettierd",
				"prosemd-lsp",
				"ruff",
				"selene",
				"shellcheck",
				"shfmt",
				"stylua",
			},
			ui = {
				border = "rounded",
			},
		},
	},

	{
		"nvimdev/lspsaga.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter", -- optional
			"nvim-tree/nvim-web-devicons", -- optional
		},
	},

	"williamboman/mason-lspconfig.nvim",

	{
		"AstroNvim/astrolsp",
		-- we must use the function override because table merging
		-- does not play nicely with list-like tables
		---@param opts AstroLSPOpts
		opts = function(plugin, opts)
			-- safely extend the servers list
			opts.servers = opts.servers or {}
			vim.list_extend(opts.servers, {
				"pyright",
				"clangd",
			})
		end,
	},

	{
		"jay-babu/mason-nvim-dap.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"mfussenegger/nvim-dap",
		},
		opts = {
			ensure_installed = {},
			automatic_installation = true,
		},
		config = true,
	},

	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
	},

	-- {
	--   "DNLHC/glance.nvim",
	--   event = "BufReadPre",
	--   config = true,
	--   keys = {
	--     { "gM", "<cmd>Glance implementations<cr>", desc = "Goto Implementations (Glance)" },
	--     { "gY", "<cmd>Glance type_definitions<cr>", desc = "Goto Type Definition (Glance)" },
	--   },
	-- },

	-- lsp servers
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"SmiteshP/nvim-navbuddy",
				dependencies = {
					"SmiteshP/nvim-navic",
					"MunifTanjim/nui.nvim",
				},
				opts = { lsp = { auto_attach = true, inlay_hints = { enabled = true } } },
				keys = {
					{ "<leader>cln", "<cmd>Navbuddy<cr>", desc = "Lsp Navigation" },
				},
			},
		},
		init = function()
			local keys = require("lazyvim.plugins.lsp.keymaps").get()

			-- move cl to cli
			keys[#keys + 1] = { "<leader>cl", false }
			keys[#keys + 1] = { "<leader>cli", "<cmd>LspInfo<cr>", desc = "LspInfo" }

			-- add more lsp keymaps
			keys[#keys + 1] = { "<leader>cla", vim.lsp.buf.add_workspace_folder, desc = "Add Folder" }
			keys[#keys + 1] = { "<leader>clr", vim.lsp.buf.remove_workspace_folder, desc = "Remove Folder" }
			keys[#keys + 1] = {
				"<leader>cll",
				"<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>",
				desc = "List Folders",
			}
			keys[#keys + 1] = { "<leader>clh", vim.lsp.codelens.run, desc = "Run Code Lens" }
			keys[#keys + 1] = { "<leader>cld", vim.lsp.codelens.refresh, desc = "Refresh Code Lens" }
			keys[#keys + 1] = { "<leader>cls", "<cmd>LspRestart<cr>", desc = "Restart Lsp" }

			require("which-key").register({
				["<leader>cl"] = { name = "+lsp" },
			})
		end,
		opts = {
			diagnostics = { virtual_text = { prefix = "icons" } },
			capabilities = {
				workspace = {
					didChangeWatchedFiles = {
						dynamicRegistration = false,
					},
				},
			},
			-- LSP Server Settings
			---@type lspconfig.options
			servers = {
				ansiblels = {},
				asm_lsp = {},
				bashls = {},
				cmake = {},
				clangd = {
					cmd = { "clangd", "--background-index", "--clang-tidy" },
				},
				cssls = {},
				html = {},
				lua_ls = {
					single_file_support = true,
					---@type lspconfig.settings.lua_ls
					settings = {
						Lua = {
							workspace = {
								checkThirdParty = false,
							},
							completion = {
								workspaceWord = true,
								callSnippet = "Both",
							},
							misc = {
								parameters = {
									"--log-level=trace",
								},
							},
							hover = { expandAlias = false },
							hint = {
								enable = true,
								setType = false,
								paramType = true,
								paramName = "Disable",
								semicolon = "Disable",
								arrayIndex = "Disable",
							},
							doc = {
								privateName = { "^_" },
							},
							type = {
								castNumberToInteger = true,
							},
							diagnostics = {
								disable = { "incomplete-signature-doc", "trailing-space" },
								-- enable = false,
								groupSeverity = {
									strong = "Warning",
									strict = "Warning",
								},
								groupFileStatus = {
									["ambiguity"] = "Opened",
									["await"] = "Opened",
									["codestyle"] = "None",
									["duplicate"] = "Opened",
									["global"] = "Opened",
									["luadoc"] = "Opened",
									["redefined"] = "Opened",
									["strict"] = "Opened",
									["strong"] = "Opened",
									["type-check"] = "Opened",
									["unbalanced"] = "Opened",
									["unused"] = "Opened",
								},
								unusedLocalExclude = { "_*" },
							},
							format = {
								enable = false,
								defaultConfig = {
									indent_style = "tab",
									indent_size = "4",
									continuation_indent_size = "4",
								},
							},
						},
					},
				},
				marksman = {},
				omnisharp = {},
				prosemd_lsp = {},
				pyright = {
					settings = {
						python = {
							analysis = {
								diagnosticSeverityOverrides = {
									reportWildcardImportFromLibrary = "none",
									reportUnusedImport = "information",
									reportUnusedClass = "information",
									reportUnusedFunction = "information",
								},
							},
						},
						pyright = {
							disableTaggedHints = true,
						},
					},
				},
				texlab = {},
				tsserver = {
					-- root_dir = function(...)
					--   return require("lspconfig.util").root_pattern(".git")(...)
					-- end,
					single_file_support = false,
					settings = {
						typescript = {
							inlayHints = {
								includeInlayParameterNameHints = "literal",
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = false,
								includeInlayVariableTypeHints = false,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
						javascript = {
							inlayHints = {
								includeInlayParameterNameHints = "all",
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = true,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
					},
				},
				vimls = {},
				yamlls = {
					settings = {
						yaml = {
							format = {
								enable = true,
							},
							schemaStore = {
								enable = true,
							},
						},
					},
				},
			},
			setup = {},
		},
	},

	{
		"stevearc/conform.nvim",
		optional = true,
		opts = {
			formatters_by_ft = {
				["markdown"] = { { "prettierd", "prettier" } },
				["markdown.mdx"] = { { "prettierd", "prettier" } },
				["javascript"] = { "eslint_d" },
				["javascriptreact"] = { "eslint_d" },
				["typescript"] = { "eslint_d" },
				["typescriptreact"] = { "eslint_d" },
				["python"] = function(bufnr)
					if require("conform").get_formatter_info("ruff_format", bufnr).available then
						return { "ruff_fix", "ruff_format" }
					else
						return { "isort", "black" }
					end
				end,
				["sh"] = { "shfmt" },
				["c"] = { "uncrustify" },
				["cpp"] = { "uncrustify" },
				["xml"] = { "xmllint" },
			},
			formatters = {
				eslint_d = {
					condition = function(_self, ctx)
						local package_json = vim.fs.find({ "package.json" }, { path = ctx.filename, upward = true })[1]
						if package_json then
							local f = io.open(package_json, "r")
							if f then
								local data = vim.json.decode(f:read("*all"))
								f:close()
								if data and data.eslintConfig then
									return true
								end
							end
						end
						return vim.fs.find({ ".eslintrc", ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json" }, {
							path = ctx.filename,
							upward = true,
						})[1]
					end,
				},
				dprint = {
					condition = function(_self, ctx)
						return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
					end,
				},
				uncrustify = {
					condition = function(_self, ctx)
						local paths = vim.fs.find({ "uncrustify.cfg", ".uncrustify.cfg" }, {
							path = ctx.filename,
							upward = true,
						})
						if vim.tbl_isempty(paths) then
							return false
						end
						if not util.executable("uncrustify", true) then
							return false
						end
						---@type string
						vim.env.UNCRUSTIFY_CONFIG = paths[1]
						return true
					end,
				},
			},
		},
	},

	{
		"mfussenegger/nvim-lint",
		opts = {
			linters_by_ft = {
				lua = { "selene", "luacheck" },
				markdown = { "markdownlint" },
			},
			linters = {
				selene = {
					condition = function(ctx)
						return vim.fs.find({ "selene.toml" }, { path = ctx.filename, upward = true })[1]
					end,
				},
				luacheck = {
					condition = function(ctx)
						return vim.fs.find({ ".luacheckrc" }, { path = ctx.filename, upward = true })[1]
					end,
				},
			},
		},
	},

	{
		"zeioth/garbage-day.nvim",
		dependencies = "neovim/nvim-lspconfig",
		event = "VeryLazy",
		opts = {
			excluded_lsp_clients = {
				"null-ls",
				"jdtls",
				"copilot",
				"rust-analyzer",
			},
		},
	},
}
