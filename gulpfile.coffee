gulp = require 'gulp'
fs = require 'fs'


onError = (err) ->
  console.log(err.message)
  console.log(err.stack)
  this.emit('end')


# `gulp-load-plugins` loads all the modules in your `package.json` that begin with `gulp-` converting  dashes to camelcase, e.g. `'gulp-front-matter'` becomes `plugins.frontMatter`
gulpLoadPlugins = require 'gulp-load-plugins'
plugins = gulpLoadPlugins()

style_glob = ["src/*.less"]

gulp.task "less", ->
  gulp.src(style_glob).pipe(plugins.watch())
  .pipe(plugins.less()).pipe(plugins.continuousConcat('style.css'))
  .pipe(gulp.dest("./dist")).pipe(plugins.connect.reload())


js_glob = ["src/*.js", "lib/*.js", "src/*.coffee"]
# js_glob = ["src/*.js", "lib/a_underscore.js", "lib/*.js", "src/*.coffee"]
# Watch our coffeescript, and add it to our javascript
gulp.task "coffee", ->
  coffee_filter = plugins.filter("*.coffee")
  gulp.src(js_glob).pipe(plugins.watch())
  .pipe(plugins.plumber({errrorHandler:onError}))
  .pipe(coffee_filter).pipe(plugins.coffee({bare: true}).on('error', plugins.util.log)).pipe(coffee_filter.restore())
  .pipe(plugins.continuousConcat('script.js')).pipe(gulp.dest("./dist")).pipe(plugins.connect.reload())

gulp.task 'connect', ->
  plugins.connect.server
    root: './dist'
    port: 8882
    livereload:
      port: 35735

gulp.task 'default', ['coffee', 'connect', 'less']


aws_site = require './aws-site.coffee' 

try
  aws_config = JSON.parse(fs.readFileSync("./aws.json"));
catch err
  plugins.util.log plugins.util.colors.bgRed 'No AWS config found!'

publisher = plugins.awspublish.create(aws_config)
# headers = {'Cache-Control': 'max-age=315360000, no-transform, public'}; # 10 years
headers = {'Cache-Control': 'max-age=3600, no-transform, public'}; #  1 hour


# Delete every damn thing in a bucket. Use with care.
gulp.task "delete", ->
  gulp.src('./noexist/*')
  .pipe(publisher.sync())
  .pipe(plugins.awspublish.reporter())


# ## Publishing to S3
gulp.task 'publish', ->
  gulp.src('dist/**/**')
  .pipe(plugins.awspublish.gzip())
  .pipe(publisher.publish())
  .pipe(publisher.cache())
  .pipe(plugins.awspublish.reporter())

# Set up a bucket
gulp.task 'setup_bucket', ->
  aws_site.config aws_config
  aws_site.createBucket ->
    aws_site.putBucketPolicy ->
      aws_site.configureWebsite(aws_config.bucket)

# gulp.task 'cloudfront', ->
#   revAll = new plugins.revAll()
#   gulp.src('dist/**')
#       .pipe(revAll.revision())
#       .pipe(plugins.awspublish.gzip())
#       .pipe(publisher.publish(headers))
#       .pipe(publisher.cache())
#       .pipe(plugins.awspublish.reporter())
#       .pipe(plugins.cloudfront(aws_config))


