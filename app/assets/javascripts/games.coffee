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

$ ->
    movablePieces = $("div[draggable]")
    $.each(movablePieces, (i, o) -> o.ondragstart = dragStartHandler)

    possibleMoves = $(".square")
    # allow drop to fire
    possibleMoves.on('dragenter', (e) -> e.preventDefault())
    possibleMoves.on('dragleave', (e) -> e.preventDefault())
    possibleMoves.on('dragover', (e) -> e.preventDefault())

    possibleMoves.on("drop dragdrop", dropHandler)
    getGameData()
    App.cable.subscriptions.create "GameChannel",
      received: (data) ->
        getGameData()

getGameData = () ->
  gameId = $('#board').data('id')
  $.ajax({
    url: "/games/#{gameId}.json",
    type: 'get',
    success: (data, textStatus, jqXHR) ->
      drawGame(data)
  })

drawGame = (game) ->
  pieces = colorizePieces(game.active_pieces, game.white_player_id)
  playerColor = $('#board').data('player-color')
  if playerColor == 'black'
    pieces = pieces.map((p) ->
      p.pos_y = 7 - p.pos_y
      p)
  current_player_id = getPlayerId()
  drawBoard(pieces, current_player_id)
  movablePieces = $("div[draggable]")
  $.each(movablePieces, (i, o) -> o.ondragstart = dragStartHandler)
  updateTurn(game.turn)

getPlayerId = () ->
  cookies = document.cookie.split(';')
  pairs = cookies.map((c) => c.trim().split('='))
  player_cookie = pairs.find((p) -> p[0] == 'player_id')
  if player_cookie
    return parseInt(player_cookie[1])
  else
    return 'player'

colorizePieces = (pieces, white_id) ->
  pieces.map((p) ->
    p.player = if p.player_id == white_id then 'white' else 'black'
    p)

drawBoard = (pieces, player_id) ->
  board = $('#board').get(0)
  rows = board.children
  drawRow(i, row, pieces, player_id) for row, i in rows

drawRow = (i, row, pieces, player_id) ->
  # TODO: it is extra work clearing out every element in the row
  element.innerHTML = '&nbsp;' for element in row.children
  row_pieces = $.grep(pieces, (p) -> p.pos_y == i)
  drawPiece(piece, row.children[piece.pos_x], player_id) for piece in row_pieces

drawPiece = (piece, element, player_id) ->
  html = getPieceHtml(piece.type, piece.player)
  element.innerHTML = html
  element.draggable = (piece.player_id == player_id)
  # this is accessed as .attributes['data-piece-id'] above
  element.dataset.pieceId = piece.id

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

updateTurn = (turn) ->
  if turn % 2 == 0
    $('#white-player').addClass('active-player')
    $('#black-player').removeClass('active-player')
  else
    $('#white-player').removeClass('active-player')
    $('#black-player').addClass('active-player')
