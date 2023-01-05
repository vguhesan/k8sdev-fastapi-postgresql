![DevContainer Podman Python FastAPI Postgres Aewesome Template](docs/images/podman_python_fastapi_postgres_template.png)

## Podman + Python FastAPI middleware + PostgreSQL DB backend

- Python FastAPI (for middleware)
- PostgreSQL DB (for backend)

## Credit (where its due)

This template has been extended from [FastAPI-Awesome-Compose](https://github.com/docker/awesome-compose/tree/master/fastapi). _I am building upon the shoulders of giants, following their off beaten path. So, thank you._ The base template has the middleware but lacks Postgres DB backend integrated into the template. This body of work takes the Python FastAPI template and extends it to add the PostgreSQL DB layer on the backend. It also bootstraps the creation of an AppDB database (outside of the postgres DB) and creates a Bookstore schema. It goes further to bootsrap the initialization to create a Book table and auto imports the Books data available in the public domain.

## Use it with...

- [Docker](#how-to-use-with-docker-development-environments)
- [Podman](#how-to-use-this-template-with-podmanpodman-desktop-development-environment)

<a name="docker"></a>

## How to use with Docker Development Environments

You can open this sample in the Dev Environments feature of Docker Desktop version 4.12 or later.

[Open in Docker Dev Environments <img src="../open_in_new.svg" alt="Open in Docker Dev Environments" align="top"/>](https://open.docker.com/dashboard/dev-envs?url=https://github.com/docker/awesome-compose/tree/master/fastapi)

## Python/FastAPI application

Project structure:

```
├── compose.yaml
├── Dockerfile
├── requirements.txt
├── app
    ├── main.py
    ├── __init__.py

```

[_compose.yaml_](compose.yaml)

```
services:
  api:
    build: .
    container_name: fastapi-application
    environment:
      PORT: 8000
    ports:
      - '8000:8000'
    restart: "no"

```

## Deploy with docker compose

```shell
docker-compose up -d --build

# Expected result

# Listing containers must show one container running and the port mapping as below:

$ docker ps
CONTAINER ID   IMAGE          COMMAND       CREATED              STATUS              PORTS                                               NAMES
7087a6e79610   5c1778a60cf8   "/start.sh"   About a minute ago   Up About a minute   80/tcp, 0.0.0.0:8000->8000/tcp, :::8000->8000/tcp   fastapi-application
```

After the application starts, navigate to `http://localhost:8000` in your web browser and you should see the following json response:

```
{
"message": "OK"
}
```

Stop and remove the containers

```
$ docker compose down
```

<a name="podman"></a>

## How to use this template with Podman/Podman Desktop Development Environment?

## Prerequisites

- podman
- podman-compose
- podman desktop

```
podman-compose -f compose.yaml up -d
```

## Sample View in Podman Desktop

![Container View](docs/images/podman-container-view.jpg)
![Volume View](docs/images/podman-volume-view.jpg)

## How to reinitialize the Postgres Volume?

```
# Stop and delete the containers, then:

podman volume list | grep "db-data"
podman volume rm ${volume-name}
-or-
podman volume rm  $(podman volume list | grep "db-data" | cut -d " "  -f2-)
```

## To connect via psql

```
# psql [OPTION]... [DBNAME [USERNAME]]

# To connect to main DB
podman exec -it $(podman container list | grep "docker.io/library/postgres" | cut -d " " -f1) psql postgres postgres;

# To connect to appdb (bookstore schema is under appdb)
podman exec -it $(podman container list | grep "docker.io/library/postgres" | cut -d " " -f1) psql appdb appusr;

# After the psql prompt:
appdb=> \dt bookstore.*;
          List of relations
  Schema   | Name | Type  |  Owner
-----------+------+-------+----------
 bookstore | book | table | postgres
(1 row)
appdb=> SELECT * FROM bookstore.book LIMIT 10;
... removed intentionally
(10 rows)
```

## Iterative Development in Podman

When you modify your application (FastAPI Python code), you want to rerun the following commands in sequence:

```
podman-compose down
podman-compose build
podman-compose -f compose.yaml up -d
```

Repeating the three commands iteratively can become tedious very quick. To automate this process, you can leverage some tools available to you.

Option #1: [FSWatch](https://github.com/emcrisostomo/fswatch)

This utility is cross-platform (Linux, macOS, Windows). Install it based on your OS and then:

```
$ fswatch -or YOUR_PATHS | xargs -n1 -I{} YOUR_COMMAND
```

fswatch accepts a list of paths to monitor. The `-o` option asks the tool to group changes by batch, and the `-r` option stands for watching subdirectories recursively. Events are then sent through xargs to your command.

Option #2: [Skaffold](https://skaffold.dev)

This tool currently has support for `kubectl` and `minikube` (as of this writing), does not support `podman desktop` or `podman` yet. More on this at a future time.

Now, let us leverage Option #1 to implement a rebuild lifecycle. See `rebuild-and-deploy` Bash script included here with this project.

```
fswatch -or ./app | xargs -n1 -I{} ./rebuild-and-deploy.sh
```

To stop watching, simply kill the above command. Simple as that.

Now if you make any changes to the ./app/main.py file and you hit save. You will notice that it incrementally rebuilds and deploys it locally within your `Podman Desktop` leveraging `podman-compose` for the Container orchestration.

Please bear in mind that this is not the most efficient way to continually rebuild the container with each change. A more pragmatic and efficient approach will be to copy the content of the /app/\*\* to the container using a rsync strategy and to leverage `uvicorn` Python [FastAPI](https://fastapi.tiangolo.com/) server with the `--reload` option (like this: `uvicorn main:app --reload`) for the Docker RUN. More on this soon...

The above described strategy works for cases where you have interpretted/scripted Programming languages such as Python and does not work for compiled/binary artifact languages like Golang. In the later case, you will need to iteratively compile the code to a binary artifact and then rsync the binary artifact to the middleware image and have a similar restart service which restarts the binary artifact. Stay tuned for examples of this nature.
