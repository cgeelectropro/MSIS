// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_report_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TechnicianWorkload {

 int get idTechnicien; String get nom; int get charge;
/// Create a copy of TechnicianWorkload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TechnicianWorkloadCopyWith<TechnicianWorkload> get copyWith => _$TechnicianWorkloadCopyWithImpl<TechnicianWorkload>(this as TechnicianWorkload, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TechnicianWorkload&&(identical(other.idTechnicien, idTechnicien) || other.idTechnicien == idTechnicien)&&(identical(other.nom, nom) || other.nom == nom)&&(identical(other.charge, charge) || other.charge == charge));
}


@override
int get hashCode => Object.hash(runtimeType,idTechnicien,nom,charge);

@override
String toString() {
  return 'TechnicianWorkload(idTechnicien: $idTechnicien, nom: $nom, charge: $charge)';
}


}

/// @nodoc
abstract mixin class $TechnicianWorkloadCopyWith<$Res>  {
  factory $TechnicianWorkloadCopyWith(TechnicianWorkload value, $Res Function(TechnicianWorkload) _then) = _$TechnicianWorkloadCopyWithImpl;
@useResult
$Res call({
 int idTechnicien, String nom, int charge
});




}
/// @nodoc
class _$TechnicianWorkloadCopyWithImpl<$Res>
    implements $TechnicianWorkloadCopyWith<$Res> {
  _$TechnicianWorkloadCopyWithImpl(this._self, this._then);

  final TechnicianWorkload _self;
  final $Res Function(TechnicianWorkload) _then;

/// Create a copy of TechnicianWorkload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? idTechnicien = null,Object? nom = null,Object? charge = null,}) {
  return _then(TechnicianWorkload(
idTechnicien: null == idTechnicien ? _self.idTechnicien : idTechnicien // ignore: cast_nullable_to_non_nullable
as int,nom: null == nom ? _self.nom : nom // ignore: cast_nullable_to_non_nullable
as String,charge: null == charge ? _self.charge : charge // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TechnicianWorkload].
extension TechnicianWorkloadPatterns on TechnicianWorkload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TechnicianWorkload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TechnicianWorkload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TechnicianWorkload value)  $default,){
final _that = this;
switch (_that) {
case _TechnicianWorkload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TechnicianWorkload value)?  $default,){
final _that = this;
switch (_that) {
case _TechnicianWorkload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int idTechnicien,  String nom,  int charge)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TechnicianWorkload() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int idTechnicien,  String nom,  int charge)  $default,) {final _that = this;
switch (_that) {
case _TechnicianWorkload():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int idTechnicien,  String nom,  int charge)?  $default,) {final _that = this;
switch (_that) {
case _TechnicianWorkload() when $default != null:
return $default(_that.idTechnicien,_that.nom,_that.charge);case _:
  return null;

}
}

}

/// @nodoc


class _TechnicianWorkload implements TechnicianWorkload {
  const _TechnicianWorkload({required this.idTechnicien, required this.nom, required this.charge});
  

@override final  int idTechnicien;
@override final  String nom;
@override final  int charge;

/// Create a copy of TechnicianWorkload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TechnicianWorkloadCopyWith<_TechnicianWorkload> get copyWith => __$TechnicianWorkloadCopyWithImpl<_TechnicianWorkload>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TechnicianWorkload&&(identical(other.idTechnicien, idTechnicien) || other.idTechnicien == idTechnicien)&&(identical(other.nom, nom) || other.nom == nom)&&(identical(other.charge, charge) || other.charge == charge));
}


@override
int get hashCode => Object.hash(runtimeType,idTechnicien,nom,charge);

@override
String toString() {
  return 'TechnicianWorkload(idTechnicien: $idTechnicien, nom: $nom, charge: $charge)';
}


}

/// @nodoc
abstract mixin class _$TechnicianWorkloadCopyWith<$Res> implements $TechnicianWorkloadCopyWith<$Res> {
  factory _$TechnicianWorkloadCopyWith(_TechnicianWorkload value, $Res Function(_TechnicianWorkload) _then) = __$TechnicianWorkloadCopyWithImpl;
@override @useResult
$Res call({
 int idTechnicien, String nom, int charge
});




}
/// @nodoc
class __$TechnicianWorkloadCopyWithImpl<$Res>
    implements _$TechnicianWorkloadCopyWith<$Res> {
  __$TechnicianWorkloadCopyWithImpl(this._self, this._then);

  final _TechnicianWorkload _self;
  final $Res Function(_TechnicianWorkload) _then;

/// Create a copy of TechnicianWorkload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? idTechnicien = null,Object? nom = null,Object? charge = null,}) {
  return _then(_TechnicianWorkload(
idTechnicien: null == idTechnicien ? _self.idTechnicien : idTechnicien // ignore: cast_nullable_to_non_nullable
as int,nom: null == nom ? _self.nom : nom // ignore: cast_nullable_to_non_nullable
as String,charge: null == charge ? _self.charge : charge // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$WeekTrendPoint {

 String get semaine; int get creees; int get cloturees;
/// Create a copy of WeekTrendPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeekTrendPointCopyWith<WeekTrendPoint> get copyWith => _$WeekTrendPointCopyWithImpl<WeekTrendPoint>(this as WeekTrendPoint, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeekTrendPoint&&(identical(other.semaine, semaine) || other.semaine == semaine)&&(identical(other.creees, creees) || other.creees == creees)&&(identical(other.cloturees, cloturees) || other.cloturees == cloturees));
}


@override
int get hashCode => Object.hash(runtimeType,semaine,creees,cloturees);

@override
String toString() {
  return 'WeekTrendPoint(semaine: $semaine, creees: $creees, cloturees: $cloturees)';
}


}

/// @nodoc
abstract mixin class $WeekTrendPointCopyWith<$Res>  {
  factory $WeekTrendPointCopyWith(WeekTrendPoint value, $Res Function(WeekTrendPoint) _then) = _$WeekTrendPointCopyWithImpl;
@useResult
$Res call({
 String semaine, int creees, int cloturees
});




}
/// @nodoc
class _$WeekTrendPointCopyWithImpl<$Res>
    implements $WeekTrendPointCopyWith<$Res> {
  _$WeekTrendPointCopyWithImpl(this._self, this._then);

  final WeekTrendPoint _self;
  final $Res Function(WeekTrendPoint) _then;

/// Create a copy of WeekTrendPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? semaine = null,Object? creees = null,Object? cloturees = null,}) {
  return _then(WeekTrendPoint(
semaine: null == semaine ? _self.semaine : semaine // ignore: cast_nullable_to_non_nullable
as String,creees: null == creees ? _self.creees : creees // ignore: cast_nullable_to_non_nullable
as int,cloturees: null == cloturees ? _self.cloturees : cloturees // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WeekTrendPoint].
extension WeekTrendPointPatterns on WeekTrendPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeekTrendPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeekTrendPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeekTrendPoint value)  $default,){
final _that = this;
switch (_that) {
case _WeekTrendPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeekTrendPoint value)?  $default,){
final _that = this;
switch (_that) {
case _WeekTrendPoint() when $default != null:
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
case _WeekTrendPoint() when $default != null:
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
case _WeekTrendPoint():
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
case _WeekTrendPoint() when $default != null:
return $default(_that.semaine,_that.creees,_that.cloturees);case _:
  return null;

}
}

}

/// @nodoc


class _WeekTrendPoint implements WeekTrendPoint {
  const _WeekTrendPoint({required this.semaine, required this.creees, required this.cloturees});
  

@override final  String semaine;
@override final  int creees;
@override final  int cloturees;

/// Create a copy of WeekTrendPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeekTrendPointCopyWith<_WeekTrendPoint> get copyWith => __$WeekTrendPointCopyWithImpl<_WeekTrendPoint>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeekTrendPoint&&(identical(other.semaine, semaine) || other.semaine == semaine)&&(identical(other.creees, creees) || other.creees == creees)&&(identical(other.cloturees, cloturees) || other.cloturees == cloturees));
}


@override
int get hashCode => Object.hash(runtimeType,semaine,creees,cloturees);

@override
String toString() {
  return 'WeekTrendPoint(semaine: $semaine, creees: $creees, cloturees: $cloturees)';
}


}

/// @nodoc
abstract mixin class _$WeekTrendPointCopyWith<$Res> implements $WeekTrendPointCopyWith<$Res> {
  factory _$WeekTrendPointCopyWith(_WeekTrendPoint value, $Res Function(_WeekTrendPoint) _then) = __$WeekTrendPointCopyWithImpl;
@override @useResult
$Res call({
 String semaine, int creees, int cloturees
});




}
/// @nodoc
class __$WeekTrendPointCopyWithImpl<$Res>
    implements _$WeekTrendPointCopyWith<$Res> {
  __$WeekTrendPointCopyWithImpl(this._self, this._then);

  final _WeekTrendPoint _self;
  final $Res Function(_WeekTrendPoint) _then;

/// Create a copy of WeekTrendPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? semaine = null,Object? creees = null,Object? cloturees = null,}) {
  return _then(_WeekTrendPoint(
semaine: null == semaine ? _self.semaine : semaine // ignore: cast_nullable_to_non_nullable
as String,creees: null == creees ? _self.creees : creees // ignore: cast_nullable_to_non_nullable
as int,cloturees: null == cloturees ? _self.cloturees : cloturees // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$DashboardReportEntity {

 int get total; Map<String, int> get parStatut; Map<String, int> get parPriorite; double? get delaiMoyenPriseEnChargeMinutes; double? get delaiMoyenResolutionMinutes; List<TechnicianWorkload> get chargeParTechnicien; double get satisfactionMoyenne; List<WeekTrendPoint> get tendanceHebdomadaire;
/// Create a copy of DashboardReportEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardReportEntityCopyWith<DashboardReportEntity> get copyWith => _$DashboardReportEntityCopyWithImpl<DashboardReportEntity>(this as DashboardReportEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardReportEntity&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other.parStatut, parStatut)&&const DeepCollectionEquality().equals(other.parPriorite, parPriorite)&&(identical(other.delaiMoyenPriseEnChargeMinutes, delaiMoyenPriseEnChargeMinutes) || other.delaiMoyenPriseEnChargeMinutes == delaiMoyenPriseEnChargeMinutes)&&(identical(other.delaiMoyenResolutionMinutes, delaiMoyenResolutionMinutes) || other.delaiMoyenResolutionMinutes == delaiMoyenResolutionMinutes)&&const DeepCollectionEquality().equals(other.chargeParTechnicien, chargeParTechnicien)&&(identical(other.satisfactionMoyenne, satisfactionMoyenne) || other.satisfactionMoyenne == satisfactionMoyenne)&&const DeepCollectionEquality().equals(other.tendanceHebdomadaire, tendanceHebdomadaire));
}


@override
int get hashCode => Object.hash(runtimeType,total,const DeepCollectionEquality().hash(parStatut),const DeepCollectionEquality().hash(parPriorite),delaiMoyenPriseEnChargeMinutes,delaiMoyenResolutionMinutes,const DeepCollectionEquality().hash(chargeParTechnicien),satisfactionMoyenne,const DeepCollectionEquality().hash(tendanceHebdomadaire));

@override
String toString() {
  return 'DashboardReportEntity(total: $total, parStatut: $parStatut, parPriorite: $parPriorite, delaiMoyenPriseEnChargeMinutes: $delaiMoyenPriseEnChargeMinutes, delaiMoyenResolutionMinutes: $delaiMoyenResolutionMinutes, chargeParTechnicien: $chargeParTechnicien, satisfactionMoyenne: $satisfactionMoyenne, tendanceHebdomadaire: $tendanceHebdomadaire)';
}


}

/// @nodoc
abstract mixin class $DashboardReportEntityCopyWith<$Res>  {
  factory $DashboardReportEntityCopyWith(DashboardReportEntity value, $Res Function(DashboardReportEntity) _then) = _$DashboardReportEntityCopyWithImpl;
@useResult
$Res call({
 int total, Map<String, int> parStatut, Map<String, int> parPriorite, double? delaiMoyenPriseEnChargeMinutes, double? delaiMoyenResolutionMinutes, List<TechnicianWorkload> chargeParTechnicien, double satisfactionMoyenne, List<WeekTrendPoint> tendanceHebdomadaire
});




}
/// @nodoc
class _$DashboardReportEntityCopyWithImpl<$Res>
    implements $DashboardReportEntityCopyWith<$Res> {
  _$DashboardReportEntityCopyWithImpl(this._self, this._then);

  final DashboardReportEntity _self;
  final $Res Function(DashboardReportEntity) _then;

/// Create a copy of DashboardReportEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? parStatut = null,Object? parPriorite = null,Object? delaiMoyenPriseEnChargeMinutes = freezed,Object? delaiMoyenResolutionMinutes = freezed,Object? chargeParTechnicien = null,Object? satisfactionMoyenne = null,Object? tendanceHebdomadaire = null,}) {
  return _then(DashboardReportEntity(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,parStatut: null == parStatut ? _self.parStatut : parStatut // ignore: cast_nullable_to_non_nullable
as Map<String, int>,parPriorite: null == parPriorite ? _self.parPriorite : parPriorite // ignore: cast_nullable_to_non_nullable
as Map<String, int>,delaiMoyenPriseEnChargeMinutes: freezed == delaiMoyenPriseEnChargeMinutes ? _self.delaiMoyenPriseEnChargeMinutes : delaiMoyenPriseEnChargeMinutes // ignore: cast_nullable_to_non_nullable
as double?,delaiMoyenResolutionMinutes: freezed == delaiMoyenResolutionMinutes ? _self.delaiMoyenResolutionMinutes : delaiMoyenResolutionMinutes // ignore: cast_nullable_to_non_nullable
as double?,chargeParTechnicien: null == chargeParTechnicien ? _self.chargeParTechnicien : chargeParTechnicien // ignore: cast_nullable_to_non_nullable
as List<TechnicianWorkload>,satisfactionMoyenne: null == satisfactionMoyenne ? _self.satisfactionMoyenne : satisfactionMoyenne // ignore: cast_nullable_to_non_nullable
as double,tendanceHebdomadaire: null == tendanceHebdomadaire ? _self.tendanceHebdomadaire : tendanceHebdomadaire // ignore: cast_nullable_to_non_nullable
as List<WeekTrendPoint>,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardReportEntity].
extension DashboardReportEntityPatterns on DashboardReportEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardReportEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardReportEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardReportEntity value)  $default,){
final _that = this;
switch (_that) {
case _DashboardReportEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardReportEntity value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardReportEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int total,  Map<String, int> parStatut,  Map<String, int> parPriorite,  double? delaiMoyenPriseEnChargeMinutes,  double? delaiMoyenResolutionMinutes,  List<TechnicianWorkload> chargeParTechnicien,  double satisfactionMoyenne,  List<WeekTrendPoint> tendanceHebdomadaire)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardReportEntity() when $default != null:
return $default(_that.total,_that.parStatut,_that.parPriorite,_that.delaiMoyenPriseEnChargeMinutes,_that.delaiMoyenResolutionMinutes,_that.chargeParTechnicien,_that.satisfactionMoyenne,_that.tendanceHebdomadaire);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int total,  Map<String, int> parStatut,  Map<String, int> parPriorite,  double? delaiMoyenPriseEnChargeMinutes,  double? delaiMoyenResolutionMinutes,  List<TechnicianWorkload> chargeParTechnicien,  double satisfactionMoyenne,  List<WeekTrendPoint> tendanceHebdomadaire)  $default,) {final _that = this;
switch (_that) {
case _DashboardReportEntity():
return $default(_that.total,_that.parStatut,_that.parPriorite,_that.delaiMoyenPriseEnChargeMinutes,_that.delaiMoyenResolutionMinutes,_that.chargeParTechnicien,_that.satisfactionMoyenne,_that.tendanceHebdomadaire);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int total,  Map<String, int> parStatut,  Map<String, int> parPriorite,  double? delaiMoyenPriseEnChargeMinutes,  double? delaiMoyenResolutionMinutes,  List<TechnicianWorkload> chargeParTechnicien,  double satisfactionMoyenne,  List<WeekTrendPoint> tendanceHebdomadaire)?  $default,) {final _that = this;
switch (_that) {
case _DashboardReportEntity() when $default != null:
return $default(_that.total,_that.parStatut,_that.parPriorite,_that.delaiMoyenPriseEnChargeMinutes,_that.delaiMoyenResolutionMinutes,_that.chargeParTechnicien,_that.satisfactionMoyenne,_that.tendanceHebdomadaire);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardReportEntity implements DashboardReportEntity {
  const _DashboardReportEntity({required this.total, required  Map<String, int> parStatut, required  Map<String, int> parPriorite, this.delaiMoyenPriseEnChargeMinutes, this.delaiMoyenResolutionMinutes, required  List<TechnicianWorkload> chargeParTechnicien, required this.satisfactionMoyenne, required  List<WeekTrendPoint> tendanceHebdomadaire}): _parStatut = parStatut,_parPriorite = parPriorite,_chargeParTechnicien = chargeParTechnicien,_tendanceHebdomadaire = tendanceHebdomadaire;
  

@override final  int total;
 final  Map<String, int> _parStatut;
@override Map<String, int> get parStatut {
  if (_parStatut is EqualUnmodifiableMapView) return _parStatut;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_parStatut);
}

 final  Map<String, int> _parPriorite;
@override Map<String, int> get parPriorite {
  if (_parPriorite is EqualUnmodifiableMapView) return _parPriorite;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_parPriorite);
}

@override final  double? delaiMoyenPriseEnChargeMinutes;
@override final  double? delaiMoyenResolutionMinutes;
 final  List<TechnicianWorkload> _chargeParTechnicien;
@override List<TechnicianWorkload> get chargeParTechnicien {
  if (_chargeParTechnicien is EqualUnmodifiableListView) return _chargeParTechnicien;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_chargeParTechnicien);
}

@override final  double satisfactionMoyenne;
 final  List<WeekTrendPoint> _tendanceHebdomadaire;
@override List<WeekTrendPoint> get tendanceHebdomadaire {
  if (_tendanceHebdomadaire is EqualUnmodifiableListView) return _tendanceHebdomadaire;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tendanceHebdomadaire);
}


/// Create a copy of DashboardReportEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardReportEntityCopyWith<_DashboardReportEntity> get copyWith => __$DashboardReportEntityCopyWithImpl<_DashboardReportEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardReportEntity&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other._parStatut, _parStatut)&&const DeepCollectionEquality().equals(other._parPriorite, _parPriorite)&&(identical(other.delaiMoyenPriseEnChargeMinutes, delaiMoyenPriseEnChargeMinutes) || other.delaiMoyenPriseEnChargeMinutes == delaiMoyenPriseEnChargeMinutes)&&(identical(other.delaiMoyenResolutionMinutes, delaiMoyenResolutionMinutes) || other.delaiMoyenResolutionMinutes == delaiMoyenResolutionMinutes)&&const DeepCollectionEquality().equals(other._chargeParTechnicien, _chargeParTechnicien)&&(identical(other.satisfactionMoyenne, satisfactionMoyenne) || other.satisfactionMoyenne == satisfactionMoyenne)&&const DeepCollectionEquality().equals(other._tendanceHebdomadaire, _tendanceHebdomadaire));
}


@override
int get hashCode => Object.hash(runtimeType,total,const DeepCollectionEquality().hash(_parStatut),const DeepCollectionEquality().hash(_parPriorite),delaiMoyenPriseEnChargeMinutes,delaiMoyenResolutionMinutes,const DeepCollectionEquality().hash(_chargeParTechnicien),satisfactionMoyenne,const DeepCollectionEquality().hash(_tendanceHebdomadaire));

@override
String toString() {
  return 'DashboardReportEntity(total: $total, parStatut: $parStatut, parPriorite: $parPriorite, delaiMoyenPriseEnChargeMinutes: $delaiMoyenPriseEnChargeMinutes, delaiMoyenResolutionMinutes: $delaiMoyenResolutionMinutes, chargeParTechnicien: $chargeParTechnicien, satisfactionMoyenne: $satisfactionMoyenne, tendanceHebdomadaire: $tendanceHebdomadaire)';
}


}

/// @nodoc
abstract mixin class _$DashboardReportEntityCopyWith<$Res> implements $DashboardReportEntityCopyWith<$Res> {
  factory _$DashboardReportEntityCopyWith(_DashboardReportEntity value, $Res Function(_DashboardReportEntity) _then) = __$DashboardReportEntityCopyWithImpl;
@override @useResult
$Res call({
 int total, Map<String, int> parStatut, Map<String, int> parPriorite, double? delaiMoyenPriseEnChargeMinutes, double? delaiMoyenResolutionMinutes, List<TechnicianWorkload> chargeParTechnicien, double satisfactionMoyenne, List<WeekTrendPoint> tendanceHebdomadaire
});




}
/// @nodoc
class __$DashboardReportEntityCopyWithImpl<$Res>
    implements _$DashboardReportEntityCopyWith<$Res> {
  __$DashboardReportEntityCopyWithImpl(this._self, this._then);

  final _DashboardReportEntity _self;
  final $Res Function(_DashboardReportEntity) _then;

/// Create a copy of DashboardReportEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? parStatut = null,Object? parPriorite = null,Object? delaiMoyenPriseEnChargeMinutes = freezed,Object? delaiMoyenResolutionMinutes = freezed,Object? chargeParTechnicien = null,Object? satisfactionMoyenne = null,Object? tendanceHebdomadaire = null,}) {
  return _then(_DashboardReportEntity(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,parStatut: null == parStatut ? _self._parStatut : parStatut // ignore: cast_nullable_to_non_nullable
as Map<String, int>,parPriorite: null == parPriorite ? _self._parPriorite : parPriorite // ignore: cast_nullable_to_non_nullable
as Map<String, int>,delaiMoyenPriseEnChargeMinutes: freezed == delaiMoyenPriseEnChargeMinutes ? _self.delaiMoyenPriseEnChargeMinutes : delaiMoyenPriseEnChargeMinutes // ignore: cast_nullable_to_non_nullable
as double?,delaiMoyenResolutionMinutes: freezed == delaiMoyenResolutionMinutes ? _self.delaiMoyenResolutionMinutes : delaiMoyenResolutionMinutes // ignore: cast_nullable_to_non_nullable
as double?,chargeParTechnicien: null == chargeParTechnicien ? _self._chargeParTechnicien : chargeParTechnicien // ignore: cast_nullable_to_non_nullable
as List<TechnicianWorkload>,satisfactionMoyenne: null == satisfactionMoyenne ? _self.satisfactionMoyenne : satisfactionMoyenne // ignore: cast_nullable_to_non_nullable
as double,tendanceHebdomadaire: null == tendanceHebdomadaire ? _self._tendanceHebdomadaire : tendanceHebdomadaire // ignore: cast_nullable_to_non_nullable
as List<WeekTrendPoint>,
  ));
}


}

// dart format on
