" tabnine
set number
set mouse=a
syntax enable

set showcmd
set showmatch
set relativenumber

call plug#begin('~/.vim/plugged')

" Theme
Plug 'sainnhe/gruvbox-material'

" LSP
Plug 'neovim/nvim-lspconfig'

" autocomplete nvim-cmp
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" For vsnip users. Snippets
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'rafamadriz/friendly-snippets'

" For ultisnips users.
Plug 'SirVer/ultisnips'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'

" formatting
Plug 'sbdchd/neoformat'

" indent
Plug 'lukas-reineke/indent-blankline.nvim'

" Emparejar comillas, parentesis, etc...
Plug 'windwp/nvim-autopairs'

" Envolver
Plug 'tpope/vim-surround'

" nvim-tree
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-tree/nvim-tree.lua'

" toogleTerm
Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}

" barra de funcion
Plug 'lewis6991/gitsigns.nvim'
Plug 'feline-nvim/feline.nvim'

" pestañas
Plug 'romgrk/barbar.nvim'

" tabnine
Plug 'tzachar/cmp-tabnine', { 'do': './install.sh' }

call plug#end()

" gruvbox config
set background=dark
let g:gruvbox_material_background='medium'
colorscheme gruvbox-material

" nvim-cmp
set completeopt=menu,menuone,noselect

lua <<EOF
  -- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig')['pyright'].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
  require 'lspconfig'.bashls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { 'zsh', 'bash', 'sh' },
  }
  require'lspconfig'.volar.setup{
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json'},
  }
  USER = vim.fn.expand('$USER')

  local sumneko_root_path = ""
  local sumneko_binary = ""

  if vim.fn.has("mac") == 1 then
    sumneko_root_path = "/Users/" .. USER .. "/.config/nvim/lua-language-server"
    sumneko_binary = "/Users/" .. USER .. "/.config/nvim/lua-language-server/bin/macOS/lua-language-server"
  elseif vim.fn.has("unix") == 1 then
    sumneko_root_path = "/usr/bin/lua-language-server"
    sumneko_binary = "/usr/bin/lua-language-server"
  else
    print("Unsupported system for sumneko")
  end

  require'lspconfig'.sumneko_lua.setup {
    cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Setup your lua path
                path = vim.split(package.path, ';')
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim'}
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = {[vim.fn.expand('$VIMRUNTIME/lua')] = true, [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true}
            }
        }
    },
    filetypes = { 'lua' },
  }
  require("nvim-autopairs").setup {}
  -- examples for your init.lua

  -- disable netrw at the very start of your init.lua (strongly advised)
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

  -- set termguicolors to enable highlight groups
  vim.opt.termguicolors = true

  -- empty setup using defaults
  require("nvim-tree").setup()
  require("toggleterm").setup{}
  require('gitsigns').setup() 
  require('feline').setup()
  require'cmp'.setup {
    sources = {
 	{ name = 'cmp_tabnine' },
    },
  }
  
EOF


" Atajos de teclado
noremap <C-s> :w<CR>


" Copiar al portapapeles
vnoremap <C-c> "+y
nnoremap <C-c> "+y

" Cortar al portapapeles
vnoremap <C-x> "+d
nnoremap <C-x> "+d

" Pegar desde el portapapeles
nnoremap <C-p> "+P
vnoremap <C-p> "+P

" comandos envolver codigo (vim-surround)
" cs'" cambia las comillas simples por dobles
" ds" elimina comillas dobles
" ys" añade comillas "dobles"
