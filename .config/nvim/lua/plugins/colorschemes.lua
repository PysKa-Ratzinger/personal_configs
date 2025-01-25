return {

	-- colorschemes
	{ "rebelot/kanagawa.nvim" },
	{ "widatama/vim-phoenix" },
	{ "L-Colombo/atlantic-dark.nvim" },
	{ "andreasvc/vim-256noir" },
	{ "dracula/vim" },
	{ "neanias/everforest-nvim" },
	{ "EdenEast/nightfox.nvim" },
	{ "ficcdaf/ashen.nvim" },
	{ "projekt0n/github-nvim-theme" },

	{
		"ficcdaf/ashen.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme ashen]])
		end
	}

}

