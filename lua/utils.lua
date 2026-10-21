local M = {}

-- Unload all lua modules
M['unload_lua_namespace'] = function(prefix)
  local prefix_with_dot = prefix .. '.'
  for key, value in pairs(package.loaded) do
    if key == prefix or key:sub(1, #prefix_with_dot) == prefix_with_dot then
      package.loaded[key] = nil
    end
  end
end

-- Env for lualine
function M.env_cleanup(venv)
  if string.find(venv, "/") then
    local final_venv = venv
    for w in venv:gmatch "([^/]+)" do
      final_venv = w
    end
    venv = final_venv
  end
  return venv
end

-- Foldtext: first line on a solid bar + a badge with the folded line count
function M.foldtext()
  local start, finish = vim.v.foldstart, vim.v.foldend
  local line = vim.fn.getline(start):gsub("\t", string.rep(" ", vim.bo.tabstop))
  return {
    { line, "Folded" },
    { "  ", "Folded" },
    { " 󰁂 " .. (finish - start + 1) .. " lines ", "FoldBadge" },
    { " ", "Folded" },
  }
end

return M
