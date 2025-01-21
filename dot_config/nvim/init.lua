-- 文字コード設定
vim.opt.encoding = 'utf-8'
vim.scriptencoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'
vim.opt.fileencodings = 'ucs-bom,utf-8,euc-jp,cp932'
vim.opt.fileformats = 'unix,dos,mac'
vim.opt.ambiwidth = 'double'

-- バックアップ等ファイル設定(*.swpだけ作って*.~や*.un~を作らない
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = false
vim.opt.writebackup = true
vim.opt.hidden = true

-- 行番号表示
vim.opt.number = true
-- 現在の行を強調表示
vim.opt.cursorline = true
-- スマートインデント
vim.opt.smartindent = true
-- ビープ音を可視化
vim.opt.visualbell = true
-- 対応括弧表示
vim.opt.showmatch = true
-- ステータスラインを常に表示
vim.opt.laststatus = 2
-- コマンドラインでタブ補完
vim.opt.wildmenu = true
-- シンタックスハイライトの有効化
vim.cmd('syntax on')

-- 不可視文字表示
vim.opt.list = true
vim.opt.listchars={tab = '»-', trail = '･', eol = '↲', extends = '»', precedes = '«',nbsp = '%'}
-- tabを半角スペースに
vim.opt.expandtab = true
-- tab表示幅
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- 小文字で検索した場合は大文字もヒット
vim.opt.ignorecase = true
-- 大文字含みで検索した場合は区別して検索
vim.opt.smartcase = true
-- インクリメンタルサーチ
vim.opt.incsearch = true
-- 検索で最後までいったら最初に戻る
vim.opt.wrapscan = true
-- 検索語をハイライト
vim.opt.hlsearch = true
-- ESC連打でハイライト解除
vim.keymap.set('n', '<Esc><Esc>', ':nohlsearch<CR><Esc>', {remap = true})

-- インサートモードをEmacsライクに
vim.keymap.set('i', '<C-d>', '<Del>', { remap = true })
vim.keymap.set('i', '<C-h>', '<BS>', { remap = true })
vim.keymap.set('i', '<C-a>', '<home>', { remap = true })
vim.keymap.set('i', '<C-e>', '<End>', { remap = true })
vim.keymap.set('i', '<C-p>', '<Up>', { remap = true })
vim.keymap.set('i', '<C-n>', '<Down>', { remap = true })
vim.keymap.set('i', '<C-f>', '<right>', { remap = true })
vim.keymap.set('i', '<C-b>', '<left>', { remap = true })


-- プラグインマネージャ(JetPack)
local jetpackfile = vim.fn.stdpath('data') .. '/site/pack/jetpack/opt/vim-jetpack/plugin/jetpack.vim'
local jetpackurl = 'https://raw.githubusercontent.com/tani/vim-jetpack/master/plugin/jetpack.vim'
if vim.fn.filereadable(jetpackfile) == 0 then
  vim.fn.system('curl -fsSLo ' .. jetpackfile .. ' --create-dirs ' .. jetpackurl)
end

vim.cmd('packadd vim-jetpack')
require('jetpack.packer').add {
  -- JetPack本体
  'tani/vim-jetpack',
  -- ファジーファインダ(telescoope)
  {'nvim-telescope/telescope.nvim',
   requires = {{'nvim-lua/plenary.nvim'}}
 }
}

-- ファジーファインダ(telescoope)
require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ["<C-h>"] = "which_key"
      }
    }
  },
  pickers = {
  },
  extensions = {
  }
}

