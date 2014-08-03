# GULP-FILE --------------------------------------------------------------------

gulp        = require 'gulp'
glob        = require 'glob'
jshint      = require 'gulp-jshint'
runsequence = require 'run-sequence'
browsersync = require 'browser-sync'

# CONFIG -----------------------------------------------------------------------

sources =
  js:  glob.sync 'js/**/**/**/*.js'
  less: [
    glob.sync 'less/*.less'
    glob.sync 'js/**/**/**/*.less'
    ]
  vendor: [
    glob.sync 'bower_components/**/**/**/*.js'
    glob.sync 'bower_components/**/**/**/*.css'
  ]
  html: glob.sync './**/**/**/*.html'

# TASKS ------------------------------------------------------------------------

gulp.task 'jshint', ->
  gulp.src sources.js
  .pipe jshint()
  .pipe jshint.reporter 'fail'

gulp.task 'browsersync', ->
  browsersync.init
    files: [
      sources.js
      sources.less
      sources.html
      sources.vendor
    ]
    online: no
    server:
      baseDir: './'

gulp.task 'default', ->
  runsequence 'jshint', 'browsersync'
