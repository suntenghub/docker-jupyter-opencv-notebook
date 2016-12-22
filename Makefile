init:
	pip install -r requirements-admin.txt
run:
	NB_UID=$(shell id -u) docker-compose up
build:
	docker-compose build
test_build:
	docker-compose run notebook python -c 'import cv2'
