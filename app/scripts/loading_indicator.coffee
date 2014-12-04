class LoadingIndicator

  constructor: (opt = {}) ->

    @opt = _.extend(@getDefaultOpt(), opt)

  getDefaultOpt: ->

    # number of lines to draw
    lines: 13
    # length of each line
    length: 10
    # line thickness
    width: 10
    # radius of inner circle
    radius: 30
    # corner roundness (0..1)
    corners: 1
    # rotation offset
    rotate: 0
    # 1: clockwise, -1: counterclockwise
    direction: 1
    # #rgb
    color: '#000'
    # rounds per second
    speed: 1
    # afterglow percentage
    trail: 60
    # whether to render a shadow
    shadow: false
    # whether to use hardware acceleration
    hwaccel: false
    # CSS class to assign to the spinner
    className: 'spinner'
    # z-index, default is 2000000000
    zIndex: 2
    # top position relative to parent
    top: '50%'
    # left position relative to parent
    left: '50%'

  createDom: ->

    new Spinner(@opt).spin().el