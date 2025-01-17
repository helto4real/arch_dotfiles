function OpenMarkdownPreview (url)
    execute "silent ! xdg-open " . a:url
endfunction
let g:mkdp_browserfunc = "OpenMarkdownPreview"

