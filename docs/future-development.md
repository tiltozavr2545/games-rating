# Future development

## First feature after launch — compare tastes

On another player's public profile, a signed-in reader can compare the games both have rated. Match published reviews by canonical game ID and show the shared game count and both players' scores side by side. For “Both rated highly”, sort by the lower of the two scores, highest first. For “Biggest differences”, sort by the absolute score difference, largest first. When there are no shared ratings, say so. Private drafts and library ownership do not enter the comparison.

Verify with two profiles that share one highly rated game and one polarizing game. Each sort should put the expected game first. Editing or deleting a published score must update the comparison.

## A threshold based on game length

Compare IGDB estimates for reaching the credits, playing with some extras and completing 100% of a game. IGDB reports these in seconds and includes a submission count. Sample short narrative games, long RPGs, multiplayer games and titles with sparse data. For each candidate percentage, report the resulting wait in minutes. Pick the definition of completion, percentage, fallback for missing estimates and treatment of existing reviews after examining those results. The first release uses the fixed 90-minute rule. [IGDB game time to beat](https://api-docs.igdb.com/#game-time-to-beat)

## More platforms

Investigate Xbox, PlayStation and Nintendo separately. For each, first demonstrate authorized access to a consenting player's title-level time and a reliable game mapping. Decide how cross-platform hours count once evidence from two platforms is available. Add iOS as another Flutter target after the Android and web workflow is validated.

## Ideas to explore after the MVP

- **Review revisions.** Let a reader see how an author's score changed between an early impression and a later save, alongside hours at each revision.
- **Filter reviews by time played.** On a long RPG, a reader could browse the views of players with under ten hours or over fifty. Show the sample size for each filter.
- **Personal shelves.** Let players group games into playing, finished and dropped, independently of whether they have published a review.
