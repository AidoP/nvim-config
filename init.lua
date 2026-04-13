-- Disable unused built-in features
vim.g.loaded_node_provider = 0;
vim.g.loaded_perl_provider = 0;
vim.g.loaded_python3_provider = 0;
vim.g.loaded_ruby_provider = 0;

-- Binding
vim.g.mapleader = " ";
vim.g.maplocalleader = " ";

-- Netrw
vim.g.netrw_liststyle = 1
vim.g.netrw_liststyle = 1
vim.keymap.set("n", "<Leader>ft", "<cmd>Explore<CR>", {desc = "File Tree"})

-- Editor Basics
vim.o.autocomplete = false;
vim.o.clipboard = 'unnamedplus';
vim.o.colorcolumn = "80";
vim.o.completeopt = "menuone,noselect,popup";
vim.o.expandtab = true;
vim.o.fileencodings = 'utf8,IBM-1047/ZOS_UNIX,IBM-1047'
vim.o.hlsearch = false;
vim.o.ignorecase = true;
vim.o.list = true;
vim.o.listchars = 'trail:·,tab:>-'
vim.o.mouse = 'a';
vim.o.shiftwidth = 4;
vim.o.signcolumn = "yes";
vim.o.smartcase = true;
vim.o.smartindent = true;
vim.o.tabstop = 4;
vim.o.termguicolors = true;
vim.o.timeout = true;
vim.o.timeoutlen = 1000;
vim.o.undofile = true;
vim.wo.number = true;
vim.wo.relativenumber = true;

-- Diagnostics
vim.diagnostic.config({
    severity_sort = true,
    signs = true,
    underline = true,
    virtual_lines = true,
    virtual_text = false,
});


-- Packages
vim.pack.add({
    "https://github.com/folke/which-key.nvim",
    "https://github.com/ibhagwan/fzf-lua",
    "https://github.com/j-hui/fidget.nvim",
    "https://github.com/lewis6991/gitsigns.nvim",
    "https://github.com/nvim-lualine/lualine.nvim",
    "https://github.com/nvim-tree/nvim-web-devicons",
});
local plugin = {
    fidget = require("fidget"),
    fzf = require("fzf-lua"),
    gitsigns = require("gitsigns"),
    lualine = require('lualine'),
    which_key = require("which-key"),
};

vim.cmd("packadd nvim.undotree")
vim.cmd("packadd nvim.difftool")

plugin.which_key.setup({});
plugin.fidget.setup({});

-- plugin.lualine.setup({
--     options = {
--         icons_enabled = true,
--         theme = "auto",
--         component_separators = "│",
--         section_separators = "",
--     },
-- });

-- Git Integration
plugin.gitsigns.setup({
    -- See `:help gitsigns.txt`
    diff_opts = {
        vertical = true,
    },
    signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
    },
    on_attach = function(bufnr)
        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end
        map('n', ']c', function()
            if vim.wo.diff then
                vim.cmd.normal({']c', bang = true})
            else
                plugin.gitsigns.nav_hunk('next')
            end
        end, {desc="Next Change"})


        map('n', '[c', function()
            if vim.wo.diff then
                vim.cmd.normal({'[c', bang = true})
            else
                plugin.gitsigns.nav_hunk('prev')
            end
        end, {desc="Previous Change"})
    end,
});
vim.keymap.set("n", "<Leader>gb", function() plugin.gitsigns.blame() end, {desc = "Git Blame"})
vim.keymap.set("n", "<Leader>gp", function() plugin.gitsigns.preview_hunk_inline() end, {desc = "Preview Git Hunk"})
vim.keymap.set("n", "<Leader>gs", function() plugin.gitsigns.stage_hunk() end, {desc = "Git Stage Hunk"})
vim.keymap.set("n", "<Leader>ggs", function() plugin.gitsigns.stage_buffer() end, {desc = "Git Stage Buffer"})

-- Pop-Up Search Window
plugin.fzf.setup({
    "fzf-native",
    winopts = {
        fullscreen = true,
    },
});
vim.keymap.set("n", "<Leader> ", function() plugin.fzf.buffers() end, {desc = "Buffers"})
vim.keymap.set("n", "<Leader>/", function() plugin.fzf.lgrep_curbuf() end, {desc = "Search Buffer"})
vim.keymap.set("n", "<Leader>q", function() plugin.fzf.diagnostics_document() end, {desc = "Diagnostics"})
vim.keymap.set("n", "<Leader>sf", function() plugin.fzf.files() end, {desc = "Search File Names"})
vim.keymap.set("n", "<Leader>sg", function() plugin.fzf.live_grep() end, {desc = "Search Global"})
vim.keymap.set("n", "<Leader>sq", function() plugin.fzf.diagnostics_workspace() end, {desc = "Search Diagnostics"})
vim.keymap.set("n", "<Leader>sd", function() plugin.fzf.git_diff() end, {desc = "Search Git Diffs"})
vim.keymap.set("n", "<Leader>la", function() plugin.fzf.lsp_code_actions() end, {desc = "[L]SP [A]ctions"})
vim.keymap.set("n", "<Leader>lr", function() plugin.fzf.lsp_references() end, {desc = "[L]SP [R]eferences"})
vim.keymap.set("n", "<Leader>lg", function() plugin.fzf.lsp_workspace_symbols() end, {desc = "[L]SP [G]lobal Symbol"})
vim.keymap.set("n", "<Leader>ll", function() plugin.fzf.lsp_document_symbols() end, {desc = "[L]SP [L]ocal Symbol"})


-- LSP
vim.lsp.inlay_hint.enable(true)
vim.lsp.codelens.enable()

vim.keymap.set('i', '<C-space>', vim.lsp.completion.get, {desc = "Autocomplete"})
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client then
            if client:supports_method('textDocument/completion') then
                vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
            end
            if client:supports_method('textDocument/linkedEditingRange') then
                vim.lsp.linked_editing_range.enable(true, { client_id = client.id })
            end
        end
    end
});

vim.lsp.config['lua'] = {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { '.git' },
    settings = {
        Lua = {
            telemetry = { enable = false },
        },
    },
    on_init = function(client)
        local join = vim.fs.joinpath
        if client.workspace_folders then
            local path = client.workspace_folders[1].name

            -- Don't do anything if there is project local config
            if vim.uv.fs_stat(join(path, '.luarc.json')) or vim.uv.fs_stat(join(path, '.luarc.jsonc')) then
                return
            end
        end

        local nvim_settings = {
            runtime = {
                -- Tell the language server which version of Lua you're using
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim'}
            },
            workspace = {
                checkThirdParty = false,
                library = {
                    -- Make the server aware of Neovim runtime files
                    vim.env.VIMRUNTIME,
                    vim.fn.stdpath('config'),
                },
            },
        }

        client.config.settings.Lua = vim.tbl_deep_extend(
            'force',
            nvim_settings,
            client.config.settings.Lua
        )
    end,
};

vim.lsp.config['rust'] = {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    root_markers = { 'Cargo.lock', '.git' },
    settings = {
        ['rust-analyzer'] = {
        },
    },
};

vim.lsp.config['clangd'] = {
    cmd = { 'clangd' },
    filetypes = { 'c', 'cpp' },
    root_markers = { '.clangd', '.git' },
    settings = {},
};

vim.lsp.enable({'lua', 'rust', 'clangd'})


-- Status Line
Statusline = {
    group = vim.api.nvim_create_augroup("statusline", { clear = true }),
};
function Statusline.active()
    return table.concat({
        " %f ",
        "%=",
        vim.diagnostic.status(),
        " %y %#Normal# %p%% %#StatusLine# %l:%c %o"
    });
end
function Statusline.inactive()
    return "%f%=%y";
end
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    group = Statusline.group,
    desc = "Activate statusline on focus",
    callback = function()
        vim.opt_local.statusline = "%!v:lua.Statusline.active()";
    end,
})
vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
    group = Statusline.group,
    desc = "Deactivate statusline on focus",
    callback = function()
        vim.opt_local.statusline = "%!v:lua.Statusline.inactive()";
    end,
})
