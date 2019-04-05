up:
	docker-compose up -d
stop:
	docker-compose stop
	docker rm -f $(docker ps -a | grep imgur-storage | awk '{print $1}') || echo "\n\n >bash stoped before\n\n"
app:
	docker rm -f imgur-storage; docker-compose run --name imgur-storage --rm -p 8001:4000 phoenix iex -S mix phx.server

bash:
	docker-compose run phoenix bash
prod:
	docker-compose run \
		-e MIX_ENV=$MIX_ENV \
		-e NODE_ENV=$NODE_ENV \
		-e IMGUR_HOSTNAME=$IMGUR_HOSTNAME \
		--name imgur-storage --rm \
	  -p 8001:8001 \
	  phoenix iex -S mix phx.server
format:
	mix format mix.exs “lib/**/*.{ex,exs}”