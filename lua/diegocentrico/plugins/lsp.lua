return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"j-hui/fidget.nvim",
		"folke/neodev.nvim",
		"jose-elias-alvarez/null-ls.nvim",
	},

	config = function()
		local cmp = require("cmp")
		local cmp_lsp = require("cmp_nvim_lsp")
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			cmp_lsp.default_capabilities()
		)

		require("fidget").setup({})
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"ts_ls", -- TypeScript/JavaScript
				"denols", -- Deno
				"astro", -- Astro
				"svelte", -- Svelte
				"html", -- HTML
				"tailwindcss", -- Tailwind CSS
				"cssls", -- CSS
				"jdtls", -- Java
				"gopls", -- Go
				"pyright", -- Python
				"rust_analyzer", -- Rust
			},
			handlers = {
				function(server_name) -- default handler (optional)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
					})
				end,

				["lua_ls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.lua_ls.setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								runtime = { version = "Lua 5.1" },
								diagnostics = {
									globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
								},
							},
						},
					})
				end,

				["ts_ls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.ts_ls.setup({
						capabilities = capabilities,
						settings = {
							javascript = {
								inlayHints = {
									includeInlayEnumMemberValueHints = true,
									includeInlayFunctionLikeReturnTypeHints = true,
									includeInlayFunctionParameterTypeHints = true,
									includeInlayPropertyDeclarationTypeHints = true,
									includeInlayVariableTypeHints = true,
								},
							},
							typescript = {
								inlayHints = {
									includeInlayEnumMemberValueHints = true,
									includeInlayFunctionLikeReturnTypeHints = true,
									includeInlayFunctionParameterTypeHints = true,
									includeInlayPropertyDeclarationTypeHints = true,
									includeInlayVariableTypeHints = true,
								},
							},
						},
					})
				end,

				["gopls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.gopls.setup({
						capabilities = capabilities,
						cmd = { "gopls" },
						filetypes = { "go", "gomod", "gowork", "gotmpl" },
						root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
						settings = {
							gopls = {
								analyses = {
									unusedparams = true,
									shadow = true,
								},
								staticcheck = true,
							},
						},
					})
				end,

				["jdtls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.jdtls.setup({
						capabilities = capabilities,
						cmd = { "jdtls" },
						root_dir = lspconfig.util.root_pattern(".git", "pom.xml", "build.gradle"),
						settings = {
							java = {
								format = {
									settings = {
										url = "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml", -- Formato de código
									},
								},
								signatureHelp = { enabled = true },
								contentProvider = { preferred = "fernflower" },
							},
						},
					})
				end,

				["denols"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.denols.setup({
						capabilities = capabilities,
						root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
					})
				end,

				["svelte"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.svelte.setup({
						capabilities = capabilities,
						settings = {
							svelte = {
								plugin = {
									css = { enable = true },
									html = { enable = true },
									typescript = { enable = true },
									diagnostics = { enable = true },
								},
							},
						},
					})
				end,

				["astro"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.astro.setup({
						capabilities = capabilities,
						settings = {
							astro = {
								plugin = {
									typescript = {
										enable = true, -- Soporte de TypeScript en archivos Astro
									},
									html = {
										enable = true, -- Soporte de HTML en archivos Astro
									},
									css = {
										enable = true, -- Soporte de CSS en archivos Astro
									},
									diagnostics = {
										enable = true, -- Activar diagnósticos para Astro
									},
								},
							},
						},
					})
				end,

				["tailwindcss"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.tailwindcss.setup({
						capabilities = capabilities,
						settings = {
							tailwindCSS = {
								lint = {
									cssConflict = "warning",
									invalidApply = "error",
									invalidScreen = "error",
									invalidVariant = "error",
									recommendedVariantOrder = "warning",
								},
							},
						},
					})
				end,

				["cssls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.cssls.setup({
						capabilities = capabilities,
					})
				end,

				["pyright"] = function()
					require("lspconfig").pyright.setup({
						capabilities = capabilities,
						settings = {
							python = {
								analysis = {
									typeCheckingMode = "basic",
									autoSearchPaths = true,
									useLibraryCodeForTypes = true,
								},
							},
						},
					})
				end,

				["rust_analyzer"] = function()
					local lspconfig = require("lspconfig")
					local util = require("lspconfig.util")
					lspconfig.rust_analyzer.setup({
						capabilities = capabilities,
						root_dir = util.root_pattern("Cargo.toml", "rust-project.json"),
						settings = {
							["rust-analyzer"] = {
								procMacro = { enable = true },
								cargo = { allFeatures = true, buildScripts = { enable = true } },
							},
						},
					})
				end,
			},
		})

		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" }, -- For luasnip users.
			}, {
				{ name = "buffer" },
			}),
		})

		vim.diagnostic.config({
			-- update_in_insert = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})
	end,
}
