build-rpi4:
	docker run --rm --privileged -v /dev:/dev -v ${PWD}:/build mkaczanowski/packer-builder-arm build boards/raspberry-pi-4/image.pkr.hcl

.PHONY: build-rpi4