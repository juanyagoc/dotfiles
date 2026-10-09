return {
	"rmagatti/auto-session",
	lazy = false, -- necesita estar cargado para guardar la sesión al salir
	keys = {
		{ "<leader>wr", "<cmd>AutoSession restore<CR>", desc = "Restore session for cwd" },
		{ "<leader>ws", "<cmd>AutoSession save<CR>", desc = "Save session for auto session root dir" },
	},
	opts = {
		auto_restore = false,
		suppressed_dirs = { "~/", "~/Downloads", "~/Documents", "~/Desktop/" },
	},
}
