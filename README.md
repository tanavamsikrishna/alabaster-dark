# Alabaster Dark

A Neovim colorscheme with a minimal amount of highlighting. Port of
[vscode-theme-alabaster-dark](https://github.com/liangpengyv/vscode-theme-alabaster-dark),
which follows [Tonksy’s syntax highlighting notes](https://tonsky.me/blog/syntax-highlighting/).

Most schemes color everything they can. This one colors four classes:

1. Strings
2. Statically known constants (numbers, symbols, `true` / `false` / `nil`)
3. Comments
4. Global definitions

Language keywords (`if`, `else`, `function`, …) stay at the editor foreground.
Punctuation is dimmed. There are no italics or bold on syntax.

Closest parity with the VSCode theme needs Treesitter highlighting and LSP
semantic tokens. Regex syntax is a fallback.

Rainbow bracket coloring is not part of this scheme. Use
[rainbow-delimiters.nvim](https://github.com/HiPhish/rainbow-delimiters.nvim)
if you want that.

Requires Neovim 0.10+.

## Usage

```lua
vim.o.termguicolors = true
vim.o.background = "dark"
vim.cmd.colorscheme("alabaster-dark")
```

With [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "tanavamsikrishna/alabaster-dark",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("alabaster-dark")
  end,
}
```

## License

MIT
