# Socket.io
socket = io()

# Create a new live chart
chart = new LiveChart("#rotation-x")

# Subscribe to rotation events from the server
socket.on "rotation", (rotation) ->
  chart.push(rotation.x)
  console.log "roll=#{rotation.x}, pitch=#{rotation.y}, yaw=#{rotation.z}"
