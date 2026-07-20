local mini_files = require("mini.files")

local show_dotfiles = true

local function filter_entries(fs_entry)
  if show_dotfiles then
    return true
  end
  return not vim.startswith(fs_entry.name, ".")
end

mini_files.setup({
  content = {
    filter = filter_entries,
    sort = function(entries)
      table.sort(entries, function(a, b)
        if a.fs_type ~= b.fs_type then
          return a.fs_type == "directory"
        end
        return a.name:lower() < b.name:lower()
      end)
      return entries
    end,
  },
  options = {
    permanent_delete = false,
    use_as_default_explorer = false,
    lsp_timeout = 1000,
  },
  windows = {
    max_number = 3,
    preview = true,
    width_focus = 40,
    width_nofocus = 22,
    width_preview = 30,
  },
})

local function toggle_dotfiles()
  show_dotfiles = not show_dotfiles
  mini_files.refresh({ content = { filter = filter_entries } })
end

local function toggle_files(path)
  if not mini_files.close() then
    mini_files.open(path, false)
  end
end

local function current_file_dir()
  local path = vim.api.nvim_buf_get_name(0)
  if path ~= "" then
    return vim.fs.dirname(path)
  end
  return vim.loop.cwd()
end

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesBufferCreate",
  callback = function(args)
    local buf_id = args.data.buf_id

    vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id, desc = "Toggle dotfiles" })

    vim.keymap.set("n", "g~", function()
      local entry = mini_files.get_fs_entry()
      if not entry or not entry.path then
        return vim.notify("Cursor is not on valid entry", vim.log.levels.WARN)
      end
      vim.fn.chdir(vim.fs.dirname(entry.path))
    end, { buffer = buf_id, desc = "Set cwd" })

    vim.keymap.set("n", "gy", function()
      local entry = mini_files.get_fs_entry()
      if not entry or not entry.path then
        return vim.notify("Cursor is not on valid entry", vim.log.levels.WARN)
      end
      vim.fn.setreg(vim.v.register, entry.path)
    end, { buffer = buf_id, desc = "Yank path" })
  end,
})

vim.keymap.set("n", "-", function()
  toggle_files(current_file_dir())
end, { desc = "Toggle mini.files (file dir)" })
