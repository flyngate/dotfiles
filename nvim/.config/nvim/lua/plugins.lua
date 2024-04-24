return {
  -- experimental
  {
    'voldikss/vim-floaterm',
    keys = {
      { '<c-t>', '<cmd>FloatermToggle<cr>' },
    },
    config = function()
      vim.cmd [[
        let g:floaterm_width = 0.9
        let g:floaterm_height = 0.9
        let g:floaterm_position = 'top'

        tnoremap <silent> <c-t> <c-\><c-n>:FloatermToggle<cr>
      ]]
    end
  },
  {
    'mhinz/vim-startify',
    config = function()
      vim.cmd [[
        let g:startify_change_to_dir = 0
        let g:startify_change_to_vcs_root = 1
      ]]
    end
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require'harpoon'

      harpoon.setup()

      vim.keymap.set("n", "<leader>h", function() harpoon:list():append() end)
      vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

      vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
      vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
      vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
      vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)

      vim.keymap.set("n", "[h", function() harpoon:list():prev() end)
      vim.keymap.set("n", "]h", function() harpoon:list():next() end)
    end
  },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = function()
      local npairs = require'nvim-autopairs'
      local Rule = require'nvim-autopairs.rule'
      local cond = require 'nvim-autopairs.conds'

      npairs.setup {
        map_cr = false
      }

      local brackets = { { '(', ')' }, { '[', ']' }, { '{', '}' } }
      npairs.add_rules {
        -- Rule for a pair with left-side ' ' and right side ' '
        Rule(' ', ' ')
          -- Pair will only occur if the conditional function returns true
          :with_pair(function(opts)
            -- We are checking if we are inserting a space in (), [], or {}
            local pair = opts.line:sub(opts.col - 1, opts.col)
            return vim.tbl_contains({
              brackets[1][1] .. brackets[1][2],
              brackets[2][1] .. brackets[2][2],
              brackets[3][1] .. brackets[3][2]
            }, pair)
          end)
          :with_move(cond.none())
          :with_cr(cond.none())
          -- We only want to delete the pair of spaces when the cursor is as such: ( | )
          :with_del(function(opts)
            local col = vim.api.nvim_win_get_cursor(0)[2]
            local context = opts.line:sub(col - 1, col + 2)
            return vim.tbl_contains({
              brackets[1][1] .. '  ' .. brackets[1][2],
              brackets[2][1] .. '  ' .. brackets[2][2],
              brackets[3][1] .. '  ' .. brackets[3][2]
            }, context)
          end)
      }
      -- For each pair of brackets we will add another rule
      for _, bracket in pairs(brackets) do
        npairs.add_rules {
          -- Each of these rules is for a pair with left-side '( ' and right-side ' )' for each bracket type
          Rule(bracket[1] .. ' ', ' ' .. bracket[2])
            :with_pair(cond.none())
            :with_move(function(opts) return opts.char == bracket[2] end)
            :with_del(cond.none())
            :use_key(bracket[2])
            -- Removes the trailing whitespace that can occur without this
            :replace_map_cr(function(_) return '<C-c>2xi<CR><C-c>O' end)
        }
      end
    end
  },
  {
    'nvim-tree/nvim-tree.lua',
    keys = {
      { '-', '<cmd>NvimTreeToggle<cr>' }
    },
    opts = {
      filesystem_watchers = {
        ignore_dirs = {
          "node_modules"
        },
      },
      actions = {
        open_file = {
          quit_on_open = true
        },
      },
      update_focused_file = {
        enable = true,
        update_root = {
          enable = true,
        },
      },
      filters = {
        enable = true,
        git_ignored = false,
      },
      renderer = {
        add_trailing = true,
        icons = {
          show = {
            file = false,
            folder = false,
            folder_arrow = false,
            git = false,
            modified = false,
            diagnostics = false,
            bookmarks = false,
          }
        }
      }
    },
  },

  -- core
  { 'tpope/vim-surround' },
  { 'tpope/vim-unimpaired' },
  { 'tpope/vim-commentary' },
  { 
    'Julian/vim-textobj-variable-segment',
    dependencies = { 'kana/vim-textobj-user'},
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      enable = true,
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },

      ensure_installed = {
        "c",
        "cpp",
        "rust",
        "python",
        "lua",
        "javascript",
        "typescript",
        "tsx",
        "html",
        "css",
        "svelte",
        "bash",
        "vim",
        "json",
        "yaml",
        "toml",
        "markdown",
      },

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<m-o>",
          node_incremental = "<m-o>",
        },
      },

      textobjects = {
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]m"] = "@function.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
          },
        },

        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            -- You can optionally set descriptions to the mappings (used in the desc parameter of
            -- nvim_buf_set_keymap) which plugins like which-key display
            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
          },

          selection_modes = {
            ['@function.outer'] = 'V',
            ['@class.outer'] = 'V',
          },
        },

        swap = {
          enable = true,
          swap_next = { ["]s"] = "@parameter.inner" },
          swap_previous = { ["[s"] = "@parameter.inner" },
        },
      },
    },
  },
  { "nvim-treesitter/nvim-treesitter-textobjects" },

  -- colorscheme
  { 'sam4llis/nvim-tundra' },

  -- navigation and search
  {
    'ibhagwan/fzf-lua',
    config = function()
      require('fzf-lua').setup()
      -- require('fzf-lua').setup({ 'skim' })

      vim.cmd [[
        nnoremap <c-p> :FzfLua files<cr>
        " nnoremap <leader>F :FzfLua files cwd=%:p:h<cr>
        nnoremap <leader>b :FzfLua buffers<cr>
        nnoremap <leader>g :FzfLua git_status<cr>
        " nnoremap <leader>h :FzfLua oldfiles<cr>

        command! Ch :FzfLua git_branches
        ]]
    end
  },
  {
    'dyng/ctrlsf.vim',
    config = function()
      vim.cmd [[
        nmap <leader>a <Plug>CtrlSFPrompt
        nmap <leader>s <Plug>CtrlSFCCwordPath
        vmap <leader>s <Plug>CtrlSFVwordExec
        nmap <leader>A :CtrlSFToggle<cr>

        let g:ctrlsf_auto_focus = {
        \ "at": "start"
        \ }
        let g:ctrlsf_populate_qflist = 1
        let g:ctrlsf_auto_preview = 1
        ]]
    end
  },
  { 'christoomey/vim-tmux-navigator' },

  -- lsp and autocompletion
  {
    'neoclide/coc.nvim',
    branch = 'release',
    config = function()
      vim.cmd [[
        let g:coc_global_extensions = [
          \ "coc-tsserver",
          \ "coc-prettier",
          \ "coc-eslint",
          \ "coc-clangd",
          \ "coc-rust-analyzer",
          \ "coc-sourcekit"
        \ ]

        " having longer updatetime (default is 4000 ms = 4s) leads to noticeable
        " delays and poor user experience
        set updatetime=300

        " always show the signcolumn, otherwise it would shift the text each time
        " diagnostics appear/become resolved
        set signcolumn=yes

        function! CheckBackspace() abort
          let col = col('.') - 1
          return !col || getline('.')[col - 1]  =~# '\s'
        endfunction

        inoremap <silent><expr> <TAB>
          \ coc#pum#visible() ? coc#pum#next(1) :
          \ CheckBackspace() ? "\<Tab>" :
          \ coc#refresh()

        inoremap <expr><S-TAB>
          \ coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

        inoremap <silent><expr> <CR>
          \ coc#pum#visible() ? coc#pum#confirm() :
          \ "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

        " use K to show documentation in preview window
        nnoremap <silent> K :call ShowDocumentation()<CR>

        function! ShowDocumentation()
          if CocAction('hasProvider', 'hover')
            call CocActionAsync('doHover')
          else
            call feedkeys('K', 'in')
          endif
        endfunction

        nmap <silent> [r <Plug>(coc-diagnostic-prev)
        nmap <silent> ]r <Plug>(coc-diagnostic-next)
        nmap <silent> gd <Plug>(coc-definition)
        nmap <silent> gy <Plug>(coc-type-definition)
        nmap <silent> gi <Plug>(coc-implementation)
        nmap <silent> gr <Plug>(coc-references)
        nmap <silent> <leader>k <Plug>(coc-codeaction)
        nmap <silent> <leader>rn <Plug>(coc-rename)
        vmap <silent> <leader>f <Plug>(coc-format-selected)
        nmap <silent> <leader>f :call CocActionAsync('format')<cr>
        ]]
    end,
  },

  -- git
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        map('n', ']c', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, {expr=true})

        map('n', '[c', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, {expr=true})
      end
    },
  },
}
