build_docker:
	docker build -t swift-lambda-builder .

build_lambda:
	docker run \
		--rm \
		--volume "$(shell pwd)/:/src" \
		--workdir "/src/" \
		swift-lambda-builder \
		swift build --product ComicsInfoBackend -c release

package_lambda:
	docker run \
		--rm \
		--volume "$(shell pwd)/:/src" \
		--workdir "/src/" \
		swift-lambda-builder \
		Scripts/package.sh ComicsInfoBackend