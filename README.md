Sparkcopter Visualizations
==========================

Real-time sensor visualization app for Sparkcopter, a Spark Core based quadcopter.

While developing the firmware for the Sparkcopter, I found myself wanting to understand the ouputs of my sensors and calculations in a visual way, rather than looking through log output, so I built real-time roll/pitch/yaw charts and an aircraft-style attitude guage.

Since Sparkcopter is protocol-compatible with the Parrot AR.Drone quadcopter, these visualizations can also be used with your Parrot AR.Drone hardware. I'm using the awesome [node-ar-drone](https://github.com/felixge/node-ar-drone) library from [@felixge](https://github.com/felixge).


Screenshot
----------

![Screenshot](http://i.imgur.com/8iIMwbm.png)


Installation
------------

-   Install dependencies

    -   [Node.js](https://nodejs.org/) - [Installation instructions](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager)
    -   [Bower](http://bower.io/) - `npm install -g bower`
    -   [Gulp](http://gulpjs.com/) - `npm install --global gulp`

-   Clone the repository

    ```
    git clone https://github.com/sparkcopter/visualizations.git
    ```

-   Install the required node packages

    ```
    npm install
    ```


Running
-------

-   Start the app

    ```
    DRONE_IP=192.168.1.1 npm start
    ```
