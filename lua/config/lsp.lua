-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
    -- NOTE: Remember that lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself
    -- many times.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
    nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Lesser used LSP functionality
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    nmap('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })
end

return {
    plugins = {
        -- Use Built-In Neovim LSP Support
        {
            'neovim/nvim-lspconfig',
            dependencies = {
                -- Display LSP Status
                { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
            }
        },
        -- Diagnostics
        {
            'folke/trouble.nvim',
            opts = {}
        },
        -- Autocompletion
        {
            'hrsh7th/nvim-cmp',
            dependencies = {
                -- Snippet Engine & its associated nvim-cmp source
                'L3MON4D3/LuaSnip',
                'saadparwaiz1/cmp_luasnip',
                -- Adds LSP completion capabilities
                'hrsh7th/cmp-nvim-lsp',
                -- Adds a number of user-friendly snippets
                'rafamadriz/friendly-snippets',
            },
        },
        -- Rust
        {
            'simrat39/rust-tools.nvim'
        },
        -- LaTeX
        {
            'lervag/vimtex'
        },
    },
    setup = function()
        -- Language Support in Markdown
        vim.g.markdown_fenced_languages = {
            'ts=typescript',
            'c',
            'rs=rust',
            'rust',
        }

        -- Diagnostic keymaps
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
        vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
        vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

        -- Provide Extra Capabilities from plugins
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

        -- Setup LSP
        local lspconfig = require('lspconfig')
        local configs = require('lspconfig.configs')

        -- HLASM
        if not configs.hlasm then
            configs.hlasm = {
                default_config = {
                    cmd = { 'hlasm-language-server' },
                    filetypes = { 'hlasm' },
                    root_dir = function(fname)
                        return lspconfig.util.find_git_ancestor(fname)
                    end,
                    settings = {},
                },
                docs = {
                    description = [[
https://github.com/eclipse-che4z/che-che4z-lsp-for-hlasm

Language Server for IBM High-Level Assember]],
                },
            }
        end
        lspconfig.hlasm.setup({
            on_attach = function()
                apples(an)
                print 'hlasm lsp setup'
            end
        })

        -- Setup Typescript
        lspconfig.tsserver.setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        -- C & C++
        lspconfig.clangd.setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        -- Rust
        local rust = require('rust-tools')
        rust.setup({
            tools = {
                executor = rust.toggleterm,
                inlay_hints = {
                    auto = true,
                    show_parameter_hints = true,
                    parameter_hints_prefix = ' ',
                    other_hints_prefix = ' ',
                },
            },
            server = {
                capabilities = capabilities,
                on_attach = on_attach,
                standalone = true,
                settings = {
                    ['rust-analyzer'] = {
                        check = {
                            allTargets = false,
                        },
                        checkOnSave = {
                            command = 'clippy',
                        }
                    }
                }
            },
        })

        -- Configure nvim-cmp
        -- See `:help cmp`
        local cmp = require 'cmp'
        local luasnip = require 'luasnip'
        require('luasnip.loaders.from_vscode').lazy_load()
        luasnip.config.setup {}

        cmp.setup {
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert {
                ['<C-n>'] = cmp.mapping.select_next_item(),
                ['<C-p>'] = cmp.mapping.select_prev_item(),
                ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete {},
                ['<CR>'] = cmp.mapping.confirm {
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true,
                },
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_locally_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
            },
            sources = {
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
            },
        }

        vim.g.vimtex_compiler_method = 'tectonic'
        vim.g.vimtex_compiler_tectonic = {
            out_dir = 'target/',
        }
    end,
}
