locked = false
hidingNav = -1
hideNav = ->
  return if locked
  clearTimeout hidingNav
  locked = true
  hidingNav = setTimeout ->
    $(".main-navigation").addClass("hidden")
    navRequestedShown = false
    locked = false
  , 5000

showNav = ->
  clearTimeout hidingNav
  locked = true
  $(".main-navigation").removeClass("hidden")
  locked = false

$(document).on "focus", ".main-navigation", showNav
$(document).on "blur", ".main-navigation", hideNav

onError = (jqXHR, textStatus, errorThrown) ->
  $(".modal.error .error-text").text(JSON.parse(jqXHR.responseText).status)
  $(".modal.error").addClass("show")

window.rescanLibrary = (ev) ->
  operation = $.ajax({
    url: "/videos/generate.json"
  })
  operation.fail onError

window.reanalyzeLibrary = (ev) ->
  operation = $.ajax({
    url: "/videos/reanalyze.json"
  })
  operation.fail onError

window.redownloadImages = (ev) ->
  operation = $.ajax({
    url: "/videos/redownload.json"
  })
  operation.fail onError

window.redownloadMissingImages = (ev) ->
  operation = $.ajax({
    url: "/videos/redownload_missing.json"
  })
  operation.fail onError

showNavOnMousemove = (ev) ->
  if ev.screenY < 300
    showNav()
  else
    hideNav()

$(document).on "mousemove", _.throttle(showNavOnMousemove, 100)

$(document).on "click", ".js-close-modal", ->
  $(".modal").removeClass("show")

$(document).on "click", "[data-modal]", (ev) ->
  ev.preventDefault()
  modalId = $(ev.currentTarget).data("modal")
  $("##{modalId}").addClass("show")

$ ->
  hideNav()

window.context = {}

document.addEventListener 'page:before-partial-replace', (event) ->
  nodes = event.data
  Twine.unbind(node) for node in nodes
  return
$ ->
  Twine.reset(context).bind().refresh()
