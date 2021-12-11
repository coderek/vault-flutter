// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Cred _$$_CredFromJson(Map<String, dynamic> json) => _$_Cred(
      id: json['id'] as int?,
      username: json['username'] as String,
      password: json['password'] as String,
      decrypted: json['decrypted'] as String?,
      description: json['description'] as String?,
      website: json['website'] as String?,
      category: json['category'] as String?,
    );

Map<String, dynamic> _$$_CredToJson(_$_Cred instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'password': instance.password,
      'decrypted': instance.decrypted,
      'description': instance.description,
      'website': instance.website,
      'category': instance.category,
    };
