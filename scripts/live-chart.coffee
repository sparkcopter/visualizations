class LiveChart
  constructor: (@element, options={})->
    @$element = $(@element)
    @event = @$element.data("chart")
    @times = []
    @data = []

    # TODO: Make these configurable
    @showSeconds = 10
    @tickFrequency = 1
    yDomain = @$element.data("ydomain")

    # TODO: Update these with browser resize
    width = @$element.width()
    height = @$element.height()

    margin =
      top: 0
      right: 0
      bottom: 0
      left: 0

    # Create the chart canvas
    @chart = d3.select(@element)
      .append("svg")
        .attr("width", width)
        .attr("height", height)
      .append("g")
        .attr("transform", "translate(#{margin.left}, #{margin.top})")

    # Create the x scale, axis and elemtn
    now = new Date()
    @x = d3.time.scale()
      .domain([d3.time.second.offset(now, -@showSeconds), now])
      .rangeRound([0, width - margin.left - margin.right]);

    @x.axis = d3.svg.axis()
      .scale(@x)
      .orient('bottom')
      .ticks(d3.time.seconds, @tickFrequency)
      .tickSize(0)

    @x.element = @chart.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0, #{(height - margin.top - margin.bottom)/2})")
      .call(@x.axis)

    # Create the y scale, axis and element
    @y = d3.scale.linear()
      .domain(yDomain)
      .rangeRound([0, height - margin.top - margin.bottom])

    # Create the data line and element
    @line = d3.svg.line()
      .x((d, i) => @x(d.time))
      .y((d, i) => @y(d.value))

    @line.element = @chart.append("g")
      .append("path")
        .datum(@data)
        .attr("class", "line")

    @chart.append("text")
      .attr("x", "0.5em")
      .attr("y", "0.25em")
      .attr("dy", "1em")
      .attr("class", "title")
      .text(@$element.data("title"))

  connect: (socket) ->
    socket.on @event, (dataPoint) => @push(dataPoint)

  push: (dataPoint) ->
    now = new Date()

    # Add new datapoint to array
    @data.push
      time: now
      value: dataPoint

    # Update x-axis domain
    @x.domain([d3.time.second.offset(now, -@showSeconds), now]);

    # Slide the x-axis left
    @x.element.call(@x.axis)

    # Redraw line
    @line.element
      .attr("d", @line)
      .attr("transform", null)

    # Remove old datapoints
    # TODO: Find the correct way to remove "off-screen" datapoints
    if @data.length > 300
      @data.splice(0, @data.length - 300)

  updateEventRate: ->
    @times.shift() if @times.length > 100

    now = new Date().getTime()
    @rate = @times.length * 1000 / (now - @times[0]) if @times.length > 0
    @times.push(now)
