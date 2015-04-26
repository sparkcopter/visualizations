class LiveChart
  constructor: (@element, options={})->
    n = 100
    duration = 100
    now = new Date(Date.now() - duration)
    count = 0
    data = d3.range(n).map(-> 0)

    margin = {top: 6, right: 0, bottom: 20, left: 40}
    width = 960 - margin.right
    height = 120 - margin.top - margin.bottom

    x = d3.time.scale()
        # .domain([now - (n - 2) * duration, now - duration])
        .range([0, width]);

    y = d3.scale.linear()
        .domain([-90, 90])
        .range([height, 0]);

    line = d3.svg.line()
        .interpolate("basis")
        .x((d, i) -> x(now - (n - 1 - i) * duration))
        .y((d, i) -> y(d));

    svg = d3.select(@element).append("svg")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
        .style("margin-left", -margin.left + "px")
      .append("g")
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    svg.append("defs").append("clipPath")
        .attr("id", "clip")
      .append("rect")
        .attr("width", width)
        .attr("height", height);

    axis = svg.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0," + height + ")")
        .call(x.axis = d3.svg.axis().scale(x).orient("bottom"));

    path = svg.append("g")
        .attr("clip-path", "url(#clip)")
      .append("path")
        .datum(data)
        .attr("class", "line");

    transition = d3.select({}).transition()
        .duration(duration)
        .ease("linear");

    d3.select(window)
        .on("scroll", -> ++count );

    # tick = ->
    #   transition = transition.each(->
    #
    #     # update the domains
    #     now = new Date();
    #     x.domain([now - (n - 2) * duration, now - duration]);
    #     # y.domain([0, d3.max(data)]);
    #
    #     # push the accumulated count onto the back, and reset the count
    #     data.push(Math.min(30, count) * 10);
    #     count = 0;
    #
    #     # redraw the line
    #     svg.select(".line")
    #         .attr("d", line)
    #         .attr("transform", null);
    #
    #     # slide the x-axis left
    #     axis.call(x.axis);
    #
    #     # slide the line left
    #     path.transition()
    #         .attr("transform", "translate(" + x(now - (n - 1) * duration) + ")");
    #
    #     # pop the old data point off the front
    #     data.shift();
    #
    #   ).transition().each("start", tick);
    #
    # tick()

  push: (dataPoint) ->
    # update the domains
    now = new Date();
    x.domain([now - (n - 2) * duration, now - duration]);
    # y.domain([0, d3.max(data)]);

    # push the accumulated count onto the back, and reset the count
    data.push(dataPoint)
    count = 0;

    # redraw the line
    svg.select(".line")
        .attr("d", line)
        .attr("transform", null);

    # slide the x-axis left
    axis.call(x.axis);

    # slide the line left
    path.transition()
        .attr("transform", "translate(" + x(now - (n - 1) * duration) + ")");

    # pop the old data point off the front
    data.shift();
