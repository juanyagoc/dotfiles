return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	init = function()
		-- sin statusline hasta que cargue lualine (evita el parpadeo)
		vim.g.lualine_laststatus = vim.o.laststatus
		if vim.fn.argc(-1) > 0 then
			vim.o.statusline = " "
		else
			vim.o.laststatus = 0
		end
	end,
	config = function()
		vim.o.laststatus = vim.g.lualine_laststatus

		local lazy_status = require("lazy.status")
		local devicons = require("nvim-web-devicons")

		local function custom_filepath()
			local filepath = vim.fn.expand("%:p")
			if filepath == "" then return "" end

			local filename = vim.fn.fnamemodify(filepath, ":t")
			local folder_path = vim.fn.fnamemodify(filepath, ":~:h")

			local file_icon = devicons.get_icon(filename, vim.fn.fnamemodify(filename, ":e"), { default = true }) or ""
			local folder_icon = "\u{f07b}" -- nf-fa-folder

			-- Truncar la ruta si es muy larga
			if #folder_path > 60 then
				local parts = vim.split(folder_path, "/", { plain = true })
				local count = #parts
				if count >= 3 then
					folder_path = ".../" .. parts[count - 1] .. "/" .. parts[count]
				end
			end

			return string.format("%s %s %s %s", folder_icon, folder_path, file_icon, filename)
		end

		-- Estado de compilación de VimTeX (sólo en buffers tex)
		local vimtex_labels = { [1] = "󰑮 compilando", [2] = "\u{f00c} compilado", [3] = "\u{f00d} error" }
		local function vimtex_status()
			local compiler = vim.b.vimtex and vim.b.vimtex.compiler
			return compiler and vimtex_labels[compiler.status] or ""
		end

		require("lualine").setup({
			options = {
				section_separators = { left = '', right = '' },
				component_separators = { left = '', right = '' },
				theme = "auto",
				icons_enabled = true,
				disabled_filetypes = {
					statusline = { "neo-tree", "alpha" },
					winbar = {},
				},
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = {},
				lualine_c = {
					{ custom_filepath },
				},
				lualine_x = {
					{ vimtex_status, cond = function() return vim.bo.filetype == "tex" end },
					{ "branch" },
					{ "diff" },
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = "#ff9e64" },
					},
					{ "encoding" },
					{ "fileformat" },
					{ "filetype" },
					{ "location" },
				},
				lualine_y = {},
				lualine_z = {},
			},
		})
	end,
}
