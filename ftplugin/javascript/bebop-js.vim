if !eval('g:bebop_enabled') || !eval('g:bebop_enable_js')
    finish
endif

function! BebopJsComplete(findstart, base)
    let line = getline('.')
    let start = col('.') - 1
    if a:findstart
        while start >= 0 && line[start - 1] =~ '\k'
            let start -= 1
        endwhile
        return start
    else
        py vim.command('return ' + vimbop.js.complete(*[vim.eval(x) for x in ('line', 'a:base', 'start')]))
    endif
endfunction

function! s:BebopJsCmdComplete(arglead, line, start)
    py vim.command('return ' + vimbop.js.complete_cmdline(*[vim.eval(x) for x in ('a:arglead', 'a:line', 'a:start')]))
endfunction

" It is insufficient to use function! to define our operator function as it
" may already be referenced by operatorfunc and vim doesn't allow redefining
" the function in that case.
if !exists('*BebopJsOperator')
    function! BebopJsOperator(type, ...)
        if a:0
            " Invoked from Visual mode, use '< and '> marks.
            silent exe "silent normal! `<" . a:type . "`>y"
        elseif a:type ==# 'char'
            silent exe "normal! `[v`]y"
        elseif a:type ==# 'line'
            silent exe "normal! '[V']y"
        elseif a:type ==# 'block'
            silent exe "normal! `[\<C-V>`]y"
        else
            return
        endif
        py vimbop.js.eval(vim.eval('@@'))
    endfunction
endif

command! -nargs=* -complete=customlist,s:BebopJsCmdComplete BebopJsEval py vimbop.js.eval(<f-args>)
command! -nargs=0 BebopJsEvalBuffer py vimbop.js.eval_buffer()
command! -nargs=0 BebopJsEvalLine   py vimbop.js.eval_line()

" Mappings
nnoremap <buffer> <leader>e  :set operatorfunc=BebopJsOperator<cr>g@
vnoremap <buffer> <leader>e  :py vimbop.js.eval_range()<cr>
nnoremap <buffer> <leader>ee :BebopJsEval<space>
nnoremap <buffer> <leader>eb :BebopJsEvalBuffer<cr>
nnoremap <buffer> <leader>el :BebopJsEvalLine<cr>
