# Socket.io
socket = io()
socket.on "connect", ->
  console.debug "Socket.io connected"

# Create live charts
$("[data-chart]").each ->
  chart = new LiveChart(this)
  chart.connect(socket)

# Create attitude indicator
$("[data-attitude]").each ->
  attitude = new AttitudeIndicator(this)

  orientation = {yaw: 0, pitch: 0, roll: 0}

  socket.on "pitch", (degrees) ->
    orientation.pitch = degrees
    attitude.draw(orientation.yaw, orientation.pitch, orientation.roll)

  socket.on "roll", (degrees) ->
    orientation.roll = degrees
    attitude.draw(orientation.yaw, orientation.pitch, orientation.roll)

# Attach buttons
$("[data-trim]").click ->
  $.ajax
    url: "/trim"
    method: "POST"
