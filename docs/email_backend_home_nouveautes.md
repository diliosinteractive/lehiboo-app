Subject: Request: add recently added events to mobile home-feed

Hi backend team,

We are replacing the mobile home "Les recommandations" section with
"Nouveautes". The section should list recently added events, not editorial
recommendations.

Current finding:

- `GET /api/v1/home-feed` returns `today`, `tomorrow`, and `recommended`.
- `recommended` is not a pure recently-added list. In
  `EventController::homeFeed`, pass 1 selects `is_featured=true` events with
  future slots, ordered by `published_at DESC`; pass 2 only tops up with other
  upcoming events ordered by `published_at DESC`.
- The mobile client can temporarily query `GET /api/v1/events?sort=published_at`
  for the home carousel, but a dedicated home-feed field would keep the home
  screen contract consistent and avoid an extra call.

Requested API change:

- Add a new `new` or `recently_added` array to
  `GET /api/v1/home-feed`.
- Keep the existing `recommended` field unchanged for backward compatibility.
- Return active, user-accessible events with at least one active slot that has
  not fully ended.
- Exclude events where all slots are in the past.
- Sort by `published_at DESC NULLS LAST, created_at DESC`. If product wants
  "added" to mean database creation instead of first publication, please use
  `created_at DESC` and confirm that definition.
- Respect the same `limit` parameter as the other home-feed sections.
- Prefer returning the same `MobileEventResource` shape as the existing
  `today`, `tomorrow`, and `recommended` arrays.

Suggested response shape:

```json
{
  "success": true,
  "data": {
    "today": [],
    "tomorrow": [],
    "recommended": [],
    "recently_added": [],
    "location_provided": false
  }
}
```

Acceptance criteria:

- Recently featured but old events do not appear ahead of newly published
  events unless they are also newly published.
- Events with only past slots are excluded.
- Events with multiple slots still include the full active slot list so mobile
  can display the closest upcoming slot on the card.
- `limit=10` returns up to 10 recently added eligible events.

Thanks.
