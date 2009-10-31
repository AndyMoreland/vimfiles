" Vim filetype plugin
" Language:		Ruby
" Maintainer:		Gavin Sinclair <gsinclair at gmail.com>
" Info:			$Id: ruby.vim,v 1.39 2007/05/06 16:38:40 tpope Exp $
" URL:			http://vim-ruby.rubyforge.org
" Anon CVS:		See above site
" Release Coordinator:  Doug Kearns <dougkearns@gmail.com>
" ----------------------------------------------------------------------------
"
" Original matchit support thanks to Ned Konz.  See his ftplugin/ruby.vim at
"   http://bike-nomad.com/vim/ruby.vim.
" ----------------------------------------------------------------------------

" Only do this when not done yet for this buffer
if (exists("b:did_ftplugin"))
  finish
endif
let b:did_ftplugin = 1

let s:cpo_save = &cpo
set cpo&vim

if has("gui_running") && !has("gui_win32")
  setlocal keywordprg=ri\ -T
else
  setlocal keywordprg=ri
endif

" Matchit support
if exists("loaded_matchit") && !exists("b:match_words")
  let b:match_ignorecase = 0

  let b:match_words =
	\ '\<\%(if\|unless\|case\|while\|until\|for\|do\|class\|module\|def\|begin\)\>=\@!' .
	\ ':' .
	\ '\<\%(else\|elsif\|ensure\|when\|rescue\|break\|redo\|next\|retry\)\>' .
	\ ':' .
	\ '\<end\>' .
	\ ',{:},\[:\],(:)'

  let b:match_skip =
	\ "synIDattr(synID(line('.'),col('.'),0),'name') =~ '" .
	\ "\\<ruby\\%(String\\|StringDelimiter\\|ASCIICode\\|Escape\\|" .
	\ "Interpolation\\|NoInterpolation\\|Comment\\|Documentation\\|" .
	\ "ConditionalModifier\\|RepeatModifier\\|OptionalDo\\|" .
	\ "Function\\|BlockArgument\\|KeywordAsMethod\\|ClassVariable\\|" .
	\ "InstanceVariable\\|GlobalVariable\\|Symbol\\)\\>'"
endif

setlocal formatoptions-=t formatoptions+=croql

setlocal include=^\\s*\\<\\(load\\\|\w*require\\)\\>
setlocal includeexpr=substitute(substitute(v:fname,'::','/','g'),'$','.rb','')
setlocal suffixesadd=.rb

if exists("&ofu") && has("ruby")
  setlocal omnifunc=rubycomplete#Complete
endif

" To activate, :set ballooneval
if has('balloon_eval') && exists('+balloonexpr')
  setlocal balloonexpr=RubyBalloonexpr()
endif


" TODO:
"setlocal define=^\\s*def

setlocal comments=:#
setlocal commentstring=#\ %s

if !exists("s:rubypath")
  if has("ruby") && has("win32")
    ruby VIM::command( 'let s:rubypath = "%s"' % ($: + begin; require %q{rubygems}; Gem.all_load_paths.sort.uniq; rescue LoadError; []; end).join(%q{,}) )
    let s:rubypath = '.,' . substitute(s:rubypath, '\%(^\|,\)\.\%(,\|$\)', ',,', '')
  elseif executable("ruby")
    let s:code = "print ($: + begin; require %q{rubygems}; Gem.all_load_paths.sort.uniq; rescue LoadError; []; end).join(%q{,})"
    if &shellxquote == "'"
      let s:rubypath = system('ruby -e "' . s:code . '"')
    else
      let s:rubypath = "/Library/Ruby/Site/1.8,/Library/Ruby/Site/1.8/powerpc-darwin9.0,/Library/Ruby/Site/1.8/universal-darwin9.0,/Library/Ruby/Site,/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/1.8,/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/1.8/powerpc-darwin9.0,/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/1.8/universal-darwin9.0,.,/Library/Ruby/Gems/1.8/gems/ParseTree-3.0.3/lib,/Library/Ruby/Gems/1.8/gems/ParseTree-3.0.3/test,/Library/Ruby/Gems/1.8/gems/Platform-0.4.0/lib,/Library/Ruby/Gems/1.8/gems/RedCloth-4.1.9/ext,/Library/Ruby/Gems/1.8/gems/RedCloth-4.1.9/lib,/Library/Ruby/Gems/1.8/gems/RedCloth-4.1.9/lib/case_sensitive_require,/Library/Ruby/Gems/1.8/gems/RubyInline-3.8.1/lib,/Library/Ruby/Gems/1.8/gems/ZenTest-4.0.0/lib,/Library/Ruby/Gems/1.8/gems/ZenTest-4.1.3/lib,/Library/Ruby/Gems/1.8/gems/actionmailer-2.1.1/lib,/Library/Ruby/Gems/1.8/gems/actionmailer-2.2.2/lib,/Library/Ruby/Gems/1.8/gems/actionmailer-2.3.2/lib,/Library/Ruby/Gems/1.8/gems/actionmailer-2.3.4/lib,/Library/Ruby/Gems/1.8/gems/actionpack-2.1.1/lib,/Library/Ruby/Gems/1.8/gems/actionpack-2.2.2/lib,/Library/Ruby/Gems/1.8/gems/actionpack-2.3.2/lib,/Library/Ruby/Gems/1.8/gems/actionpack-2.3.4/lib,/Library/Ruby/Gems/1.8/gems/activerecord-2.1.1/lib,/Library/Ruby/Gems/1.8/gems/activerecord-2.2.2/lib,/Library/Ruby/Gems/1.8/gems/activerecord-2.3.2/lib,/Library/Ruby/Gems/1.8/gems/activerecord-2.3.4/lib,/Library/Ruby/Gems/1.8/gems/activeresource-2.1.1/lib,/Library/Ruby/Gems/1.8/gems/activeresource-2.2.2/lib,/Library/Ruby/Gems/1.8/gems/activeresource-2.3.2/lib,/Library/Ruby/Gems/1.8/gems/activeresource-2.3.4/lib,/Library/Ruby/Gems/1.8/gems/activesupport-2.1.1/lib,/Library/Ruby/Gems/1.8/gems/activesupport-2.2.2/lib,/Library/Ruby/Gems/1.8/gems/activesupport-2.3.2/lib,/Library/Ruby/Gems/1.8/gems/activesupport-2.3.4/lib,/Library/Ruby/Gems/1.8/gems/acts_as_ferret-0.10/lib,/Library/Ruby/Gems/1.8/gems/anemone-0.1.0/lib,/Library/Ruby/Gems/1.8/gems/authlogic-2.0.7/lib,/Library/Ruby/Gems/1.8/gems/aws-s3-0.5.1/lib,/Library/Ruby/Gems/1.8/gems/builder-2.1.2/lib,/Library/Ruby/Gems/1.8/gems/calendar_date_select-1.15/lib,/Library/Ruby/Gems/1.8/gems/capistrano-2.5.5/lib,/Library/Ruby/Gems/1.8/gems/chriseppstein-compass-0.6.1/lib,/Library/Ruby/Gems/1.8/gems/chronic-0.2.3/lib,/Library/Ruby/Gems/1.8/gems/columnize-0.3.0/lib,/Library/Ruby/Gems/1.8/gems/configuration-0.0.5/lib,/Library/Ruby/Gems/1.8/gems/crack-0.1.4/lib,/Library/Ruby/Gems/1.8/gems/daemons-1.0.10/lib,/Library/Ruby/Gems/1.8/gems/defunkt-github-0.3.4/lib,/Library/Ruby/Gems/1.8/gems/dnssd-0.7.1/ext,/Library/Ruby/Gems/1.8/gems/dnssd-0.7.1/lib,/Library/Ruby/Gems/1.8/gems/echoe-3.1.1/lib,/Library/Ruby/Gems/1.8/gems/facets-2.6.0/lib/core,/Library/Ruby/Gems/1.8/gems/facets-2.6.0/lib/lore,/Library/Ruby/Gems/1.8/gems/facets-2.6.0/lib/more,/Library/Ruby/Gems/1.8/gems/fastercsv-1.5.0/lib,/Library/Ruby/Gems/1.8/gems/fastthread-1.0.7/ext,/Library/Ruby/Gems/1.8/gems/fastthread-1.0.7/lib,/Library/Ruby/Gems/1.8/gems/ferret-0.11.6/lib,/Library/Ruby/Gems/1.8/gems/fiveruns_tuneup-0.8.20/lib,/Library/Ruby/Gems/1.8/gems/flog-2.1.0/lib,/Library/Ruby/Gems/1.8/gems/grimen-dry_scaffold-0.2.6/lib,/Library/Ruby/Gems/1.8/gems/haml-2.0.9/lib,/Library/Ruby/Gems/1.8/gems/haml-2.1.0/lib,/Library/Ruby/Gems/1.8/gems/heroku-0.7.1/lib,/Library/Ruby/Gems/1.8/gems/heroku-1.0/lib,/Library/Ruby/Gems/1.8/gems/highline-1.5.0/lib,/Library/Ruby/Gems/1.8/gems/hirb-0.2.5/lib,/Library/Ruby/Gems/1.8/gems/hoe-1.12.2/lib,/Library/Ruby/Gems/1.8/gems/hpricot-0.7/lib,/Library/Ruby/Gems/1.8/gems/hpricot-0.8.1/lib,/Library/Ruby/Gems/1.8/gems/httparty-0.4.4/lib,/Library/Ruby/Gems/1.8/gems/jackdempsey-beet-0.2.2/lib,/Library/Ruby/Gems/1.8/gems/json-1.1.4/ext,/Library/Ruby/Gems/1.8/gems/json-1.1.4/ext/json/ext,/Library/Ruby/Gems/1.8/gems/json-1.1.4/lib,/Library/Ruby/Gems/1.8/gems/json_pure-1.1.3/lib,/Library/Ruby/Gems/1.8/gems/json_pure-1.1.4/lib,/Library/Ruby/Gems/1.8/gems/justinfrench-formtastic-0.2.1/lib,/Library/Ruby/Gems/1.8/gems/launchy-0.3.3/lib,/Library/Ruby/Gems/1.8/gems/libxml-ruby-1.1.3/ext/libxml,/Library/Ruby/Gems/1.8/gems/libxml-ruby-1.1.3/lib,/Library/Ruby/Gems/1.8/gems/linecache-0.43/lib,/Library/Ruby/Gems/1.8/gems/manalang-bdoc-0.2.2/lib,/Library/Ruby/Gems/1.8/gems/mattetti-googlecharts-1.4.0/lib,/Library/Ruby/Gems/1.8/gems/mime-types-1.16/lib,/Library/Ruby/Gems/1.8/gems/mislav-hanna-0.1.7/lib,/Library/Ruby/Gems/1.8/gems/mislav-will_paginate-2.3.8/lib,/Library/Ruby/Gems/1.8/gems/mongrel-1.1.5/ext,/Library/Ruby/Gems/1.8/gems/mongrel-1.1.5/lib,/Library/Ruby/Gems/1.8/gems/mysql-2.7/lib,/Library/Ruby/Gems/1.8/gems/net-scp-1.0.2/lib,/Library/Ruby/Gems/1.8/gems/net-sftp-2.0.2/lib,/Library/Ruby/Gems/1.8/gems/net-ssh-2.0.11/lib,/Library/Ruby/Gems/1.8/gems/net-ssh-gateway-1.0.1/lib,/Library/Ruby/Gems/1.8/gems/nokogiri-1.3.2/ext,/Library/Ruby/Gems/1.8/gems/nokogiri-1.3.2/lib,/Library/Ruby/Gems/1.8/gems/passenger-2.1.2/ext,/Library/Ruby/Gems/1.8/gems/passenger-2.1.2/lib,/Library/Ruby/Gems/1.8/gems/passenger-2.1.3/ext,/Library/Ruby/Gems/1.8/gems/passenger-2.1.3/lib,/Library/Ruby/Gems/1.8/gems/passenger-2.2.1/ext,/Library/Ruby/Gems/1.8/gems/passenger-2.2.1/lib,/Library/Ruby/Gems/1.8/gems/passenger-2.2.2/ext,/Library/Ruby/Gems/1.8/gems/passenger-2.2.2/lib,/Library/Ruby/Gems/1.8/gems/rack-0.9.1/lib,/Library/Ruby/Gems/1.8/gems/rack-1.0.0/lib,/Library/Ruby/Gems/1.8/gems/radiant-0.7.1/lib,/Library/Ruby/Gems/1.8/gems/rails-2.1.1/lib,/Library/Ruby/Gems/1.8/gems/rails-2.2.2/lib,/Library/Ruby/Gems/1.8/gems/rails-2.3.2/lib,/Library/Ruby/Gems/1.8/gems/rails-2.3.4/lib,/Library/Ruby/Gems/1.8/gems/rake-0.8.4/lib,/Library/Ruby/Gems/1.8/gems/rdoc-2.3.0/lib,/Library/Ruby/Gems/1.8/gems/rdoc-2.4.3/lib,/Library/Ruby/Gems/1.8/gems/request-log-analyzer-1.2.0/lib,/Library/Ruby/Gems/1.8/gems/rest-client-0.9.2/lib,/Library/Ruby/Gems/1.8/gems/rest-client-0.9/lib,/Library/Ruby/Gems/1.8/gems/rest-client-1.0.3/lib,/Library/Ruby/Gems/1.8/gems/rgrove-sanitize-1.0.6.1/lib,/Library/Ruby/Gems/1.8/gems/rgrove-sanitize-1.0.6/lib,/Library/Ruby/Gems/1.8/gems/rspec-1.2.2/lib,/Library/Ruby/Gems/1.8/gems/rspec-1.2.7/lib,/Library/Ruby/Gems/1.8/gems/rspec-rails-1.2.2/lib,/Library/Ruby/Gems/1.8/gems/ruby-debug-0.10.3/cli,/Library/Ruby/Gems/1.8/gems/ruby-debug-base-0.10.3/lib,/Library/Ruby/Gems/1.8/gems/ruby-openid-2.1.4/lib,/Library/Ruby/Gems/1.8/gems/rubyforge-1.0.3/lib,/Library/Ruby/Gems/1.8/gems/rubygems-update-1.3.1/lib,/Library/Ruby/Gems/1.8/gems/rubygems-update-1.3.5/lib,/Library/Ruby/Gems/1.8/gems/rubynode-0.1.5/lib,/Library/Ruby/Gems/1.8/gems/sanitize-1.0.6/lib,/Library/Ruby/Gems/1.8/gems/sequel-2.11.0/lib,/Library/Ruby/Gems/1.8/gems/sequel-3.0.0/lib,/Library/Ruby/Gems/1.8/gems/sexp_processor-3.0.1/lib,/Library/Ruby/Gems/1.8/gems/sinatra-0.9.1.1/lib,/Library/Ruby/Gems/1.8/gems/sinatra-0.9.2/lib,/Library/Ruby/Gems/1.8/gems/sqlite3-ruby-1.2.4/lib,/Library/Ruby/Gems/1.8/gems/taps-0.2.14/lib,/Library/Ruby/Gems/1.8/gems/taps-0.2.19/lib,/Library/Ruby/Gems/1.8/gems/thor-0.9.9/lib,/Library/Ruby/Gems/1.8/gems/utility_belt-1.1.0/lib,/Library/Ruby/Gems/1.8/gems/voloko-sdoc-0.2.5/lib,/Library/Ruby/Gems/1.8/gems/voloko-sdoc-0.2.7/lib,/Library/Ruby/Gems/1.8/gems/wirble-0.1.2/.,/Library/Ruby/Gems/1.8/gems/wvanbergen-request-log-analyzer-1.2.1/lib,/Library/Ruby/Gems/1.8/gems/xml-simple-1.0.12/lib,/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8/gems/RedCloth-3.0.4/lib,/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8/gems/actionmailer-1.3.6/lib,/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8/gems/actionpack-1.13.6/lib,/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8/gems/actionwebservice-1.2.6/lib,/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8/gems/activerecord-1.15.6/lib,/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8/gems/activesupport-1.4.4/lib,/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8/gems/acts_as_ferret-0.4.1/lib,/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8/gems/capistrano-2.0.0/lib,/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8/gems/cgi_multipart_eof_fix-2.5.0/lib,/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8/gems/daemons-1.0.9/lib,/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8/gems/dnssd-0.6.0/lib,/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8/gems/fastthread-1.0.1/lib,/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8/gems/fcgi-0.8.7/lib,/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8/gems/ferret-0.11.4/lib,/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8/gems/gem_plugin-0.2.3/lib,/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8/gems/highline-1.2.9/lib,/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8/gems/hpricot-0.6/lib,/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8/gems/libxml-ruby-0.3.8.4/lib,/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8/gems/libxml-ruby-0.9.5/lib,/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8/gems/mongrel-1.1.4/lib,/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8/gems/needle-1.3.0/lib,/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8/gems/net-sftp-1.1.0/lib,/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8/gems/net-ssh-1.1.2/lib,/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8/gems/rails-1.2.6/lib,/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8/gems/rake-0.7.3/lib,/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8/gems/ruby-openid-1.1.4/lib,/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8/gems/ruby-yadis-0.3.4/lib,/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8/gems/rubynode-0.1.3/lib,/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8/gems/sqlite3-ruby-1.2.1/lib,/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8/gems/termios-0.9.4/lib,/Users/andrew/.gem/ruby/1.8/gems/authlogic-2.0.2/lib,/Users/andrew/.gem/ruby/1.8/gems/rake-0.8.7/lib,/Users/andrew/.gem/ruby/1.8/gems/ruby-debug-0.10.3/cli,/Users/andrew/.gem/ruby/1.8/gems/ruby-growl-1.0.1/lib,/Users/andrew/.gem/ruby/1.8/gems/rubygems-update-1.3.5/lib"
    endif
    let s:rubypath = '.,' . substitute(s:rubypath, '\%(^\|,\)\.\%(,\|$\)', ',,', '')
  else
    " If we can't call ruby to get its path, just default to using the
    " current directory and the directory of the current file.
    let s:rubypath = ".,,"
  endif
endif

let &l:path = s:rubypath

if has("gui_win32") && !exists("b:browsefilter")
  let b:browsefilter = "Ruby Source Files (*.rb)\t*.rb\n" .
                     \ "All Files (*.*)\t*.*\n"
endif

let b:undo_ftplugin = "setl fo< inc< inex< sua< def< com< cms< path< kp<"
      \."| unlet! b:browsefilter b:match_ignorecase b:match_words b:match_skip"
      \."| if exists('&ofu') && has('ruby') | setl ofu< | endif"
      \."| if has('balloon_eval') && exists('+bexpr') | setl bexpr< | endif"

if !exists("g:no_plugin_maps") && !exists("g:no_ruby_maps")

  noremap <silent> <buffer> [m :<C-U>call <SID>searchsyn('\<def\>','rubyDefine','b')<CR>
  noremap <silent> <buffer> ]m :<C-U>call <SID>searchsyn('\<def\>','rubyDefine','')<CR>
  noremap <silent> <buffer> [M :<C-U>call <SID>searchsyn('\<end\>','rubyDefine','b')<CR>
  noremap <silent> <buffer> ]M :<C-U>call <SID>searchsyn('\<end\>','rubyDefine','')<CR>

  noremap <silent> <buffer> [[ :<C-U>call <SID>searchsyn('\<\%(class\<Bar>module\)\>','rubyModule\<Bar>rubyClass','b')<CR>
  noremap <silent> <buffer> ]] :<C-U>call <SID>searchsyn('\<\%(class\<Bar>module\)\>','rubyModule\<Bar>rubyClass','')<CR>
  noremap <silent> <buffer> [] :<C-U>call <SID>searchsyn('\<end\>','rubyModule\<Bar>rubyClass','b')<CR>
  noremap <silent> <buffer> ][ :<C-U>call <SID>searchsyn('\<end\>','rubyModule\<Bar>rubyClass','')<CR>

  let b:undo_ftplugin = b:undo_ftplugin
        \."| sil! exe 'unmap <buffer> [[' | sil! exe 'unmap <buffer> ]]' | sil! exe 'unmap <buffer> []' | sil! exe 'unmap <buffer> ]['"
        \."| sil! exe 'unmap <buffer> [m' | sil! exe 'unmap <buffer> ]m' | sil! exe 'unmap <buffer> [M' | sil! exe 'unmap <buffer> ]M'"
endif

let &cpo = s:cpo_save
unlet s:cpo_save

if exists("g:did_ruby_ftplugin_functions")
  finish
endif
let g:did_ruby_ftplugin_functions = 1

function! RubyBalloonexpr()
  if !exists('s:ri_found')
    let s:ri_found = executable('ri')
  endif
  if s:ri_found
    let line = getline(v:beval_lnum)
    let b = matchstr(strpart(line,0,v:beval_col),'\%(\w\|[:.]\)*$')
    let a = substitute(matchstr(strpart(line,v:beval_col),'^\w*\%([?!]\|\s*=\)\?'),'\s\+','','g')
    let str = b.a
    let before = strpart(line,0,v:beval_col-strlen(b))
    let after  = strpart(line,v:beval_col+strlen(a))
    if str =~ '^\.'
      let str = substitute(str,'^\.','#','g')
      if before =~ '\]\s*$'
        let str = 'Array'.str
      elseif before =~ '}\s*$'
        " False positives from blocks here
        let str = 'Hash'.str
      elseif before =~ "[\"'`]\\s*$" || before =~ '\$\d\+\s*$'
        let str = 'String'.str
      elseif before =~ '\$\d\+\.\d\+\s*$'
        let str = 'Float'.str
      elseif before =~ '\$\d\+\s*$'
        let str = 'Integer'.str
      elseif before =~ '/\s*$'
        let str = 'Regexp'.str
      else
        let str = substitute(str,'^#','.','')
      endif
    endif
    let str = substitute(str,'.*\.\s*to_f\s*\.\s*','Float#','')
    let str = substitute(str,'.*\.\s*to_i\%(nt\)\=\s*\.\s*','Integer#','')
    let str = substitute(str,'.*\.\s*to_s\%(tr\)\=\s*\.\s*','String#','')
    let str = substitute(str,'.*\.\s*to_sym\s*\.\s*','Symbol#','')
    let str = substitute(str,'.*\.\s*to_a\%(ry\)\=\s*\.\s*','Array#','')
    let str = substitute(str,'.*\.\s*to_proc\s*\.\s*','Proc#','')
    if str !~ '^\w'
      return ''
    endif
    silent! let res = substitute(system("ri -f simple -T \"".str.'"'),'\n$','','')
    if res =~ '^Nothing known about' || res =~ '^Bad argument:' || res =~ '^More than one method'
      return ''
    endif
    return res
  else
    return ""
  endif
endfunction

function! s:searchsyn(pattern,syn,flags)
    norm! m'
    let i = 0
    let cnt = v:count ? v:count : 1
    while i < cnt
        let i = i + 1
        let line = line('.')
        let col  = col('.')
        let pos = search(a:pattern,'W'.a:flags)
        while pos != 0 && s:synname() !~# a:syn
            let pos = search(a:pattern,'W'.a:flags)
        endwhile
        if pos == 0
            call cursor(line,col)
            return
        endif
    endwhile
endfunction

function! s:synname()
    return synIDattr(synID(line('.'),col('.'),0),'name')
endfunction

"
" Instructions for enabling "matchit" support:
"
" 1. Look for the latest "matchit" plugin at
"
"         http://www.vim.org/scripts/script.php?script_id=39
"
"    It is also packaged with Vim, in the $VIMRUNTIME/macros directory.
"
" 2. Copy "matchit.txt" into a "doc" directory (e.g. $HOME/.vim/doc).
"
" 3. Copy "matchit.vim" into a "plugin" directory (e.g. $HOME/.vim/plugin).
"
" 4. Ensure this file (ftplugin/ruby.vim) is installed.
"
" 5. Ensure you have this line in your $HOME/.vimrc:
"         filetype plugin on
"
" 6. Restart Vim and create the matchit documentation:
"
"         :helptags ~/.vim/doc
"
"    Now you can do ":help matchit", and you should be able to use "%" on Ruby
"    keywords.  Try ":echo b:match_words" to be sure.
"
" Thanks to Mark J. Reed for the instructions.  See ":help vimrc" for the
" locations of plugin directories, etc., as there are several options, and it
" differs on Windows.  Email gsinclair@soyabean.com.au if you need help.
"

" vim: nowrap sw=2 sts=2 ts=8 ff=unix:
