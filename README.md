# What

This repository contains a dockerized Aleph network of 4 validators and a separate container running polkadot-js-app.

# Why

To faciliate and speed-up development and end-to-end testing process.

# How

## Prerequisites

To start, make sure you have installed:
* docker
* docker compose
* Rust

## Seting up repositories

1. `make setup-submodules` to clone Aleph node repository as git submodule and update it.
2. `make update-aleph-node` updates Aleph's git submodule. Update it whenever you want to use latest version of Aleph.

## Building Docker image

`make build-aleph-image` builds a Docker image that containerizes a network of four Aleph nodes. We're running a whole network of nodes within a single container, rather than via `docker compose up --scale 4` as that allows us for easier control over nodes' configuration.

## Running Aleph network

`make run-aleph-network` runs a container that uses previously-built Docker image. If you want, you can interact with the exposed ports directly:
* 30334 for node's p2p endpoint
* 9944 for websocket
* 9933 for RPC

## Running Aleph network with polkadot-js-app

In the root directory of the project, type `docker compose up` to run an Aleph network and a container with [polkadot-js-app](https://github.com/paritytech/polkadot/blob/master/doc/docker.md). Under `localhost:80` you will now find a polkadot-js-app attached to the Aleph network running in the first container.