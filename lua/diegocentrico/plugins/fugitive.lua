return {
	"tpope/vim-fugitive",
	config = function()
		vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

		local Diegocentrico_Fugitive = vim.api.nvim_create_augroup("diegocentrico_fugitive", {})

		local autocmd = vim.api.nvim_create_autocmd
		autocmd("BufWinEnter", {
			group = Diegocentrico_Fugitive,
			pattern = "*",
			callback = function()
				if vim.bo.ft ~= "fugitive" then
					return
				end

				local bufnr = vim.api.nvim_get_current_buf()
				local opts = { buffer = bufnr, remap = false }

				vim.keymap.set("n", "<leader>p", function()
					vim.cmd.Git("push")
				end, opts)

				vim.keymap.set("n", "<leader>pl", function()
					vim.cmd.Git("pull")
				end, opts)

				vim.keymap.set("n", "<leader>plr", function()
					vim.cmd.Git("pull --rebase")
				end, opts)

				vim.keymap.set("n", "<leader>P", function()
					vim.cmd.Git({ "pull", "--rebase" })
				end, opts)

				vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts)

				vim.cmd("echo 'Atajos de Fugitive: [C]ommits [P]ush [G]it Diff [Q]uit'")
			end,
		})

		vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>")
		vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>")
	end,
}
