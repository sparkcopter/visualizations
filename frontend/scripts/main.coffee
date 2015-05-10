# Socket.io
socket = io()
socket.on "connect", ->
  console.debug "Socket.io connected"

# Create live charts
$("[data-chart]").each ->
  chart = new LiveChart(this)
  chart.connect(socket)
