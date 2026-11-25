# Backend and providers

Supabase will host the PostgreSQL database for the first release. It will store player profiles, linked platform accounts, catalog entries imported from IGDB, verified playtime observations from Steam, and player ratings and reviews.

Supabase Auth for service accounts and server functions for provider calls are proposed implementation choices. Both Flutter targets will use the same API.

## Catalog

Use IGDB for game titles, artwork and platform metadata. Resolve the Steam AppID through IGDB's external game records. Give each game a stable internal ID so a corrected title or provider mapping preserves review links. Queue ambiguous editions, demos and DLC for inspection. Only publish verified catalog matches. Cache metadata on the server within provider terms and keep Twitch credentials there. [IGDB games](https://api-docs.igdb.com/#game) · [External games](https://api-docs.igdb.com/#external-game)

## Player time

1. An authenticated player requests a Steam linking session. Tie the callback to that service account, verify the OpenID response on the server and bind the verified SteamID to one account. [Steam OpenID](https://partner.steamgames.com/doc/features/auth#website)
2. Request the linked user's visible library with `IPlayerService/GetOwnedGames`, including played free games. Read `playtime_forever` in minutes for the matching AppID. The server owns the credentials and writes observations. [Steam player service](https://partner.steamgames.com/doc/webapi/IPlayerService#GetOwnedGames)
3. Return an eligibility state to the client. Distinguish an unlinked account, unavailable data, a game missing from the response, a known minute count below threshold and a qualifying count. Suggest checking Steam game-detail and playtime visibility when data is unavailable. Offer a retry when a request fails.
4. For new publications and public edits, the proposed MVP policy checks Steam when the player presses Publish. Resolve the active account and game, then persist the review and verified minutes together. If the check fails, keep the draft and any existing public snapshot. [Publication rules](../docs/publication-rules.md)

## First integration experiment

Run the [provider probe](tools/README.md) for the catalog and playtime portion. The fixture run can be repeated offline. A live result and the Steam OpenID ownership check are still pending.

Before building library screens, verify a real consented account through the ordinary Steam Web API and a real IGDB lookup. Try a paid game, a played free game, hidden playtime and an ambiguous edition. Compare returned AppIDs and minutes with the Steam client. Record which missing-data cases the API actually distinguishes. Save anonymized fixtures and record current access, attribution and quota requirements. These integrations have only been researched so far.
