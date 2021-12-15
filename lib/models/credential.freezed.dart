// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'credential.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Cred _$CredFromJson(Map<String, dynamic> json) {
  return _Cred.fromJson(json);
}

/// @nodoc
class _$CredTearOff {
  const _$CredTearOff();

  _Cred call(
      {int? id,
      required String username,
      required String password,
      String? decrypted,
      required String description,
      required String website,
      required String category}) {
    return _Cred(
      id: id,
      username: username,
      password: password,
      decrypted: decrypted,
      description: description,
      website: website,
      category: category,
    );
  }

  Cred fromJson(Map<String, Object?> json) {
    return Cred.fromJson(json);
  }
}

/// @nodoc
const $Cred = _$CredTearOff();

/// @nodoc
mixin _$Cred {
  int? get id => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  String? get decrypted => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get website => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CredCopyWith<Cred> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CredCopyWith<$Res> {
  factory $CredCopyWith(Cred value, $Res Function(Cred) then) =
      _$CredCopyWithImpl<$Res>;
  $Res call(
      {int? id,
      String username,
      String password,
      String? decrypted,
      String description,
      String website,
      String category});
}

/// @nodoc
class _$CredCopyWithImpl<$Res> implements $CredCopyWith<$Res> {
  _$CredCopyWithImpl(this._value, this._then);

  final Cred _value;
  // ignore: unused_field
  final $Res Function(Cred) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? username = freezed,
    Object? password = freezed,
    Object? decrypted = freezed,
    Object? description = freezed,
    Object? website = freezed,
    Object? category = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      username: username == freezed
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      password: password == freezed
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      decrypted: decrypted == freezed
          ? _value.decrypted
          : decrypted // ignore: cast_nullable_to_non_nullable
              as String?,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      website: website == freezed
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String,
      category: category == freezed
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$CredCopyWith<$Res> implements $CredCopyWith<$Res> {
  factory _$CredCopyWith(_Cred value, $Res Function(_Cred) then) =
      __$CredCopyWithImpl<$Res>;
  @override
  $Res call(
      {int? id,
      String username,
      String password,
      String? decrypted,
      String description,
      String website,
      String category});
}

/// @nodoc
class __$CredCopyWithImpl<$Res> extends _$CredCopyWithImpl<$Res>
    implements _$CredCopyWith<$Res> {
  __$CredCopyWithImpl(_Cred _value, $Res Function(_Cred) _then)
      : super(_value, (v) => _then(v as _Cred));

  @override
  _Cred get _value => super._value as _Cred;

  @override
  $Res call({
    Object? id = freezed,
    Object? username = freezed,
    Object? password = freezed,
    Object? decrypted = freezed,
    Object? description = freezed,
    Object? website = freezed,
    Object? category = freezed,
  }) {
    return _then(_Cred(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      username: username == freezed
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      password: password == freezed
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      decrypted: decrypted == freezed
          ? _value.decrypted
          : decrypted // ignore: cast_nullable_to_non_nullable
              as String?,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      website: website == freezed
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String,
      category: category == freezed
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Cred implements _Cred {
  _$_Cred(
      {this.id,
      required this.username,
      required this.password,
      this.decrypted,
      required this.description,
      required this.website,
      required this.category});

  factory _$_Cred.fromJson(Map<String, dynamic> json) => _$$_CredFromJson(json);

  @override
  final int? id;
  @override
  final String username;
  @override
  final String password;
  @override
  final String? decrypted;
  @override
  final String description;
  @override
  final String website;
  @override
  final String category;

  @override
  String toString() {
    return 'Cred(id: $id, username: $username, password: $password, decrypted: $decrypted, description: $description, website: $website, category: $category)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Cred &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.username, username) &&
            const DeepCollectionEquality().equals(other.password, password) &&
            const DeepCollectionEquality().equals(other.decrypted, decrypted) &&
            const DeepCollectionEquality()
                .equals(other.description, description) &&
            const DeepCollectionEquality().equals(other.website, website) &&
            const DeepCollectionEquality().equals(other.category, category));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(username),
      const DeepCollectionEquality().hash(password),
      const DeepCollectionEquality().hash(decrypted),
      const DeepCollectionEquality().hash(description),
      const DeepCollectionEquality().hash(website),
      const DeepCollectionEquality().hash(category));

  @JsonKey(ignore: true)
  @override
  _$CredCopyWith<_Cred> get copyWith =>
      __$CredCopyWithImpl<_Cred>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CredToJson(this);
  }
}

abstract class _Cred implements Cred {
  factory _Cred(
      {int? id,
      required String username,
      required String password,
      String? decrypted,
      required String description,
      required String website,
      required String category}) = _$_Cred;

  factory _Cred.fromJson(Map<String, dynamic> json) = _$_Cred.fromJson;

  @override
  int? get id;
  @override
  String get username;
  @override
  String get password;
  @override
  String? get decrypted;
  @override
  String get description;
  @override
  String get website;
  @override
  String get category;
  @override
  @JsonKey(ignore: true)
  _$CredCopyWith<_Cred> get copyWith => throw _privateConstructorUsedError;
}
