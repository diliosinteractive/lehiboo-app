import '../../domain/entities/story.dart';
import '../models/story_dto.dart';

class StoryMapper {
  static Story toStory(StoryDto dto) {
    final storyStartDate = DateTime.tryParse(dto.startDate) ?? DateTime.now();
    final eventStartDate = dto.event?.startDate == null
        ? null
        : DateTime.tryParse(dto.event!.startDate!);

    return Story(
      uuid: dto.uuid,
      title: dto.title,
      mediaUrl: dto.mediaUrl,
      mediaType: dto.mediaType == 'video'
          ? StoryMediaType.video
          : StoryMediaType.image,
      posterUrl: dto.posterUrl,
      type: dto.type,
      startDate: storyStartDate,
      endDate: DateTime.tryParse(dto.endDate) ?? DateTime.now(),
      eventStartDate: eventStartDate,
      slotPosition: dto.slotPosition,
      impressionsCount: dto.impressionsCount,
      updatedAt:
          dto.updatedAt == null ? null : DateTime.tryParse(dto.updatedAt!),
      eventUuid: dto.event?.uuid ?? '',
      eventSlug: dto.event?.slug ?? '',
      eventTitle: dto.event?.title ?? dto.title,
      eventFeaturedImage: dto.event?.featuredImage,
      eventCity: dto.event?.city,
      eventBookingMode: dto.event?.bookingMode,
      eventTagName: dto.event?.eventTag?.name,
      organizationName:
          dto.organization?.organizationName ?? dto.organization?.displayName,
      categoryName: dto.event?.primaryCategory?.name,
    );
  }

  static List<Story> toStories(List<StoryDto> dtos) {
    return dtos.map(toStory).toList();
  }
}
