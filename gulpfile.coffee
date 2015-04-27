# Gulp and helpful tools
gulp = require "gulp"
bower = require "bower"
bowerFiles = require "main-bower-files"
rimraf = require "rimraf"

# Gulp plugins
autoprefixer = require "gulp-autoprefixer"
coffee       = require "gulp-coffee"
concat       = require "gulp-concat"
filter       = require "gulp-filter"
plumber      = require "gulp-plumber"
sass         = require "gulp-sass"
util         = require "gulp-util"

# Compile sass files to css
gulp.task "sass", ->
    gulp.src "styles/*.scss"
      .pipe sass()
      .pipe autoprefixer()
      .pipe gulp.dest('public/css')

# Compile coffeescript files to javascript
gulp.task "coffee", ->
    gulp.src "scripts/*.coffee"
      .pipe(plumber()) # Prevent pipe breaking caused by errors from gulp plugins
      .pipe(coffee({bare: true}))
      .pipe(gulp.dest("public/javascript"))

# Install bower dependencies
gulp.task "bower-install", ->
  bower.commands.install()

# Vendor javascript and css files from bower
gulp.task "vendor-js", ["bower-install"], ->
 	gulp.src bowerFiles()
		.pipe filter("*.js")
		.pipe concat("vendor.js")
		.pipe gulp.dest("public/javascript")

gulp.task "vendor-css", ["bower-install"], ->
 	gulp.src bowerFiles()
		.pipe filter("*.css")
		.pipe concat("vendor.css")
		.pipe gulp.dest("public/css")

# Watch files For changes
gulp.task "watch", ->
    gulp.watch "scripts/*.coffee", ["coffee"]
    gulp.watch "styles/*.scss", ["sass"]
    gulp.watch "bower.json", ["bower-install"]
    gulp.watch "bower_components/**", ["vendor-js", "vendor-css"]

# Clean up auto-generated files
gulp.task "clean", ->
    rimraf "bower_components", ->
    rimraf "public", ->

# Default task
gulp.task "default", ["sass", "coffee", "bower-install", "vendor-js", "vendor-css", "watch"]
