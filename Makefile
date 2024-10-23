build:
	podman-compose build

run:
	podman-compose up

down:
	podman-compose down

article:
	podman-compose run --rm app npx zenn new:article

