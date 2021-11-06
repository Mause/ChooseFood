// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'openapi.models.swagger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Countries _$CountriesFromJson(Map<String, dynamic> json) => Countries(
      id: json['id'] as int?,
      name: json['name'] as String?,
      iso2: json['iso2'] as String?,
      iso3: json['iso3'] as String?,
      localName: json['local_name'] as String?,
      continent: countriesContinentFromJson(json['continent'] as String?),
    );

Map<String, dynamic> _$CountriesToJson(Countries instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'iso2': instance.iso2,
      'iso3': instance.iso3,
      'local_name': instance.localName,
      'continent': countriesContinentToJson(instance.continent),
    };

Decision _$DecisionFromJson(Map<String, dynamic> json) => Decision(
      id: json['id'] as int?,
      createdAt: json['created_at'] as String?,
      sessionId: json['sessionId'] as String?,
      decision: json['decision'] as bool?,
      placeReference: json['placeReference'] as String?,
      participantId: json['participantId '] as int?,
    );

Map<String, dynamic> _$DecisionToJson(Decision instance) => <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'sessionId': instance.sessionId,
      'decision': instance.decision,
      'placeReference': instance.placeReference,
      'participantId ': instance.participantId,
    };

Participant _$ParticipantFromJson(Map<String, dynamic> json) => Participant(
      id: json['id'] as int?,
      createdAt: json['created_at'] as String?,
      userId: json['userId'] as int?,
      session: json['session'] as String?,
    );

Map<String, dynamic> _$ParticipantToJson(Participant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'userId': instance.userId,
      'session': instance.session,
    };

Session _$SessionFromJson(Map<String, dynamic> json) => Session(
      id: json['id'] as String?,
      createdAt: json['created_at'] as String?,
      concludedTime: json['concludedTime'] as String?,
      point: json['point'] as String?,
    );

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'concludedTime': instance.concludedTime,
      'point': instance.point,
    };
