// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_report_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TechnicianWorkloadDto {

@JsonKey(name: 'id_technicien') int get idTechnicien; String get nom; int get charge;
/// Create a copy of TechnicianWorkloadDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TechnicianWorkloadDtoCopyWith<TechnicianWorkloadDto> get copyWith => _$TechnicianWorkloadDtoCopyWithImpl<TechnicianWorkloadDto>(this as TechnicianWorkloadDto, _$identity);

  /// Serializes this TechnicianWorkloadDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TechnicianWorkloadDto&&(identical(other.idTechnicien, idTechnicien) || other.idTechnicien == idTechnicien)&&(identical(other.nom, nom) || other.nom == nom)&&(identical(other.charge, charge) || other.charge == charge));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,idTechnicien,nom,charge);

@override
String toString() {
  return 'TechnicianWorkloadDto(idTechnicien: $idTechnicien, nom: $nom, charge: $charge)';
}


}

/// @nodoc
abstract mixin class $TechnicianWorkloadDtoCopyWith<$Res>  {
  factory $TechnicianWorkloadDtoCopyWith(TechnicianWorkloadDto value, $Res Function(TechnicianWorkloadDto) _then) = _$TechnicianWorkloadDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id_technicien') int idTechnicien, String nom, int charge
});




}
/// @nodoc
class _$TechnicianWorkloadDtoCopyWithImpl<$Res>
    implements $TechnicianWorkloadDtoCopyWith<$Res> {
  _$TechnicianWorkloadDtoCopyWithImpl(this._self, this._then);

  final TechnicianWorkloadDto _self;
  final $Res Function(TechnicianWorkloadDto) _then;

/// Create a copy of TechnicianWorkloadDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? idTechnicien = null,Object? nom = null,Object? charge = null,}) {
  return _then(TechnicianWorkloadDto(
idTechnicien: null == idTechnicien ? _self.idTechnicien : idTechnicien // ignore: cast_nullable_to_non_nullable
as int,nom: null == nom ? _self.nom : nom // ignore: cast_nullable_to_non_nullable
as String,charge: null == charge ? _self.charge : charge // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TechnicianWorkloadDto].
extension TechnicianWorkloadDtoPatterns on TechnicianWorkloadDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TechnicianWorkloadDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TechnicianWorkloadDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TechnicianWorkloadDto value)  $default,){
final _that = this;
switch (_that) {
case _TechnicianWorkloadDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TechnicianWorkloadDto value)?  $default,){
final _that = this;
switch (_that) {
case _TechnicianWorkloadDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id_technicien')  int idTechnicien,  String nom,  int charge)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TechnicianWorkloadDto() when $default != null:
return $default(_that.idTechnicien,_that.nom,_that.charge);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id_technicien')  int idTechnicien,  String nom,  int charge)  $default,) {final _that = this;
switch (_that) {
case _TechnicianWorkloadDto():
return $default(_that.idTechnicien,_that.nom,_that.charge);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id_technicien')  int idTechnicien,  String nom,  int charge)?  $default,) {final _that = this;
switch (_that) {
case _TechnicianWorkloadDto() when $default != null:
return $default(_that.idTechnicien,_that.nom,_that.charge);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TechnicianWorkloadDto implements TechnicianWorkloadDto {
  const _TechnicianWorkloadDto({@JsonKey(name: 'id_technicien') required this.idTechnicien, required this.nom, required this.charge});
  factory _TechnicianWorkloadDto.fromJson(Map<String, dynamic> json) => _$TechnicianWorkloadDtoFromJson(json);

@override@JsonKey(name: 'id_technicien') final  int idTechnicien;
@override final  String nom;
@override final  int charge;

/// Create a copy of TechnicianWorkloadDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TechnicianWorkloadDtoCopyWith<_TechnicianWorkloadDto> get copyWith => __$TechnicianWorkloadDtoCopyWithImpl<_TechnicianWorkloadDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TechnicianWorkloadDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TechnicianWorkloadDto&&(identical(other.idTechnicien, idTechnicien) || other.idTechnicien == idTechnicien)&&(identical(other.nom, nom) || other.nom == nom)&&(identical(other.charge, charge) || other.charge == charge));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,idTechnicien,nom,charge);

@override
String toString() {
  return 'TechnicianWorkloadDto(idTechnicien: $idTechnicien, nom: $nom, charge: $charge)';
}


}

/// @nodoc
abstract mixin class _$TechnicianWorkloadDtoCopyWith<$Res> implements $TechnicianWorkloadDtoCopyWith<$Res> {
  factory _$TechnicianWorkloadDtoCopyWith(_TechnicianWorkloadDto value, $Res Function(_TechnicianWorkloadDto) _then) = __$TechnicianWorkloadDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id_technicien') int idTechnicien, String nom, int charge
});




}
/// @nodoc
class __$TechnicianWorkloadDtoCopyWithImpl<$Res>
    implements _$TechnicianWorkloadDtoCopyWith<$Res> {
  __$TechnicianWorkloadDtoCopyWithImpl(this._self, this._then);

  final _TechnicianWorkloadDto _self;
  final $Res Function(_TechnicianWorkloadDto) _then;

/// Create a copy of TechnicianWorkloadDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? idTechnicien = null,Object? nom = null,Object? charge = null,}) {
  return _then(_TechnicianWorkloadDto(
idTechnicien: null == idTechnicien ? _self.idTechnicien : idTechnicien // ignore: cast_nullable_to_non_nullable
as int,nom: null == nom ? _self.nom : nom // ignore: cast_nullable_to_non_nullable
as String,charge: null == charge ? _self.charge : charge // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$WeekTrendPointDto {

 String get semaine; int get creees; int get cloturees;
/// Create a copy of WeekTrendPointDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeekTrendPointDtoCopyWith<WeekTrendPointDto> get copyWith => _$WeekTrendPointDtoCopyWithImpl<WeekTrendPointDto>(this as WeekTrendPointDto, _$identity);

  /// Serializes this WeekTrendPointDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeekTrendPointDto&&(identical(other.semaine, semaine) || other.semaine == semaine)&&(identical(other.creees, creees) || other.creees == creees)&&(identical(other.cloturees, cloturees) || other.cloturees == cloturees));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,semaine,creees,cloturees);

@override
String toString() {
  return 'WeekTrendPointDto(semaine: $semaine, creees: $creees, cloturees: $cloturees)';
}


}

/// @nodoc
abstract mixin class $WeekTrendPointDtoCopyWith<$Res>  {
  factory $WeekTrendPointDtoCopyWith(WeekTrendPointDto value, $Res Function(WeekTrendPointDto) _then) = _$WeekTrendPointDtoCopyWithImpl;
@useResult
$Res call({
 String semaine, int creees, int cloturees
});




}
/// @nodoc
class _$WeekTrendPointDtoCopyWithImpl<$Res>
    implements $WeekTrendPointDtoCopyWith<$Res> {
  _$WeekTrendPointDtoCopyWithImpl(this._self, this._then);

  final WeekTrendPointDto _self;
  final $Res Function(WeekTrendPointDto) _then;

/// Create a copy of WeekTrendPointDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? semaine = null,Object? creees = null,Object? cloturees = null,}) {
  return _then(WeekTrendPointDto(
semaine: null == semaine ? _self.semaine : semaine // ignore: cast_nullable_to_non_nullable
as String,creees: null == creees ? _self.creees : creees // ignore: cast_nullable_to_non_nullable
as int,cloturees: null == cloturees ? _self.cloturees : cloturees // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WeekTrendPointDto].
extension WeekTrendPointDtoPatterns on WeekTrendPointDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeekTrendPointDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeekTrendPointDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeekTrendPointDto value)  $default,){
final _that = this;
switch (_that) {
case _WeekTrendPointDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeekTrendPointDto value)?  $default,){
final _that = this;
switch (_that) {
case _WeekTrendPointDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String semaine,  int creees,  int cloturees)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeekTrendPointDto() when $default != null:
return $default(_that.semaine,_that.creees,_that.cloturees);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String semaine,  int creees,  int cloturees)  $default,) {final _that = this;
switch (_that) {
case _WeekTrendPointDto():
return $default(_that.semaine,_that.creees,_that.cloturees);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String semaine,  int creees,  int cloturees)?  $default,) {final _that = this;
switch (_that) {
case _WeekTrendPointDto() when $default != null:
return $default(_that.semaine,_that.creees,_that.cloturees);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeekTrendPointDto implements WeekTrendPointDto {
  const _WeekTrendPointDto({required this.semaine, required this.creees, required this.cloturees});
  factory _WeekTrendPointDto.fromJson(Map<String, dynamic> json) => _$WeekTrendPointDtoFromJson(json);

@override final  String semaine;
@override final  int creees;
@override final  int cloturees;

/// Create a copy of WeekTrendPointDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeekTrendPointDtoCopyWith<_WeekTrendPointDto> get copyWith => __$WeekTrendPointDtoCopyWithImpl<_WeekTrendPointDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeekTrendPointDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeekTrendPointDto&&(identical(other.semaine, semaine) || other.semaine == semaine)&&(identical(other.creees, creees) || other.creees == creees)&&(identical(other.cloturees, cloturees) || other.cloturees == cloturees));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,semaine,creees,cloturees);

@override
String toString() {
  return 'WeekTrendPointDto(semaine: $semaine, creees: $creees, cloturees: $cloturees)';
}


}

/// @nodoc
abstract mixin class _$WeekTrendPointDtoCopyWith<$Res> implements $WeekTrendPointDtoCopyWith<$Res> {
  factory _$WeekTrendPointDtoCopyWith(_WeekTrendPointDto value, $Res Function(_WeekTrendPointDto) _then) = __$WeekTrendPointDtoCopyWithImpl;
@override @useResult
$Res call({
 String semaine, int creees, int cloturees
});




}
/// @nodoc
class __$WeekTrendPointDtoCopyWithImpl<$Res>
    implements _$WeekTrendPointDtoCopyWith<$Res> {
  __$WeekTrendPointDtoCopyWithImpl(this._self, this._then);

  final _WeekTrendPointDto _self;
  final $Res Function(_WeekTrendPointDto) _then;

/// Create a copy of WeekTrendPointDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? semaine = null,Object? creees = null,Object? cloturees = null,}) {
  return _then(_WeekTrendPointDto(
semaine: null == semaine ? _self.semaine : semaine // ignore: cast_nullable_to_non_nullable
as String,creees: null == creees ? _self.creees : creees // ignore: cast_nullable_to_non_nullable
as int,cloturees: null == cloturees ? _self.cloturees : cloturees // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$DashboardKpisDto {

 int get total;@JsonKey(name: 'par_statut') Map<String, dynamic> get parStatut;@JsonKey(name: 'par_priorite') Map<String, dynamic> get parPriorite;@JsonKey(name: 'delai_moyen_prise_en_charge_minutes') double? get delaiMoyenPriseEnChargeMinutes;@JsonKey(name: 'delai_moyen_resolution_minutes') double? get delaiMoyenResolutionMinutes;@JsonKey(name: 'charge_par_technicien') List<TechnicianWorkloadDto> get chargeParTechnicien;@JsonKey(name: 'satisfaction_moyenne') double get satisfactionMoyenne;
/// Create a copy of DashboardKpisDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardKpisDtoCopyWith<DashboardKpisDto> get copyWith => _$DashboardKpisDtoCopyWithImpl<DashboardKpisDto>(this as DashboardKpisDto, _$identity);

  /// Serializes this DashboardKpisDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardKpisDto&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other.parStatut, parStatut)&&const DeepCollectionEquality().equals(other.parPriorite, parPriorite)&&(identical(other.delaiMoyenPriseEnChargeMinutes, delaiMoyenPriseEnChargeMinutes) || other.delaiMoyenPriseEnChargeMinutes == delaiMoyenPriseEnChargeMinutes)&&(identical(other.delaiMoyenResolutionMinutes, delaiMoyenResolutionMinutes) || other.delaiMoyenResolutionMinutes == delaiMoyenResolutionMinutes)&&const DeepCollectionEquality().equals(other.chargeParTechnicien, chargeParTechnicien)&&(identical(other.satisfactionMoyenne, satisfactionMoyenne) || other.satisfactionMoyenne == satisfactionMoyenne));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,const DeepCollectionEquality().hash(parStatut),const DeepCollectionEquality().hash(parPriorite),delaiMoyenPriseEnChargeMinutes,delaiMoyenResolutionMinutes,const DeepCollectionEquality().hash(chargeParTechnicien),satisfactionMoyenne);

@override
String toString() {
  return 'DashboardKpisDto(total: $total, parStatut: $parStatut, parPriorite: $parPriorite, delaiMoyenPriseEnChargeMinutes: $delaiMoyenPriseEnChargeMinutes, delaiMoyenResolutionMinutes: $delaiMoyenResolutionMinutes, chargeParTechnicien: $chargeParTechnicien, satisfactionMoyenne: $satisfactionMoyenne)';
}


}

/// @nodoc
abstract mixin class $DashboardKpisDtoCopyWith<$Res>  {
  factory $DashboardKpisDtoCopyWith(DashboardKpisDto value, $Res Function(DashboardKpisDto) _then) = _$DashboardKpisDtoCopyWithImpl;
@useResult
$Res call({
 int total,@JsonKey(name: 'par_statut') Map<String, dynamic> parStatut,@JsonKey(name: 'par_priorite') Map<String, dynamic> parPriorite,@JsonKey(name: 'delai_moyen_prise_en_charge_minutes') double? delaiMoyenPriseEnChargeMinutes,@JsonKey(name: 'delai_moyen_resolution_minutes') double? delaiMoyenResolutionMinutes,@JsonKey(name: 'charge_par_technicien') List<TechnicianWorkloadDto> chargeParTechnicien,@JsonKey(name: 'satisfaction_moyenne') double satisfactionMoyenne
});




}
/// @nodoc
class _$DashboardKpisDtoCopyWithImpl<$Res>
    implements $DashboardKpisDtoCopyWith<$Res> {
  _$DashboardKpisDtoCopyWithImpl(this._self, this._then);

  final DashboardKpisDto _self;
  final $Res Function(DashboardKpisDto) _then;

/// Create a copy of DashboardKpisDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? parStatut = null,Object? parPriorite = null,Object? delaiMoyenPriseEnChargeMinutes = freezed,Object? delaiMoyenResolutionMinutes = freezed,Object? chargeParTechnicien = null,Object? satisfactionMoyenne = null,}) {
  return _then(DashboardKpisDto(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,parStatut: null == parStatut ? _self.parStatut : parStatut // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,parPriorite: null == parPriorite ? _self.parPriorite : parPriorite // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,delaiMoyenPriseEnChargeMinutes: freezed == delaiMoyenPriseEnChargeMinutes ? _self.delaiMoyenPriseEnChargeMinutes : delaiMoyenPriseEnChargeMinutes // ignore: cast_nullable_to_non_nullable
as double?,delaiMoyenResolutionMinutes: freezed == delaiMoyenResolutionMinutes ? _self.delaiMoyenResolutionMinutes : delaiMoyenResolutionMinutes // ignore: cast_nullable_to_non_nullable
as double?,chargeParTechnicien: null == chargeParTechnicien ? _self.chargeParTechnicien : chargeParTechnicien // ignore: cast_nullable_to_non_nullable
as List<TechnicianWorkloadDto>,satisfactionMoyenne: null == satisfactionMoyenne ? _self.satisfactionMoyenne : satisfactionMoyenne // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardKpisDto].
extension DashboardKpisDtoPatterns on DashboardKpisDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardKpisDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardKpisDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardKpisDto value)  $default,){
final _that = this;
switch (_that) {
case _DashboardKpisDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardKpisDto value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardKpisDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int total, @JsonKey(name: 'par_statut')  Map<String, dynamic> parStatut, @JsonKey(name: 'par_priorite')  Map<String, dynamic> parPriorite, @JsonKey(name: 'delai_moyen_prise_en_charge_minutes')  double? delaiMoyenPriseEnChargeMinutes, @JsonKey(name: 'delai_moyen_resolution_minutes')  double? delaiMoyenResolutionMinutes, @JsonKey(name: 'charge_par_technicien')  List<TechnicianWorkloadDto> chargeParTechnicien, @JsonKey(name: 'satisfaction_moyenne')  double satisfactionMoyenne)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardKpisDto() when $default != null:
return $default(_that.total,_that.parStatut,_that.parPriorite,_that.delaiMoyenPriseEnChargeMinutes,_that.delaiMoyenResolutionMinutes,_that.chargeParTechnicien,_that.satisfactionMoyenne);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int total, @JsonKey(name: 'par_statut')  Map<String, dynamic> parStatut, @JsonKey(name: 'par_priorite')  Map<String, dynamic> parPriorite, @JsonKey(name: 'delai_moyen_prise_en_charge_minutes')  double? delaiMoyenPriseEnChargeMinutes, @JsonKey(name: 'delai_moyen_resolution_minutes')  double? delaiMoyenResolutionMinutes, @JsonKey(name: 'charge_par_technicien')  List<TechnicianWorkloadDto> chargeParTechnicien, @JsonKey(name: 'satisfaction_moyenne')  double satisfactionMoyenne)  $default,) {final _that = this;
switch (_that) {
case _DashboardKpisDto():
return $default(_that.total,_that.parStatut,_that.parPriorite,_that.delaiMoyenPriseEnChargeMinutes,_that.delaiMoyenResolutionMinutes,_that.chargeParTechnicien,_that.satisfactionMoyenne);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int total, @JsonKey(name: 'par_statut')  Map<String, dynamic> parStatut, @JsonKey(name: 'par_priorite')  Map<String, dynamic> parPriorite, @JsonKey(name: 'delai_moyen_prise_en_charge_minutes')  double? delaiMoyenPriseEnChargeMinutes, @JsonKey(name: 'delai_moyen_resolution_minutes')  double? delaiMoyenResolutionMinutes, @JsonKey(name: 'charge_par_technicien')  List<TechnicianWorkloadDto> chargeParTechnicien, @JsonKey(name: 'satisfaction_moyenne')  double satisfactionMoyenne)?  $default,) {final _that = this;
switch (_that) {
case _DashboardKpisDto() when $default != null:
return $default(_that.total,_that.parStatut,_that.parPriorite,_that.delaiMoyenPriseEnChargeMinutes,_that.delaiMoyenResolutionMinutes,_that.chargeParTechnicien,_that.satisfactionMoyenne);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardKpisDto implements DashboardKpisDto {
  const _DashboardKpisDto({required this.total, @JsonKey(name: 'par_statut') required  Map<String, dynamic> parStatut, @JsonKey(name: 'par_priorite') required  Map<String, dynamic> parPriorite, @JsonKey(name: 'delai_moyen_prise_en_charge_minutes') this.delaiMoyenPriseEnChargeMinutes, @JsonKey(name: 'delai_moyen_resolution_minutes') this.delaiMoyenResolutionMinutes, @JsonKey(name: 'charge_par_technicien') required  List<TechnicianWorkloadDto> chargeParTechnicien, @JsonKey(name: 'satisfaction_moyenne') required this.satisfactionMoyenne}): _parStatut = parStatut,_parPriorite = parPriorite,_chargeParTechnicien = chargeParTechnicien;
  factory _DashboardKpisDto.fromJson(Map<String, dynamic> json) => _$DashboardKpisDtoFromJson(json);

@override final  int total;
 final  Map<String, dynamic> _parStatut;
@override@JsonKey(name: 'par_statut') Map<String, dynamic> get parStatut {
  if (_parStatut is EqualUnmodifiableMapView) return _parStatut;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_parStatut);
}

 final  Map<String, dynamic> _parPriorite;
@override@JsonKey(name: 'par_priorite') Map<String, dynamic> get parPriorite {
  if (_parPriorite is EqualUnmodifiableMapView) return _parPriorite;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_parPriorite);
}

@override@JsonKey(name: 'delai_moyen_prise_en_charge_minutes') final  double? delaiMoyenPriseEnChargeMinutes;
@override@JsonKey(name: 'delai_moyen_resolution_minutes') final  double? delaiMoyenResolutionMinutes;
 final  List<TechnicianWorkloadDto> _chargeParTechnicien;
@override@JsonKey(name: 'charge_par_technicien') List<TechnicianWorkloadDto> get chargeParTechnicien {
  if (_chargeParTechnicien is EqualUnmodifiableListView) return _chargeParTechnicien;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_chargeParTechnicien);
}

@override@JsonKey(name: 'satisfaction_moyenne') final  double satisfactionMoyenne;

/// Create a copy of DashboardKpisDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardKpisDtoCopyWith<_DashboardKpisDto> get copyWith => __$DashboardKpisDtoCopyWithImpl<_DashboardKpisDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardKpisDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardKpisDto&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other._parStatut, _parStatut)&&const DeepCollectionEquality().equals(other._parPriorite, _parPriorite)&&(identical(other.delaiMoyenPriseEnChargeMinutes, delaiMoyenPriseEnChargeMinutes) || other.delaiMoyenPriseEnChargeMinutes == delaiMoyenPriseEnChargeMinutes)&&(identical(other.delaiMoyenResolutionMinutes, delaiMoyenResolutionMinutes) || other.delaiMoyenResolutionMinutes == delaiMoyenResolutionMinutes)&&const DeepCollectionEquality().equals(other._chargeParTechnicien, _chargeParTechnicien)&&(identical(other.satisfactionMoyenne, satisfactionMoyenne) || other.satisfactionMoyenne == satisfactionMoyenne));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,const DeepCollectionEquality().hash(_parStatut),const DeepCollectionEquality().hash(_parPriorite),delaiMoyenPriseEnChargeMinutes,delaiMoyenResolutionMinutes,const DeepCollectionEquality().hash(_chargeParTechnicien),satisfactionMoyenne);

@override
String toString() {
  return 'DashboardKpisDto(total: $total, parStatut: $parStatut, parPriorite: $parPriorite, delaiMoyenPriseEnChargeMinutes: $delaiMoyenPriseEnChargeMinutes, delaiMoyenResolutionMinutes: $delaiMoyenResolutionMinutes, chargeParTechnicien: $chargeParTechnicien, satisfactionMoyenne: $satisfactionMoyenne)';
}


}

/// @nodoc
abstract mixin class _$DashboardKpisDtoCopyWith<$Res> implements $DashboardKpisDtoCopyWith<$Res> {
  factory _$DashboardKpisDtoCopyWith(_DashboardKpisDto value, $Res Function(_DashboardKpisDto) _then) = __$DashboardKpisDtoCopyWithImpl;
@override @useResult
$Res call({
 int total,@JsonKey(name: 'par_statut') Map<String, dynamic> parStatut,@JsonKey(name: 'par_priorite') Map<String, dynamic> parPriorite,@JsonKey(name: 'delai_moyen_prise_en_charge_minutes') double? delaiMoyenPriseEnChargeMinutes,@JsonKey(name: 'delai_moyen_resolution_minutes') double? delaiMoyenResolutionMinutes,@JsonKey(name: 'charge_par_technicien') List<TechnicianWorkloadDto> chargeParTechnicien,@JsonKey(name: 'satisfaction_moyenne') double satisfactionMoyenne
});




}
/// @nodoc
class __$DashboardKpisDtoCopyWithImpl<$Res>
    implements _$DashboardKpisDtoCopyWith<$Res> {
  __$DashboardKpisDtoCopyWithImpl(this._self, this._then);

  final _DashboardKpisDto _self;
  final $Res Function(_DashboardKpisDto) _then;

/// Create a copy of DashboardKpisDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? parStatut = null,Object? parPriorite = null,Object? delaiMoyenPriseEnChargeMinutes = freezed,Object? delaiMoyenResolutionMinutes = freezed,Object? chargeParTechnicien = null,Object? satisfactionMoyenne = null,}) {
  return _then(_DashboardKpisDto(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,parStatut: null == parStatut ? _self._parStatut : parStatut // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,parPriorite: null == parPriorite ? _self._parPriorite : parPriorite // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,delaiMoyenPriseEnChargeMinutes: freezed == delaiMoyenPriseEnChargeMinutes ? _self.delaiMoyenPriseEnChargeMinutes : delaiMoyenPriseEnChargeMinutes // ignore: cast_nullable_to_non_nullable
as double?,delaiMoyenResolutionMinutes: freezed == delaiMoyenResolutionMinutes ? _self.delaiMoyenResolutionMinutes : delaiMoyenResolutionMinutes // ignore: cast_nullable_to_non_nullable
as double?,chargeParTechnicien: null == chargeParTechnicien ? _self._chargeParTechnicien : chargeParTechnicien // ignore: cast_nullable_to_non_nullable
as List<TechnicianWorkloadDto>,satisfactionMoyenne: null == satisfactionMoyenne ? _self.satisfactionMoyenne : satisfactionMoyenne // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$DashboardReportDto {

 DashboardKpisDto get kpis;@JsonKey(name: 'tendance_hebdomadaire') List<WeekTrendPointDto> get tendanceHebdomadaire;
/// Create a copy of DashboardReportDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardReportDtoCopyWith<DashboardReportDto> get copyWith => _$DashboardReportDtoCopyWithImpl<DashboardReportDto>(this as DashboardReportDto, _$identity);

  /// Serializes this DashboardReportDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardReportDto&&(identical(other.kpis, kpis) || other.kpis == kpis)&&const DeepCollectionEquality().equals(other.tendanceHebdomadaire, tendanceHebdomadaire));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kpis,const DeepCollectionEquality().hash(tendanceHebdomadaire));

@override
String toString() {
  return 'DashboardReportDto(kpis: $kpis, tendanceHebdomadaire: $tendanceHebdomadaire)';
}


}

/// @nodoc
abstract mixin class $DashboardReportDtoCopyWith<$Res>  {
  factory $DashboardReportDtoCopyWith(DashboardReportDto value, $Res Function(DashboardReportDto) _then) = _$DashboardReportDtoCopyWithImpl;
@useResult
$Res call({
 DashboardKpisDto kpis,@JsonKey(name: 'tendance_hebdomadaire') List<WeekTrendPointDto> tendanceHebdomadaire
});


$DashboardKpisDtoCopyWith<$Res> get kpis;

}
/// @nodoc
class _$DashboardReportDtoCopyWithImpl<$Res>
    implements $DashboardReportDtoCopyWith<$Res> {
  _$DashboardReportDtoCopyWithImpl(this._self, this._then);

  final DashboardReportDto _self;
  final $Res Function(DashboardReportDto) _then;

/// Create a copy of DashboardReportDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kpis = null,Object? tendanceHebdomadaire = null,}) {
  return _then(DashboardReportDto(
kpis: null == kpis ? _self.kpis : kpis // ignore: cast_nullable_to_non_nullable
as DashboardKpisDto,tendanceHebdomadaire: null == tendanceHebdomadaire ? _self.tendanceHebdomadaire : tendanceHebdomadaire // ignore: cast_nullable_to_non_nullable
as List<WeekTrendPointDto>,
  ));
}
/// Create a copy of DashboardReportDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardKpisDtoCopyWith<$Res> get kpis {
  
  return $DashboardKpisDtoCopyWith<$Res>(_self.kpis, (value) {
    return _then(_self.copyWith(kpis: value));
  });
}
}


/// Adds pattern-matching-related methods to [DashboardReportDto].
extension DashboardReportDtoPatterns on DashboardReportDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardReportDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardReportDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardReportDto value)  $default,){
final _that = this;
switch (_that) {
case _DashboardReportDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardReportDto value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardReportDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DashboardKpisDto kpis, @JsonKey(name: 'tendance_hebdomadaire')  List<WeekTrendPointDto> tendanceHebdomadaire)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardReportDto() when $default != null:
return $default(_that.kpis,_that.tendanceHebdomadaire);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DashboardKpisDto kpis, @JsonKey(name: 'tendance_hebdomadaire')  List<WeekTrendPointDto> tendanceHebdomadaire)  $default,) {final _that = this;
switch (_that) {
case _DashboardReportDto():
return $default(_that.kpis,_that.tendanceHebdomadaire);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DashboardKpisDto kpis, @JsonKey(name: 'tendance_hebdomadaire')  List<WeekTrendPointDto> tendanceHebdomadaire)?  $default,) {final _that = this;
switch (_that) {
case _DashboardReportDto() when $default != null:
return $default(_that.kpis,_that.tendanceHebdomadaire);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardReportDto implements DashboardReportDto {
  const _DashboardReportDto({required this.kpis, @JsonKey(name: 'tendance_hebdomadaire') required  List<WeekTrendPointDto> tendanceHebdomadaire}): _tendanceHebdomadaire = tendanceHebdomadaire;
  factory _DashboardReportDto.fromJson(Map<String, dynamic> json) => _$DashboardReportDtoFromJson(json);

@override final  DashboardKpisDto kpis;
 final  List<WeekTrendPointDto> _tendanceHebdomadaire;
@override@JsonKey(name: 'tendance_hebdomadaire') List<WeekTrendPointDto> get tendanceHebdomadaire {
  if (_tendanceHebdomadaire is EqualUnmodifiableListView) return _tendanceHebdomadaire;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tendanceHebdomadaire);
}


/// Create a copy of DashboardReportDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardReportDtoCopyWith<_DashboardReportDto> get copyWith => __$DashboardReportDtoCopyWithImpl<_DashboardReportDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardReportDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardReportDto&&(identical(other.kpis, kpis) || other.kpis == kpis)&&const DeepCollectionEquality().equals(other._tendanceHebdomadaire, _tendanceHebdomadaire));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kpis,const DeepCollectionEquality().hash(_tendanceHebdomadaire));

@override
String toString() {
  return 'DashboardReportDto(kpis: $kpis, tendanceHebdomadaire: $tendanceHebdomadaire)';
}


}

/// @nodoc
abstract mixin class _$DashboardReportDtoCopyWith<$Res> implements $DashboardReportDtoCopyWith<$Res> {
  factory _$DashboardReportDtoCopyWith(_DashboardReportDto value, $Res Function(_DashboardReportDto) _then) = __$DashboardReportDtoCopyWithImpl;
@override @useResult
$Res call({
 DashboardKpisDto kpis,@JsonKey(name: 'tendance_hebdomadaire') List<WeekTrendPointDto> tendanceHebdomadaire
});


@override $DashboardKpisDtoCopyWith<$Res> get kpis;

}
/// @nodoc
class __$DashboardReportDtoCopyWithImpl<$Res>
    implements _$DashboardReportDtoCopyWith<$Res> {
  __$DashboardReportDtoCopyWithImpl(this._self, this._then);

  final _DashboardReportDto _self;
  final $Res Function(_DashboardReportDto) _then;

/// Create a copy of DashboardReportDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kpis = null,Object? tendanceHebdomadaire = null,}) {
  return _then(_DashboardReportDto(
kpis: null == kpis ? _self.kpis : kpis // ignore: cast_nullable_to_non_nullable
as DashboardKpisDto,tendanceHebdomadaire: null == tendanceHebdomadaire ? _self._tendanceHebdomadaire : tendanceHebdomadaire // ignore: cast_nullable_to_non_nullable
as List<WeekTrendPointDto>,
  ));
}

/// Create a copy of DashboardReportDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardKpisDtoCopyWith<$Res> get kpis {
  
  return $DashboardKpisDtoCopyWith<$Res>(_self.kpis, (value) {
    return _then(_self.copyWith(kpis: value));
  });
}
}

// dart format on
