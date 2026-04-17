import '../../domain/entities/story.dart';
import '../models/story_dto.dart';

class StoryMapper {
  static Story toStory(StoryDto dto) {
    return Story(
      uuid: dto.uuid,
      title: dto.title,
      mediaUrl: dto.mediaUrl,
      mediaType: dto.mediaType == 'video'
          ? StoryMediaType.video
          : StoryMediaType.image,
      type: dto.type,
      startDate: DateTime.tryParse(dto.startDate) ?? DateTime.now(),
      endDate: DateTime.tryParse(dto.endDate) ?? DateTime.now(),
      slotPosition: dto.slotPosition,
      impressionsCount: dto.impressionsCount,
      eventUuid: dto.event?.uuid ?? '',
      eventSlug: dto.event?.slug ?? '',
      eventTitle: dto.event?.title ?? dto.title,
      eventFeaturedImage: dto.event?.featuredImage,
      eventCity: dto.event?.city,
      eventBookingMode: dto.event?.bookingMode,
      organizationName: dto.organization?.organizationName ??
          dto.organization?.displayName,
      categoryName: dto.event?.primaryCategory?.name,
    );
  }

  static List<Story> toStories(List<StoryDto> dtos) {
    return dtos.map(toStory).toList();
  }
}
