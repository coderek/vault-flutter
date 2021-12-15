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
      description: json['description'] as String,
      website: json['website'] as String,
      category: json['category'] as String,
    );

Map<String, dynamic> _$$_CredToJson(_$_Cred instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['username'] = instance.username;
  val['password'] = instance.password;
  writeNotNull('decrypted', instance.decrypted);
  val['description'] = instance.description;
  val['website'] = instance.website;
  val['category'] = instance.category;
  return val;
}

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Vault on _Vault, Store {
  Computed<List<String>>? _$categoriesComputed;

  @override
  List<String> get categories =>
      (_$categoriesComputed ??= Computed<List<String>>(() => super.categories,
              name: '_Vault.categories'))
          .value;

  final _$credentialsAtom = Atom(name: '_Vault.credentials');

  @override
  ObservableList<Cred> get credentials {
    _$credentialsAtom.reportRead();
    return super.credentials;
  }

  @override
  set credentials(ObservableList<Cred> value) {
    _$credentialsAtom.reportWrite(value, super.credentials, () {
      super.credentials = value;
    });
  }

  final _$initAsyncAction = AsyncAction('_Vault.init');

  @override
  Future init() {
    return _$initAsyncAction.run(() => super.init());
  }

  final _$addAsyncAction = AsyncAction('_Vault.add');

  @override
  Future add(Cred cred) {
    return _$addAsyncAction.run(() => super.add(cred));
  }

  final _$removeAsyncAction = AsyncAction('_Vault.remove');

  @override
  Future remove(Cred cred) {
    return _$removeAsyncAction.run(() => super.remove(cred));
  }

  final _$updateAsyncAction = AsyncAction('_Vault.update');

  @override
  Future update(Cred old, Cred cred) {
    return _$updateAsyncAction.run(() => super.update(old, cred));
  }

  @override
  String toString() {
    return '''
credentials: ${credentials},
categories: ${categories}
    ''';
  }
}
