practice.nvim
================

A plugin for practicing NeoVim.
Inspired by [VimBeGood](https://github.com/ThePrimeagen/vim-be-good) 

## Installation

Lazy

```lua
{
    "doriancmore/practice.nvim",
    config = function()
        require('practice').setup()
    end
}
```

## Usage

```vim
:StartTypingChallenge 10
```

### Using a keymap

```lua
{
    "doriancmore/practice.nvim",
    config = function()
        local practice = require('practice')
        practice.setup()
        vim.keymap.set("n", "<leader>pc", function()
            practice.start(10)
        end, { desc = "Practice" })
    end
}
```

Where 10 is the number of challenges you'd like to complete.
