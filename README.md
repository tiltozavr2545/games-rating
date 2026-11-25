# SaveMargin

Anyone can open a game or review link and read what players thought. To publish a score, the author links Steam and the service checks how much time Steam recorded for that game.

**Status** — initial design. The first release will use one Flutter client for web and Android and a PostgreSQL database hosted on Supabase.

| Location | Start here for |
| --- | --- |
| [Product brief](docs/project-brief.md) | Player journeys, rating rules and public pages |
| [Flutter client](app/README.md) | Screen layout, routes and platform differences |
| [Interactive prototype](docs/prototype/README.md) | Try drafting at 89 minutes, publishing at 90 and reading the guest view |
| [Publication rules](docs/publication-rules.md) | Acceptance cases for the client, server and public reader |
| [Provider probe](backend/tools/README.md) | Run the offline samples or check one Steam AppID against IGDB and Steam |
| [Backend and providers](backend/README.md) | Steam verification, IGDB catalog and the first integration experiment |
| [Data model](docs/data-model.md) | Ownership, identifiers, publication and aggregate scores |
| [Implementation plan](docs/implementation-plan.md) | Build order and acceptance checks |
| [Future development](docs/future-development.md) | Completion-based thresholds, additional platforms and product ideas |
