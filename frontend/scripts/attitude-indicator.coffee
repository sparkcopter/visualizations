class AttitudeIndicator
  constructor: (@element) ->
    # Configuration
    @radius = 175
    @globeRatio = 0.85
    @rollOverlaySize = @radius * (1 - @globeRatio) + 1
    @majorPitchTicks = [-60, -40, -20, 20, 40, 60]
    @minorPitchTicks = [-50, -30, -10, 10, 30, 50]
    @majorRollTicks = [-90, -60, -30, 0, 30, 60, 90]
    @minorRollTicks = [-20, -10, 10, 20]

    # Create the canvas
    selection = d3.select(@element).append("canvas")
      .attr("width", @radius*2)
      .attr("height", @radius*2)
      .style("width", @radius*2 + "px")
      .style("height", @radius*2 + "px")

    @context = selection[0][0].getContext("2d")

    # Create an orthographic projection
    @projection = d3.geo.orthographic()
      .scale(@radius  * @globeRatio)
      .clipAngle(90)
      .translate([@radius, @radius])

    # Create "earth"
    @earth = d3.geo.circle()
      .angle(90)
      .origin([0,-90])

    # Draw the initial state
    @draw(0,0,0)

  draw: (yaw, pitch, roll) ->
    # Clear the canvas
    @context.clearRect(0, 0, @radius*2, @radius*2);

    # Draw the globe (earth, sky, horizon)
    @drawGlobe(yaw, pitch, roll)

    # Draw static overlays (aircraft, roll indicator)
    @drawStaticOverlays()

    # Draw rotating overlays (roll ticks)
    @drawRollOverlays(roll)

  drawGlobe: (yaw, pitch, roll) ->
    # Rotate the d3 projection
    @projection.rotate([yaw, pitch, roll])

    # Create a drawing path
    path = d3.geo.path()
      .context(@context)
      .projection(@projection)

    # Draw the "sky"
    @context.fillStyle = "#98bbc4"
    @context.beginPath()
    path({type: "Sphere"})
    @context.fill()

    # Draw the "earth"
    @context.fillStyle = "#765636"
    @context.beginPath()
    path(@earth())
    @context.fill()

    # Draw the "horizon"
    @context.strokeStyle = "#fff"
    @context.lineWidth = 3
    @context.beginPath()
    path({
      type: 'LineString',
      coordinates: [[-180, 0], [-90, 0], [0, 0], [90, 0], [180, 0]]
    })
    @context.stroke()

    # Draw major pitch ticks
    @context.strokeStyle = "rgba(255,255,255,0.8)"
    @context.lineWidth = 2
    @majorPitchTicks.forEach (degs) => @drawPitchTick(path, degs, 15)

    # Draw minor pitch ticks
    @context.strokeStyle = "rgba(255,255,255,0.5)"
    @context.lineWidth = 1
    @minorPitchTicks.forEach (degs) => @drawPitchTick(path, degs, 5)

  drawStaticOverlays: ->
    # Draw "aircraft"
    aircraftWidth = @radius * 2 * @globeRatio * (1/2)
    @context.strokeStyle = "#ffcc00"
    @context.lineWidth = 6
    @context.beginPath()
    @context.moveTo(@radius - aircraftWidth / 2, @radius);
    @context.lineTo(@radius + aircraftWidth / 2, @radius);
    @context.stroke()

    # Draw roll indicator triangle
    @context.fillStyle = "#ffcc00"
    @context.beginPath()
    @context.moveTo(@radius - 10, @radius * (1 - @globeRatio) + 25);
    @context.lineTo(@radius, @radius * (1 - @globeRatio));
    @context.lineTo(@radius + 10, @radius * (1 - @globeRatio) + 25);
    @context.closePath()
    @context.fill()

  drawRollOverlays: (roll) ->
    # Rotate roll canvas based on current roll state
    @context.save()
    @context.translate(@radius, @radius)
    @context.rotate(-roll*(Math.PI/180))
    @context.translate(-@radius, -@radius)

    # Draw roll canvas
    @context.strokeStyle = "#666"
    @context.lineWidth = @rollOverlaySize
    @context.beginPath();
    @context.arc(@radius, @radius, @radius - @context.lineWidth/2, 0, 2*Math.PI);
    @context.stroke()
    @context.translate(@radius, @radius)

    # Draw major roll ticks
    @context.strokeStyle = "rgba(255,255,255, 0.8)"
    @context.lineWidth = 3
    @majorRollTicks.forEach (degs) => @drawRollTick(degs, 0.96)

    # Draw minor roll ticks
    @context.strokeStyle = "rgba(255,255,255,0.5)"
    @context.lineWidth = 2
    @minorRollTicks.forEach (degs) => @drawRollTick(degs, 0.93)

    @context.restore()

  drawRollTick: (degrees, scale) ->
    radians = (degrees - 90) * (Math.PI/180)
    x = @radius * Math.cos(radians)
    y = @radius * Math.sin(radians)
    length = (@radius - @rollOverlaySize) / @radius

    @context.beginPath()
    @context.moveTo(x*scale, y*scale)
    @context.lineTo(x*length, y*length)
    @context.stroke()

  drawPitchTick: (path, degrees, size) ->
    @context.beginPath()
    path({
      "type": "LineString",
      "coordinates": [[-size, degrees], [size, degrees]]
    })
    @context.stroke()
