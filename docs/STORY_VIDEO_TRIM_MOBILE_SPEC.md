# Story Video Auto-Trim — Mobile Integration Spec

**Audience** : Mobile app (Flutter)
**Status** : Stable contract
**Scope** : Story video uploads (vendor + admin paths). Image stories are unaffected.
**Reference doc** : `docs/03-guides/MARKETING_SYSTEM.md`

The backend automatically trims story videos that exceed a configurable duration cap. Clients (web + mobile) **MUST pre-warn the vendor** when a video will be trimmed, but **MUST NOT block the upload** — the backend is the authoritative enforcer.

---

## 1. Behavior overview

```
vendor picks a video file (e.g. 60s long)
  ─→ client reads the file's duration locally (video_player)
  ─→ if duration > cap, render an inline warning under the upload
       message: "Your video is 60s long — only the first 30 seconds will be shown."
  ─→ vendor proceeds normally; client uploads + creates the story
  ─→ backend dispatches TrimStoryVideoJob (queue: marketing)
       under cap → no-op pass-through to GenerateStoryPosterJob
       over cap  → ffmpeg stream-copy trim → replace media_url → poster job
  ─→ client can refetch the story to see the new trimmed media_url
```

The warning is informational. If the client fails to render it, the video still gets trimmed correctly — it just surprises the vendor.

---

## 2. Endpoints used by this workflow

| # | Verb | Path | Purpose | Auth |
|---|---|---|---|---|
| 1 | `GET` | `/api/v1/mobile/config` | Read the current video duration cap | none |
| 2 | `POST` | `/api/v1/vendor/stories` | Create a story (existing — unchanged) | vendor |
| 3 | `GET`  | `/api/v1/vendor/stories/{uuid}` | Read a story (poll for trimmed URL) | vendor |

The trim itself happens server-side in a queue job — there's no client-callable trim endpoint. Clients neither trigger nor wait for the trim; they simply re-fetch the story when they want the final URL.

---

## 3. Endpoint 1 — Read the cap

```
GET /api/v1/mobile/config
```

Public, unauthenticated. Cache aggressively (≥ 1 hour) — the cap rarely changes.

### 3.1 Response (relevant subset)

```json
{
  "data": {
    "media": {
      "story_video_max_seconds": 30
    }
  }
}
```

### 3.2 Recommended Flutter handling

```dart
// lib/data/repositories/mobile_config_repository.dart
class MediaConstraints {
  final int storyVideoMaxSeconds;
  const MediaConstraints({required this.storyVideoMaxSeconds});

  factory MediaConstraints.fromJson(Map<String, dynamic> json) =>
      MediaConstraints(
        storyVideoMaxSeconds: json['story_video_max_seconds'] as int,
      );

  // Fallback if the endpoint is unreachable on first launch.
  // Matches the server default in api/config/media.php.
  static const fallback = MediaConstraints(storyVideoMaxSeconds: 30);
}
```

Cache via `shared_preferences` or `flutter_secure_storage` keyed by app version, refresh on cache miss or version bump.

---

## 4. Reading a video's duration locally

Use [`video_player`](https://pub.dev/packages/video_player) — already a dependency for story playback. The metadata loader is fast (~100–500 ms typical) and works on both `File` and network URLs.

```dart
import 'package:video_player/video_player.dart';

Future<int?> readVideoDurationSeconds(File file) async {
  VideoPlayerController? controller;
  try {
    controller = VideoPlayerController.file(file);
    await controller.initialize();
    return controller.value.duration.inSeconds;
  } catch (_) {
    return null; // unparseable — defer to backend, do not warn
  } finally {
    await controller?.dispose();
  }
}
```

For URLs already on the server (e.g. user re-picks a previously uploaded asset from the media library), use `VideoPlayerController.networkUrl(uri)` instead. CORS is not a concern in mobile.

---

## 5. Pre-upload warning UX (REQUIRED)

When `duration != null && duration > cap`, render an **inline warning** under the upload control.

| Style | Use? |
|---|---|
| Inline alert under upload | ✅ **Required pattern** — matches web parity (see `create-vendor-story-wizard.tsx`) |
| Toast / SnackBar | ❌ Dismissible; vendors miss it on a paid flow |
| Modal / Dialog | ❌ Interrupts the wizard for a non-destructive transformation |

### 5.1 Reference Flutter widget

```dart
class _TrimWarning extends StatelessWidget {
  final int actual;
  final int max;
  const _TrimWarning({required this.actual, required this.max});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        border: Border.all(color: Colors.amber.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.amber.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              AppLocalizations.of(context).videoWillBeTrimmed(actual, max),
              style: TextStyle(color: Colors.amber.shade900),
            ),
          ),
        ],
      ),
    );
  }
}
```

### 5.2 Auto-clearing the warning

The warning is tied to a specific source (file or URL). When the vendor swaps to a different asset, the warning **MUST disappear immediately** — do not show stale state.

Web mirrors this with an `attachedToUrl` field on the warning object that is checked in JSX (`trimWarning.attachedToUrl === currentMediaUrl`). Mobile should do the same: re-evaluate (or null) the warning whenever the picked media changes.

---

## 6. i18n

The string is already translated in all six locales under `marketing.upload.videoWillBeTrimmed`:

| Locale | Message |
|---|---|
| fr | `Votre vidéo dure {actual}s — seules les {max} premières secondes seront affichées.` |
| en | `Your video is {actual}s long — only the first {max} seconds will be shown.` |
| es | `Tu vídeo dura {actual}s — solo se mostrarán los primeros {max} segundos.` |
| de | `Dein Video ist {actual}s lang — nur die ersten {max} Sekunden werden angezeigt.` |
| nl | `Je video duurt {actual}s — alleen de eerste {max} seconden worden getoond.` |
| ar | `مدة الفيديو {actual} ثانية — سيتم عرض أول {max} ثانية فقط.` |

`{actual}` and `{max}` are integers (seconds). Round duration to the nearest second before interpolation.

If you mirror these into the Flutter app's ARB files, keep the same placeholder names so backend-side string changes propagate via a single source.

---

## 7. Backend behavior (informational)

You don't call the trim job — it's automatic — but knowing what it does helps with debugging.

| Trigger | What runs | Result |
|---|---|---|
| Story created with `media_type=video` | `TrimStoryVideoJob` on the `marketing` queue | Probes duration via ffprobe header read |
| Duration ≤ cap | No transform | Chains directly to `GenerateStoryPosterJob` |
| Duration > cap | Downloads file → ffmpeg `-c copy -t {cap}` → uploads to `stories/videos/{uuid}-trimmed.mp4` → updates `media_url` → poster job | Vendor's stored URL changes; original is left in storage (audit trail) |
| ffprobe / ffmpeg fails | Job retries 3× with 60s backoff, then dies | Story keeps original (oversized) media_url; manual ops intervention needed |

The trim uses **stream copy** (no re-encode). The output may be 1–2 s shorter than the cap because the cut lands on the last keyframe before the requested duration. This is acceptable per product decision — the homepage carousel auto-advances every 5 s anyway.

### 7.1 When to refetch the story

The trim job typically completes within 5–15 s of story creation. Mobile should treat the post-create response as **provisional** — the `media_url` returned by `POST /vendor/stories` may still point at the un-trimmed file. Polling `GET /vendor/stories/{uuid}` after a short delay (or on next dashboard open) will return the trimmed URL.

If you implement push notifications for marketing events, a `story.processed` event is a future hook point but not currently emitted.

---

## 8. Edge cases

| Case | Expected client behavior |
|---|---|
| `video_player` throws on `initialize()` (unsupported codec) | Treat as unknown duration — no warning, allow upload |
| `/mobile/config` unreachable on first launch | Use fallback cap of 30 s; do not block upload |
| Duration is `Infinity` or `NaN` (some adaptive streams) | Treat as unknown — no warning |
| Vendor picks the same video twice | Re-evaluate; warning state should re-render with the same values |
| Duration is exactly equal to cap | No warning — backend trim is a no-op |
| File is image (`mime/image*`) | Skip duration check entirely |

The recurring pattern: **prefer silence over a wrong warning**. If anything is uncertain, let the backend decide.

---

## 9. Testing checklist

```
☐ Pick a 60s video on a 30s cap → inline warning shows "Your video is 60s long…"
☐ Pick a 15s video → no warning
☐ Submit the 60s video → POST /vendor/stories returns 201; media_url points to original
☐ Wait 15s → GET /vendor/stories/{uuid} → media_url ends with `-trimmed.mp4`
☐ Play the trimmed URL → duration ≤ 30s
☐ Disable network during pick → no warning, upload still works (or fails with the existing upload error path)
☐ Pick an image → no warning, no probe overhead
☐ Pick a video then swap to a shorter one → first warning disappears
```

---

## 10. Reference files

| Concern | File |
|---|---|
| Cap config | `api/config/media.php` |
| Trim job | `api/app/Jobs/TrimStoryVideoJob.php` |
| ffprobe wrapper | `api/app/Support/VideoProbe.php` |
| Cap exposure to clients | `api/app/Http/Controllers/Api/V1/Mobile/MobileConfigController.php` |
| Web hook (parity) | `frontend/src/lib/hooks/use-media-constraints.ts` |
| Web duration util (parity) | `frontend/src/lib/utils/get-video-duration.ts` |
| Web UX reference (Option B inline alert) | `frontend/src/components/features/vendor/stories/create-vendor-story-wizard.tsx` (Step2Content) |
| i18n keys | `frontend/src/messages/{fr,en,es,de,nl,ar}.json` → `marketing.upload.videoWillBeTrimmed` |
