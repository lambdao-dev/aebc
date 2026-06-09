# AEBC Website

Phoenix website for the **Association d'échanges belgo-chinois (AEBC)**. It
presents the association, its institute and HSK centre, courses, teachers,
administrators, news, and events. Editorial content is managed in a separate
[Strapi](https://strapi.io/) application.

## Features

- French and English content and interface localization
- Strapi-backed institute, HSK, contact, and download pages
- LiveView listings and detail pages for courses, teachers, administrators,
  news, and events
- Course and teacher relationships
- Upcoming and archived events, sorted by start date
- Localized event dates in the `Europe/Brussels` time zone
- Latest news, latest events, and an embedded Google Calendar on the home page
- Responsive navigation with an institute submenu

## Stack

- Elixir 1.14 or later
- Phoenix 1.7 and Phoenix LiveView
- Tailwind CSS and esbuild
- Tesla for Strapi HTTP requests
- Gettext for translations
- Tzdata for time-zone conversion
- Bandit HTTP server

The application does not use a local database. Strapi is its content store.

## Requirements

- Elixir 1.14 or later
- A compatible Erlang/OTP release
- A Strapi server available at `http://localhost:1337`

Node.js is not required by the default asset workflow. Mix installs and runs
the configured Tailwind and esbuild binaries.

## Development

Install dependencies and build assets:

```bash
mix setup
```

Start the application:

```bash
mix phx.server
```

Or start it inside IEx:

```bash
iex -S mix phx.server
```

Open [http://localhost:4000](http://localhost:4000).

Development-only tools are available at:

- [http://localhost:4000/dev/dashboard](http://localhost:4000/dev/dashboard)
- [http://localhost:4000/dev/mailbox](http://localhost:4000/dev/mailbox)

If Strapi is unavailable, CMS-backed lists render empty and individual content
pages cannot be loaded.

## Strapi

The REST client uses this API base URL by default:

```text
http://localhost:1337/api
```

Set `STRAPI_API_URL` to point the application at another Strapi instance.
`STRAPI_URL_PREFIX` separately controls generated media URLs.

### Collection Types

| API name | Fields used by the website |
| --- | --- |
| `courses` | `name`, `short`, `description`, `photo`, `teacher` |
| `teachers` | `name`, `description`, `photo`, `courses` |
| `administrators` | `name`, `description`, `photo` |
| `events` | `name`, `description`, `photo`, `date_start` |
| `posts` | `name`, `description`, `photo` |

`date_start` must contain an ISO 8601 date-time. The events page separates
future and archived events using this field.

### Single Types

The following localized single types must expose a `main` field containing the
page HTML:

- `home`
- `about`
- `institute`
- `hsk`
- `download`
- `contact-page`

Enable French (`fr`) and English (`en`) localization for displayed content and
grant public read access to the required Strapi types.

The repository contains an older Turnstile-protected contact form and a
`contacts` submission client, but the current `/contact` route renders the
`contact-page` single type instead.

## Configuration

Development defaults are in `config/config.exs`. Production configuration is
read from environment variables:

| Variable | Required | Default | Purpose |
| --- | --- | --- | --- |
| `SECRET_KEY_BASE` | Yes | None | Signs and encrypts Phoenix data |
| `PHX_SERVER` | For releases | Unset | Enables the HTTP server when set |
| `PHX_HOST` | No | `aebc.lambdao.org` | Public application hostname |
| `PORT` | No | `4000` | HTTP listen port |
| `STRAPI_API_URL` | No | `http://localhost:1337/api` | Strapi REST API base URL |
| `STRAPI_URL_PREFIX` | No | Empty string | Prefix for Strapi media paths |
| `TURNSTILE_SITE_KEY` | No | Cloudflare test key | Dormant contact form site key |
| `TURNSTILE_SECRET_KEY` | No | Cloudflare test key | Dormant contact form secret |
| `DNS_CLUSTER_QUERY` | No | Unset | DNS query for node clustering |

Generate a production secret with:

```bash
mix phx.gen.secret
```

## Localization

French is the default locale; English is also supported. Locale selection is
resolved in this order:

1. The `locale` query parameter
2. The persisted `locale` cookie
3. The browser `Accept-Language` header

For example:

```text
http://localhost:4000/events?locale=en
```

The locale cookie is retained for ten days. Interface translations are under
`priv/gettext/`, including the French month-name catalog. Editorial
translations are managed in Strapi.

Update translation catalogs with:

```bash
mix gettext.extract --merge
```

## Routes

| Route | Description |
| --- | --- |
| `/` | Home page, latest content, and events calendar |
| `/about` | About AEBC |
| `/institute` | Institute information |
| `/hsk` | HSK centre |
| `/download` | Downloads |
| `/contact` | CMS-managed contact page |
| `/courses` | Course listing and detail pages |
| `/teachers` | Teacher listing and detail pages |
| `/administrators` | Administrator listing and detail pages |
| `/events` | Upcoming and archived events |
| `/posts` | News listing and detail pages |

Unknown routes return the custom 404 page. In development, the dashboard and
mailbox routes are registered before this catch-all.

## Common Commands

```bash
# Compile
mix compile

# Run tests
mix test

# Format Elixir and HEEx
mix format

# Build development assets
mix assets.build

# Build and digest production assets
MIX_ENV=prod mix assets.deploy
```

## Production

Build a release:

```bash
MIX_ENV=prod mix deps.get --only prod
MIX_ENV=prod mix compile
MIX_ENV=prod mix assets.deploy
MIX_ENV=prod mix release
```

Start it with:

```bash
PHX_SERVER=true \
SECRET_KEY_BASE="$(mix phx.gen.secret)" \
PHX_HOST=aebc.example.com \
STRAPI_API_URL=https://cms.example.com/api \
STRAPI_URL_PREFIX=https://cms.example.com \
_build/prod/rel/aebc/bin/aebc start
```

TLS is expected to terminate at a reverse proxy or hosting platform. See the
[Phoenix deployment guide](https://hexdocs.pm/phoenix/deployment.html) for
other deployment approaches.

## Project Structure

```text
assets/                              CSS, JavaScript, and asset configuration
config/                              Compile-time and runtime configuration
lib/aebc/institute.ex                Strapi REST client
lib/aebc_web/controllers/            CMS-backed page controllers
lib/aebc_web/live/                   Collection listing and detail LiveViews
lib/aebc_web/components/             Layouts and shared UI components
lib/aebc_web/helpers/date_helper.ex  Brussels time and localized date helpers
priv/gettext/                        Translation catalogs
priv/static/                         Static public files
test/                                ExUnit tests
```

## Testing

The regular suite contains controller and error-rendering tests:

```bash
mix test
```

CMS integration tests run against a real test instance of the sibling
`straebc` repository. They do not use mocks.

Start a dedicated Strapi instance from `../straebc`, using a separate database:

```bash
cd ../straebc
PORT=1338 DATABASE_FILENAME=.tmp/test.db npm run develop
```

Configure its public role to read the required single and collection types,
then populate and publish both French and English test content. Run the
frontend contract tests with:

```bash
STRAPI_INTEGRATION=1 \
STRAPI_API_URL=http://localhost:1338/api \
mix test
```

The integration suite verifies all required single types and collections in
both locales. It is excluded from a plain `mix test` run so normal development
does not silently depend on whichever Strapi database happens to be running.
