express = require "express"
http = require "http"
socketio = require "socket.io"
drone  = require "ar-drone"
dotenv = require "dotenv"

# Load environmental variables
dotenv.load()

# Create a webserver and connect socket.io to it
app = express()
server = http.Server(app)
io = socketio(server)

# Create an ar-drone client
client  = drone.createClient
  ip: process.env.DRONE_IP

# Configure express
app.set "view engine", "jade"
app.use express.static(process.cwd() + "/public")

# Set up HTTP actions
app.get "/", (req, res) ->
  res.render "index", { title: 'Hey', message: 'Hello there!'}

# Set up Socket.io actions
io.on "connection", (socket) ->
  console.log('a user connected')

  socket.on "disconnect", ->
    console.log('user disconnected')

  # Send navdata to connected clients
  client.on "navdata", (navdata) ->
    socket.emit "rotation",
      x: navdata.demo.rotation.x
      y: navdata.demo.rotation.y
      z: navdata.demo.rotation.z

# # Output navdata
# client.on "navdata", (navdata) ->
#   console.log "roll/pitch/yaw: #{navdata.demo.rotation.roll}/#{navdata.demo.rotation.pitch}/#{navdata.demo.rotation.yaw}"

# Start the server
server.listen 3000, ->
  console.log('listening on *:3000')
