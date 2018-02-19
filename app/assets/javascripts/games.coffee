# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@paintIt = () ->
    console.log("ondragHandler")

@dragStartHandler = (e) ->
    $.ajax({
        url: "/games/8.json",
        type :"put",
        data: {},
        success: (data, textStatus, jqXHR) ->
            console.log "Successful AJAX call: #{data}"
    })
    #paintIt()
    #console.log("xx: " + e)
    x = 0

@dropHandler = (e) ->
    e.preventDefault()
    e.stopPropagation()
    console.log(e.target)

$ ->
    movablePieces = $("span[draggable]")
    $.each(movablePieces, (i, o) -> o.ondragstart = dragStartHandler)

    possibleMoves = $(".square")
    # allow drop to fire
    possibleMoves.on('dragenter', (e) -> e.preventDefault())
    possibleMoves.on('dragleave', (e) -> e.preventDefault())
    possibleMoves.on('dragover', (e) -> e.preventDefault())

    possibleMoves.on("drop dragdrop", dropHandler)
