local job = require("plenary.job")
local noice = require("noice")

local sql = function()
  local fileName = vim.api.nvim_buf_get_name(0)
  return job:new({
    command = "sqlfmt",
    args = { fileName },
    on_exit = function(j, return_val)
      if return_val == 0 then
        print("Formatted " .. fileName)
        vim.schedule(function()
          vim.cmd(":e")
        end)
      else
        vim.schedule(function()
          noice.notify(table.concat(j:stderr_result(), "\n"), "error")
        end)
      end
    end,
  })
end

-- Add any other formatter overrides here
-- The key should be the filetype and the value should be the function to run

local format_overrides = {
  sql = sql,
  plsql = sql,
  mysql = sql,
}

vim.g.format = function()
  if (format_overrides[vim.bo.filetype] or nil) ~= nil then
    format_overrides[vim.bo.filetype]():start()
  else
    vim.lsp.buf.format({ async = true })
  end
end
