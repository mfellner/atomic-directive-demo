# GULP-FILE --------------------------------------------------------------------

gulp        = require 'gulp'
glob        = require 'glob'
globall     = require 'glob-all'
gutil       = require 'gulp-util'
rimraf      = require 'gulp-rimraf'
concat      = require 'gulp-concat'
rename      = require 'gulp-rename'
runsequence = require 'run-sequence'
browsersync = require 'browser-sync'

jshint = require 'gulp-jshint'
uglify = require 'gulp-uglify'
jade   = require 'gulp-jade'
less   = require 'gulp-less'

# CONFIG -----------------------------------------------------------------------

isDistBuild = no

sources =
  js:  [
    'js/**/**/**/*.js'
    '!js/*.min.js'
    ]
  less: [
    'less/main.less'
    ]
  libs: ->
    if isDistBuild
      [
        'bower_components/angular/angular.min.js'
      ]
    else
      [
        'bower_components/less/dist/less-1.7.3.js'
        'bower_components/angular/angular.js'
      ]
  jade: [
    'index.jade'
    ]

destinations =
  js  : 'js/'
  css : 'css/'
  html: './'

jadeLocals = ->
  if isDistBuild
    styles : glob.sync destinations.css + '*.min.css'
    scripts: glob.sync destinations.js  + '*.min.js'
  else
    styles : sources.less
    scripts: [].concat sources.libs(), globall.sync sources.js

# TASKS ------------------------------------------------------------------------

gulp.task 'jshint', ->
  gulp.src sources.js
  .pipe jshint()
  .pipe jshint.reporter 'fail'

gulp.task 'jade', ->
  gulp.src sources.jade
  .pipe jade
    locals: jadeLocals()
    pretty: yes
  .pipe gulp.dest destinations.html

gulp.task 'less', ->
  gulp.src sources.less
  .pipe less
    cleancss     : yes
    strictImports: yes
  .pipe rename 'app.min.css'
  .pipe gulp.dest destinations.css

gulp.task 'libs', ->
  gulp.src sources.libs()
  .pipe concat 'app.libs.min.js'
  .pipe gulp.dest destinations.js

gulp.task 'uglify', ->
  gulp.src sources.js
  .pipe concat 'app.min.js'
  .pipe uglify()
  .pipe gulp.dest destinations.js

gulp.task 'js', ['libs', 'uglify']

gulp.task 'clean', ->
  gulp.src [
    destinations.js  + '*.min.js',
    destinations.css + '*.min.css'
  ]
  .pipe rimraf()

gulp.task 'browsersync', ->
  browsersync.init
    files: [
      glob.sync 'js/**/**/**/*.js'
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
  isDistBuild = yes
  runsequence 'clean', 'jshint', ['js', 'less'], 'jade'

gulp.task 'dist:watch', ->
  isDistBuild = yes
  runsequence 'dist', 'browsersync'

gulp.task 'default', ['watch']
