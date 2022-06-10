all: build

build:
	@find asciidoc/blogs -name '*.adoc' \
		| sed 's/^asciidoc//;s/.adoc$$/.html/' \
		| xargs -I {} echo https://www.eastack.me{} \
		> static/sitemap.txt
	@cp -rT static public
	@docker run --rm \
	  --user $(shell id -u):$(shell id -g) \
	  --volume $(shell pwd):/documents \
	  asciidoctor/docker-asciidoctor \
	  asciidoctor 'asciidoc/**/*.adoc' \
	    --source-dir=asciidoc \
	    --destination-dir=public \
	    --attribute=favicon=/favicon.ico \
	    --attribute=lang=zh-Hans \
	    --attribute=source-highlighter=rouge \
	    --attribute=icons=font \
	    --attribute=toc=left@ \
	    --attribute=toc-title=目录 \
	    --attribute=nofooter \
	    --attribute=linkcss \
	    --attribute=stylesdir=.asciidoctor \
	    --attribute=copycss \
	    --require asciidoctor-diagram \
	    --require asciidoctor-mathematical
	@rm -rf \?

clean:
	@rm -rf public
