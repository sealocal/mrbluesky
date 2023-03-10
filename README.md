## mrbluesky
### Dependencies

* Docker
    * Ruby: 3.2.1
    * Rails: "~> 7.0.4", ">= 7.0.4.2"
    * environment file (e.g., a `.env` at the root)
        * MRBLUESKY_DATABASE_URL (in production mode)
        * WEATHER_KIT_JWT_TEAM_ID
        * WEATHER_KIT_JWT_KEY_ID
        * WEATHER_KIT_SERVICE_ID
        * WEATHER_KIT_KEY_PATH

### Configuration

Add a `.env` file in the root of the repo.

```
MRBLUESKY_DATABASE_URL=postgres://
WEATHER_KIT_JWT_TEAM_ID=team_id
WEATHER_KIT_JWT_KEY_ID=key_id
WEATHER_KIT_SERVICE_ID=service_id
WEATHER_KIT_KEY_PATH=/path/to/AuthKey_${team_id}.p8
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

### Tests

Run the (limited) tests.

```
docked rails bundle exec rake test
docked rails bundle exec rake test:system # requires Chrome binary
```

### NOTE

In lieu of docker, the app can of course be run with the app depencies run on the host machine (YMMV).
