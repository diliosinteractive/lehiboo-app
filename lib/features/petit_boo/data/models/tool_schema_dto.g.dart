// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tool_schema_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ToolSchemaDtoImpl _$$ToolSchemaDtoImplFromJson(Map<String, dynamic> json) =>
    _$ToolSchemaDtoImpl(
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      displayType: json['display_type'] as String? ?? 'list',
      icon: json['icon'] as String? ?? 'extension',
      color: json['color'] as String?,
      title: json['title'] as String?,
      emptyMessage: json['empty_message'] as String?,
      responseSchema: json['response_schema'] == null
          ? null
          : ToolResponseSchemaDto.fromJson(
              json['response_schema'] as Map<String, dynamic>),
      sectionSchemas: (json['section_schemas'] as List<dynamic>?)
          ?.map(
              (e) => BrainSectionSchemaDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      tripSchema: json['trip_schema'] == null
          ? null
          : TripSchemaDto.fromJson(json['trip_schema'] as Map<String, dynamic>),
      actionType: json['action_type'] as String?,
      showToast: json['show_toast'] as bool? ?? true,
    );

Map<String, dynamic> _$$ToolSchemaDtoImplToJson(_$ToolSchemaDtoImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'display_type': instance.displayType,
      'icon': instance.icon,
      'color': instance.color,
      'title': instance.title,
      'empty_message': instance.emptyMessage,
      'response_schema': instance.responseSchema,
      'section_schemas': instance.sectionSchemas,
      'trip_schema': instance.tripSchema,
      'action_type': instance.actionType,
      'show_toast': instance.showToast,
    };

_$ToolResponseSchemaDtoImpl _$$ToolResponseSchemaDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ToolResponseSchemaDtoImpl(
      itemsKey: json['items_key'] as String?,
      totalKey: json['total_key'] as String?,
      itemKey: json['item_key'] as String?,
      itemSchema: json['item_schema'] == null
          ? null
          : ToolItemSchemaDto.fromJson(
              json['item_schema'] as Map<String, dynamic>),
      stats: (json['stats'] as List<dynamic>?)
          ?.map((e) => ToolStatSchemaDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ToolResponseSchemaDtoImplToJson(
        _$ToolResponseSchemaDtoImpl instance) =>
    <String, dynamic>{
      'items_key': instance.itemsKey,
      'total_key': instance.totalKey,
      'item_key': instance.itemKey,
      'item_schema': instance.itemSchema,
      'stats': instance.stats,
    };

_$ToolItemSchemaDtoImpl _$$ToolItemSchemaDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ToolItemSchemaDtoImpl(
      titleField: json['title_field'] as String?,
      subtitleField: json['subtitle_field'] as String?,
      imageField: json['image_field'] as String?,
      dateField: json['date_field'] as String?,
      timeField: json['time_field'] as String?,
      priceField: json['price_field'] as String?,
      statusField: json['status_field'] as String?,
      badgeField: json['badge_field'] as String?,
      badgeConditionField: json['badge_condition_field'] as String?,
      badgeText: json['badge_text'] as String?,
      navigation: json['navigation'] == null
          ? null
          : ToolNavigationDto.fromJson(
              json['navigation'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ToolItemSchemaDtoImplToJson(
        _$ToolItemSchemaDtoImpl instance) =>
    <String, dynamic>{
      'title_field': instance.titleField,
      'subtitle_field': instance.subtitleField,
      'image_field': instance.imageField,
      'date_field': instance.dateField,
      'time_field': instance.timeField,
      'price_field': instance.priceField,
      'status_field': instance.statusField,
      'badge_field': instance.badgeField,
      'badge_condition_field': instance.badgeConditionField,
      'badge_text': instance.badgeText,
      'navigation': instance.navigation,
    };

_$ToolNavigationDtoImpl _$$ToolNavigationDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ToolNavigationDtoImpl(
      route: json['route'] as String,
      idField: json['id_field'] as String,
      useGo: json['use_go'] as bool? ?? false,
    );

Map<String, dynamic> _$$ToolNavigationDtoImplToJson(
        _$ToolNavigationDtoImpl instance) =>
    <String, dynamic>{
      'route': instance.route,
      'id_field': instance.idField,
      'use_go': instance.useGo,
    };

_$ToolStatSchemaDtoImpl _$$ToolStatSchemaDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ToolStatSchemaDtoImpl(
      icon: json['icon'] as String,
      label: json['label'] as String,
      field: json['field'] as String,
    );

Map<String, dynamic> _$$ToolStatSchemaDtoImplToJson(
        _$ToolStatSchemaDtoImpl instance) =>
    <String, dynamic>{
      'icon': instance.icon,
      'label': instance.label,
      'field': instance.field,
    };

_$ToolsResponseDtoImpl _$$ToolsResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ToolsResponseDtoImpl(
      success: json['success'] as bool? ?? true,
      tools: (json['tools'] as List<dynamic>?)
              ?.map((e) => ToolSchemaDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ToolsResponseDtoImplToJson(
        _$ToolsResponseDtoImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'tools': instance.tools,
    };

_$BrainSectionSchemaDtoImpl _$$BrainSectionSchemaDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$BrainSectionSchemaDtoImpl(
      key: json['key'] as String,
      title: json['title'] as String,
      icon: json['icon'] as String,
      collapsible: json['collapsible'] as bool? ?? true,
    );

Map<String, dynamic> _$$BrainSectionSchemaDtoImplToJson(
        _$BrainSectionSchemaDtoImpl instance) =>
    <String, dynamic>{
      'key': instance.key,
      'title': instance.title,
      'icon': instance.icon,
      'collapsible': instance.collapsible,
    };

_$TripSchemaDtoImpl _$$TripSchemaDtoImplFromJson(Map<String, dynamic> json) =>
    _$TripSchemaDtoImpl(
      showMap: json['show_map'] as bool? ?? true,
      enableReorder: json['enable_reorder'] as bool? ?? true,
    );

Map<String, dynamic> _$$TripSchemaDtoImplToJson(_$TripSchemaDtoImpl instance) =>
    <String, dynamic>{
      'show_map': instance.showMap,
      'enable_reorder': instance.enableReorder,
    };
