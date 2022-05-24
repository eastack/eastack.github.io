all: build

build:
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

watch:
	@find -name "*.adoc" | entr asciidoctor /_ \
	    --source-dir=asciidoc \
	    --destination-dir=public \
	    --attribute=source-highlighter=rouge \
	    --attribute=icons=font \
	    --attribute=toc=left@ \
	    --attribute=toc-title=目录 \
	    --attribute=nofooter \
	    --attribute=linkcss \
	    --attribute=stylesdir=.asciidoctor \
	    --attribute=copycss &

clean:
	@rm -rf public
