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

-- Foldtext: first line on a solid bar + a badge with the folded line count.
-- In diff windows (foldtext is evaluated with the drawn window as current), use the flashier DiffFolded /
-- DiffFoldBadge so folded context between hunks stands out. The bar is padded to the window width: the fill
-- after the text uses `Folded`, which can't be remapped per window here ('winhighlight' is overridden by the
-- highlight namespace octo sets on its review windows).
function M.foldtext()
  local start, finish = vim.v.foldstart, vim.v.foldend
  local line = vim.fn.getline(start):gsub("\t", string.rep(" ", vim.bo.tabstop))
  local diff = vim.wo.diff
  local bar, badge = diff and "DiffFolded" or "Folded", diff and "DiffFoldBadge" or "FoldBadge"
  return {
    { line, bar },
    { "  ", bar },
    { " 󰁂 " .. (finish - start + 1) .. " lines ", badge },
    { diff and string.rep(" ", vim.api.nvim_win_get_width(0)) or " ", bar },
  }
end

return M
