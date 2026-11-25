# Steam and IGDB probe

Run from the repository root with Python 3.8 or newer. The fixture mode works offline and checks the same mapping and minute classification used by the live command.

```sh
python3 backend/tools/probe.py --fixtures
```

## Live check for one game

1. Register a Twitch application for IGDB access and obtain its client ID and secret. The probe exchanges these for an app token. [IGDB setup](https://api-docs.igdb.com/#getting-started) · [Twitch client credentials](https://dev.twitch.tv/docs/authentication/getting-tokens-oauth/#client-credentials-grant-flow)
2. Use a Steam Web API key and the 17-digit SteamID64 of a consenting test player. Choose a game the player has launched. The number after `/app/` in its Steam store URL is the AppID. [Steam Web API key registration](https://steamcommunity.com/dev/apikey) · [GetOwnedGames](https://partner.steamgames.com/doc/webapi/IPlayerService#GetOwnedGames)
3. Run the following command with that game's numeric ID in place of 620. Enter the credentials at the hidden terminal prompts. For automation the same inputs are accepted as environment variables named `TWITCH_CLIENT_ID`, `TWITCH_CLIENT_SECRET`, `STEAM_ID64` and `STEAM_WEB_API_KEY`.

```sh
python3 backend/tools/probe.py --live 620
```

The probe identifies Steam in IGDB's external game sources, looks up the AppID there, and requests the player's library filtered to that AppID, including played free games. Inspect the returned IGDB title and ID against the edition shown in Steam. Compare the returned minutes with the player's Steam client, allowing for display rounding. A unique ID match plus at least 90 minutes sets `qualifies_in_sample`. Assess the title match manually before adopting a mapping. [IGDB external games](https://api-docs.igdb.com/#external-game)

Repeat for a played free game, a different edition, and a consenting player whose game details or hours are hidden from the key owner. A key belonging to the test player can have a different view than a service key. Record only the AppID, catalog match, observed response class and minutes where appropriate. An empty result can have multiple causes. HTTP and credential failures exit with an error instead of producing a zero-minute observation.

This probe accepts a test SteamID directly. Verified account ownership via Steam OpenID belongs to the subsequent integration stage. It reads provider APIs and does not write to SaveMargin.
