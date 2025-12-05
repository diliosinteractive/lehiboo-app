import 'package:lehiboo/data/models/activity_dto.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/domain/entities/city.dart';
import 'package:lehiboo/domain/entities/partner.dart';
import 'package:lehiboo/domain/entities/taxonomy.dart';

extension ActivityDtoX on ActivityDto {
  Activity toDomain() {
    return Activity(
      id: id.toString(),
      title: title,
      slug: slug,
      description: description ?? '',
      excerpt: excerpt,
      imageUrl: imageUrl,
      category: category?.toDomain(),
      tags: tags?.map((t) => t.toDomain()).toList(),
      ageRange: ageRange?.toDomain(),
      audience: audience?.toDomain(),
      isFree: isFree,
      priceMin: price?.min,
      priceMax: price?.max,
      currency: price?.currency,
      indoorOutdoor: _mapIndoorOutdoor(indoorOutdoor),
      durationMinutes: durationMinutes,
      city: city?.toDomain(),
      partner: partner?.toDomain(),
      reservationMode: _mapReservationMode(reservationMode),
      externalBookingUrl: externalBookingUrl,
      bookingPhone: bookingPhone,
      bookingEmail: bookingEmail,
      nextSlot: nextSlot?.toDomain(),
    );
  }

  IndoorOutdoor? _mapIndoorOutdoor(String? value) {
    switch (value) {
      case 'indoor':
        return IndoorOutdoor.indoor;
      case 'outdoor':
        return IndoorOutdoor.outdoor;
      case 'both':
        return IndoorOutdoor.both;
      default:
        return null;
    }
  }

  ReservationMode? _mapReservationMode(String? value) {
    switch (value) {
      case 'lehiboo_free':
        return ReservationMode.lehibooFree;
      case 'lehiboo_paid':
        return ReservationMode.lehibooPaid;
      case 'external_url':
        return ReservationMode.externalUrl;
      case 'phone':
        return ReservationMode.phone;
      case 'email':
        return ReservationMode.email;
      default:
        return null;
    }
  }
}

extension ActivityCategoryDtoX on ActivityCategoryDto {
  Category toDomain() => Category(
    id: id.toString(),
    slug: slug,
    name: name,
  );
}

extension TagDtoX on TagDto {
  Tag toDomain() => Tag(
    id: id.toString(),
    slug: slug,
    name: name,
  );
}

extension AgeRangeDtoX on AgeRangeDto {
  AgeRange toDomain() => AgeRange(
    id: id.toString(),
    label: label,
    minAge: minAge,
    maxAge: maxAge,
  );
}

extension AudienceDtoX on AudienceDto {
  Audience toDomain() => Audience(
    id: id.toString(),
    slug: slug,
    name: name,
  );
}

extension CityDtoX on CityDto {
  City toDomain() => City(
    id: id.toString(),
    name: name,
    slug: slug,
    lat: lat,
    lng: lng,
    region: region,
  );
}

extension PartnerDtoX on PartnerDto {
  Partner toDomain() => Partner(
    id: id.toString(),
    name: name,
    description: description,
    logoUrl: logoUrl,
    cityId: cityId?.toString(),
    website: website,
    email: email,
    phone: phone,
    verified: verified,
  );
}

extension SlotDtoX on SlotDto {
  Slot toDomain() => Slot(
    id: id.toString(),
    activityId: activityId.toString(),
    startDateTime: startDateTime,
    endDateTime: endDateTime,
    capacityTotal: capacityTotal,
    capacityRemaining: capacityRemaining,
    priceMin: price?.min,
    priceMax: price?.max,
    currency: price?.currency,
    indoorOutdoor: indoorOutdoor == 'indoor' ? IndoorOutdoor.indoor 
      : indoorOutdoor == 'outdoor' ? IndoorOutdoor.outdoor 
      : indoorOutdoor == 'both' ? IndoorOutdoor.both : null,
    status: status,
  );
}
