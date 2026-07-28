# Legal Pages (CGU / CGV / Privacy / Cookies) — Mobile Integration Spec

**Audience** : Mobile app (Flutter — customer + vendor)
**Status** : Stable contract
**Scope** : How the mobile app should display terms of use, terms of sale, privacy policy, cookies policy, and legal notices. Covers the recommended **web-redirect** strategy via in-app browser, the fallback JSON API, and recording user consent at signup.

---

## TL;DR

| Goal | Strategy | Endpoint / URL |
|---|---|---|
| **Display** a legal document | Open the web page in an **in-app browser** | `https://lehiboo.com/{locale}/{slug}` |
| **List** the available documents (optional) | JSON API | `GET /api/v1/pages?type=legal` |
| **Read raw content** in a native view (fallback) | JSON API | `GET /api/v1/pages/{slug}?locale=fr` |
| **Record consent** at signup | Send `accept_terms: true` on register | `POST /api/v1/auth/register` |

**Recommended for v1**: in-app browser → web page. The native JSON fallback exists if you need to embed content (e.g., a settings summary or a search index), but the web page is the source of truth.

---

## 1. Canonical slugs

Five legal pages are seeded in production. Slugs are stable contracts — they will not be renamed without a backend migration that also adds redirects.

| Slug | Document | Mobile label key (i18n) |
|---|---|---|
| `cgu` | Conditions Générales d'Utilisation (Terms of Use) | `legal.terms` |
| `cgv` | Conditions Générales de Vente (Terms of Sale) | `legal.sales` |
| `privacy` | Politique de confidentialité (Privacy Policy) | `legal.privacy` |
| `cookies` | Politique cookies (Cookies Policy) | `legal.cookies` |
| `mentions-legales` | Mentions légales (Legal Notices) | `legal.legalNotices` |

All five are `page_type = "legal"` on the backend. Other `page_type` values exist (`about`, `info`) but are out of scope for this spec.

---

## 2. Strategy A — In-app browser (recommended)

### URL pattern

```
https://lehiboo.com/{locale}/{slug}
```

Examples:

| Document | French | English | Spanish |
|---|---|---|---|
| Terms of Use | `https://lehiboo.com/fr/cgu` | `https://lehiboo.com/en/cgu` | `https://lehiboo.com/es/cgu` |
| Terms of Sale | `https://lehiboo.com/fr/cgv` | `https://lehiboo.com/en/cgv` | `https://lehiboo.com/es/cgv` |
| Privacy | `https://lehiboo.com/fr/privacy` | `https://lehiboo.com/en/privacy` | `https://lehiboo.com/es/privacy` |

Supported locales: `fr` (default), `en`, `es`, `de`, `nl`, `ar` (RTL).

**Host by environment**:

| Env | Host |
|---|---|
| Local | `http://lehiboo.localhost` |
| Staging | `https://staging.lehiboo.com` *(confirm with DevOps)* |
| Production | `https://lehiboo.com` |

Store this in your build config / `.env` — do not hard-code `lehiboo.com` in source.

### Opening the URL

| Platform | API | Notes |
|---|---|---|
| iOS | `SFSafariViewController` | Native sheet, shares cookies with Safari, has close button, "Done" affordance. App Store approved. |
| Android | Chrome Custom Tabs | Native overlay, fast first paint via warm-up, back button returns to app. |
| Flutter (both) | `url_launcher` with `mode: LaunchMode.inAppBrowserView` | Resolves to `SFSafariViewController` / Custom Tabs automatically. |

```dart
import 'package:url_launcher/url_launcher.dart';

Future<void> openLegalPage(String slug, String locale) async {
  final base = AppConfig.frontendUrl; // from build config
  final uri = Uri.parse('$base/$locale/$slug');
  await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
}
```

### When to use this strategy
- Tappable "View terms" links on signup, checkout, settings, account screens.
- Footer / "About" navigation.
- Any place a user is *reading*, not *acting* on the document.

### Do not use this strategy for
- Recording consent (use the API — see §4).
- Anything you'd want to display without a network connection.
- Anything you'd want to style or theme to match the app shell.

---

## 3. Strategy B — JSON content (fallback)

Use this when you need the raw HTML/markdown content rendered inside a native view (offline cache, settings summary card, in-app search).

### List published legal pages

```
GET /api/v1/pages?type=legal
```

No authentication required.

**200 Response**

```json
{
  "success": true,
  "data": [
    {
      "uuid": "9f2a-…",
      "slug": "cgu",
      "title": "Conditions Générales d'Utilisation",
      "page_type": "legal",
      "title_translations": { "fr": "...", "en": "...", "es": "..." },
      "sort_order": 1,
      "published_at": "2026-01-15T10:00:00+00:00",
      "updated_at": "2026-04-22T14:30:00+00:00"
    }
  ]
}
```

Use this to render a "Legal documents" screen in settings without hard-coding the list.

### Fetch one page by slug

```
GET /api/v1/pages/{slug}?locale={locale}
```

Examples:
- `GET /api/v1/pages/cgu?locale=fr`
- `GET /api/v1/pages/privacy?locale=en`

The `?locale=` query param picks the right translation from `*_translations` JSON fields. If the locale is not available, the response falls back to `fr` and then to the base field.

**200 Response**

```json
{
  "success": true,
  "data": {
    "uuid": "9f2a-…",
    "slug": "cgu",
    "title": "Conditions Générales d'Utilisation",
    "page_type": "legal",
    "content": "<h1>Article 1 — Objet</h1><p>...</p>",
    "meta_title": "CGU | Le Hiboo",
    "meta_description": "Consultez les conditions générales d'utilisation...",
    "is_published": true,
    "published_at": "2026-01-15T10:00:00+00:00",
    "updated_at": "2026-04-22T14:30:00+00:00"
  }
}
```

**404 Response** (slug not found or unpublished)

```json
{
  "success": false,
  "message": "No published page found with slug 'xxx'"
}
```

### Content format
`content` is **HTML** (rich text from the admin CMS editor). On Flutter render with `flutter_html` or similar. Sanitize before render if you intend to handle anchor clicks or embedded scripts (the CMS already strips scripts on save, but treat content as defense-in-depth).

---

## 4. Recording user consent at signup

The registration endpoint already enforces `accept_terms`:

```
POST /api/v1/auth/register

{
  ...,
  "accept_terms": true,
  "newsletter": false
}
```

`accept_terms` is **required and must be `true`** — the request is rejected otherwise (`422 Unprocessable Entity`).

For the **vendor** registration (`POST /api/v1/auth/register-vendor`), there's an additional `accept_vendor_terms` boolean field.

### What's stored today
The backend currently only validates the checkbox — it does **not** snapshot which version of the CGU was accepted. If product/legal needs a per-version audit trail, that requires a backend change (track `consent_version` per user, surface a re-consent flow when CGU is updated). Flag this if it's a requirement.

---

## 5. UX patterns

### Signup screen
- "I accept the [Terms of Use](cgu) and [Privacy Policy](privacy)" — both links open in-app browser.
- Apple/Google review note: terms must be readable **without leaving the app**. In-app browser satisfies this.

### Settings → Legal
Two recommended layouts:
1. **Static list** (simplest): hard-code the 5 slugs in your locale files with translated labels. Tap = open in-app browser.
2. **Dynamic list**: `GET /api/v1/pages?type=legal` on app launch, cache for 24h, render in the order returned (`sort_order` is honored backend-side).

### When terms change
- The backend has no push notification for "terms updated" today.
- Mobile may compare `updated_at` from `GET /api/v1/pages/cgu` on app launch and, if it changed since the user last accepted, show a one-time re-consent modal. **This is a product decision** — coordinate with backend if you want a `requires_reconsent` flag on the user profile response.

---

## 6. Optional hardening — Indirection endpoint

**Not shipped yet.** If product wants to decouple the mobile app from slug names (so future renames don't require an app release), the backend can add:

```
GET /api/v1/legal/links?locale=fr

→ {
    "success": true,
    "data": {
      "terms":         "https://lehiboo.com/fr/cgu",
      "sales":         "https://lehiboo.com/fr/cgv",
      "privacy":       "https://lehiboo.com/fr/privacy",
      "cookies":       "https://lehiboo.com/fr/cookies",
      "legal_notices": "https://lehiboo.com/fr/mentions-legales"
    }
  }
```

If we ship this, the mobile app would key off semantic roles (`terms`, `privacy`) rather than slugs. **Decision pending** — for v1 the mobile app can safely hard-code the 5 slugs above.

---

## 7. Quick test commands

```bash
# List legal pages
curl https://api.lehiboo.com/api/v1/pages?type=legal | jq

# Fetch CGU in English
curl "https://api.lehiboo.com/api/v1/pages/cgu?locale=en" | jq

# Open the web page (paste in browser)
open https://lehiboo.com/fr/cgu
```

---

## 8. Open questions for product

1. **Re-consent on terms update** — needed? If yes, backend needs `consent_version` tracking + a flag on the user profile.
2. **Indirection endpoint** (§6) — ship now, or accept slug coupling for v1?
3. **Offline support** — required? If yes, the mobile app should cache `GET /api/v1/pages/{slug}` responses with a TTL.

---

## Related docs

- `docs/05-reference/PUSH_NOTIFICATIONS_MOBILE_SPEC.md` — push token lifecycle
- `docs/05-reference/IN_APP_NOTIFICATIONS_MOBILE_SPEC.md` — in-app realtime
- `api/app/Http/Controllers/Api/V1/PageController.php` — backend controller
- `api/app/Http/Resources/PageResource.php` — response shape
- `api/database/seeders/PageSeeder.php` — canonical slug list
