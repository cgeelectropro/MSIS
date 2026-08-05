// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AttachmentEntity {

 int get id; String get typeMime; int get tailleOctets; String get url;
/// Create a copy of AttachmentEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttachmentEntityCopyWith<AttachmentEntity> get copyWith => _$AttachmentEntityCopyWithImpl<AttachmentEntity>(this as AttachmentEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttachmentEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.typeMime, typeMime) || other.typeMime == typeMime)&&(identical(other.tailleOctets, tailleOctets) || other.tailleOctets == tailleOctets)&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode => Object.hash(runtimeType,id,typeMime,tailleOctets,url);

@override
String toString() {
  return 'AttachmentEntity(id: $id, typeMime: $typeMime, tailleOctets: $tailleOctets, url: $url)';
}


}

/// @nodoc
abstract mixin class $AttachmentEntityCopyWith<$Res>  {
  factory $AttachmentEntityCopyWith(AttachmentEntity value, $Res Function(AttachmentEntity) _then) = _$AttachmentEntityCopyWithImpl;
@useResult
$Res call({
 int id, String typeMime, int tailleOctets, String url
});




}
/// @nodoc
class _$AttachmentEntityCopyWithImpl<$Res>
    implements $AttachmentEntityCopyWith<$Res> {
  _$AttachmentEntityCopyWithImpl(this._self, this._then);

  final AttachmentEntity _self;
  final $Res Function(AttachmentEntity) _then;

/// Create a copy of AttachmentEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? typeMime = null,Object? tailleOctets = null,Object? url = null,}) {
  return _then(AttachmentEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,typeMime: null == typeMime ? _self.typeMime : typeMime // ignore: cast_nullable_to_non_nullable
as String,tailleOctets: null == tailleOctets ? _self.tailleOctets : tailleOctets // ignore: cast_nullable_to_non_nullable
as int,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AttachmentEntity].
extension AttachmentEntityPatterns on AttachmentEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttachmentEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttachmentEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttachmentEntity value)  $default,){
final _that = this;
switch (_that) {
case _AttachmentEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttachmentEntity value)?  $default,){
final _that = this;
switch (_that) {
case _AttachmentEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String typeMime,  int tailleOctets,  String url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttachmentEntity() when $default != null:
return $default(_that.id,_that.typeMime,_that.tailleOctets,_that.url);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String typeMime,  int tailleOctets,  String url)  $default,) {final _that = this;
switch (_that) {
case _AttachmentEntity():
return $default(_that.id,_that.typeMime,_that.tailleOctets,_that.url);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String typeMime,  int tailleOctets,  String url)?  $default,) {final _that = this;
switch (_that) {
case _AttachmentEntity() when $default != null:
return $default(_that.id,_that.typeMime,_that.tailleOctets,_that.url);case _:
  return null;

}
}

}

/// @nodoc


class _AttachmentEntity implements AttachmentEntity {
  const _AttachmentEntity({required this.id, required this.typeMime, required this.tailleOctets, required this.url});
  

@override final  int id;
@override final  String typeMime;
@override final  int tailleOctets;
@override final  String url;

/// Create a copy of AttachmentEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttachmentEntityCopyWith<_AttachmentEntity> get copyWith => __$AttachmentEntityCopyWithImpl<_AttachmentEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttachmentEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.typeMime, typeMime) || other.typeMime == typeMime)&&(identical(other.tailleOctets, tailleOctets) || other.tailleOctets == tailleOctets)&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode => Object.hash(runtimeType,id,typeMime,tailleOctets,url);

@override
String toString() {
  return 'AttachmentEntity(id: $id, typeMime: $typeMime, tailleOctets: $tailleOctets, url: $url)';
}


}

/// @nodoc
abstract mixin class _$AttachmentEntityCopyWith<$Res> implements $AttachmentEntityCopyWith<$Res> {
  factory _$AttachmentEntityCopyWith(_AttachmentEntity value, $Res Function(_AttachmentEntity) _then) = __$AttachmentEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String typeMime, int tailleOctets, String url
});




}
/// @nodoc
class __$AttachmentEntityCopyWithImpl<$Res>
    implements _$AttachmentEntityCopyWith<$Res> {
  __$AttachmentEntityCopyWithImpl(this._self, this._then);

  final _AttachmentEntity _self;
  final $Res Function(_AttachmentEntity) _then;

/// Create a copy of AttachmentEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? typeMime = null,Object? tailleOctets = null,Object? url = null,}) {
  return _then(_AttachmentEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,typeMime: null == typeMime ? _self.typeMime : typeMime // ignore: cast_nullable_to_non_nullable
as String,tailleOctets: null == tailleOctets ? _self.tailleOctets : tailleOctets // ignore: cast_nullable_to_non_nullable
as int,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$MessageEntity {

 int get id; int get idIntervention; int get idExpediteur; String? get expediteurNom; String get contenu; AttachmentEntity? get attachment; bool get livre; bool get lu; DateTime get createdAt; MessageSendStatus get sendStatus; String? get clientTempId;
/// Create a copy of MessageEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageEntityCopyWith<MessageEntity> get copyWith => _$MessageEntityCopyWithImpl<MessageEntity>(this as MessageEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.idIntervention, idIntervention) || other.idIntervention == idIntervention)&&(identical(other.idExpediteur, idExpediteur) || other.idExpediteur == idExpediteur)&&(identical(other.expediteurNom, expediteurNom) || other.expediteurNom == expediteurNom)&&(identical(other.contenu, contenu) || other.contenu == contenu)&&(identical(other.attachment, attachment) || other.attachment == attachment)&&(identical(other.livre, livre) || other.livre == livre)&&(identical(other.lu, lu) || other.lu == lu)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.sendStatus, sendStatus) || other.sendStatus == sendStatus)&&(identical(other.clientTempId, clientTempId) || other.clientTempId == clientTempId));
}


@override
int get hashCode => Object.hash(runtimeType,id,idIntervention,idExpediteur,expediteurNom,contenu,attachment,livre,lu,createdAt,sendStatus,clientTempId);

@override
String toString() {
  return 'MessageEntity(id: $id, idIntervention: $idIntervention, idExpediteur: $idExpediteur, expediteurNom: $expediteurNom, contenu: $contenu, attachment: $attachment, livre: $livre, lu: $lu, createdAt: $createdAt, sendStatus: $sendStatus, clientTempId: $clientTempId)';
}


}

/// @nodoc
abstract mixin class $MessageEntityCopyWith<$Res>  {
  factory $MessageEntityCopyWith(MessageEntity value, $Res Function(MessageEntity) _then) = _$MessageEntityCopyWithImpl;
@useResult
$Res call({
 int id, int idIntervention, int idExpediteur, String? expediteurNom, String contenu, AttachmentEntity? attachment, bool livre, bool lu, DateTime createdAt, MessageSendStatus sendStatus, String? clientTempId
});


$AttachmentEntityCopyWith<$Res>? get attachment;

}
/// @nodoc
class _$MessageEntityCopyWithImpl<$Res>
    implements $MessageEntityCopyWith<$Res> {
  _$MessageEntityCopyWithImpl(this._self, this._then);

  final MessageEntity _self;
  final $Res Function(MessageEntity) _then;

/// Create a copy of MessageEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? idIntervention = null,Object? idExpediteur = null,Object? expediteurNom = freezed,Object? contenu = null,Object? attachment = freezed,Object? livre = null,Object? lu = null,Object? createdAt = null,Object? sendStatus = null,Object? clientTempId = freezed,}) {
  return _then(MessageEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,idIntervention: null == idIntervention ? _self.idIntervention : idIntervention // ignore: cast_nullable_to_non_nullable
as int,idExpediteur: null == idExpediteur ? _self.idExpediteur : idExpediteur // ignore: cast_nullable_to_non_nullable
as int,expediteurNom: freezed == expediteurNom ? _self.expediteurNom : expediteurNom // ignore: cast_nullable_to_non_nullable
as String?,contenu: null == contenu ? _self.contenu : contenu // ignore: cast_nullable_to_non_nullable
as String,attachment: freezed == attachment ? _self.attachment : attachment // ignore: cast_nullable_to_non_nullable
as AttachmentEntity?,livre: null == livre ? _self.livre : livre // ignore: cast_nullable_to_non_nullable
as bool,lu: null == lu ? _self.lu : lu // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,sendStatus: null == sendStatus ? _self.sendStatus : sendStatus // ignore: cast_nullable_to_non_nullable
as MessageSendStatus,clientTempId: freezed == clientTempId ? _self.clientTempId : clientTempId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of MessageEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttachmentEntityCopyWith<$Res>? get attachment {
    if (_self.attachment == null) {
    return null;
  }

  return $AttachmentEntityCopyWith<$Res>(_self.attachment!, (value) {
    return _then(_self.copyWith(attachment: value));
  });
}
}


/// Adds pattern-matching-related methods to [MessageEntity].
extension MessageEntityPatterns on MessageEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MessageEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MessageEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MessageEntity value)  $default,){
final _that = this;
switch (_that) {
case _MessageEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MessageEntity value)?  $default,){
final _that = this;
switch (_that) {
case _MessageEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int idIntervention,  int idExpediteur,  String? expediteurNom,  String contenu,  AttachmentEntity? attachment,  bool livre,  bool lu,  DateTime createdAt,  MessageSendStatus sendStatus,  String? clientTempId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessageEntity() when $default != null:
return $default(_that.id,_that.idIntervention,_that.idExpediteur,_that.expediteurNom,_that.contenu,_that.attachment,_that.livre,_that.lu,_that.createdAt,_that.sendStatus,_that.clientTempId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int idIntervention,  int idExpediteur,  String? expediteurNom,  String contenu,  AttachmentEntity? attachment,  bool livre,  bool lu,  DateTime createdAt,  MessageSendStatus sendStatus,  String? clientTempId)  $default,) {final _that = this;
switch (_that) {
case _MessageEntity():
return $default(_that.id,_that.idIntervention,_that.idExpediteur,_that.expediteurNom,_that.contenu,_that.attachment,_that.livre,_that.lu,_that.createdAt,_that.sendStatus,_that.clientTempId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int idIntervention,  int idExpediteur,  String? expediteurNom,  String contenu,  AttachmentEntity? attachment,  bool livre,  bool lu,  DateTime createdAt,  MessageSendStatus sendStatus,  String? clientTempId)?  $default,) {final _that = this;
switch (_that) {
case _MessageEntity() when $default != null:
return $default(_that.id,_that.idIntervention,_that.idExpediteur,_that.expediteurNom,_that.contenu,_that.attachment,_that.livre,_that.lu,_that.createdAt,_that.sendStatus,_that.clientTempId);case _:
  return null;

}
}

}

/// @nodoc


class _MessageEntity implements MessageEntity {
  const _MessageEntity({required this.id, required this.idIntervention, required this.idExpediteur, this.expediteurNom, required this.contenu, this.attachment, required this.livre, required this.lu, required this.createdAt, this.sendStatus = MessageSendStatus.sent, this.clientTempId});
  

@override final  int id;
@override final  int idIntervention;
@override final  int idExpediteur;
@override final  String? expediteurNom;
@override final  String contenu;
@override final  AttachmentEntity? attachment;
@override final  bool livre;
@override final  bool lu;
@override final  DateTime createdAt;
@override@JsonKey() final  MessageSendStatus sendStatus;
@override final  String? clientTempId;

/// Create a copy of MessageEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageEntityCopyWith<_MessageEntity> get copyWith => __$MessageEntityCopyWithImpl<_MessageEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessageEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.idIntervention, idIntervention) || other.idIntervention == idIntervention)&&(identical(other.idExpediteur, idExpediteur) || other.idExpediteur == idExpediteur)&&(identical(other.expediteurNom, expediteurNom) || other.expediteurNom == expediteurNom)&&(identical(other.contenu, contenu) || other.contenu == contenu)&&(identical(other.attachment, attachment) || other.attachment == attachment)&&(identical(other.livre, livre) || other.livre == livre)&&(identical(other.lu, lu) || other.lu == lu)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.sendStatus, sendStatus) || other.sendStatus == sendStatus)&&(identical(other.clientTempId, clientTempId) || other.clientTempId == clientTempId));
}


@override
int get hashCode => Object.hash(runtimeType,id,idIntervention,idExpediteur,expediteurNom,contenu,attachment,livre,lu,createdAt,sendStatus,clientTempId);

@override
String toString() {
  return 'MessageEntity(id: $id, idIntervention: $idIntervention, idExpediteur: $idExpediteur, expediteurNom: $expediteurNom, contenu: $contenu, attachment: $attachment, livre: $livre, lu: $lu, createdAt: $createdAt, sendStatus: $sendStatus, clientTempId: $clientTempId)';
}


}

/// @nodoc
abstract mixin class _$MessageEntityCopyWith<$Res> implements $MessageEntityCopyWith<$Res> {
  factory _$MessageEntityCopyWith(_MessageEntity value, $Res Function(_MessageEntity) _then) = __$MessageEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, int idIntervention, int idExpediteur, String? expediteurNom, String contenu, AttachmentEntity? attachment, bool livre, bool lu, DateTime createdAt, MessageSendStatus sendStatus, String? clientTempId
});


@override $AttachmentEntityCopyWith<$Res>? get attachment;

}
/// @nodoc
class __$MessageEntityCopyWithImpl<$Res>
    implements _$MessageEntityCopyWith<$Res> {
  __$MessageEntityCopyWithImpl(this._self, this._then);

  final _MessageEntity _self;
  final $Res Function(_MessageEntity) _then;

/// Create a copy of MessageEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? idIntervention = null,Object? idExpediteur = null,Object? expediteurNom = freezed,Object? contenu = null,Object? attachment = freezed,Object? livre = null,Object? lu = null,Object? createdAt = null,Object? sendStatus = null,Object? clientTempId = freezed,}) {
  return _then(_MessageEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,idIntervention: null == idIntervention ? _self.idIntervention : idIntervention // ignore: cast_nullable_to_non_nullable
as int,idExpediteur: null == idExpediteur ? _self.idExpediteur : idExpediteur // ignore: cast_nullable_to_non_nullable
as int,expediteurNom: freezed == expediteurNom ? _self.expediteurNom : expediteurNom // ignore: cast_nullable_to_non_nullable
as String?,contenu: null == contenu ? _self.contenu : contenu // ignore: cast_nullable_to_non_nullable
as String,attachment: freezed == attachment ? _self.attachment : attachment // ignore: cast_nullable_to_non_nullable
as AttachmentEntity?,livre: null == livre ? _self.livre : livre // ignore: cast_nullable_to_non_nullable
as bool,lu: null == lu ? _self.lu : lu // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,sendStatus: null == sendStatus ? _self.sendStatus : sendStatus // ignore: cast_nullable_to_non_nullable
as MessageSendStatus,clientTempId: freezed == clientTempId ? _self.clientTempId : clientTempId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of MessageEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttachmentEntityCopyWith<$Res>? get attachment {
    if (_self.attachment == null) {
    return null;
  }

  return $AttachmentEntityCopyWith<$Res>(_self.attachment!, (value) {
    return _then(_self.copyWith(attachment: value));
  });
}
}

// dart format on
