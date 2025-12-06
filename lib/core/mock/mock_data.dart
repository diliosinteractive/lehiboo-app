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
  static const String cities = '''
[
  {
    "id": "valenciennes",
    "name": "Valenciennes",
    "slug": "valenciennes",
    "description": "Valenciennes, 'l'Athènes du Nord', est riche d'un patrimoine culturel et artistique exceptionnel. Découvrez ses musées, ses parcs et sa vie locale dynamique.",
    "image_url": "https://images.unsplash.com/photo-1549144511-3085f269dc56?q=80&w=2070",
    "lat": 50.3570,
    "lng": 3.5230,
    "region": "Nord"
  },
  {
    "id": "anzin",
    "name": "Anzin",
    "slug": "anzin",
    "description": "Ville historique du bassin minier, Anzin offre de nombreux espaces verts et des activités culturelles variées au cœur du Valenciennois.",
    "image_url": "https://images.unsplash.com/photo-1570129477492-45c003edd2be?q=80&w=2070",
    "lat": 50.3717,
    "lng": 3.5033,
    "region": "Nord"
  },
  {
    "id": "beuvrages",
    "name": "Beuvrages",
    "slug": "beuvrages",
    "description": "Beuvrages est une commune verte et accueillante, idéale pour les promenades en famille et la découverte de la nature locale.",
    "image_url": "https://images.unsplash.com/photo-1444723121867-2291d1dee5c2?q=80&w=2070",
    "lat": 50.3860,
    "lng": 3.5110,
    "region": "Nord"
  },
  {
    "id": "bruay-sur-l-escaut",
    "name": "Bruay-sur-l'Escaut",
    "slug": "bruay-sur-l-escaut",
    "description": "Située le long de l'Escaut, Bruay est une ville dynamique proposant de nombreuses activités fluviales et de plein air.",
    "image_url": "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0?q=80&w=2070",
    "lat": 50.3990,
    "lng": 3.5410,
    "region": "Nord"
  },
  {
    "id": "saint-saulve",
    "name": "Saint-Saulve",
    "slug": "saint-saulve",
    "description": "Saint-Saulve allie culture et nature avec son parc municipal renommé et une programmation artistique de qualité tout au long de l'année.",
    "image_url": "https://images.unsplash.com/photo-1465146344425-f00d5f5c8f07?q=80&w=2076",
    "lat": 50.3700,
    "lng": 3.5460,
    "region": "Nord"
  },
  {
    "id": "trith-saint-leger",
    "name": "Trith-Saint-Léger",
    "slug": "trith-saint-leger",
    "description": "Ville sportive et fleurie, Trith-Saint-Léger est réputée pour ses infrastructures de loisirs et son cadre de vie agréable.",
    "image_url": "https://images.unsplash.com/photo-1477959858617-67f85cf4f1df?q=80&w=2144",
    "lat": 50.3323,
    "lng": 3.4839,
    "region": "Nord"
  },
  {
    "id": "aulnoy-lez-valenciennes",
    "name": "Aulnoy-lez-Valenciennes",
    "slug": "aulnoy-lez-valenciennes",
    "description": "Commune dynamique de la banlieue sud de Valenciennes, offrant un cadre de vie paisible.",
    "image_url": "https://images.unsplash.com/photo-1596422846543-75c6fc197f07?q=80&w=2070"
  },
  {
    "id": "marly",
    "name": "Marly",
    "slug": "marly",
    "description": "Marly est une ville agréable, connue pour son golf et ses espaces verts.",
    "image_url": "https://images.unsplash.com/photo-1596422846543-75c6fc197f07?q=80&w=2070"
  },
  {
    "id": "la-sentinelle",
    "name": "La Sentinelle",
    "slug": "la-sentinelle",
    "description": "Ville chargée d'histoire minière, inscrite au patrimoine mondial de l'UNESCO.",
    "image_url": "https://images.unsplash.com/photo-1596422846543-75c6fc197f07?q=80&w=2070"
  },
  {
    "id": "petit-foret",
    "name": "Petit-Forêt",
    "slug": "petit-foret",
    "description": "Ville commerciale et dynamique au nord de Valenciennes.",
    "image_url": "https://images.unsplash.com/photo-1596422846543-75c6fc197f07?q=80&w=2070"
  },
  {
    "id": "raismes",
    "name": "Raismes",
    "slug": "raismes",
    "description": "Connue pour sa grande forêt domaniale, Raismes est le poumon vert de l'agglomération.",
    "image_url": "https://images.unsplash.com/photo-1596422846543-75c6fc197f07?q=80&w=2070"
  },
  {
    "id": "escaupont",
    "name": "Escaupont",
    "slug": "escaupont",
    "description": "Commune paisible traversée par l'Escaut.",
    "image_url": "https://images.unsplash.com/photo-1596422846543-75c6fc197f07?q=80&w=2070"
  },
  {
    "id": "onnaing",
    "name": "Onnaing",
    "slug": "onnaing",
    "description": "Ville industrielle en plein renouveau, célèbre pour sa faïencerie.",
    "image_url": "https://images.unsplash.com/photo-1596422846543-75c6fc197f07?q=80&w=2070"
  },
  {
    "id": "estreux",
    "name": "Estreux",
    "slug": "estreux",
    "description": "Petit village rural au charme authentique.",
    "image_url": "https://images.unsplash.com/photo-1596422846543-75c6fc197f07?q=80&w=2070"
  },
  {
    "id": "saultain",
    "name": "Saultain",
    "slug": "saultain",
    "description": "Village calme et résidentiel à l'est de Valenciennes.",
    "image_url": "https://images.unsplash.com/photo-1596422846543-75c6fc197f07?q=80&w=2070"
  },
  {
    "id": "preseau",
    "name": "Préseau",
    "slug": "preseau",
    "description": "Village typique de l'Avesnois, entouré de champs et de pâturages.",
    "image_url": "https://images.unsplash.com/photo-1596422846543-75c6fc197f07?q=80&w=2070"
  },
  {
    "id": "artres",
    "name": "Artres",
    "slug": "artres",
    "description": "Commune rurale traversée par la Rhonelle, offrant de belles balades.",
    "image_url": "https://images.unsplash.com/photo-1596422846543-75c6fc197f07?q=80&w=2070"
  },
  {
    "id": "famars",
    "name": "Famars",
    "slug": "famars",
    "description": "Site archéologique important et village dynamique.",
    "image_url": "https://images.unsplash.com/photo-1596422846543-75c6fc197f07?q=80&w=2070"
  },
  {
    "id": "maing",
    "name": "Maing",
    "slug": "maing",
    "description": "Village classé au patrimoine, traversé par l'Escaut.",
    "image_url": "https://images.unsplash.com/photo-1596422846543-75c6fc197f07?q=80&w=2070"
  },
  {
    "id": "prouvy",
    "name": "Prouvy",
    "slug": "prouvy",
    "description": "Commune active avec un important parc d'activités.",
    "image_url": "https://images.unsplash.com/photo-1596422846543-75c6fc197f07?q=80&w=2070"
  },
  {
    "id": "rouvignies",
    "name": "Rouvignies",
    "slug": "rouvignies",
    "description": "Petit village bordé par l'Escaut.",
    "image_url": "https://images.unsplash.com/photo-1596422846543-75c6fc197f07?q=80&w=2070"
  },
  {
    "id": "wavrechain-sous-denain",
    "name": "Wavrechain-sous-denain",
    "slug": "wavrechain-sous-denain",
    "description": "Commune au passé industriel riche, proche de Denain.",
    "image_url": "https://images.unsplash.com/photo-1596422846543-75c6fc197f07?q=80&w=2070"
  },
  {
    "id": "herin",
    "name": "Herin",
    "slug": "herin",
    "description": "Ville résidentielle paisible à l'ouest de Valenciennes.",
    "image_url": "https://images.unsplash.com/photo-1596422846543-75c6fc197f07?q=80&w=2070"
  },
  {
    "id": "aubry-du-hainaut",
    "name": "Aubry-du-Hainaut",
    "slug": "aubry-du-hainaut",
    "description": "Village rural accueillant, porte du Parc naturel régional.",
    "image_url": "https://images.unsplash.com/photo-1596422846543-75c6fc197f07?q=80&w=2070"
  }
]
''';
}
