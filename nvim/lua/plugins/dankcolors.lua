return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#151311',
				base01 = '#151311',
				base02 = '#8f8a84',
				base03 = '#8f8a84',
				base04 = '#e7e1d9',
				base05 = '#fffcf8',
				base06 = '#fffcf8',
				base07 = '#fffcf8',
				base08 = '#ffa69f',
				base09 = '#ffa69f',
				base0A = '#f2dab9',
				base0B = '#b4ffa5',
				base0C = '#fff1df',
				base0D = '#f2dab9',
				base0E = '#ffeace',
				base0F = '#ffeace',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#8f8a84',
				fg = '#fffcf8',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Statusline', {
				bg = '#f2dab9',
				fg = '#151311',
			})
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#8f8a84' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#fff1df', bold = true })

			vim.api.nvim_set_hl(0, 'Statement', {
				fg = '#ffeace',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })

			vim.api.nvim_set_hl(0, 'Function', {
				fg = '#f2dab9',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Macro', {
				fg = '#f2dab9',
				italic = true
			})
			vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })

			vim.api.nvim_set_hl(0, 'Type', {
				fg = '#fff1df',
				bold = true,
				italic = true
			})
			vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })

			vim.api.nvim_set_hl(0, 'String', {
				fg = '#b4ffa5',
				italic = true
			})

			vim.api.nvim_set_hl(0, 'Operator', { fg = '#e7e1d9' })
			vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#e7e1d9' })
			vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
			vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })

			vim.api.nvim_set_hl(0, 'Comment', {
				fg = '#8f8a84',
				italic = true
			})

			local current_file_path = vim.fn.stdpath("config") .. "/lua/plugins/dankcolors.lua"
			if not _G._matugen_theme_watcher then
				local uv = vim.uv or vim.loop
				_G._matugen_theme_watcher = uv.new_fs_event()
				_G._matugen_theme_watcher:start(current_file_path, {}, vim.schedule_wrap(function()
					local new_spec = dofile(current_file_path)
					if new_spec and new_spec[1] and new_spec[1].config then
						new_spec[1].config()
						print("Theme reload")
					end
				end))
			end
		end
	}
}
