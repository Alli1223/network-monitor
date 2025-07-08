.PHONY: install-deps run build build-windows run-docker

install-deps:
cd flutter_network_monitor && flutter pub get

run:
cd flutter_network_monitor && flutter run

build:
cd flutter_network_monitor && flutter build linux

build-windows:
cd flutter_network_monitor && flutter build windows

run-docker:
docker run --rm -it -v $(PWD)/flutter_network_monitor:/app -w /app ghcr.io/cirruslabs/flutter:latest flutter run
