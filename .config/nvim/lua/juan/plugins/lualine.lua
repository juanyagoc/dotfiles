return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status")
		local devicons = require("nvim-web-devicons")
		local uv = vim.uv or vim.loop

		local function custom_filepath()
			local filepath = vim.fn.expand("%:p")
			if filepath == "" then return "" end

			local home = uv.os_homedir()
			if filepath:find(home, 1, true) == 1 then
				filepath = "~" .. filepath:sub(#home + 1)
			end

			local sep = package.config:sub(1, 1)
			local path_parts = vim.split(filepath, sep, { plain = true })

			local filename = table.remove(path_parts)
			local folder_path = table.concat(path_parts, sep)

            local extension = vim.fn.expand("%:e")
            local file_icon = devicons.get_icon(filename, extension, { default = true }) or ""
			local folder_icon = devicons.get_icon("folder", { default = true }) or ""

			-- Truncar la ruta si es muy larga
            if #folder_path > 60 then
                local parts = vim.split(folder_path, sep, { plain = true })
                local count = #parts
                if count >= 3 then
                    folder_path = "..." .. sep .. parts[count - 1] .. sep .. parts[count]
                end
            end

			return string.format("%s %s %s %s", folder_icon, folder_path, file_icon, filename)
		end

		vim.opt.laststatus = 3

		lualine.setup({
			options = {
				section_separators = "",
				component_separators = "",
				theme = "auto",
				icons_enabled = true,
				disabled_filetypes = {
					statusline = { "NvimTree" },
					winbar = {},
				},
			},
			sections = {
				lualine_c = {
					{ custom_filepath },
				},
				lualine_x = {
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = "#ff9e64" },
					},
					{ "encoding" },
					{ "fileformat" },
					{ "filetype" },
				},
				lualine_z = {
					{ "location" },
				},
			},
		})
	end,
}
