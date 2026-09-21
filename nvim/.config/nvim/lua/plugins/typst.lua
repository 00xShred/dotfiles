-- lua/plugins/typst.lua
return {
  -- Configure Tinymist LSP
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tinymist = {
          settings = {
            exportPdf = "onSave",
          },
        },
      },
    },
  },

  -- Typst preview and keymaps
  {
    "chomosuke/typst-preview.nvim",
    opts = {
      dependencies_bin = {
        tinymist = "tinymist",
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "typst",
        callback = function(event)
          local function open_in_zathura()
            local typ_path = vim.api.nvim_buf_get_name(event.buf)
            if typ_path == "" then
              return
            end

            local pdf_path = typ_path:gsub("%.typ$", ".pdf")
            -- If PDF does not exist yet, compile it now
            if vim.fn.filereadable(pdf_path) == 0 then
              vim.notify("Compiling PDF...", vim.log.levels.INFO)
              local root = vim.fs.root(typ_path, { ".git", "typst.toml" }) or vim.fn.fnamemodify(typ_path, ":p:h")
              local res = vim.system({ "typst", "compile", "--root", root, typ_path, pdf_path }):wait()
              if res.code ~= 0 then
                vim.notify("Typst compile error: " .. (res.stderr or ""), vim.log.levels.ERROR)
                return
              end
            end

            -- Check if Zathura is already running for this PDF
            local filename = vim.fn.fnamemodify(pdf_path, ":t")
            local check = vim.system({ "pgrep", "-f", "zathura.*" .. filename }):wait()
            if check.code == 0 and check.stdout and #check.stdout > 0 then
              vim.notify("Zathura is already open for " .. filename .. " (auto-reloads on save)", vim.log.levels.INFO)
              return
            end

            vim.fn.jobstart({ "zathura", pdf_path }, { detach = true })
            vim.notify("Opened " .. filename .. " in Zathura", vim.log.levels.INFO)
          end

          -- VimTeX muscle-memory keybindings
          vim.keymap.set("n", "<localleader>ll", open_in_zathura, {
            buffer = event.buf,
            desc = "Typst: Open PDF in Zathura",
          })
          vim.keymap.set("n", "<localleader>lv", open_in_zathura, {
            buffer = event.buf,
            desc = "Typst: View PDF in Zathura",
          })
        end,
      })
    end,
  },
}
