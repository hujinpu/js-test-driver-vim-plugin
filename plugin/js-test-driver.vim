" js-test-driver.vim – JsTestDriver Vim Plugin
" Version : 0.0.1 
" Maintainer : Jinpu Hu<hujinpu@gmail.com>
" Last modified : 01/11/2011
" License : This script is released under the Vim License.


" check if script is already loaded
"if exists('loaded_js_test_driver')
"finish "stop loading the script
"endif
"let loaded_js_test_driver = 1

let s:global_cpo = &cpo "store compatible-mode in local variable
set cpo&vim " go into nocompatible-mode

" ######## CONFIGURATION ########
" variable js_test_driver_lib
if !exists('js_test_driver_lib')
    let s:js_test_driver_lib = expand('%:p:h:h') . '/lib/JsTestDriver.jar'
else
    let s:js_test_driver_lib = js_test_driver_lib
    unlet js_test_driver_lib
endif

" variable js_test_driver_bin
if !exists('js_test_driver_bin')
    let s:js_test_driver_bin = expand('%:p:h:h') . '/bin'
else
    let s:js_test_driver_bin = js_test_driver_bin
    unlet js_test_driver_bin
endif


" ######## FUNCTIONS #########

function! s:StartServer(port)
    let cmd = '!sh ' . s:js_test_driver_bin . '/jstestserver.sh ' . s:js_test_driver_lib . a:port
    redir => output_message
    silent execute cmd
    redir END
    let s:sid = matchstr(output_message, '\v\n\zs<\d{3,}>')
    echo 'start server at port = ' . a:port . ' and sid = ' . s:sid
endfunction

function! s:JsTestStartServer(interact, ...)
    if !executable(s:js_test_driver_lib)
        if a:interact
            let port = input('Please enter port number: ', '9876')
            call s:StartServer(port)
        else
            call s:StartServer(9876)
        endif
    else
        echohl WarningMsg | echoerr "Can't execute java jar." | echohl None
        return
    endif
endfunction

function! s:JsTestStopServer()
    silent execute '!kill ' . s:sid
    echo 'stop server at sid = ' . s:sid
endfunction

function! s:JsTest()
    let cmd = '!java -jar ' . s:js_test_driver_lib . ' --tests all'
    execute cmd
endfunction

command! -bang -nargs=? JsTestStartServer call s:JsTestStartServer(<bang>1, <f-args>)
command! -nargs=0 JsTestStopServer call s:JsTestStopServer()
command! -nargs=0 JsTest call s:JsTest()
