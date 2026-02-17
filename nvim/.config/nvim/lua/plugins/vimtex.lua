-- lua/plugins/vimtex.lua
return {
  "lervag/vimtex",
  ft = { "tex" }, -- only load vimtex for tex files
  config = function()
    -- Set Zathura as the viewer for VimTeX
    vim.g.vimtex_view_method = 'zathura'

    -- Set neovim-remote for backward search (Ctrl+Click in Zathura)
    vim.g.vimtex_compiler_progname = 'nvr'
  end,
}