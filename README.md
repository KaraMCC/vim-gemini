# vim-gemini
vim-gemini is a customizable vim plugin that automatically adds closing, parenthesis, brackets, quotes, and more!

<br/>

![Gemini Gif](https://user-images.githubusercontent.com/56435971/68540940-42799300-0367-11ea-9389-cc77efafc4c2.gif)

# How do I use it?
Simply type a character that vim-gemini is built to handle, and the plugin will automatically add the closing counterpart.
```
What is typed: ("|
What appears ("|")
```

```
What is typed: if(foo {<CR>|
What appears:
if(foo) {
|
}
```
Without modifiying any settings, vim-gemini should start working as soon as it's installed.

<br/>

# Settings
### How do I define custom pairs for gemini to complete?
Add this to your .vimrc. The first argument <filetype> is what type of file the matching will take place in. The second argument is a list containing the opening character and the closing character in position 0 and position 1 respectively.
```
let g:gemini#match_list = {
            \'<filetype>': [['<open>', '<close>']]
            \}
```

<br/>

You can use regex to expand the use of filetype matches. The example below will allow Gemini to close carets and parentheses, but only when editing an html or xml file.
```
let g:gemini#match_list = {
            \'html\|xml': [['<', '>'], ['(', ')']]
            \}
```

<br/>

Regex can also be used to define universal matches. The example below will automatically close curly brackets and parentheses when editing any file.
```
let g:gemini#match_list = {
            \'.*': [['{', '}'], ['(', ')']]
            \}
```

<br/>

### How do I change the default matches that Gemini uses?
The plugin uses a list of default matches which can be edited by the user by modifying the global variable ```g:gemini#default_matches```. In the example below the default matches are changed such to allow only automatically adding brackets.
```
let g:gemini#default_matches = {
            \'.*': [['[', ']']],
            \}
```

<br/>

### How do I allow Gemini to match characters in comments?
By default, Gemini will detect when your cursor is in a commented out area of text, and not complete the matches. You can let the plugin match characters simply by adding this to your .vimrc.
```
let g:gemini#match_in_comment = 1
```

<br/>

### How do I disable matching when the cursor is imediately before a character?
By default, Gemini will append matching characters when the cursor is positioned immediately before a non-whitespace characer. You can disable matching in that scenario by putting ```let g:gemini#cozy_matching = 0``` in your .vimrc. This will make sure Gemini only appends matching characters when there is extra room around the cursor.

<br/>

# Installation
#### With [pathogen](https://github.com/tpope/vim-pathogen):
```
cd ~/.vim/bundle && \
git clone https://github.com/KaraMCC/vim-gemini.git
```

#### With [vim-plug](https://github.com/junegunn/vim-plug):
```
Plug 'KaraMCC/vim-gemini'
```

#### With [Vundle](https://github.com/VundleVim/Vundle.vim):
```
Plugin 'KaraMCC/vim-gemini'
```
