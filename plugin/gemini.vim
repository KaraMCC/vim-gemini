if exists('g:loaded_gemini_plugin')
    finish
endif
let g:loaded_gemini_plugin = 1

function! s:Init()
    call s:CreateMatchList()
    augroup init
        autocmd!
        autocmd BufEnter * call <SID>CreateMatchList()
    augroup END
    inoremap <expr><BS> <SID>TryDeletePair()
endfunction

function! s:CreateMatchList()
    " Define basic matches
    let b:match_chars = [['(', ')'], ['{', '}'], ['[', ']'], ["'", "'"]]
    " Add user-defined matches
    let b:match_chars += get(g:, 'gemini_match_list', [])

    " Check if filetype dictionary has the current filetype, if so,
    " add the match specified to the list
    if has_key(get(g:, 'gemini_filetype_match_list', {}), &filetype)
        let b:match_chars += g:gemini_filetype_match_list[&filetype]
    endif

    if &filetype !=? 'vim'
        let b:match_chars += [['"', '"']]
    endif
    if &filetype =~? '.*html'
        let b:match_chars += [['<', '>']]
    endif
    call s:CreateMappings()
endfunction

function! s:CreateMappings()
    for matches in b:match_chars
        if matches[0] !=# matches[1]
            execute printf('inoremap <buffer><expr>%s <SID>TryClosePair("\%s","\%s")', matches[0], matches[0], matches[1])
            execute printf('inoremap <buffer><expr>%s <SID>OnClosingCharacter("\%s")', matches[1], matches[1])
        else
            execute printf('inoremap <buffer><expr>%s <SID>TryCloseDuplicatePair("\%s")', matches[0], matches[1])
        endif
    endfor
endfunction

function! s:TryClosePair(open, close)
    " Append closing character if a:close doesn't appear before cursor,
    " and line isn't commented
    if stridx(getline('.'), a:close, col('.') - 1) == -1 && !s:IsComment()
        return a:open . a:close . "\<left>"
    endif
    return a:open
endfunction

function! s:TryDeletePair()
    for chars in b:match_chars
        " If the opening character is deleted, also delete the closing one
        if getline('.')[col('.')-2] ==# chars[0] && getline('.')[col('.')-1] ==# chars[1]
            return "\<right>" . "\<BS>" . "\<BS>"
        endif
    endfor
    return "\<BS>"
endfunction

function! s:OnClosingCharacter(close)
    " If pair of characters is already closed, move right
    if getline('.')[col('.')-1] ==# a:close
        return "\<right>"
    else
        return a:close
    endif
endfunction

function! s:TryCloseDuplicatePair(char)
    " If the specified character is adjacent to the cursor, do not repeat
    if stridx(getline('.'), a:char, col('.') - 2) == -1 && !s:IsComment()
        " Don't close if only one of a:char exists on the line
        if count(getline('.'), a:char) % 2 == 0
            return repeat(a:char, 2) . "\<left>"
        endif
    elseif getline('.')[col('.') - 1] ==# a:char
        return "\<right>"
    endif
    return a:char
endfunction

" Return 1 if cursor is inside a commented section; 0 if not
function! s:IsComment()
    return synIDattr(synIDtrans(synID(line('.'), col('.') - 1, 1)), 'name') ==? 'Comment'
endfunction

call s:Init()
