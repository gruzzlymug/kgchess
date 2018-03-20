# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@dragStartHandler = (e) ->
  gameId = $("#board").data("id")
  pieceId = e.target.attributes["data-piece-id"].value
  $.ajax({
    url: "/games/#{gameId}.json",
    type :"put",
    data: { 'cmd': 'select', 'pieceId': pieceId },
    success: (data, textStatus, jqXHR) ->
      console.log(data)
  })

@dropHandler = (e) ->
  e.preventDefault()
  e.stopPropagation()
  gameId = $("#board").data("id")
  row = e.target.attributes["data-y"].value
  col = e.target.attributes["data-x"].value
  $.ajax({
    url: "/games/#{gameId}.json",
    type: "put",
    data: { 'cmd': 'move', 'row': row, 'col': col },
    success: (data, textStatus, jqXHR) ->
      console.log(e.target)
  })

getPieceHtml = (type, color) ->
  bias = if color == 'white' then 0 else 6
  code = switch type
    when 'Pawn' then 9817
    when 'Knight' then 9816
    when 'Bishop' then 9815
    when 'Rook' then 9814
    when 'Queen' then 9813
    when 'King' then 9812
  "&##{code+bias};"

drawPiece = (piece, element) ->
  # TODO: even this is too much work (but broken, moved piece not erased)
  # element.innerHTML = '&nbsp;'
  html = getPieceHtml(piece.type, piece.player)
  element.innerHTML = html

drawRow = (i, row, pieces) ->
  # TODO: it is extra work clearing out every element in the row
  element.innerHTML = '&nbsp;' for element in row.children
  row_pieces = $.grep(pieces, (p) -> p.pos_y == i)
  drawPiece(piece, row.children[piece.pos_x]) for piece in row_pieces

drawBoard = (pieces) ->
  board = $('#board').get(0)
  rows = board.children
  drawRow(i, row, pieces) for row, i in rows

drawGame = (game) ->
  pieces = colorizePieces(game.active_pieces, game.white_player_id)
  drawBoard(pieces)

colorizePieces = (pieces, white_id) ->
  pieces.map((p) ->
    p.player = if p.player_id == white_id then 'white' else 'black'
    p)

getGameData = () ->
  gameId = $('#board').data('id')
  $.ajax({
    url: "/games/#{gameId}.json",
    type: 'get',
    success: (data, textStatus, jqXHR) ->
      drawGame(data)
  })

$ ->
    movablePieces = $("div[draggable]")
    $.each(movablePieces, (i, o) -> o.ondragstart = dragStartHandler)

    possibleMoves = $(".square")
    # allow drop to fire
    possibleMoves.on('dragenter', (e) -> e.preventDefault())
    possibleMoves.on('dragleave', (e) -> e.preventDefault())
    possibleMoves.on('dragover', (e) -> e.preventDefault())

    possibleMoves.on("drop dragdrop", dropHandler)
    App.cable.subscriptions.create "GameChannel",
      received: (data) ->
        getGameData()
