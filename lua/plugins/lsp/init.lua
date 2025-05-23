local formatter = require("plugins/lsp/format")
local on_attach = require("plugins/lsp/lsp_attach")

return {
	"stevearc/conform.nvim",
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",

			{ "j-hui/fidget.nvim",       opts = {} },

			"folke/neodev.nvim",
			"folke/trouble.nvim",

			-- Cmp Stuff
			"hrsh7th/nvim-cmp",
			-- "L3MON4D3/LuaSnip",
			-- "saadparwaiz1/cmp_luasnip",

			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			-- uncomment to eiasble local buffer completion
			-- also check line 102 ( hit :102 in normal mode )
			-- "hrsh7th/cmp-buffer",

			"rafamadriz/friendly-snippets",
		},
		config = function()
			require("neodev").setup()

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			local servers = require("plugins/lsp/servers")

			-- First set up mason-lspconfig
			require("mason").setup()
			
			-- Pre-configure servers for Neovim 0.11+ using lspconfig
			for server_name, server_settings in pairs(servers) do
				local setup_opts = vim.tbl_extend("force", {
					capabilities = capabilities,
					on_attach = on_attach,
				}, server_settings)
				
				require("lspconfig")[server_name].setup(setup_opts)
			end
			
			-- Set up mason-lspconfig
			local ensure_installed = {}
			for server_name, server in pairs(servers) do
				if server.cmd == nil then
					table.insert(ensure_installed, server_name)
				end
			end
			
			require("mason-lspconfig").setup({
				ensure_installed = ensure_installed,
			})

			local cmp = require("cmp")
			-- local luasnip = require("luasnip")
			-- require("luasnip.loaders.from_vscode").lazy_load()
			-- luasnip.config.setup({ enable_autosnippets = false })

			cmp.setup({
				-- snippet = {
				-- 	expand = function(args)
				-- 		luasnip.lsp_expand(args.body)
				-- 	end,
				-- },
				mapping = cmp.mapping.preset.insert({
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete({}),
					["<A-e>"] = cmp.mapping.close(),
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					}),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
							-- elseif luasnip.expand_or_locally_jumpable() then
							-- 	luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
							-- elseif luasnip.locally_jumpable(-1) then
							-- 	luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = {
					{ name = "supermaven" },
					{ name = "nvim_lsp" },
					-- { name = "luasnip" },
					{ name = "path" },
					-- uncomment to diasble local buffer completion
					-- also check line 24 ( hit :24 in normal mode )
					-- { name = "buffer" },
				},
				completion = {
					autocomplete = {
						"TextChanged",
					},
				},
			})
		end,
	},
	formatter,
}