// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_setting.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types, experimental_member_use

extension GetAppSettingCollection on Isar {
  IsarCollection<AppSetting> get appSettings => this.collection();
}

const AppSettingSchema = CollectionSchema(
  name: r'AppSetting',
  id: -948817443998796339,
  properties: {
    r'bossCookie': PropertySchema(
      id: 0,
      name: r'bossCookie',
      type: IsarType.string,
    ),
    r'bossCookieUpdatedAt': PropertySchema(
      id: 1,
      name: r'bossCookieUpdatedAt',
      type: IsarType.dateTime,
    ),
    r'pushEnabled': PropertySchema(
      id: 2,
      name: r'pushEnabled',
      type: IsarType.bool,
    ),
    r'updatedAt': PropertySchema(
      id: 3,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _appSettingEstimateSize,
  serialize: _appSettingSerialize,
  deserialize: _appSettingDeserialize,
  deserializeProp: _appSettingDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _appSettingGetId,
  getLinks: _appSettingGetLinks,
  attach: _appSettingAttach,
  version: '3.4.1',
);

int _appSettingEstimateSize(
  AppSetting object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.bossCookie.length * 3;
  return bytesCount;
}

void _appSettingSerialize(
  AppSetting object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.bossCookie);
  writer.writeDateTime(offsets[1], object.bossCookieUpdatedAt);
  writer.writeBool(offsets[2], object.pushEnabled);
  writer.writeDateTime(offsets[3], object.updatedAt);
}

AppSetting _appSettingDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AppSetting();
  object.bossCookie = reader.readString(offsets[0]);
  object.bossCookieUpdatedAt = reader.readDateTimeOrNull(offsets[1]);
  object.id = id;
  object.pushEnabled = reader.readBool(offsets[2]);
  object.updatedAt = reader.readDateTime(offsets[3]);
  return object;
}

P _appSettingDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _appSettingGetId(AppSetting object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _appSettingGetLinks(AppSetting object) {
  return [];
}

void _appSettingAttach(IsarCollection<dynamic> col, Id id, AppSetting object) {
  object.id = id;
}

extension AppSettingQueryWhereSort
    on QueryBuilder<AppSetting, AppSetting, QWhere> {
  QueryBuilder<AppSetting, AppSetting, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AppSettingQueryWhere
    on QueryBuilder<AppSetting, AppSetting, QWhereClause> {
  QueryBuilder<AppSetting, AppSetting, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension AppSettingQueryFilter
    on QueryBuilder<AppSetting, AppSetting, QFilterCondition> {
  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> bossCookieEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'bossCookie',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  bossCookieGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'bossCookie',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  bossCookieLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'bossCookie',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> bossCookieBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'bossCookie',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  bossCookieStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'bossCookie',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  bossCookieEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'bossCookie',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  bossCookieContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'bossCookie',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> bossCookieMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'bossCookie',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  bossCookieIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'bossCookie', value: ''),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  bossCookieIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'bossCookie', value: ''),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  bossCookieUpdatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'bossCookieUpdatedAt'),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  bossCookieUpdatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'bossCookieUpdatedAt'),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  bossCookieUpdatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'bossCookieUpdatedAt', value: value),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  bossCookieUpdatedAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'bossCookieUpdatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  bossCookieUpdatedAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'bossCookieUpdatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  bossCookieUpdatedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'bossCookieUpdatedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  pushEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'pushEnabled', value: value),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> updatedAtEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  updatedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'updatedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension AppSettingQueryObject
    on QueryBuilder<AppSetting, AppSetting, QFilterCondition> {}

extension AppSettingQueryLinks
    on QueryBuilder<AppSetting, AppSetting, QFilterCondition> {}

extension AppSettingQuerySortBy
    on QueryBuilder<AppSetting, AppSetting, QSortBy> {
  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByBossCookie() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bossCookie', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByBossCookieDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bossCookie', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  sortByBossCookieUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bossCookieUpdatedAt', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  sortByBossCookieUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bossCookieUpdatedAt', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByPushEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pushEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByPushEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pushEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension AppSettingQuerySortThenBy
    on QueryBuilder<AppSetting, AppSetting, QSortThenBy> {
  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByBossCookie() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bossCookie', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByBossCookieDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bossCookie', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  thenByBossCookieUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bossCookieUpdatedAt', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  thenByBossCookieUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bossCookieUpdatedAt', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByPushEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pushEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByPushEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pushEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension AppSettingQueryWhereDistinct
    on QueryBuilder<AppSetting, AppSetting, QDistinct> {
  QueryBuilder<AppSetting, AppSetting, QDistinct> distinctByBossCookie({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bossCookie', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QDistinct>
  distinctByBossCookieUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bossCookieUpdatedAt');
    });
  }

  QueryBuilder<AppSetting, AppSetting, QDistinct> distinctByPushEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pushEnabled');
    });
  }

  QueryBuilder<AppSetting, AppSetting, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension AppSettingQueryProperty
    on QueryBuilder<AppSetting, AppSetting, QQueryProperty> {
  QueryBuilder<AppSetting, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AppSetting, String, QQueryOperations> bossCookieProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bossCookie');
    });
  }

  QueryBuilder<AppSetting, DateTime?, QQueryOperations>
  bossCookieUpdatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bossCookieUpdatedAt');
    });
  }

  QueryBuilder<AppSetting, bool, QQueryOperations> pushEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pushEnabled');
    });
  }

  QueryBuilder<AppSetting, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
