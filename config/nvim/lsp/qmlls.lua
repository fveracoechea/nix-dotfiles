---@type vim.lsp.Config
return {
  cmd = { "qmlls" },
  filetypes = { "qml", "qmljs" },
  root_markers = { ".qmlls.ini", ".git" },
}
