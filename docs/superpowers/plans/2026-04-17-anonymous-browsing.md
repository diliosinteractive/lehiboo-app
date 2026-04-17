# Anonymous Browsing — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Allow unauthenticated users to browse the app freely (home, explore, map, event details) and only prompt login when they attempt a protected action (booking, favorites, profile, chat, etc.).

**Architecture:** Two changes: (1) Remove the router auth wall so anonymous users land on `/` instead of `/login`, (2) Add `GuestGuard.check()` calls at every protected action entry point. The `GuestGuard` utility and `GuestRestrictionDialog` already exist and are production-ready — currently used only in `favorite_button.dart`. The `MainScaffold` bottom nav needs a guard on the "Réservations" tab. The `VoiceFab` (Petit Boo) needs a guard since chat requires auth.

**Tech Stack:** Flutter, Riverpod, GoRouter, existing `GuestGuard` + `GuestRestrictionDialog`

---

## File Map

### Modified files

| File | Change |
|------|--------|
| `lib/routes/app_router.dart` | Remove auth wall redirect, send unauthenticated users to `/` after bootstrap |
| `lib/core/widgets/main_scaffold.dart` | Guard "Réservations" tab with GuestGuard |
| `lib/core/widgets/voice_fab/voice_fab.dart` | Guard chat/voice actions with GuestGuard |
| `lib/features/events/presentation/screens/event_detail_screen.dart` | Guard booking button |
| `lib/features/search/presentation/screens/search_screen.dart` | Guard save search action |
| `lib/features/events/presentation/screens/event_list_screen.dart` | Guard save search action |
| `lib/features/home/presentation/screens/home_screen.dart` | Guard profile and favorites navigation |
| `lib/features/profile/presentation/screens/profile_screen.dart` | Guard protected menu items |
| `lib/features/gamification/presentation/widgets/hibon_counter_widget.dart` | Guard hibons tap |

---

## Task 1: Remove the router auth wall

The core change. Currently line 125-128 of `app_router.dart` redirects all unauthenticated users to `/login`. We remove this and also change bootstrap to send unauthenticated users to `/` instead of `/login`.

**Files:**
- Modify: `lib/routes/app_router.dart`

- [ ] **Step 1: Update bootstrap redirect for unauthenticated users**

In `lib/routes/app_router.dart`, find (around line 93-97):

```dart
      if (isBootstrap) {
        if (!onboardingCompleted) return '/onboarding';
        if (isPendingOtp) return '/verify-otp';
        return isAuthenticated ? '/' : '/login';
      }
```

Replace with:

```dart
      if (isBootstrap) {
        if (!onboardingCompleted) return '/onboarding';
        if (isPendingOtp) return '/verify-otp';
        return '/';
      }
```

- [ ] **Step 2: Update onboarding completion redirect**

Find (around line 106-108):

```dart
      // 2. If onboarding completed but user on onboarding page, go to login
      if (onboardingCompleted && isOnboarding) {
        debugPrint('🔀 Redirecting to /login (from onboarding)');
        return '/login';
      }
```

Replace with:

```dart
      // 2. If onboarding completed but user on onboarding page, go to home
      if (onboardingCompleted && isOnboarding) {
        debugPrint('🔀 Redirecting to / (from onboarding)');
        return '/';
      }
```

- [ ] **Step 3: Remove the auth wall redirect**

Find and delete the entire block (lines 124-128):

```dart
      // 4. If not authenticated and not on auth route, redirect to login
      if (!isAuthenticated && !isAuthRoute && !isOnboarding) {
        debugPrint('🔀 Redirecting to /login (not authenticated)');
        return '/login';
      }
```

- [ ] **Step 4: Verify no syntax errors**

Run: `flutter analyze lib/routes/app_router.dart`
Expected: No errors

- [ ] **Step 5: Commit**

```bash
git add lib/routes/app_router.dart
git commit -m "feat(auth): remove router auth wall, allow anonymous browsing"
```

---

## Task 2: Guard the bottom nav "Réservations" tab

The bottom nav's "Réservations" tab (index 3) navigates to `/my-bookings` which requires auth. We need to intercept the tap and show the guest dialog instead.

**Files:**
- Modify: `lib/core/widgets/main_scaffold.dart`

- [ ] **Step 1: Add imports**

At the top of `lib/core/widgets/main_scaffold.dart`, add:

```dart
import '../utils/guest_guard.dart';
```

- [ ] **Step 2: Guard the Réservations tab**

In `_onItemTapped`, find (around line 63-65):

```dart
      case 3:
        context.go('/my-bookings');
        break;
```

Replace with:

```dart
      case 3:
        _navigateToBookings();
        return;
```

Then add this method to `_MainScaffoldState`:

```dart
  Future<void> _navigateToBookings() async {
    final allowed = await GuestGuard.check(
      context: context,
      ref: ref,
      featureName: 'voir vos réservations',
    );
    if (allowed && mounted) {
      setState(() {
        _selectedIndex = 3;
      });
      context.go('/my-bookings');
    }
  }
```

- [ ] **Step 3: Verify no syntax errors**

Run: `flutter analyze lib/core/widgets/main_scaffold.dart`
Expected: No errors

- [ ] **Step 4: Commit**

```bash
git add lib/core/widgets/main_scaffold.dart
git commit -m "feat(auth): guard Réservations tab for anonymous users"
```

---

## Task 3: Guard the VoiceFab (Petit Boo chat)

The floating action button in the center of the bottom nav opens Petit Boo chat. All chat endpoints require auth.

**Files:**
- Modify: `lib/core/widgets/voice_fab/voice_fab.dart`

- [ ] **Step 1: Read the file and add imports**

Read `lib/core/widgets/voice_fab/voice_fab.dart` to find the exact structure. Add at the top:

```dart
import '../../utils/guest_guard.dart';
```

- [ ] **Step 2: Guard the chat open action**

Find the `_openChat()` method (or whatever method navigates to `/petit-boo`). Wrap the navigation with a GuestGuard check:

Before:
```dart
  void _openChat() {
    context.push('/petit-boo');
  }
```

After:
```dart
  Future<void> _openChat() async {
    final allowed = await GuestGuard.check(
      context: context,
      ref: ref,
      featureName: 'discuter avec Petit Boo',
    );
    if (allowed && mounted) {
      context.push('/petit-boo');
    }
  }
```

- [ ] **Step 3: Guard the voice message send action**

Find the method that sends voice transcription to Petit Boo (navigates to `/petit-boo?message=...`). Apply the same guard pattern:

Before:
```dart
  context.push('/petit-boo?message=${Uri.encodeComponent(transcription)}');
```

After:
```dart
  final allowed = await GuestGuard.check(
    context: context,
    ref: ref,
    featureName: 'discuter avec Petit Boo',
  );
  if (allowed && mounted) {
    context.push('/petit-boo?message=${Uri.encodeComponent(transcription)}');
  }
```

- [ ] **Step 4: Verify no syntax errors**

Run: `flutter analyze lib/core/widgets/voice_fab/voice_fab.dart`
Expected: No errors

- [ ] **Step 5: Commit**

```bash
git add lib/core/widgets/voice_fab/voice_fab.dart
git commit -m "feat(auth): guard Petit Boo chat for anonymous users"
```

---

## Task 4: Guard booking initiation on event detail screen

When a user taps "Réserver" on an event detail page, we need to check auth before navigating to checkout.

**Files:**
- Modify: `lib/features/events/presentation/screens/event_detail_screen.dart`

- [ ] **Step 1: Add import**

Add at the top of `event_detail_screen.dart`:

```dart
import 'package:lehiboo/core/utils/guest_guard.dart';
```

- [ ] **Step 2: Guard the booking action**

Find the `_onBookPressed()` method (or the callback that navigates to `/checkout`). Wrap it with GuestGuard:

Before:
```dart
  void _onBookPressed() {
    context.push('/checkout', extra: checkoutParams);
  }
```

After:
```dart
  Future<void> _onBookPressed() async {
    final allowed = await GuestGuard.check(
      context: context,
      ref: ref,
      featureName: 'réserver une activité',
    );
    if (!allowed) return;
    if (!mounted) return;
    context.push('/checkout', extra: checkoutParams);
  }
```

Note: The exact method name and structure may differ — read the file first. The key point is adding the guard **before** the `context.push('/checkout', ...)` call.

- [ ] **Step 3: Verify no syntax errors**

Run: `flutter analyze lib/features/events/presentation/screens/event_detail_screen.dart`
Expected: No errors

- [ ] **Step 4: Commit**

```bash
git add lib/features/events/presentation/screens/event_detail_screen.dart
git commit -m "feat(auth): guard booking button for anonymous users"
```

---

## Task 5: Guard save search actions

Two screens allow saving searches as alerts: `search_screen.dart` and `event_list_screen.dart`.

**Files:**
- Modify: `lib/features/search/presentation/screens/search_screen.dart`
- Modify: `lib/features/events/presentation/screens/event_list_screen.dart`

- [ ] **Step 1: Guard save search in search_screen.dart**

Add import:
```dart
import 'package:lehiboo/core/utils/guest_guard.dart';
```

Find the `_saveCurrentSearch` method (around line 255). Add GuestGuard at the beginning:

```dart
  Future<void> _saveCurrentSearch(BuildContext context) async {
    final allowed = await GuestGuard.check(
      context: context,
      ref: ref,
      featureName: 'sauvegarder une recherche',
    );
    if (!allowed) return;
    // ... existing SaveSearchSheet.show() code continues here
```

- [ ] **Step 2: Guard save search in event_list_screen.dart**

Add import:
```dart
import 'package:lehiboo/core/utils/guest_guard.dart';
```

Find the `_saveCurrentSearch` method (around line 488). Add the same guard:

```dart
  Future<void> _saveCurrentSearch() async {
    final allowed = await GuestGuard.check(
      context: context,
      ref: ref,
      featureName: 'sauvegarder une recherche',
    );
    if (!allowed) return;
    // ... existing SaveSearchSheet.show() code continues here
```

- [ ] **Step 3: Verify no syntax errors**

Run: `flutter analyze lib/features/search/presentation/screens/search_screen.dart lib/features/events/presentation/screens/event_list_screen.dart`
Expected: No errors

- [ ] **Step 4: Commit**

```bash
git add lib/features/search/presentation/screens/search_screen.dart lib/features/events/presentation/screens/event_list_screen.dart
git commit -m "feat(auth): guard save search for anonymous users"
```

---

## Task 6: Guard home screen navigation to profile, favorites, and hibons

The home screen app bar has icons for profile, favorites, and hibons counter — all require auth.

**Files:**
- Modify: `lib/features/home/presentation/screens/home_screen.dart`
- Modify: `lib/features/gamification/presentation/widgets/hibon_counter_widget.dart`

- [ ] **Step 1: Guard profile and favorites icons in home_screen.dart**

Add import:
```dart
import 'package:lehiboo/core/utils/guest_guard.dart';
```

Find the favorites icon `onPressed` (around line 265) that does `context.push('/favorites')`. Wrap it:

Before:
```dart
  onPressed: () => context.push('/favorites'),
```

After:
```dart
  onPressed: () async {
    final allowed = await GuestGuard.check(
      context: context,
      ref: ref,
      featureName: 'voir vos favoris',
    );
    if (allowed && mounted) {
      context.push('/favorites');
    }
  },
```

Find the profile icon `onPressed` (around line 279) that does `context.push('/profile')`. Wrap it:

Before:
```dart
  onPressed: () => context.push('/profile'),
```

After:
```dart
  onPressed: () async {
    final allowed = await GuestGuard.check(
      context: context,
      ref: ref,
      featureName: 'accéder à votre profil',
    );
    if (allowed && mounted) {
      context.push('/profile');
    }
  },
```

- [ ] **Step 2: Guard hibons counter widget tap**

Read `lib/features/gamification/presentation/widgets/hibon_counter_widget.dart`.

The widget already returns an empty widget if not authenticated (line 15: `ref.watch(isAuthenticatedProvider)`). This is fine — anonymous users won't see the hibons counter at all. **No change needed here** — the widget self-hides.

However, verify this by reading the file. If the widget is tappable and navigates to `/hibons-dashboard`, add GuestGuard. If it returns `SizedBox.shrink()` when not authenticated, leave it alone.

- [ ] **Step 3: Verify no syntax errors**

Run: `flutter analyze lib/features/home/presentation/screens/home_screen.dart`
Expected: No errors

- [ ] **Step 4: Commit**

```bash
git add lib/features/home/presentation/screens/home_screen.dart
git commit -m "feat(auth): guard profile and favorites in home screen"
```

---

## Task 7: Guard profile screen menu items

The profile screen has menu items that navigate to protected routes (my bookings, favorites, trip plans, settings). If an anonymous user somehow reaches this screen, these should be guarded. But more importantly: the profile screen should handle the unauthenticated state gracefully — show a "Connect" CTA instead of user data.

**Files:**
- Modify: `lib/features/profile/presentation/screens/profile_screen.dart`

- [ ] **Step 1: Read the profile screen**

Read `lib/features/profile/presentation/screens/profile_screen.dart` to understand its current structure. It likely already checks `authState.isAuthenticated` and shows different content.

- [ ] **Step 2: Ensure unauthenticated state is handled**

If the screen doesn't already handle unauthenticated users, add an early return in the build method that shows a "Connectez-vous" screen with a login button:

```dart
  if (!authState.isAuthenticated) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mon profil')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Connectez-vous pour accéder à votre profil'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.push('/login'),
              child: const Text('Se connecter'),
            ),
          ],
        ),
      ),
    );
  }
```

If it already has this pattern, skip to step 3.

- [ ] **Step 3: Verify no syntax errors**

Run: `flutter analyze lib/features/profile/presentation/screens/profile_screen.dart`
Expected: No errors

- [ ] **Step 4: Commit**

```bash
git add lib/features/profile/presentation/screens/profile_screen.dart
git commit -m "feat(auth): handle anonymous state in profile screen"
```

---

## Task 8: Guard the 401 force-logout behavior for anonymous users

With the force-logout interceptor we added earlier, a 401 on any API call triggers `forceLogout()` which sets auth state to `unauthenticated`. For anonymous users who were never authenticated, this shouldn't happen. The interceptor already handles this correctly — it only clears tokens if a token exists. But verify this still works: an anonymous user browsing public endpoints should never trigger the 401 interceptor.

**Files:**
- Verify: `lib/config/dio_client.dart`

- [ ] **Step 1: Verify the interceptor is safe for anonymous users**

Read `lib/config/dio_client.dart` and confirm the `onError` handler in `JwtAuthInterceptor`:
1. Only processes 401 when `currentToken != null && currentToken.isNotEmpty` — anonymous users have no token, so this is skipped. Correct.
2. The `onRequest` handler skips auth headers for public endpoints — anonymous users only hit public endpoints unless they bypass GuestGuard (which they can't). Correct.

**No code change needed.** This is a verification step.

- [ ] **Step 2: Commit (no-op)**

No changes to commit. Mark as verified.

---

## Task 9: Full build verification

- [ ] **Step 1: Run full project analysis**

Run: `flutter analyze`
Expected: No new errors (only pre-existing warnings/infos)

- [ ] **Step 2: Run existing tests**

Run: `flutter test test/mappers/ test/data/ test/features/`
Expected: All pass

- [ ] **Step 3: Manual verification checklist**

Test these scenarios on a device/emulator:
- [ ] App starts → lands on home screen (not login)
- [ ] Can browse home feed, tap events, use explore tab, open map
- [ ] Tap "Réservations" tab → guest dialog appears
- [ ] Tap favorite button on event → guest dialog appears (already worked)
- [ ] Tap "Réserver" on event detail → guest dialog appears
- [ ] Tap VoiceFab → guest dialog appears
- [ ] Tap profile icon → guest dialog appears
- [ ] Tap favorites icon → guest dialog appears
- [ ] Tap "Se connecter" in dialog → navigates to login
- [ ] After login → return to app with full access
- [ ] Tap "Plus tard" → dialog closes, user stays on current screen
