# Planned data model

| Record | Key fields and constraints |
| --- | --- |
| Profile | Stable user ID linked to the auth account, public display name |
| Platform account | User ID, provider, verified external account ID. Unique per provider and external account, one active link per user and provider |
| Game | Internal game ID, unique IGDB ID, title, cover reference, supported platforms |
| Platform game | Game ID, provider and external game ID. Each external ID maps to one canonical game |
| Playtime observation | Verified platform account, platform game, whole minutes and check time. Update observations only from a valid server response |
| Review draft | Author, game, text and revision. One private draft per author and game, accessible only to its author |
| Review | Stable review ID, author, game, integer score units from 0 through 20, optional text, optional self-reported play status, spoiler flag, source platform, minutes at save, created and updated times. Unique per author and game |

One score unit equals half a point. A score of 0 is stored as 0. A game without an author's review has no row for that author. For each game, compute the mean as the sum of score units divided by twice the number of published reviews. Group by score units for the 21 distribution buckets.

## Write boundary

Derive the author from the current session for both draft and review writes. Authors can save a draft regardless of playtime. Only the server can verify playtime for publication. Resolve the platform game against the requested game and check that the observation belongs to the active link. In one transaction enforce eligibility, upsert the review, snapshot the verified minutes and clear the submitted draft revision. Preserve any newer draft saved on another device. A failed publication preserves the draft. Retrying a publication yields one vote. Removing a link invalidates its evidence for future publications. Authors may delete their own reviews even when Steam is unavailable.

## Read boundary

Expose public game metadata, profile display names, published reviews and derived aggregates. Restrict platform links and library observations to their owner and the verification service. Public profile queries use published reviews as their source. A library refresh changes private observations only.
