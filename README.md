# OpenResty Fennel REST API

Minimalistic example for:

- Developing REST APIs with Fennel using OPM and LuaRocks packages
- "Reload on request" DX
- Compiled build for production

## Development

- Fire up the dev server with compose: `docker-compose up`; logs are
  written here.  Server listens on http://localhost:8080
- Test the application:
  ```clojure
  http://localhost:8080 => ((juxt :status :body) (POST "/" (json {})))
  [400 {:validation-errors {:name "string"}}]
  http://localhost:8080 => ((juxt :status :body) (POST "/" (json {:name ""})))
  [400 {:validation-errors {:name "minlen"}}]
  http://localhost:8080 => ((juxt :status :body) (POST "/" (json {:name "Wörld"})))
  [200 {:hello "Wörld"}]
  ```
- Change `./src/helloworld.fnl`, reload your tests

## Production

NOTE: `Dockerfile.prod` uses the dev image for compiling the Fennel file
so not to much code from `Dockerfile.dev` must be copied.

``` console
# docker-compose build --pull
# docker build --force-rm -t net.ofnir/openresty-fennel-rest-api -f Dockerfile.prod .
```

## Files

- `./src/helloworld.fnl` : main source file
- `./docker-compose.yml` : Compose file for development; add databases
  etc.
- `./Dockerfile.dev` : Development image; add OPM and LuaRocks packages
  and remember to add to `Dockerfile.prod` too
- `./dev/default.conf` : Nginx configuration for loading Fennel files directly
  and "reload on request"
- `./Dockerfile.prod` : Staged prod build to compile Fennel files to Lua
- `./prod/default.conf` : Production Nginx configuration

