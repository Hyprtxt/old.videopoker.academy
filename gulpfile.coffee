gulp = require('gulp')
gutil = require('gulp-util')
sass = require('gulp-sass')
sourcemaps = require('gulp-sourcemaps')
autoprefixer = require('gulp-autoprefixer')
coffee = require('gulp-coffee')
livereload = require('gulp-livereload')
rimraf = require('rimraf')
taskListing = require('gulp-task-listing')

gulp.task 'default', taskListing

gulp.task 'help', taskListing

gulp.task 'clean', ( cb ) ->
  rimraf './static_generated', cb
  return

gulp.task 'sass', ->
  gulp.src './src/sass/**/*.sass'
    .pipe sourcemaps.init()
    .pipe sass(
        outputStyle: 'expanded'
        includePaths: ['./bower_components/bootstrap/scss']
      ).on 'error', sass.logError
    .pipe autoprefixer ['> 1%']
    .pipe sourcemaps.write '../map' # , sourceRoot: __dirname + './src'
    .pipe gulp.dest './static_generated/css'
    .pipe livereload()
  return

gulp.task 'copyjs', ->
  gulp.src './bower_components/jquery/dist/*'
    .pipe gulp.dest './static_generated/js'
  gulp.src './modules/*.coffee'
    .pipe sourcemaps.init()
    .pipe coffee(
      bare: true
    ).on 'error', gutil.log
    .pipe sourcemaps.write '../map'
    .pipe gulp.dest './static_generated/js'

gulp.task 'copystyle', ->
  gulp.src './bower_components/font-awesome/css/*'
    .pipe gulp.dest './static_generated/css'
  gulp.src './bower_components/font-awesome/fonts/*'
    .pipe gulp.dest './static_generated/fonts'

gulp.task 'coffee', ->
  gulp.src './src/coffee/**/*.coffee'
    .pipe sourcemaps.init()
    .pipe coffee(
        bare: true
      ).on 'error', gutil.log
    .pipe sourcemaps.write '../map' # , sourceRoot: __dirname + './src'
    .pipe gulp.dest './static_generated/js'
    .pipe livereload()
  return

gulp.task 'reload', ->
  # This task only works when the livereload server is up
  # Jade is compiled by Hapi, so a reload is all we need
  livereload.reload()
  return

gulp.task 'build', ['copystyle', 'sass', 'copyjs', 'coffee']

gulp.task 'watch', ['copystyle', 'sass', 'copyjs', 'coffee'], ->
  livereload.listen
    basePath: './src'
    start: true
  gulp.watch './src/sass/**/*.sass', ['sass']
  gulp.watch './src/coffee/**/*.coffee', ['coffee']
  gulp.watch './views/**/*.jade', ['reload']
  return
