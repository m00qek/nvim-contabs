if ! exists('g:contabs#project#locations')
  let g:contabs#project#locations = []
endif

if ! exists('g:contabs#integrations#airline_theme')
  let g:contabs#integrations#airline_theme = 'basename'
endif

if ! exists('g:contabs#integrations#airline')
  let g:contabs#integrations#airline = v:true
endif

if g:contabs#integrations#airline
  let g:airline#extensions#tabline#formatter = 'contabs'
endif
