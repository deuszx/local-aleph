setup-submodules:
	git submodule add --depth 1 https://github.com/Cardinal-Cryptography/aleph-node && \
	git submodule init && \
	git submodule update

update-aleph-node:
	cd aleph-node && \
	git fetch origin && \
	git pull origin main

build-aleph-node:
	cd aleph-node && \
	cargo build --release -p aleph-node

build-aleph-image: build-aleph-node
	docker build -t deuszx/local-aleph .

run-aleph-network:
	docker run --rm -itd --name local-aleph -p 9944:9944 -p 30334:30334 -p 9933:9933 deuszx/local-aleph