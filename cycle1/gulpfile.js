const gulp = require('gulp')
const babelify = require('babelify')
const browserify = require('browserify')
const source = require('vinyl-source-stream')

function build() {
  return browserify({
    entries: ['./wallet/background.js']
  })
  .transform(babelify)
  .bundle()
  .pipe(source('wallet-background-bundle.js'))
  .pipe(gulp.dest('./public/scripts'))
}

gulp.task('build', build)

gulp.task('watch', () => {
  gulp.watch('./wallet/background.js', build)
})
