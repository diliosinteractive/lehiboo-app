// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_post_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BlogPostDtoImpl _$$BlogPostDtoImplFromJson(Map<String, dynamic> json) =>
    _$BlogPostDtoImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      slug: json['slug'] as String,
      excerpt: json['excerpt'] as String?,
      content: json['content'] as String?,
      featuredImage: json['featured_image'] == null
          ? null
          : BlogImageDto.fromJson(
              json['featured_image'] as Map<String, dynamic>),
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => BlogCategoryDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      tags: (json['tags'] as List<dynamic>?)
          ?.map((e) => BlogTagDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      author: json['author'] == null
          ? null
          : BlogAuthorDto.fromJson(json['author'] as Map<String, dynamic>),
      publishedAt: json['published_at'] as String?,
      modifiedAt: json['modified_at'] as String?,
      link: json['link'] as String?,
      readingTime: (json['reading_time'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$BlogPostDtoImplToJson(_$BlogPostDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'excerpt': instance.excerpt,
      'content': instance.content,
      'featured_image': instance.featuredImage,
      'categories': instance.categories,
      'tags': instance.tags,
      'author': instance.author,
      'published_at': instance.publishedAt,
      'modified_at': instance.modifiedAt,
      'link': instance.link,
      'reading_time': instance.readingTime,
    };

_$BlogImageDtoImpl _$$BlogImageDtoImplFromJson(Map<String, dynamic> json) =>
    _$BlogImageDtoImpl(
      thumbnail: json['thumbnail'] as String?,
      medium: json['medium'] as String?,
      large: json['large'] as String?,
      full: json['full'] as String?,
    );

Map<String, dynamic> _$$BlogImageDtoImplToJson(_$BlogImageDtoImpl instance) =>
    <String, dynamic>{
      'thumbnail': instance.thumbnail,
      'medium': instance.medium,
      'large': instance.large,
      'full': instance.full,
    };

_$BlogCategoryDtoImpl _$$BlogCategoryDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$BlogCategoryDtoImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      slug: json['slug'] as String,
    );

Map<String, dynamic> _$$BlogCategoryDtoImplToJson(
        _$BlogCategoryDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
    };

_$BlogTagDtoImpl _$$BlogTagDtoImplFromJson(Map<String, dynamic> json) =>
    _$BlogTagDtoImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      slug: json['slug'] as String,
    );

Map<String, dynamic> _$$BlogTagDtoImplToJson(_$BlogTagDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
    };

_$BlogAuthorDtoImpl _$$BlogAuthorDtoImplFromJson(Map<String, dynamic> json) =>
    _$BlogAuthorDtoImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      avatar: json['avatar'] as String?,
    );

Map<String, dynamic> _$$BlogAuthorDtoImplToJson(_$BlogAuthorDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatar': instance.avatar,
    };

_$BlogPostsResponseDtoImpl _$$BlogPostsResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$BlogPostsResponseDtoImpl(
      posts: (json['posts'] as List<dynamic>)
          .map((e) => BlogPostDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: BlogPaginationDto.fromJson(
          json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$BlogPostsResponseDtoImplToJson(
        _$BlogPostsResponseDtoImpl instance) =>
    <String, dynamic>{
      'posts': instance.posts,
      'pagination': instance.pagination,
    };

_$BlogPaginationDtoImpl _$$BlogPaginationDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$BlogPaginationDtoImpl(
      currentPage: (json['current_page'] as num).toInt(),
      perPage: (json['per_page'] as num).toInt(),
      totalItems: (json['total_items'] as num).toInt(),
      totalPages: (json['total_pages'] as num).toInt(),
      hasNext: json['has_next'] as bool? ?? false,
      hasPrev: json['has_prev'] as bool? ?? false,
    );

Map<String, dynamic> _$$BlogPaginationDtoImplToJson(
        _$BlogPaginationDtoImpl instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'per_page': instance.perPage,
      'total_items': instance.totalItems,
      'total_pages': instance.totalPages,
      'has_next': instance.hasNext,
      'has_prev': instance.hasPrev,
    };
