# Publication rules

Use these cases on both Flutter targets and at the database write boundary. “Draft” means text saved under the signed-in service account. A valid score is an integer from 0 to 20 in storage, displayed as 0 to 10 in half-point steps.

## Before publication

| Given | Player sees or can do | Server decision | Public result |
| --- | --- | --- | --- |
| Guest opens a game or a published review | Read reviews, sign in to write | Allow public read only | Published content is readable by direct link |
| Signed in, Steam unlinked | Save a draft, link Steam | Allow owner-only draft writes, reject publication | Draft is private |
| Steam request fails or returns no usable library | Retry refresh, keep drafting | Record an unsuccessful check separately from observed minutes | Existing reviews retain their published values |
| Game missing or returned without minutes | Check visibility and refresh | Treat evidence as unavailable. A missing entry proves neither zero playtime nor a private profile | No new vote |
| No unique verified catalog match | Keep draft on an existing game if applicable | Require a resolved mapping before counting hours | No vote from the ambiguous entry |
| Steam explicitly reports 0 minutes | Show 0 of 90 and offer draft | Save the observation and allow draft only | No new vote |
| Steam reports 89 minutes | Show 1 minute remaining | Reject publish even if the client sends an eligible flag | No new vote |
| Steam reports exactly 90 minutes or more | Enable score and Publish, restore saved draft | Verify evidence for this player, link and game | Nothing changes until explicit publication |
| Player publishes a valid score, including 0 | Optionally add text, a play status or spoiler flag | Save one review and its verified minute snapshot atomically | Count one vote and show self-reported status when supplied |
| Score missing, out of range or between half steps | Correct score, retain draft | Reject the write and preserve the draft | Public score and count stay as before |
| Another player requests a draft or edits a review they do not own | Access denied | Enforce ownership on every private read and write | No disclosure or change |

## After publication

| Given | Player sees or can do | Server decision | Public result |
| --- | --- | --- | --- |
| Steam visibility changes or a refresh fails | Read the published review, keep writing privately or delete it | Proposed MVP rule: require a successful check for a new publication or public edit. Preserve the last observation and mark its age in the library | Original review, hours and vote remain visible |
| Player unlinks Steam | Keep drafts, delete own review or link Steam again | Invalidate evidence tied to the old link for new writes | Original review remains visible |
| Player edits a review after a successful check | Change score, text, status or spoiler flag | Update the existing row and its minute snapshot | Same URL, one vote, recomputed average |
| Another device saves a newer draft while publication is pending | Reopen the newer draft | Clear only the submitted revision after success | Only the submitted revision becomes public |
| Save fails or a successful request is retried | Retry with the same submission | Failure preserves draft and previous review. An identical retry yields one review | At most one vote per player and game |
| Author deletes the review | Confirm removal | Permit owner deletion regardless of Steam visibility | Remove vote, update distribution and make the review URL unavailable |

Steam only establishes what its API reports. A zero value and an absent field have different representations. If privacy settings produce the same response as an empty or missing entry, show the observable result and offer a visibility check.
