# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@paintIt = () ->
    console.log("ondragHandler")

@dragStartHandler = (e) ->
    gameId = $("#board").data("id")
    pieceId = e.target.attributes["data-piece-id"].value
    $.ajax({
        url: "/games/#{gameId}.json",
        type :"put",
        data: { 'cmd': 'select', 'pieceId': pieceId },
        success: (data, textStatus, jqXHR) ->
            console.log data
    })
    #paintIt()

@dropHandler = (e) ->
    e.preventDefault()
    e.stopPropagation()
    console.log(e.target)

$ ->
    movablePieces = $("div[draggable]")
    $.each(movablePieces, (i, o) -> o.ondragstart = dragStartHandler)

    possibleMoves = $(".square")
    # allow drop to fire
    possibleMoves.on('dragenter', (e) -> e.preventDefault())
    possibleMoves.on('dragleave', (e) -> e.preventDefault())
    possibleMoves.on('dragover', (e) -> e.preventDefault())

    possibleMoves.on("drop dragdrop", dropHandler)
