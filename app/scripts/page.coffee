class Page

  constructor: () ->

    @pageData = null
    @pageDom = null
    @loadingDom = null
    @stubDom = null
    @contentDom = null
    @backdropDom = null
    @state = 'loading'

  createBackboneDom: ->

    docFragment = document.createDocumentFragment()
    docFragment.appendChild(pageDiv = @createPageDom())

    @loadingDom = loadingDiv = document.createElement 'div'
    loadingDiv.setAttribute('class', 'loading')
    loadingDiv.appendChild @createStubDom()
    # loadingDiv.appendChild @createLoadingIndicatorDom()

    pageDiv.appendChild loadingDiv
    docFragment

  createPageDom: ->

    @pageDom = pageDiv = document.createElement 'div'
    pageDiv.setAttribute('class', 'page')
    pageDiv

  createStubDom: ->

    @stubDom = stubDiv = document.createElement 'div'
    stubDiv.setAttribute('class', 'stub')

    if @pageData
      width = @pageData.width
      height = @pageData.height
    else
      width = 3.0
      height = 4.0

    @setPageAspectRatio(width, height)
    stubDiv

  setPageAspectRatio: (width, height) ->

    ratio = height / width * 100
    paddingTop = ratio.toFixed(3) + '%'

    if @stubDom
      @stubDom.style.paddingTop = paddingTop

    if @backdropDom
      @backdropDom.style.paddingTop = paddingTop

  createLoadingIndicatorDom: ->

    new LoadingIndicator().createDom()

  setPageData: (pageData) ->

    @pageData = pageData

    if @isVisibleFromViewport()
      @setActiveMode()

    @setPageAspectRatio(pageData.width, pageData.height)

  createContentDom: ->

    return document.createDocumentFragment() unless @pageData

    @contentDom = contentDiv = document.createElement 'div'
    contentDiv.setAttribute('class', 'content')
    contentDiv.appendChild @createBackdropDom()
    # contentDiv.appendChild @createBackgroundImagesDom()
    contentDiv.appendChild @createForegroundImagesDom()
    contentDiv

  createBackdropDom: ->

    @backdropDom = backdropDiv = document.createElement 'div'
    backdropDiv.setAttribute('class', 'backdrop')
    backdropDiv

  createBackgroundImagesDom: ->

    docFragment = document.createDocumentFragment()

    _.each @pageData.backgroundImages, (bg) ->
      img = document.createElement 'img'
      img.setAttribute('class', 'background')
      img.setAttribute('src', bg.src)
      img.style.top = (bg.top * 100).toFixed(3) + '%'
      img.style.left = (bg.left * 100).toFixed(3) + '%'
      img.style.width = (bg.size * 100).toFixed(3) + '%'
      docFragment.appendChild img

    docFragment

  createForegroundImagesDom: ->

    docFragment = document.createDocumentFragment()

    _.each @pageData.foregroundImages, (fg) ->
      img = document.createElement 'img'
      img.setAttribute('class', 'foreground')
      img.setAttribute('src', fg.src)
      img.style.top = (fg.top * 100).toFixed(3) + '%'
      img.style.left = (fg.left * 100).toFixed(3) + '%'
      img.style.width = (fg.size * 100).toFixed(3) + '%'
      docFragment.appendChild img

    docFragment

  isVisibleFromViewport: ->

    rect = @pageDom.getBoundingClientRect()
    rect.top < window.innerHeight and rect.bottom > 0

  setLoadingMode: ->

    return if @state is 'loading'
    @state = 'loading'
    @loadingDom.style.visibility = 'visible' if @loadingDom
    @pageDom.removeChild(@contentDom) if @pageDom and @contentDom
    @contentDom = null

  setActiveMode: ->

    return if @state is 'active'
    return unless @pageData

    @state = 'active'
    @pageDom.appendChild @createContentDom()
    @setPageAspectRatio(@pageData.width, @pageData.height)
    @loadingDom.style.visibility = 'hidden'


window.Page = Page

# Page.pageData structure
# {
#   width: <number>,
#   height: <number>,
#   pageNumber: <number>,
#   backgroundImages: [
#     {
#       src: <string>,
#       top: <number>,
#       left: <number>,
#       size: <number>
#     },
#     ...
#   ],
#   foregroundImages: [
#     {
#       src: <string>,
#       top: <number>,
#       left: <number>,
#       size: <number>
#     },
#     ...
#   ]
# }
