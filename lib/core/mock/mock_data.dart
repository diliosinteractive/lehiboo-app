class MockData {
  static const String activities = '''
[
  {
    "id": 1,
    "title": "Yoga au lever du soleil",
    "slug": "yoga-lever-soleil",
    "description": "Une séance de yoga revitalisante pour bien commencer la journée.",
    "image_url": "https://images.unsplash.com/photo-1544367563-121955377d01",
    "category": { "id": 1, "slug": "bien-etre", "name": "Bien-être" },
    "tags": [{ "id": 101, "slug": "yoga", "name": "Yoga" }],
    "age_range": { "id": 1, "label": "Adultes", "min_age": 18 },
    "audience": { "id": 1, "slug": "tous", "name": "Tous niveaux" },
    "price": { "min": 15.0, "max": 15.0, "currency": "EUR" },
    "duration": 60,
    "city": { "id": 1, "name": "Paris", "slug": "paris", "lat": 48.8566, "lng": 2.3522 },
    "partner": { "id": 1, "name": "Studio Zen", "logo_url": "https://placehold.co/100x100" },
    "reservation_mode": "lehiboo_paid",
    "next_slot": {
      "id": 10,
      "activity_id": 1,
      "start_date_time": "2025-06-15T08:00:00",
      "end_date_time": "2025-06-15T09:00:00",
      "capacity_total": 20,
      "status": "open"
    }
  },
  {
    "id": 2,
    "title": "Atelier Poterie Débutant",
    "slug": "atelier-poterie",
    "description": "Apprenez les bases de la poterie et repartez avec votre création.",
    "image_url": "https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261",
    "category": { "id": 2, "slug": "artisanat", "name": "Artisanat" },
    "tags": [{ "id": 102, "slug": "poterie", "name": "Poterie" }],
    "age_range": { "id": 1, "label": "Adultes" },
    "audience": { "id": 2, "slug": "debutant", "name": "Débutant" },
    "price": { "min": 40.0, "max": 40.0, "currency": "EUR" },
    "duration": 120,
    "city": { "id": 1, "name": "Paris", "slug": "paris", "lat": 48.8566, "lng": 2.3522 },
    "partner": { "id": 2, "name": "L'Argile Joyeuse", "logo_url": "https://placehold.co/100x100" },
    "reservation_mode": "lehiboo_paid",
    "next_slot": {
      "id": 20,
      "activity_id": 2,
      "start_date_time": "2025-06-16T14:00:00",
      "end_date_time": "2025-06-16T16:00:00",
      "capacity_total": 8,
      "status": "open"
    }
  },
  {
    "id": 3,
    "title": "Concert Jazz en Plein Air",
    "slug": "concert-jazz",
    "description": "Soirée jazz gratuite dans le parc.",
    "image_url": "https://images.unsplash.com/photo-1511192336575-5a79af67a629",
    "category": { "id": 3, "slug": "culture", "name": "Culture" },
    "tags": [{ "id": 103, "slug": "musique", "name": "Musique" }],
    "age_range": { "id": 2, "label": "Famille" },
    "audience": { "id": 1, "slug": "tous", "name": "Tous" },
    "price": { "min": 0.0, "max": 0.0, "currency": "EUR" },
    "duration": 90,
    "city": { "id": 1, "name": "Paris", "slug": "paris", "lat": 48.8566, "lng": 2.3522 },
    "partner": { "id": 3, "name": "Mairie de Paris", "logo_url": "https://placehold.co/100x100" },
    "reservation_mode": "lehiboo_free",
    "next_slot": {
      "id": 30,
      "activity_id": 3,
      "start_date_time": "2025-06-20T19:00:00",
      "end_date_time": "2025-06-20T20:30:00",
      "capacity_total": 100,
      "status": "open"
    }
  }
]
''';

  static const String myBookings = '''
[
  {
    "id": "booking_mock_1",
    "user_id": "user_1",
    "slot_id": 30,
    "activity_id": 3,
    "quantity": 2,
    "total_price": 0.0,
    "currency": "EUR",
    "status": "confirmed",
    "payment_status": "none",
    "created_at": "2025-05-10T10:00:00",
    "activity": {
      "id": 3,
      "title": "Concert Jazz en Plein Air",
      "slug": "concert-jazz",
      "image_url": "https://images.unsplash.com/photo-1511192336575-5a79af67a629",
      "is_free": true
    },
    "slot": {
      "id": 30,
      "activity_id": 3,
      "start_date_time": "2025-06-20T19:00:00",
      "end_date_time": "2025-06-20T20:30:00"
    }
  }
]
''';
}
