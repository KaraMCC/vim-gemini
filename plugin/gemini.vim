if exists('g:loaded_gemini_plugin')
    finish
endif
let g:loaded_gemini_plugin = 1

" Define default matches
let g:gemini#default_matches = {
            \'.*': [['(', ')'], ['{', '}'], ['[', ']'], ['"', '"']],
            \'.*python\|.*php\|.*c\|.*cpp\|.*cs\|.*sh\|.*html\|.*xml\|.*vim\|.*perl\|.*rust\|.*java\|.*javascript': [["'", "'"]],
            \'.*html\|xml': [['<', '>']],
            \'r\|go\|sh\|javascript': [['`', '`']],
            \}
" Get user settings
let g:gemini#match_list = get(g:, 'gemini#match_list', {})
let g:gemini#match_in_comment = get(g:, 'gemini#match_in_comment', 0)
let g:gemini#cozy_matching = get(g:, 'gemini#cozy_matching', 1)

augroup create_gemini_mappings
    autocmd!
    autocmd BufEnter * call <SID>CreateMappings()
augroup END

function! s:CreateMatchList()
    let b:match_chars = []
    let l:potential_matches = extend(g:gemini#default_matches, g:gemini#match_list)
    " Loop through all potential matches, and add them if the regex matches
    for key in keys(l:potential_matches)
        if &filetype =~? key
            let b:match_chars += l:potential_matches[key]
        endif
    endfor
endfunction

function! s:CreateMappings()
    if !exists('b:match_chars')
        call s:CreateMatchList()
    endif
    " Loop through characters to match
    for matches in b:match_chars
        if matches[0] !=# matches[1]
            exec printf('inoremap <buffer><expr>%s <SID>OnOpeningCharacter("\%s","\%s")', matches[0], matches[0], matches[1])
            exec printf('inoremap <buffer><expr>%s <SID>OnClosingCharacter("\%s")', matches[1], matches[1])
        else
            " A different function is required if the opening and closing char are the same
            exec printf('inoremap <buffer><expr>%s <SID>OnTypedDuplicate("\%s")', matches[0], matches[1])
        endif
    endfor
    inoremap <expr><BS> <SID>TryDeletePair()
endfunction

function! s:OnOpeningCharacter(open, close)
    if g:gemini#match_in_comment || !s:IsComment()
        " Get the string index of a:open, starting at the cursor's position
        let l:open_idx = stridx(getline('.'), a:open, 0)
        " Do the same for a:close
        let l:close_idx = stridx(getline('.'), a:close, 0)
        if l:open_idx == l:close_idx || l:open_idx < l:close_idx && l:open_idx != -1
            " Only match if the cursor is next to whitespace --
            " disregard if cozy matching is enabled
            if g:gemini#cozy_matching || getline('.')[col('.') - 1] =~? '\s' || col('.') == col('$')
                " Add both the characters, then move the cursor to the left
                return a:open . a:close . "\<left>"
            endif
        endif
    endif
    return a:open
endfunction

function! s:OnClosingCharacter(close)
    " If pair of characters is already closed, move right
    if getline('.')[col('.')-1] ==# a:close
        return "\<right>"
    else
        return a:close
    endif
endfunction

function! s:OnTypedDuplicate(char)
    " Don't repeat if in comment, unless user has enabled it
    if g:gemini#cozy_matching || getline('.')[col('.') - 1] =~? '\s' || col('.') == col('$')
        " If the specified character is adjacent to the cursor, do not repeat
        if g:gemini#match_in_comment || !s:IsComment()
            if stridx(getline('.'), a:char, col('.') - 2) == -1
                " Don't close if an even number of a:char exists on the line
                if count(getline('.'), a:char) % 2 == 0
                    return repeat(a:char, 2) . "\<left>"
                endif
                " If cursor is already on the specified character, move right
            elseif getline('.')[col('.') - 1] ==# a:char
                return "\<right>"
            endif
        endif
    endif
    return a:char
endfunction

" If the opening character is deleted, also delete the closing one
function! s:TryDeletePair()
    for chars in b:match_chars
        if getline('.')[col('.')-2] ==# chars[0] && getline('.')[col('.')-1] ==# chars[1]
            return "\<right>\<BS>\<BS>"
        endif
    endfor
    return "\<BS>"
endfunction

function! s:IsComment()
    " Return 1 if the name of the syntax id under cursor is 'Comment'
    return synIDattr(synIDtrans(synID(line('.'), col('.') - 1, 1)), 'name') ==? 'Comment'
endfunction
