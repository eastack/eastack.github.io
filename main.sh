#!/usr/bin/env bash

author='Wang Heng'
email='admin@eastack.me'
homepage='https://eastack.me'

compile() {
  echo compiling "$1" ...
  asciidoctor "$1" \
        --source-dir=asciidoc \
        --destination-dir=public \
        --attribute=favicon=/favicon.ico \
        --attribute=lang=zh-Hans \
        --attribute=source-highlighter=rouge \
        --attribute=icons=font \
        --attribute=toc=left@ \
        --attribute=toc-title=目录 \
        --attribute=docinfo=shared \
        --attribute=nofooter \
        --attribute=linkcss \
        --attribute=stylesdir=.asciidoctor \
        --attribute=copycss \
        --attribute=author="$author" \
        --attribute=email="$email" \
        --require asciidoctor-diagram \
        --require asciidoctor-mathematical
  rm -rf \?
}

build() {
  compile 'asciidoc/**/*.adoc'
  find asciidoc/posts/publish -name '*.adoc' \
    | sed 's/^asciidoc//;s/.adoc$$/.html/' \
    | xargs -I {} echo '$(homepage){}' \
    | cat - <(echo '$(homepage)') \
    | cat - <(echo '$(homepage)/robots.txt') \
    | cat - <(echo '$(homepage)/sitemap.txt') \
    > static/sitemap.txt
  cp -rT static public
}

serve() {
  trap 'echo Asciidoctor server exited.' TERM INT
  python3 -m http.server -d public &
  echo 'Asciidoctor server starting...'
  inotifywait -qmr -e 'modify' \
    --format '%w%f%0' --no-newline \
    --include '.*\.adoc$' asciidoc | \
    while IFS= read -r -d '' file
    do
      compile $file
    done &
  wait $!
}

main() {
  if [[ $1 == 'build' ]]; then
  	build
  elif [[ $1 == 'serve' ]]; then
  	serve
  fi
}

main "$@"
