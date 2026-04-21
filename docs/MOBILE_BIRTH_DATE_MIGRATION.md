# Migration Guide: Birth Date & Membership City Fields

**Date**: 2026-04-20
**Affects**: All registration endpoints, user profile endpoint
**Breaking**: No (fields are optional)
**Priority**: Medium — new fields should be added to signup forms and profile page

---

## Overview

Two new optional fields have been added to the user model:

| Field | Type | Max Length | Nullable | Validation |
|-------|------|-----------|----------|------------|
| `birth_date` | `date` (YYYY-MM-DD) | — | Yes | Must be 15+ years old |
| `membership_city` | `string` | 120 chars | Yes | — |

These fields are available on **all three registration flows** (customer, vendor, business) and on the **profile update** endpoint.

---

## 1. Registration Endpoints

### 1.1 Customer Registration

**`POST /api/v1/auth/register`**

New body parameters:

```json
{
  "verified_email_token": "abc123",
  "first_name": "Amine",
  "last_name": "Benali",
  "email": "amine@example.com",
  "password": "SecurePass123!",
  "password_confirmation": "SecurePass123!",
  "phone": "+33612345678",
  "birth_date": "1995-06-15",
  "membership_city": "Lyon",
  "newsletter": true,
  "accept_terms": true
}
```

### 1.2 Vendor Registration

**`POST /api/v1/auth/register/vendor`**

New body parameters (same names):

```json
{
  "first_name": "Sophie",
  "last_name": "Martin",
  "email": "sophie@events.com",
  "password": "SecurePass123!",
  "password_confirmation": "SecurePass123!",
  "phone": "+33698765432",
  "birth_date": "1990-03-22",
  "membership_city": "Paris",
  "organization_name": "Events Pro",
  "...": "other vendor fields"
}
```

### 1.3 Business Registration

**`POST /api/v1/auth/register/business`**

New body parameters (same names):

```json
{
  "first_name": "Marc",
  "last_name": "Dupont",
  "email": "marc@corp.com",
  "password": "SecurePass123!",
  "password_confirmation": "SecurePass123!",
  "phone": "+33611223344",
  "birth_date": "1988-11-30",
  "membership_city": "Marseille",
  "company_name": "Corp SA",
  "...": "other business fields"
}
```

---

## 2. Profile Update Endpoint

**`PATCH /api/v1/account/profile`**

Both fields can be updated independently:

```json
{
  "birth_date": "1995-06-15",
  "membership_city": "Bordeaux"
}
```

To clear a value, send `null`:

```json
{
  "birth_date": null,
  "membership_city": null
}
```

---

## 3. API Response Format

Both fields are returned in the user object. The V1 UserResource uses **camelCase** and restricts visibility to the authenticated user (owner) or admin.

### User object in auth responses

```json
{
  "success": true,
  "data": {
    "user": {
      "id": 42,
      "name": "Amine Benali",
      "firstName": "Amine",
      "lastName": "Benali",
      "email": "amine@example.com",
      "phone": "+33612345678",
      "birthDate": "1995-06-15",
      "membershipCity": "Lyon",
      "role": "customer",
      "...": "other fields"
    },
    "token": "1|abc..."
  }
}
```

### User object in profile responses

```json
{
  "success": true,
  "data": {
    "id": 42,
    "name": "Amine Benali",
    "birth_date": "1995-06-15",
    "birthDate": "1995-06-15",
    "membership_city": "Lyon",
    "membershipCity": "Lyon",
    "...": "other fields"
  }
}
```

> **Note**: The standard UserResource returns both `snake_case` and `camelCase` variants. The V1 UserResource returns `camelCase` only. Use whichever format your Dart models expect.

---

## 4. Validation Rules

| Field | Rule | Error |
|-------|------|-------|
| `birth_date` | Optional, valid date, user must be >= 15 years old | `"Vous devez avoir au moins 15 ans."` |
| `membership_city` | Optional, string, max 120 characters | `"La ville d'appartenance ne peut pas depasser 120 caracteres."` |

### Validation error response (422)

```json
{
  "message": "The given data was invalid.",
  "errors": {
    "birth_date": ["Vous devez avoir au moins 15 ans."],
    "membership_city": ["La ville d'appartenance ne peut pas depasser 120 caracteres."]
  }
}
```

---

## 5. Flutter Implementation Guide

### 5.1 Update Dart Models

```dart
class User {
  // ... existing fields ...
  final String? birthDate;       // "YYYY-MM-DD" or null
  final String? membershipCity;  // String or null

  User({
    // ... existing params ...
    this.birthDate,
    this.membershipCity,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      // ... existing fields ...
      // Accept both formats for safety
      birthDate: json['birthDate'] ?? json['birth_date'],
      membershipCity: json['membershipCity'] ?? json['membership_city'],
    );
  }
}
```

### 5.2 Update Registration Request

```dart
class RegisterRequest {
  // ... existing fields ...
  final String? birthDate;
  final String? membershipCity;

  Map<String, dynamic> toJson() {
    return {
      // ... existing fields ...
      if (birthDate != null) 'birth_date': birthDate,           // snake_case for API
      if (membershipCity != null) 'membership_city': membershipCity, // snake_case for API
    };
  }
}
```

### 5.3 Update Profile Request

```dart
class UpdateProfileRequest {
  final String? birthDate;
  final String? membershipCity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    // Only include fields that were explicitly set
    if (birthDate != null) map['birth_date'] = birthDate;
    if (membershipCity != null) map['membership_city'] = membershipCity;
    return map;
  }
}
```

### 5.4 Signup Form — Date Picker

```dart
// Date picker with 15+ age validation
final DateTime maxDate = DateTime.now().subtract(Duration(days: 15 * 365));

showDatePicker(
  context: context,
  initialDate: maxDate,
  firstDate: DateTime(1920),
  lastDate: maxDate,  // Enforces 15+ age
);

// Format for API: "YYYY-MM-DD"
final String formatted = DateFormat('yyyy-MM-dd').format(selectedDate);
```

### 5.5 Signup Form — City Field

A simple text input. No autocomplete required from the API — use a local city list or free text.

```dart
TextFormField(
  decoration: InputDecoration(labelText: 'Ville'),
  maxLength: 120,
  onSaved: (value) => membershipCity = value,
);
```

### 5.6 Profile Page

Display both fields in the profile page and allow editing:

```dart
// Read-only display
ListTile(
  title: Text('Date de naissance'),
  subtitle: Text(user.birthDate ?? 'Non renseigné'),
);

ListTile(
  title: Text('Ville'),
  subtitle: Text(user.membershipCity ?? 'Non renseignée'),
);
```

---

## 6. Parameter Reference (Quick Table)

| Context | Parameter Name | Response Field | Format |
|---------|---------------|----------------|--------|
| Request body (all endpoints) | `birth_date` | — | `YYYY-MM-DD` |
| Request body (all endpoints) | `membership_city` | — | `string` |
| V1 Response (auth, profile) | — | `birthDate` | `YYYY-MM-DD` or `null` |
| V1 Response (auth, profile) | — | `membershipCity` | `string` or `null` |
| Standard Response (profile) | — | `birth_date` + `birthDate` | both returned |
| Standard Response (profile) | — | `membership_city` + `membershipCity` | both returned |

---

## 7. Backward Compatibility

- Both fields are **optional** (`sometimes`, `nullable`) — existing mobile builds will continue to work without changes.
- No existing fields were modified or removed.
- The response now includes two new fields that will be `null` for existing users.
- **No token invalidation** — existing sessions remain valid.

---

## 8. Testing Checklist

- [ ] Customer registration with `birth_date` and `membership_city`
- [ ] Customer registration without these fields (backward compat)
- [ ] Vendor registration with both fields
- [ ] Business registration with both fields
- [ ] Profile update — set `birth_date` and `membership_city`
- [ ] Profile update — clear fields by sending `null`
- [ ] Validation — birth date under 15 years old returns 422
- [ ] Validation — membership_city over 120 chars returns 422
- [ ] User response includes `birthDate` and `membershipCity` after login
- [ ] Profile page displays both fields correctly
