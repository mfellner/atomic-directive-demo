# GULP-FILE --------------------------------------------------------------------

gulp        = require 'gulp'
glob        = require 'glob'
gutil       = require 'gulp-util'
runsequence = require 'run-sequence'
browsersync = require 'browser-sync'

jshint = require 'gulp-jshint'
jade   = require 'gulp-jade'

# CONFIG -----------------------------------------------------------------------

sources =
  js:  glob.sync 'js/**/**/**/*.js'
  less: [
    'less/main.less'
    ]
  vendor: [
    'bower_components/less/dist/less-1.7.3.js'
    'bower_components/angular/angular.js'
    ]
  jade: [
    'index.jade'
    ]

destinations =
  js  : 'js'
  css : 'css'
  html: '.'

JADE_LOCALS =
  styles : sources.less
  scripts: [].concat sources.vendor, sources.js

# TASKS ------------------------------------------------------------------------

gulp.task 'jshint', ->
  gulp.src sources.js
  .pipe jshint()
  .pipe jshint.reporter 'fail'

gulp.task 'jade', ->
  gulp.src sources.jade
  .pipe jade
    locals: JADE_LOCALS
    pretty: yes
  .pipe gulp.dest destinations.html

gulp.task 'browsersync', ->
  browsersync.init
    files: [
      sources.js
      glob.sync './**/**/**/*.html'
      glob.sync 'less/*.less'
      glob.sync 'js/**/**/**/*.less'
      glob.sync 'bower_components/**/**/**/*.js'
      glob.sync 'bower_components/**/**/**/*.css'
    ]
    online: no
    server:
      baseDir: './'

gulp.task 'watch', ->
  runsequence ['jshint', 'jade'], 'browsersync'

gulp.task 'dist', ->
  runsequence ['jshint', 'jade']

gulp.task 'default', ['watch']
