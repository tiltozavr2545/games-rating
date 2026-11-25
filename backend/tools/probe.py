"""Compare IGDB's Steam mapping with the minutes visible for one Steam AppID."""
import argparse
import getpass
import json
import os
import sys
from pathlib import Path
from urllib.error import HTTPError, URLError
from urllib.parse import urlencode
from urllib.request import Request, urlopen


def request_json(provider, url, data=None, headers=None):
    req = Request(url, data=data, headers=headers or {})
    try:
        with urlopen(req, timeout=20) as result:
            return json.load(result)
    except HTTPError as exc:
        raise ValueError(f"{provider}: HTTP {exc.code}. Check credentials or retry later.") from None
    except (URLError, OSError, ValueError):
        raise ValueError(f"{provider}: connection failed or invalid JSON.") from None


def credential(name):
    value = os.environ.get(name)
    if not value and sys.stdin.isatty():
        value = getpass.getpass(f"{name} (hidden): ").strip()
    if not value:
        raise ValueError(f"Set {name} or run in an interactive terminal.")
    return value


def live(app_id):
    client = credential("TWITCH_CLIENT_ID")
    token = request_json("Twitch", "https://id.twitch.tv/oauth2/token", urlencode({
        "client_id": client, "client_secret": credential("TWITCH_CLIENT_SECRET"),
        "grant_type": "client_credentials",
    }).encode())
    headers = {"Client-ID": client, "Authorization": "Bearer " + token["access_token"],
               "Content-Type": "text/plain", "Accept": "application/json"}

    def igdb(endpoint, query):
        return request_json("IGDB", "https://api.igdb.com/v4/" + endpoint, query.encode(), headers)

    sources = igdb("external_game_sources", 'fields id,name; where name ~ "Steam";')
    if len(sources) != 1 or type(sources[0].get("id")) is not int:
        raise ValueError("IGDB: expected one Steam source.")
    source = sources[0]["id"]
    links = igdb("external_games", f'fields uid,game.id,game.name; where external_game_source = {source} & uid = "{app_id}"; limit 500;')
    steam_id = credential("STEAM_ID64")
    if not (steam_id.isascii() and steam_id.isdecimal() and len(steam_id) == 17):
        raise ValueError("Steam: expected a 17-digit SteamID64.")
    params = urlencode({"key": credential("STEAM_WEB_API_KEY"), "input_json": json.dumps({
        "steamid": steam_id, "appids_filter": [app_id], "include_played_free_games": True,
    })})
    library = request_json("Steam", "https://api.steampowered.com/IPlayerService/GetOwnedGames/v1/?" + params)
    return links, library


def inspect(app_id, links, library):
    games = {row["game"]["id"]: row["game"]["name"] for row in links
             if row["uid"] == str(app_id)}
    result = {"steam_app_id": app_id, "igdb_candidates": games}
    response = library["response"]
    rows = response.get("games")
    if rows is None and response.get("game_count") == 0:
        rows = []
    if rows is None:
        state = "library_unavailable"
    elif not isinstance(rows, list):
        raise ValueError("Steam: unexpected games field.")
    else:
        row = next((item for item in rows if item["appid"] == app_id), None)
        minutes = row.get("playtime_forever") if row else None
        if row is None:
            state = "game_not_returned"
        elif type(minutes) is not int or minutes < 0:
            state = "minutes_unavailable"
        else:
            state = "known_minutes"
            result["minutes"] = minutes
    result["steam_state"] = state
    result["qualifies_in_sample"] = len(games) == 1 and result.get("minutes", -1) >= 90
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--live", type=int, metavar="STEAM_APP_ID")
    mode.add_argument("--fixtures", action="store_true")
    args = parser.parse_args()
    if args.fixtures:
        cases = json.loads(Path(__file__).with_name("probe-cases.json").read_text())
        for case in cases:
            result = inspect(case["app_id"], case["links"], case["library"])
            for key, expected in case["expect"].items():
                if result.get(key) != expected:
                    raise ValueError(f"{case['case']}: unexpected {key}")
            print(case["case"], json.dumps(result, ensure_ascii=False))
        return
    if args.live < 1:
        parser.error("Steam AppID must be positive.")
    print(json.dumps(inspect(args.live, *live(args.live)), indent=2, ensure_ascii=False))


if __name__ == "__main__":
    try:
        main()
    except (ValueError, OSError, KeyError, TypeError, AttributeError) as exc:
        sys.exit(str(exc) if isinstance(exc, ValueError) else "Unexpected input or provider response.")
