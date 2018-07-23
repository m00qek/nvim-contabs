if ! exists('g:contabs#project#locations')
  let g:contabs#project#locations = []
endif

if ! exists('g:contabs#integrations#airline_theme')
  let g:contabs#integrations#airline_theme = 'dirname'
endif

if ! exists('g:contabs#integrations#airline')
  let g:contabs#integrations#airline = 1
endif

if g:contabs#integrations#airline
  let g:airline#extensions#tabline#formatter = 'contabs'
endif
