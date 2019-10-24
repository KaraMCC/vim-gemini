# vim-gemini
vim-gemini is a customizable vim plugin that automatically adds closing, parenthesis, brackets, quotes, and more!<br/>

# How do I use it?
Simply type a character that vim-gemini is built to handle, and the plugin will easily add the closing counterpart.
```
What is typed: ("|
What appears ("|")
```

```
What is typed: if(foo { <Enter>|
What appears:
if(foo) {
|
}
```
Without modifiying any settings, vim-gemini should work automatically as soon as it's installed.

<br/>

# Settings
### How do I define custom pairs for gemini to complete?
Add this to your .vimrc, the first character is the one that you type to trigger the completion, and the second is the one that is added after.
```
let g:gemini_match_list['<open>', '<close>']
```

<br/>

The example below will automatically add a closing caret, when an opening caret is typed.
```
             Character that's typed
                         |  Character that gets added
                         |    |
let g:gemini_match_list['<', '>']
```

<br/>

### How do I define custom pairs that are filetype specific?
Add this to your .vimrc, replacing the words in carets with the ones you want.
```
let g:gemini_filetype_match_list = {'<filetype>': [['<open>', '<close>']] }
```

The example below will automatically pair "{" and "}" but only when editing a C file.
```
let g:gemini_filetype_match_list = {'c': [['{', '}']] }
```

<br/>

This example will automatically pair "(" and ")" but only when editing a python file, and automatically pair "<", and ">", but only when editing an HTML file.
```
let g:gemini_filetype_match_list = {'python': [['(', ')']], 'html': [['<', '>']] }
```

<br/>

And finally this example will pair "{", "}", and "(", ")" but only when editing a C++ file.
```
let g:gemini_filetype_match_list = {'cpp': [['{', '}'], ['(', ')']] }
```

<br/>

# Installation
With [pathogen](https://github.com/tpope/vim-pathogen):
```
cd ~/.vim/bundle && \
git clone https://github.com/KaraMCC/vim-gemini.git
```

With [vim-plug](https://github.com/junegunn/vim-plug):
```vim
Plug 'KaraMCC/vim-gemini'
```

With [Vundle](https://github.com/VundleVim/Vundle.vim):
```vim
Plugin 'KaraMCC/vim-gemini'
```
