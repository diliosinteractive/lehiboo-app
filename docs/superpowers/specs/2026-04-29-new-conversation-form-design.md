# New Conversation Form — Design Spec

**Date:** 2026-04-29
**Feature:** Unified context-aware conversation creation widget for mobile
**Status:** Approved — ready for implementation

---

## Problem

Conversation creation is currently split across two separate full-screen routes:
- `NewConversationScreen` — handles dashboard org picker + fromOrganizer + fromBooking redirect
- `SupportDetailScreen` (isNew: true) — handles support creation inline

Neither has: file attachments, character counters, a fixed-recipient card, or an event chip. The entry point from `event_organizer_card.dart` always pushes a new full-screen route even though a modal would be more appropriate (matching the web SaaS Dialog).

---

## Goal

A single, context-aware `NewConversationForm` widget in `lib/features/messages/presentation/widgets/` that:
- Presents as a modal bottom sheet callable from anywhere
- Matches the web SaaS `new-conversation-form.tsx` layout and field set
- Covers all 3 V1 mobile creation contexts

---

## Context Model

```dart
sealed class NewConversationContext {}

/// User selects from their contactable organizations.
/// API: GET /user/conversations/contactable-organizations → POST /user/conversations
class DashboardConversationContext extends NewConversationContext {}

/// Pre-filled organizer (from event detail or org public page).
/// API: POST /user/conversations/from-organization/{orgUuid}
class FromOrganizerConversationContext extends NewConversationContext {
  final String organizationUuid;
  final String organizationName;
  final String? organizationLogoUrl;
  final String? prefilledEventId;    // optional — passed from event context
  final String? prefilledEventTitle; // display label for the chip
}

/// Fixed recipient: Support Le Hiboo.
/// API: POST /user/support-conversations
class SupportConversationContext extends NewConversationContext {}
```

---

## Widget API

```dart
class NewConversationForm extends ConsumerStatefulWidget {
  final NewConversationContext conversationContext;
  final VoidCallback? onSuccess; // optional override; default = navigate + pop

  const NewConversationForm({
    required this.conversationContext,
    this.onSuccess,
  });

  /// Show as a modal bottom sheet. Preferred entry point.
  static Future<void> show(
    BuildContext context, {
    required NewConversationContext conversationContext,
  });
}
```

---

## Form Layout

Rendered inside a `DraggableScrollableSheet` (initial 85%, max 95%) via `showModalBottomSheet`.

```
┌─────────────────────────────────────────────┐
│  ── drag handle ──                           │
│  Nouveau message                    [X]      │
│  <context-aware subtitle>                    │
├─────────────────────────────────────────────┤
│                                              │
│  DESTINATAIRE                                │
│  ┌──────────────────────────────────────┐   │
│  │ [avatar] Org name / Support LeHiboo │   │  fixed card
│  └──────────────────────────────────────┘   │
│  — OR (DashboardContext only) —              │
│  [Sélectionner un organisateur ▼]            │  tappable → org picker sheet
│                                              │
│  ÉVÉNEMENT (optionnel)            [Titre ×] │  FromOrganizerContext only
│                                              │
│  OBJET *                             0/100  │
│  [________________________________]          │
│                                              │
│  MESSAGE *                          0/2000  │
│  [                                 ]         │
│  [                                 ]         │
│                                              │
│  PIÈCES JOINTES (optionnel)                  │  hidden for SupportContext
│  [📎 Ajouter un fichier]   0/3 · Max 5 Mo  │
│  [chip filename.pdf ×]                       │
│                                              │
│  [error banner]                              │
│                                              │
│  [  Annuler  ]   [  ▶ Envoyer  ]            │
└─────────────────────────────────────────────┘
```

---

## Per-Context Variations

| Element | DashboardContext | FromOrganizerContext | SupportContext |
|---|---|---|---|
| Recipient | Tappable row → org picker bottom sheet | Fixed card (logo + name) | Fixed card (support icon + "Support Le Hiboo") |
| Subtitle | "Composez votre message ci-dessous." | "Composez votre message ci-dessous." | "Décrivez votre problème et notre équipe vous répondra rapidement." |
| Événement chip | Hidden | Shown if `prefilledEventId` provided — removable (clears `event_id` from payload) | Hidden |
| Subject | Free text field | Free text field | Predefined chips (7 options) + free text — same as current `SupportDetailScreen` |
| Attachments section | Enabled | Enabled | Hidden |
| Send button label | "Envoyer" | "Envoyer" | "Envoyer au support" |

**Predefined support subjects** (from current `SupportDetailScreen._subjectOptions`):
- Problème de réservation
- Question sur un événement
- Problème de paiement
- Demande de remboursement
- Problème de compte
- Signalement d'un contenu
- Autre

---

## Validation Rules

| Field | Rule |
|---|---|
| Recipient | Required for `DashboardContext` — org must be selected |
| Subject | Required, 1–100 chars |
| Message | Required, 1–2000 chars |
| Files | Max 3, max 5 MB each, types: jpg/jpeg/png/webp/pdf — validated before adding to list |

---

## API Dispatch

| Context | Method | Endpoint | Payload |
|---|---|---|---|
| `DashboardContext` | POST | `/user/conversations` | `{ organization_uuid, subject, message, attachments[]? }` |
| `FromOrganizerContext` | POST | `/user/conversations/from-organization/{orgUuid}` | `{ subject, message, event_id?, attachments[]? }` |
| `SupportContext` | POST | `/user/support-conversations` | `{ subject, message }` |

- Use `multipart/form-data` when files are attached, `application/json` otherwise.
- Repository methods already exist: `createConversation`, `createFromOrganization`, `createSupportConversation`.

---

## On Success Navigation

| Context | Route |
|---|---|
| `DashboardContext` | `context.push('/messages/{uuid}')` |
| `FromOrganizerContext` | `context.push('/messages/{uuid}')` |
| `SupportContext` | `context.push('/messages/support/{uuid}')` |

Modal is dismissed before navigation.

---

## Files Changed

| File | Type | Change |
|---|---|---|
| `lib/features/messages/presentation/widgets/new_conversation_form.dart` | **New** | The unified widget |
| `lib/features/messages/presentation/screens/new_conversation_screen.dart` | Modified | `fromBookingUuid` path unchanged; dashboard path calls `NewConversationForm.show()` + pops; `fromOrganizationUuid` path calls `NewConversationForm.show()` + pops |
| `lib/features/messages/presentation/screens/support_detail_screen.dart` | Modified | `isNew` path calls `NewConversationForm.show()` instead of inline form |
| `lib/features/events/presentation/widgets/detail/event_organizer_card.dart` | Modified | `_buildContactButton` replaces `context.push(...)` with `NewConversationForm.show(ctx, context: FromOrganizerConversationContext(...))` |

---

## Out of Scope

- Event dropdown fetching all org events (requires new backend endpoint — known gap #5)
- `fromBooking` creation form (backend auto-creates + redirects, no form needed)
- Vendor / admin contexts (mobile V2)
- WebSocket realtime (mobile V2)
