all: build

build: clean
	@docker run --rm \
          --interactive --tty \
	  --user $(shell id -u):$(shell id -g) \
	  --volume $(shell pwd):/documents \
	  asciidoctor/docker-asciidoctor \
	  bash -c './main.sh build'

clean:
	@rm -rf public

serve: clean build
	@docker run --rm --detach \
	  --name asciidocker \
          --publish 8000:8000 \
	  --user $(shell id -u):$(shell id -g) \
	  --volume $(shell pwd):/documents \
	  asciidoctor/docker-asciidoctor \
	  bash -c './main.sh serve'

stop:
	@docker stop asciidocker

