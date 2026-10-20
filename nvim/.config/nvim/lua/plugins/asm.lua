-- Assembly linting: NASM (x86_64) and GAS (GNU as)
-- Both tools report errors on stderr, so merge it into stdout for nvim-lint.
return {
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters = opts.linters or {}

      local parser = function(output, bufnr)
        if not output or output == "" then
          return {}
        end
        local diags = {}
        for line in output:gmatch("[^\r\n]+") do
          local lnum, msg = line:match("^.+:(%d+):%s*(.+)$")
          if lnum then
            diags[#diags + 1] = {
              lnum = tonumber(lnum) - 1,
              col = 0,
              message = msg,
              severity = msg:lower():match("^error") and vim.diagnostic.severity.ERROR
                or vim.diagnostic.severity.WARN,
              source = "asm",
            }
          end
        end
        return diags
      end

      -- ponytail: dialect picked by extension (.s/.S = GAS, else NASM x86_64); add flags/-I paths here if needed.
      opts.linters["asm"] = {
        name = "asm",
        cmd = "sh",
        args = {
          "-c",
          'case "$1" in *.s|*.S) as "$1" -o /dev/null;; *) nasm -f elf64 "$1" -o /dev/null;; esac 2>&1',
          "asm-check",
        },
        stream = "stdout",
        ignore_exitcode = true,
        parser = parser,
      }

      opts.linters_by_ft = vim.tbl_extend("force", opts.linters_by_ft or {}, {
        asm = { "asm" },
        nasm = { "asm" },
        gas = { "asm" },
      })
    end,
  },
}
