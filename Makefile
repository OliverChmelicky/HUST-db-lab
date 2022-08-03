stop:
	docker container stop db-svc

rm:
	docker rm db-svc

whipe: stop rm

up:
	docker-compose up