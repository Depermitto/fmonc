call plug#begin()


" NvimTree and icons
Plug 'nvim-tree/nvim-web-devicons' 
Plug 'nvim-tree/nvim-tree.lua'

" Cursorline
Plug 'yamatsum/nvim-cursorline' 

" Statusline
Plug 'nvim-lualine/lualine.nvim'

" Tabs
Plug 'romgrk/barbar.nvim'

" COQ
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}

" Polygot
Plug 'sheerun/vim-polyglot'

" LSP
Plug 'neovim/nvim-lspconfig'

" Rust
Plug 'simrat39/rust-tools.nvim'


call plug#end()

" Python provider
let g:python3_host_prog = '/usr/bin/python3'


" LSP
lua require'lspconfig'.pyright.setup{}
lua require'lspconfig'.bashls.setup{}
lua require'lspconfig'.vimls.setup{}


" NvimTree setup
lua require("nvim-tree").setup()


" Numbers on the left side
set number relativenumber


" Change number highlight color
highlight LineNr ctermfg=238


" Set and highlight the lualine and cursorline
lua require('lualine').setup()
set cursorlineopt=screenline
hi cursorline cterm=none term=none
highlight CursorLine guibg=#303000 ctermbg=237


" Set autocomplete COQ
let g:coq_settings = { 'auto_start': v:true }


" Clipboard
set clipboard=unnamedplus


" Polybar
set ft=dosini


" Nvim-cursorline config "
lua << CURSORLINE
require('nvim-cursorline').setup {
  cursorline = {
    enable = true,
    timeout = 1000,
    number = true,
  },
  cursorword = {
    enable = true,
    min_length = 3,
    hl = { underline = true },
  }
}
CURSORLINE

" Rust "
lua << RUST
local rt = require("rust-tools")

rt.setup({
  server = {
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
})
RUST
