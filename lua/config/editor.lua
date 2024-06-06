return {
    plugins = {
        -- Atom One Dark Theme
        {
            'navarasu/onedark.nvim',
            priority = 1000,
            config = function()
                vim.cmd.colorscheme 'onedark'
            end,
        },
        -- Terminal
        {
            'akinsho/toggleterm.nvim',
            version = "*",
            config = true
        },
        -- Status Line
        {
            'nvim-lualine/lualine.nvim',
            -- See `:help lualine.txt`
            opts = {
                options = {
                    icons_enabled = false,
                    theme = 'onedark',
                    component_separators = '│',
                    section_separators = '',
                },
            },
        },
        -- Show Indentation Lines
        {
            'lukas-reineke/indent-blankline.nvim',
            -- See `:help indent_blankline.txt`
            opts = {
                char = '┊',
                show_trailing_blankline_indent = false,
            },
        },
        -- Surround Text Objects
        {
            'kylechui/nvim-surround',
            opts = {}
        },
        -- Automatically Insert Text Pairs
        {
            'windwp/nvim-autopairs',
            event = 'InsertEnter',
            opts = {}
        },
        -- Keybind Help Prompt
        {
            'folke/which-key.nvim',
            opts = {}
        },
        -- Toggle Comments
        {
            'numToStr/Comment.nvim',
            opts = {}
        },
        -- Fuzzy Finder (files, lsp, etc)
        {
            'nvim-telescope/telescope.nvim',
            branch = '0.1.x',
            dependencies = {
                'nvim-lua/plenary.nvim',
                -- Fuzzy Finder Algorithm which requires local dependencies to be built.
                -- Only load if `make` is available. Make sure you have the system
                -- requirements installed.
                {
                    'nvim-telescope/telescope-fzf-native.nvim',
                    -- NOTE: If you are having trouble with this installation,
                    --       refer to the README for telescope-fzf-native for more instructions.
                    build = 'make',
                    cond = function()
                        return vim.fn.executable 'make' == 1
                    end,
                },
            },
        },
        -- Highlight, edit, and navigate code
        {
            'nvim-treesitter/nvim-treesitter',
            dependencies = {
                'nvim-treesitter/nvim-treesitter-textobjects',
            },
            build = ':TSUpdate',
        },
    },
    setup = function()
        -- Tab Behaviour
        vim.o.tabstop = 4
        vim.o.shiftwidth = 4
        vim.o.smartindent = true
        vim.o.expandtab = true

        -- Invisible Characters
        vim.o.list = true
        vim.o.listchars = 'trail:·,tab:>-'

        -- Column 80 Guide
        vim.o.cc = '81'

        -- File Encodings
        -- TODO: iconv will have support for `IBM-1047/ZOS_UNIX` soon
        vim.o.fileencodings = 'utf8,IBM-1047/ZOS_UNIX,IBM-1047'

        vim.api.nvim_create_autocmd({'FileReadPost', 'BufReadPost', 'FileWritePost', 'BufWritePost'}, {
            callback = function(args)
                local encoding = vim.api.nvim_get_option_value('fileencoding', { buf = args.buf })
                if encoding:lower() ~= 'ibm-1047' then
                    return
                end
                vim.api.nvim_set_option_value('eol', false, { buf = args.buf })
                vim.api.nvim_set_option_value('fixeol', false, { buf = args.buf })
                local ok, resul = pcall(
                    vim.cmd,
                    [[%s//\r/g]]
                )
                local ok, resul = pcall(
                    vim.cmd,
                    [[%s#\($\n\s*\)\+\%$##]]
                )
            end
        })
        vim.api.nvim_create_autocmd({'FileWritePre', 'BufWritePre'}, {
            callback = function(args)
                local encoding = vim.api.nvim_get_option_value('fileencoding', { buf = args.buf })
                if encoding:lower() ~= 'ibm-1047' then
                    return
                end
                vim.api.nvim_set_option_value('eol', false, { buf = args.buf })
                vim.api.nvim_set_option_value('fixeol', false, { buf = args.buf })
                local ok, result = pcall(
                    vim.cmd,
                    [[%s/\n//g]]
                )
            end
        })

        -- Highlight on Search
        vim.o.hlsearch = false

        -- Line Numbering
        vim.wo.number = true

        -- Enable Mouse Mode
        vim.o.mouse = 'a'

        -- Sync Clipboard with OS
        vim.o.clipboard = 'unnamedplus'

        -- Break Indent
        vim.o.breakindent = true

        -- Save Undo History
        vim.o.undofile = true

        -- Case-Insensitive Search
        vim.o.ignorecase = true
        vim.o.smartcase = true

        -- Sign Column
        vim.o.signcolumn = 'yes'

        -- Decrease Update Time
        vim.o.updatetime = 250
        vim.o.timeoutlen = 300

        -- Completion Options
        vim.o.completeopt = 'menuone,noselect'

        -- Better Colours
        vim.o.termguicolors = true

        -- Terminal
        require('toggleterm').setup{
            open_mapping = [[<C-space>]],
            insert_mappings = true,
            terminal_mappings = true,
            direction = 'float',
        }

        -- Telescope
        -- See `:help telescope` and `:help telescope.setup()`
        require('telescope').setup {
            defaults = {
                mappings = {
                    n = {
                        ['<C-d>'] = require('telescope.actions').delete_buffer,
                    },
                    i = {
                        ['<C-u>'] = false,
                        ['<C-d>'] = require('telescope.actions').delete_buffer,
                    },
                },
            },
        }

        -- Enable telescope fzf native, if installed
        pcall(require('telescope').load_extension, 'fzf')

        -- See `:help telescope.builtin`
        vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
        vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
        vim.keymap.set('n', '<leader>/', function()
            -- You can pass additional configuration to telescope to change theme, layout, etc.
            require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                winblend = 10,
                previewer = false,
            })
        end, { desc = '[/] Fuzzily search in current buffer' })
        vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
        vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
        vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
        vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
        vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
        vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
        vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]resume' })


        -- Treesitter
        -- See `:help nvim-treesitter`
        require('nvim-treesitter.configs').setup {
            -- Add languages to be installed here that you want installed for treesitter
            ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim' },

            -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
            auto_install = false,

            highlight = { enable = true },
            indent = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    --init_selection = '<c-space>',
                    --node_incremental = '<c-space>',
                    --scope_incremental = '<c-s>',
                    --node_decremental = '<M-space>',
                },
            },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ['aa'] = '@parameter.outer',
                        ['ia'] = '@parameter.inner',
                        ['af'] = '@function.outer',
                        ['if'] = '@function.inner',
                        ['ac'] = '@class.outer',
                        ['ic'] = '@class.inner',
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true, -- whether to set jumps in the jumplist
                    goto_next_start = {
                        [']m'] = '@function.outer',
                        [']]'] = '@class.outer',
                    },
                    goto_next_end = {
                        [']M'] = '@function.outer',
                        [']['] = '@class.outer',
                    },
                    goto_previous_start = {
                        ['[m'] = '@function.outer',
                        ['[['] = '@class.outer',
                    },
                    goto_previous_end = {
                        ['[M'] = '@function.outer',
                        ['[]'] = '@class.outer',
                    },
                },
                swap = {
                    enable = true,
                    swap_next = {
                        ['<leader>a'] = '@parameter.inner',
                    },
                    swap_previous = {
                        ['<leader>A'] = '@parameter.inner',
                    },
                },
            },
        }
    end,
}
