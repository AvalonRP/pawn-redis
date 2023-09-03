# -
# Setup test requirements
# -

test-setup:
	cd test && sampctl server ensure
	sampctl package ensure

redis:
	-docker stop redis
	-docker rm redis
	docker run \
		--name redis \
		--publish 6379:6379 \
		--detach \
		redis

redis-ui:
	echo "requires npm install -g redis-commander"
	redis-commander \
		--redis-host=localhost \
		--redis-port=6379

# -
# Run Tests
# -

test-windows:
	sampctl package build
	cd test && sampctl server run

test-linux:
	sampctl package build
	cd test && sampctl server run --container

# -
# Build (Linux)
# -

build-linux:
	rm -rf build
	docker build -t southclaws/pawn-redis-build .
	docker run -v $(shell pwd)/build/plugins:/root/test/plugins southclaws/pawn-redis-build

build-inside:
	cd build && cmake .. && make
