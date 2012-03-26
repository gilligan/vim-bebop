if !exists("g:bebop_loaded")
    let g:bebop_loaded = 1
else
    finish
endif

if !exists('g:bebop_auto_connect')
   let g:bebop_auto_connect = 1
endif

if !exists('g:bebop_enable_js')
   let g:bebop_enable_js = 1
endif

if !exists('g:bebop_enable_coffee')
   let g:bebop_enable_coffee = 1
endif

if !exists('g:bebop_complete_js')
   let g:bebop_complete_js = 1
endif

if !exists('g:bebop_complete_coffee')
   let g:bebop_complete_coffee = 1
endif

if !exists('g:bebop_preview_window')
   let g:bebop_preview_window = 1
endif

if !exists('g:bebop_preview_location')
   let g:bebop_preview_location = 'botright 10'
endif

python <<EOF
import sys
import vim
# add vimbop to syspath
sys.path.append(vim.eval("expand('<sfile>:p:h')")  + '/lib/')

import vimbop
import vimbop.js
import vimbop.coffee
EOF

if eval('g:bebop_auto_connect')
    py vimbop.connect()
endif

if eval('g:bebop_enable_js') && eval('g:bebop_complete_js')
    au FileType javascript set omnifunc=BebopJsComplete
endif

if eval('g:bebop_enable_coffee') && eval('g:bebop_complete_coffee')
    au FileType coffee set omnifunc=BebopCoffeeComplete
endif

au FileType javascript,coffee command! -nargs=* BebopActive       py vimbop.active(<f-args>)
command! -nargs=0 BebopConnect      py vimbop.connect()
command! -nargs=0 BebopListeners    py vimbop.listeners()
command! -bang -nargs=* BebopReload py vimbop.reload("<bang>", <f-args>)
command! -nargs=0 BebopSync         py vimbop.sync()


