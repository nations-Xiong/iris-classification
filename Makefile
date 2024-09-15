all:
	./utils.sh push

pull:
	./utils.sh pull

gst:
	./utils.sh gst

continue-work:
	./utils.sh continue-work

.PHONY: all pull gst continue-work
