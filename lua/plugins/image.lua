return {
	"3rd/image.nvim",
	opts = {
		backend = "kitty", -- Explicitly set Kitty backend
		processor = "magick_cli",
		integrations = {
			markdown = {
				enabled = true,
				download_remote_images = true,
				only_render_image_at_cursor = false,
			},
		},
	},
	rocks = { "magick" }, -- Install magick Lua rock
}
