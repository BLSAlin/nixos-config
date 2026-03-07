{
  programs.nixvim = {
    opts = {
      laststatus = 3;
      showmode = false;
    };

    extraConfigLua = ''
      local function statusline()
        -- Mode
        local mode_map = {
          ["n"]  = "NORMAL",
          ["i"]  = "INSERT",
          ["v"]  = "VISUAL",
          ["V"]  = "V-LINE",
          ["\22"] = "V-BLOCK",
          ["c"]  = "COMMAND",
          ["R"]  = "REPLACE",
          ["t"]  = "TERMINAL",
          ["s"]  = "SELECT",
          ["S"]  = "S-LINE",
        }
        local mode = mode_map[vim.fn.mode()] or vim.fn.mode()

        -- File
        local file = vim.fn.expand("%:t")
        if file == "" then file = "[No Name]" end
        local modified = vim.bo.modified and " [+]" or ""

        -- Git branch
        local branch = vim.b.gitsigns_head or ""
        if branch ~= "" then
          branch = "  " .. branch
        end

        -- Diagnostics
        local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        local diag = ""
        if errors > 0 or warnings > 0 then
          diag = " E:" .. errors .. " W:" .. warnings
        end

        -- Filetype
        local ft = vim.bo.filetype
        if ft == "" then ft = "none" end

        -- Position
        local line = vim.fn.line(".")
        local col = vim.fn.col(".")
        local pct = math.floor(vim.fn.line(".") / vim.fn.line("$") * 100)

        return " " .. mode
          .. "  " .. file .. modified
          .. branch
          .. "%="
          .. diag .. "  "
          .. ft
          .. "  " .. line .. ":" .. col
          .. " " .. pct .. "%% "
      end

      vim.o.statusline = "%!v:lua.statusline()"
      _G.statusline = statusline
    '';
  };
}
