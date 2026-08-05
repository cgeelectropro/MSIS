// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AttachmentDto {

 int get id;@JsonKey(name: 'type_mime') String get typeMime;@JsonKey(name: 'taille_octets') int get tailleOctets; String get url;
/// Create a copy of AttachmentDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttachmentDtoCopyWith<AttachmentDto> get copyWith => _$AttachmentDtoCopyWithImpl<AttachmentDto>(this as AttachmentDto, _$identity);

  /// Serializes this AttachmentDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttachmentDto&&(identical(other.id, id) || other.id == id)&&(identical(other.typeMime, typeMime) || other.typeMime == typeMime)&&(identical(other.tailleOctets, tailleOctets) || other.tailleOctets == tailleOctets)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,typeMime,tailleOctets,url);

@override
String toString() {
  return 'AttachmentDto(id: $id, typeMime: $typeMime, tailleOctets: $tailleOctets, url: $url)';
}


}

/// @nodoc
abstract mixin class $AttachmentDtoCopyWith<$Res>  {
  factory $AttachmentDtoCopyWith(AttachmentDto value, $Res Function(AttachmentDto) _then) = _$AttachmentDtoCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'type_mime') String typeMime,@JsonKey(name: 'taille_octets') int tailleOctets, String url
});




}
/// @nodoc
class _$AttachmentDtoCopyWithImpl<$Res>
    implements $AttachmentDtoCopyWith<$Res> {
  _$AttachmentDtoCopyWithImpl(this._self, this._then);

  final AttachmentDto _self;
  final $Res Function(AttachmentDto) _then;

/// Create a copy of AttachmentDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? typeMime = null,Object? tailleOctets = null,Object? url = null,}) {
  return _then(AttachmentDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,typeMime: null == typeMime ? _self.typeMime : typeMime // ignore: cast_nullable_to_non_nullable
as String,tailleOctets: null == tailleOctets ? _self.tailleOctets : tailleOctets // ignore: cast_nullable_to_non_nullable
as int,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AttachmentDto].
extension AttachmentDtoPatterns on AttachmentDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttachmentDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttachmentDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttachmentDto value)  $default,){
final _that = this;
switch (_that) {
case _AttachmentDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttachmentDto value)?  $default,){
final _that = this;
switch (_that) {
case _AttachmentDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'type_mime')  String typeMime, @JsonKey(name: 'taille_octets')  int tailleOctets,  String url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttachmentDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'type_mime')  String typeMime, @JsonKey(name: 'taille_octets')  int tailleOctets,  String url)  $default,) {final _that = this;
switch (_that) {
case _AttachmentDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'type_mime')  String typeMime, @JsonKey(name: 'taille_octets')  int tailleOctets,  String url)?  $default,) {final _that = this;
switch (_that) {
case _AttachmentDto() when $default != null:
return $default(_that.id,_that.typeMime,_that.tailleOctets,_that.url);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttachmentDto implements AttachmentDto {
  const _AttachmentDto({required this.id, @JsonKey(name: 'type_mime') required this.typeMime, @JsonKey(name: 'taille_octets') required this.tailleOctets, required this.url});
  factory _AttachmentDto.fromJson(Map<String, dynamic> json) => _$AttachmentDtoFromJson(json);

@override final  int id;
@override@JsonKey(name: 'type_mime') final  String typeMime;
@override@JsonKey(name: 'taille_octets') final  int tailleOctets;
@override final  String url;

/// Create a copy of AttachmentDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttachmentDtoCopyWith<_AttachmentDto> get copyWith => __$AttachmentDtoCopyWithImpl<_AttachmentDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttachmentDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttachmentDto&&(identical(other.id, id) || other.id == id)&&(identical(other.typeMime, typeMime) || other.typeMime == typeMime)&&(identical(other.tailleOctets, tailleOctets) || other.tailleOctets == tailleOctets)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,typeMime,tailleOctets,url);

@override
String toString() {
  return 'AttachmentDto(id: $id, typeMime: $typeMime, tailleOctets: $tailleOctets, url: $url)';
}


}

/// @nodoc
abstract mixin class _$AttachmentDtoCopyWith<$Res> implements $AttachmentDtoCopyWith<$Res> {
  factory _$AttachmentDtoCopyWith(_AttachmentDto value, $Res Function(_AttachmentDto) _then) = __$AttachmentDtoCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'type_mime') String typeMime,@JsonKey(name: 'taille_octets') int tailleOctets, String url
});




}
/// @nodoc
class __$AttachmentDtoCopyWithImpl<$Res>
    implements _$AttachmentDtoCopyWith<$Res> {
  __$AttachmentDtoCopyWithImpl(this._self, this._then);

  final _AttachmentDto _self;
  final $Res Function(_AttachmentDto) _then;

/// Create a copy of AttachmentDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? typeMime = null,Object? tailleOctets = null,Object? url = null,}) {
  return _then(_AttachmentDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,typeMime: null == typeMime ? _self.typeMime : typeMime // ignore: cast_nullable_to_non_nullable
as String,tailleOctets: null == tailleOctets ? _self.tailleOctets : tailleOctets // ignore: cast_nullable_to_non_nullable
as int,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$MessageDto {

@JsonKey(name: 'id_message') int get idMessage;@JsonKey(name: 'id_intervention') int get idIntervention;@JsonKey(name: 'id_expediteur') int get idExpediteur; Map<String, dynamic>? get expediteur; String get contenu; List<AttachmentDto>? get attachments; bool get livre; bool get lu;@JsonKey(name: 'created_at') String get createdAt;
/// Create a copy of MessageDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageDtoCopyWith<MessageDto> get copyWith => _$MessageDtoCopyWithImpl<MessageDto>(this as MessageDto, _$identity);

  /// Serializes this MessageDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageDto&&(identical(other.idMessage, idMessage) || other.idMessage == idMessage)&&(identical(other.idIntervention, idIntervention) || other.idIntervention == idIntervention)&&(identical(other.idExpediteur, idExpediteur) || other.idExpediteur == idExpediteur)&&const DeepCollectionEquality().equals(other.expediteur, expediteur)&&(identical(other.contenu, contenu) || other.contenu == contenu)&&const DeepCollectionEquality().equals(other.attachments, attachments)&&(identical(other.livre, livre) || other.livre == livre)&&(identical(other.lu, lu) || other.lu == lu)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,idMessage,idIntervention,idExpediteur,const DeepCollectionEquality().hash(expediteur),contenu,const DeepCollectionEquality().hash(attachments),livre,lu,createdAt);

@override
String toString() {
  return 'MessageDto(idMessage: $idMessage, idIntervention: $idIntervention, idExpediteur: $idExpediteur, expediteur: $expediteur, contenu: $contenu, attachments: $attachments, livre: $livre, lu: $lu, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $MessageDtoCopyWith<$Res>  {
  factory $MessageDtoCopyWith(MessageDto value, $Res Function(MessageDto) _then) = _$MessageDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id_message') int idMessage,@JsonKey(name: 'id_intervention') int idIntervention,@JsonKey(name: 'id_expediteur') int idExpediteur, Map<String, dynamic>? expediteur, String contenu, List<AttachmentDto>? attachments, bool livre, bool lu,@JsonKey(name: 'created_at') String createdAt
});




}
/// @nodoc
class _$MessageDtoCopyWithImpl<$Res>
    implements $MessageDtoCopyWith<$Res> {
  _$MessageDtoCopyWithImpl(this._self, this._then);

  final MessageDto _self;
  final $Res Function(MessageDto) _then;

/// Create a copy of MessageDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? idMessage = null,Object? idIntervention = null,Object? idExpediteur = null,Object? expediteur = freezed,Object? contenu = null,Object? attachments = freezed,Object? livre = null,Object? lu = null,Object? createdAt = null,}) {
  return _then(MessageDto(
idMessage: null == idMessage ? _self.idMessage : idMessage // ignore: cast_nullable_to_non_nullable
as int,idIntervention: null == idIntervention ? _self.idIntervention : idIntervention // ignore: cast_nullable_to_non_nullable
as int,idExpediteur: null == idExpediteur ? _self.idExpediteur : idExpediteur // ignore: cast_nullable_to_non_nullable
as int,expediteur: freezed == expediteur ? _self.expediteur : expediteur // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,contenu: null == contenu ? _self.contenu : contenu // ignore: cast_nullable_to_non_nullable
as String,attachments: freezed == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<AttachmentDto>?,livre: null == livre ? _self.livre : livre // ignore: cast_nullable_to_non_nullable
as bool,lu: null == lu ? _self.lu : lu // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MessageDto].
extension MessageDtoPatterns on MessageDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MessageDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MessageDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MessageDto value)  $default,){
final _that = this;
switch (_that) {
case _MessageDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MessageDto value)?  $default,){
final _that = this;
switch (_that) {
case _MessageDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id_message')  int idMessage, @JsonKey(name: 'id_intervention')  int idIntervention, @JsonKey(name: 'id_expediteur')  int idExpediteur,  Map<String, dynamic>? expediteur,  String contenu,  List<AttachmentDto>? attachments,  bool livre,  bool lu, @JsonKey(name: 'created_at')  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessageDto() when $default != null:
return $default(_that.idMessage,_that.idIntervention,_that.idExpediteur,_that.expediteur,_that.contenu,_that.attachments,_that.livre,_that.lu,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id_message')  int idMessage, @JsonKey(name: 'id_intervention')  int idIntervention, @JsonKey(name: 'id_expediteur')  int idExpediteur,  Map<String, dynamic>? expediteur,  String contenu,  List<AttachmentDto>? attachments,  bool livre,  bool lu, @JsonKey(name: 'created_at')  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _MessageDto():
return $default(_that.idMessage,_that.idIntervention,_that.idExpediteur,_that.expediteur,_that.contenu,_that.attachments,_that.livre,_that.lu,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id_message')  int idMessage, @JsonKey(name: 'id_intervention')  int idIntervention, @JsonKey(name: 'id_expediteur')  int idExpediteur,  Map<String, dynamic>? expediteur,  String contenu,  List<AttachmentDto>? attachments,  bool livre,  bool lu, @JsonKey(name: 'created_at')  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _MessageDto() when $default != null:
return $default(_that.idMessage,_that.idIntervention,_that.idExpediteur,_that.expediteur,_that.contenu,_that.attachments,_that.livre,_that.lu,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MessageDto implements MessageDto {
  const _MessageDto({@JsonKey(name: 'id_message') required this.idMessage, @JsonKey(name: 'id_intervention') required this.idIntervention, @JsonKey(name: 'id_expediteur') required this.idExpediteur,  Map<String, dynamic>? expediteur, required this.contenu,  List<AttachmentDto>? attachments, required this.livre, required this.lu, @JsonKey(name: 'created_at') required this.createdAt}): _expediteur = expediteur,_attachments = attachments;
  factory _MessageDto.fromJson(Map<String, dynamic> json) => _$MessageDtoFromJson(json);

@override@JsonKey(name: 'id_message') final  int idMessage;
@override@JsonKey(name: 'id_intervention') final  int idIntervention;
@override@JsonKey(name: 'id_expediteur') final  int idExpediteur;
 final  Map<String, dynamic>? _expediteur;
@override Map<String, dynamic>? get expediteur {
  final value = _expediteur;
  if (value == null) return null;
  if (_expediteur is EqualUnmodifiableMapView) return _expediteur;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  String contenu;
 final  List<AttachmentDto>? _attachments;
@override List<AttachmentDto>? get attachments {
  final value = _attachments;
  if (value == null) return null;
  if (_attachments is EqualUnmodifiableListView) return _attachments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  bool livre;
@override final  bool lu;
@override@JsonKey(name: 'created_at') final  String createdAt;

/// Create a copy of MessageDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageDtoCopyWith<_MessageDto> get copyWith => __$MessageDtoCopyWithImpl<_MessageDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessageDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessageDto&&(identical(other.idMessage, idMessage) || other.idMessage == idMessage)&&(identical(other.idIntervention, idIntervention) || other.idIntervention == idIntervention)&&(identical(other.idExpediteur, idExpediteur) || other.idExpediteur == idExpediteur)&&const DeepCollectionEquality().equals(other._expediteur, _expediteur)&&(identical(other.contenu, contenu) || other.contenu == contenu)&&const DeepCollectionEquality().equals(other._attachments, _attachments)&&(identical(other.livre, livre) || other.livre == livre)&&(identical(other.lu, lu) || other.lu == lu)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,idMessage,idIntervention,idExpediteur,const DeepCollectionEquality().hash(_expediteur),contenu,const DeepCollectionEquality().hash(_attachments),livre,lu,createdAt);

@override
String toString() {
  return 'MessageDto(idMessage: $idMessage, idIntervention: $idIntervention, idExpediteur: $idExpediteur, expediteur: $expediteur, contenu: $contenu, attachments: $attachments, livre: $livre, lu: $lu, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$MessageDtoCopyWith<$Res> implements $MessageDtoCopyWith<$Res> {
  factory _$MessageDtoCopyWith(_MessageDto value, $Res Function(_MessageDto) _then) = __$MessageDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id_message') int idMessage,@JsonKey(name: 'id_intervention') int idIntervention,@JsonKey(name: 'id_expediteur') int idExpediteur, Map<String, dynamic>? expediteur, String contenu, List<AttachmentDto>? attachments, bool livre, bool lu,@JsonKey(name: 'created_at') String createdAt
});




}
/// @nodoc
class __$MessageDtoCopyWithImpl<$Res>
    implements _$MessageDtoCopyWith<$Res> {
  __$MessageDtoCopyWithImpl(this._self, this._then);

  final _MessageDto _self;
  final $Res Function(_MessageDto) _then;

/// Create a copy of MessageDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? idMessage = null,Object? idIntervention = null,Object? idExpediteur = null,Object? expediteur = freezed,Object? contenu = null,Object? attachments = freezed,Object? livre = null,Object? lu = null,Object? createdAt = null,}) {
  return _then(_MessageDto(
idMessage: null == idMessage ? _self.idMessage : idMessage // ignore: cast_nullable_to_non_nullable
as int,idIntervention: null == idIntervention ? _self.idIntervention : idIntervention // ignore: cast_nullable_to_non_nullable
as int,idExpediteur: null == idExpediteur ? _self.idExpediteur : idExpediteur // ignore: cast_nullable_to_non_nullable
as int,expediteur: freezed == expediteur ? _self._expediteur : expediteur // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,contenu: null == contenu ? _self.contenu : contenu // ignore: cast_nullable_to_non_nullable
as String,attachments: freezed == attachments ? _self._attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<AttachmentDto>?,livre: null == livre ? _self.livre : livre // ignore: cast_nullable_to_non_nullable
as bool,lu: null == lu ? _self.lu : lu // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
