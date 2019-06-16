if ! exists('g:contabs#project#locations')
  let g:contabs#project#locations = []
endif

" DEPRECATED config, use g:contabs#integrations#tabline#theme
if exists('g:contabs#integrations#airline_theme')
  let g:contabs#integrations#tabline#theme = g:contabs#integrations#airline_theme
endif

if ! exists('g:contabs#integrations#tabline#theme')
  let g:contabs#integrations#tabline#theme = 'basename'
endif

if ! exists('g:contabs#integrations#airline')
  let g:contabs#integrations#airline = v:true
endif

if g:contabs#integrations#airline
  let g:airline#extensions#tabline#formatter = 'contabs'
endif
