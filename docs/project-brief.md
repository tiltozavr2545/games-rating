# SaveMargin product brief

A reader deciding whether to play a game can see its scores, read individual reviews and see how much recorded experience each author had when they published. Playtime gives the review context. Finishing a game is optional.

## From reader to reviewer

1. A guest searches the catalog, opens a game and reads reviews without registering. Each published review has a shareable URL. The author's public profile lists their published ratings.
2. A player creates a service account and links Steam. Their private library view lists games that already qualify. Other matched games show progress in minutes and a refresh action.
3. At **90 recorded minutes in that game**, the player can publish one score from **0 to 10 in steps of 0.5**. Exactly 90 qualifies. The same rule applies to free games and games shorter than 90 minutes in the first release.
4. A review consists of the score and optional text. The author can also select “Reached the credits”, “Still playing” or “Set aside”, or leave the status blank. Show this self-reported status alongside the verified hours. The author can mark the text as containing spoilers. Readers see the score and can choose to reveal the text.
5. The author can edit the same review or delete it. A public review shows the platform and recorded hours at publication or latest edit. Subsequent library refreshes leave that snapshot intact.

## Writing before the threshold

A signed-in player can save impressions as a private text draft on the game page, even before reaching 90 minutes. The player can reopen, revise or discard it from either client. Reaching the threshold enables the score picker and the Publish action. The text stays private until the author explicitly publishes. Only published scores contribute to the game average.

Walk through the [interactive draft and publication prototype](prototype/README.md). The [publication rules](publication-rules.md) specify the behavior for unavailable playtime, failed saves, edits and deletion.

## Reading a game page

Show the cover, title, platforms, public reviews, arithmetic mean, vote count and score distribution. Count every published score once, including zero and scores without text. An empty page says “No ratings yet”. Give guests the same reading and sharing experience as signed-in players.

## Catalog scope

Initially list games with an identified Steam game entry. A reader can find a game even if they have never owned it. A player can rate it once the service verifies their own time. Keep provider account identifiers and imported libraries private. Players choose their public display name independently of Steam.
