# Flutter client

One Dart project will build the website and the Android app. Both targets share the catalog, rating editor, session state and backend contract. iOS is a later target. Riverpod and go_router are proposed defaults from Amicus.

| Route | What the user can do |
| --- | --- |
| `/` | Search the public catalog |
| `/games/:id` | Read the score distribution and reviews, check personal eligibility and open the editor |
| `/reviews/:id` | Read or share one review and follow links to its game and author |
| `/players/:id` | Browse a player's published ratings |
| `/library` | Link Steam, refresh playtime and browse games ready to rate |

Group Flutter code by feature under `lib/features/`. Put the router, theme and session handling in `lib/app/`. Keep the Steam callback and IGDB requests on the backend.

## Rating interaction

The game page offers a private text draft before the player qualifies. Once eligible, the player can choose a score on Framebook's horizontal reel with 21 positions. The reel opens at 5 for a first rating and at the saved value for an edit, including 0. Give each step a readable value, keyboard controls on web and haptic feedback where available. Offer the optional play status in the review editor. Use distinct “Save draft” and “Publish” actions.

## Web and Android

Use clean public URLs and configure hosting to serve the Flutter entry point for client routes. Preserve distinct server routes for API requests and the Steam callback. Test browser back, refresh and a pasted review URL in a signed-out window. On Android, open Steam in the system browser and restore the library screen after linking. Use the same public HTTPS review URL for sharing from either client. [Flutter URL strategies](https://docs.flutter.dev/ui/navigation/url-strategies)
