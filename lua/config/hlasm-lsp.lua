local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'hlasm-language-server' },
    filetypes = { 's', 'hlasm' },
    root_dir = util.find_git_ancestor,
  },
  docs = {
    description = [[
https://github.com/eclipse-che4z/che-che4z-lsp-for-hlasm

Language Server for IBM High-Level Assember
]],
  },
}
