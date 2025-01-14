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

call plug#end()

" NvimTree setup
lua require("nvim-tree").setup()

" Numbers on the left side
set relativenumber
" Change number highlight color
highlight LineNr ctermfg=238

" Set and highlight the cursorline
set cursorlineopt=screenline
hi cursorline cterm=none term=none
highlight CursorLine guibg=#303000 ctermbg=237

" nvim-cursorline config
lua << EOF
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
EOF

lua require('lualine').setup()

let g:coq_settings = { 'auto_start': v:true }
