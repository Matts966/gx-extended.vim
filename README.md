# gx-extended.vim

Extend `gx` to use it beyond just URLs!

## Features

- Open anything under your cursor with several providers per file type
- Normal and visual mode support
- Providers that work across all file types
- Fall back to the original `gx` command if all providers fail
- Implement your own providers

## Installation

Install using [vim-plug](https://github.com/junegunn/vim-plug).
Put this in your `init.vim`/`.vimrc`.

```vim
Plug 'stsewd/gx-extended.vim'
```

## Available providers

### global

Providers available in all file types.

- `global#urls`: Open links without an explicit protocol
   * `google.com` will open `https://google.com`
- `global#gx`: Mimics the original `gx` command

### vim

- `vim#openplugin`: Open the GitHub page of the plugin under the cursor
  * `Plug stsewd/fzf-checkout.vim` will open `https://github.com/stsewd/fzf-checkout.vim`

### TODO

- rst?
- markdown?
- requirements.txt?

## Mappings

If you don't define these mappings, `gx` is used by default.

```vim
nmap gx <Plug>(gxext-normal)
vmap gx <Plug>(gxext-visual)
```

## Settings

Default values are shown in the code blocks.

### g:gxext#custom

List of custom providers (`language#providername`).
The order is respected when executing this providers.
Use it only if you want to add custom providers without changing the default ones.
These have priority over the ones listed in `g:gxext#load`.

```vim
let g:gxext#custom = []
```

### g:gxext#load

List of active providers (`language#providername`).
The order is respected when executing this providers.

```vim
let g:gxext#load = [
      \ 'vim#openplugin',
      \ 'global#urls',
      \]
```

## Writing your own provider

_If you think this provider is something more people will use, feel free to open a PR!_

List your provider in your `init.vim`/`.vimrc`:

```vim
let g:gxext_custom = ['language#myprovider']
```

Create a file in your Vim runtime path `autoload/gxext/language/myprovider.vim` with a function called `open`:

```vim
" Returns 1 if it was able to parse/open the thing under the cursor
function! gxext#language#myprovider#open(line, mode)
  return 0
endfunction
```

The argumente passed to the function are:

- line: `extend('<cfile>')` if mode is `normal` or the selection from the first line if mode is `visual`
- mode: `normal` or `visual`

Note: these argumente can be useful, but aren't required to be used.
You can get the information from the current line or buffer using any of the Vim builtin functions.

Note: If you want your function to be called over all file types, use `global` as language.

See [autoload/gxext/](autoload/gxext/) for examples.

## Do I need this plugin?

If you press `gx` when the cursor is under an URL,
the URL will open in a new tab in your browser or in your file explorer.
This functionality is provided by default by `Netrw`
(the default file explorer included in Vim).
_You can extend_ `Netrw`, see `:h netrw_filehandler`,
but it has its limitations:

- You can only extend it to support new suffixes (.doc, .csv, etc).
- If you override the `gx` mapping, you'll loose the default behavior of `gx`.

If you don't care about any of those things,
then you are probably fine without this plugin.
