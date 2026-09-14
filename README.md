# Alabaster Dark

A Neovim colorscheme with a minimal amount of highlighting. Port of
[vscode-theme-alabaster-dark](https://github.com/liangpengyv/vscode-theme-alabaster-dark),
which follows
[Tonksy’s syntax highlighting notes](https://tonsky.me/blog/syntax-highlighting/).

This theme as it is right now is custom built for my needs and thus assumes some
custom setting elsewhere.

Most schemes color everything they can. This one colors four classes:

1. Strings
2. Statically known constants (numbers, symbols, `true` / `false` / `nil`)
3. Comments
4. Global definitions

Language keywords (`if`, `else`, `function`, …) stay at the editor foreground.
Punctuation is dimmed. There are no italics or bold on syntax.

Closest parity with the VSCode theme needs Treesitter highlighting and LSP
semantic tokens. Regex syntax is a fallback.

[rainbow-delimiters.nvim](https://github.com/HiPhish/rainbow-delimiters.nvim)
uses `RainbowDelimiter1`–`5` (nesting levels, not hue names). Point the plugin
at those groups.

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
