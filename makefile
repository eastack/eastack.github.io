all:
	@cp -r resources public
	@docker run --rm \
	  --user $(shell id -u):$(shell id -g) \
	  --volume $(shell pwd):/documents \
	  asciidoctor/docker-asciidoctor \
	  asciidoctor 'asciidoc/**/*.adoc' \
	    --source-dir=asciidoc \
	    --destination-dir=public \
	    --attribute=source-highlighter=highlightjs \
	    --attribute=highlightjsdir=/.highlightjs \
	    --attribute=icons=font \
	    --attribute=prewrap! \
	    --attribute=nofooter \
	    --require asciidoctor-diagram
	@rm -rf \?

clean:
	@rm -rf public
