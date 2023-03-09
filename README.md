## mrbluesky
### Dependencies

* Docker
    * Ruby: 3.2.1
    * Rails: "~> 7.0.4", ">= 7.0.4.2"
    * environment file (e.g., a `.env` at the root)
        * WEATHER_CLIENT_JWT
        * MAPS_CLIENT_JWT

### Configuration

Add a `.env` file in the root of the repo.

```
WEATHER_CLIENT_JWT=token
MAPS_CLIENT_JWT=token
```

### System Dependencies and Development

The app as-is depends on:

1. A compatible Docker installation (e.g., Docker Desktop 4.7.1)
2. A server on the host machine running Postgres (with default port of 5432)
3. A host machine that is running macOS (or alterations to database config)

The app can be run with *docked rails*.

```sh
alias docked='docker run --rm -it --env-file .env -v ${PWD}:/rails -v ruby-bundle-cache:/bundle -p 3000:3000 ghcr.io/rails/cli'
docked bundle
docked rails db:create
docked rails db:migrate
docked rials server
```

### NOTE

In lieu of docker, the app can of course be run with the app depencies run on the host machine (YMMV).
