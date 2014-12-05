class Viewer

  constructor: ->

    @pages = []
    pageContainer = document.createDocumentFragment()

    _.times 68, =>
      page = new Page()
      pageContainer.appendChild page.createBackboneDom()
      @pages.push page

    el = document.querySelector '#pages'
    el.appendChild pageContainer

    @initedPageCounter = 0
    @intervalId = setInterval(_.bind(@initPage, @), 500)

    if @pages.length > 3
      setInterval(_.bind(@adjustPagesVisiblity, @), 350)

  initPage: ->

    if @initedPageCounter >= @pages.length
      clearInterval @intervalId
      return

    page = @pages[@initedPageCounter]
    pageNumber = @initedPageCounter + 1
    zeroFilledPageNumber = sprintf('%03d', pageNumber)
    page.setPageData(
      width: 728
      height: 958
      pageNumber: pageNumber
      backgroundImages: [
        {
          src: "http://hqtp.thekono.com/~yuliang/newsweek/bg_#{ zeroFilledPageNumber }.png",
          top: 0
          left: 0
          size: 1
        }
      ]
      foregroundImages: [
        {
          src: "http://hqtp.thekono.com/~yuliang/newsweek/txt_#{ zeroFilledPageNumber }.svg"
          top: 0
          left: 0
          size: 1
        }
      ]
    )

    @initedPageCounter += 1

  adjustPagesVisiblity: ->

    visibleLut = []
    _.times @pages.length, -> visibleLut.push(false)

    firstVisiblePageIx = -1
    lastVisiblePageIx = -1

    for i in [0...@pages.length]
      page = @pages[i]
      if page.isVisibleFromViewport()
        visibleLut[i] = true

        if firstVisiblePageIx is -1
          firstVisiblePageIx = i

        lastVisiblePageIx = i

      else
        if i - 1 > 0 and visibleLut[i - 1]
          break

    #if firstVisiblePageIx - 1 > 0
    #  visibleLut[firstVisiblePageIx - 1] = true

    #if lastVisiblePageIx + 1 < @pages.length
    #  visibleLut[lastVisiblePageIx + 1] = true

    _.each visibleLut, (visible, ix) =>
      page = @pages[ix]
      if visible then page.setActiveMode() else page.setLoadingMode()

window.Viewer = Viewer
