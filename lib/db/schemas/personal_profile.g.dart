// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_profile.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types, experimental_member_use

extension GetPersonalProfileCollection on Isar {
  IsarCollection<PersonalProfile> get personalProfiles => this.collection();
}

const PersonalProfileSchema = CollectionSchema(
  name: r'PersonalProfile',
  id: -6165840511828152569,
  properties: {
    r'availableTime': PropertySchema(
      id: 0,
      name: r'availableTime',
      type: IsarType.string,
    ),
    r'education': PropertySchema(
      id: 1,
      name: r'education',
      type: IsarType.string,
    ),
    r'email': PropertySchema(id: 2, name: r'email', type: IsarType.string),
    r'grade': PropertySchema(id: 3, name: r'grade', type: IsarType.string),
    r'intendedCity': PropertySchema(
      id: 4,
      name: r'intendedCity',
      type: IsarType.string,
    ),
    r'major': PropertySchema(id: 5, name: r'major', type: IsarType.string),
    r'name': PropertySchema(id: 6, name: r'name', type: IsarType.string),
    r'phone': PropertySchema(id: 7, name: r'phone', type: IsarType.string),
    r'resumePdfPath': PropertySchema(
      id: 8,
      name: r'resumePdfPath',
      type: IsarType.string,
    ),
    r'school': PropertySchema(id: 9, name: r'school', type: IsarType.string),
    r'updatedAt': PropertySchema(
      id: 10,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _personalProfileEstimateSize,
  serialize: _personalProfileSerialize,
  deserialize: _personalProfileDeserialize,
  deserializeProp: _personalProfileDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _personalProfileGetId,
  getLinks: _personalProfileGetLinks,
  attach: _personalProfileAttach,
  version: '3.4.1',
);

int _personalProfileEstimateSize(
  PersonalProfile object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.availableTime.length * 3;
  bytesCount += 3 + object.education.length * 3;
  bytesCount += 3 + object.email.length * 3;
  bytesCount += 3 + object.grade.length * 3;
  bytesCount += 3 + object.intendedCity.length * 3;
  bytesCount += 3 + object.major.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.phone.length * 3;
  {
    final value = object.resumePdfPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.school.length * 3;
  return bytesCount;
}

void _personalProfileSerialize(
  PersonalProfile object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.availableTime);
  writer.writeString(offsets[1], object.education);
  writer.writeString(offsets[2], object.email);
  writer.writeString(offsets[3], object.grade);
  writer.writeString(offsets[4], object.intendedCity);
  writer.writeString(offsets[5], object.major);
  writer.writeString(offsets[6], object.name);
  writer.writeString(offsets[7], object.phone);
  writer.writeString(offsets[8], object.resumePdfPath);
  writer.writeString(offsets[9], object.school);
  writer.writeDateTime(offsets[10], object.updatedAt);
}

PersonalProfile _personalProfileDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PersonalProfile();
  object.availableTime = reader.readString(offsets[0]);
  object.education = reader.readString(offsets[1]);
  object.email = reader.readString(offsets[2]);
  object.grade = reader.readString(offsets[3]);
  object.id = id;
  object.intendedCity = reader.readString(offsets[4]);
  object.major = reader.readString(offsets[5]);
  object.name = reader.readString(offsets[6]);
  object.phone = reader.readString(offsets[7]);
  object.resumePdfPath = reader.readStringOrNull(offsets[8]);
  object.school = reader.readString(offsets[9]);
  object.updatedAt = reader.readDateTime(offsets[10]);
  return object;
}

P _personalProfileDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _personalProfileGetId(PersonalProfile object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _personalProfileGetLinks(PersonalProfile object) {
  return [];
}

void _personalProfileAttach(
  IsarCollection<dynamic> col,
  Id id,
  PersonalProfile object,
) {
  object.id = id;
}

extension PersonalProfileQueryWhereSort
    on QueryBuilder<PersonalProfile, PersonalProfile, QWhere> {
  QueryBuilder<PersonalProfile, PersonalProfile, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PersonalProfileQueryWhere
    on QueryBuilder<PersonalProfile, PersonalProfile, QWhereClause> {
  QueryBuilder<PersonalProfile, PersonalProfile, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterWhereClause>
  idNotEqualTo(Id id) {
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

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterWhereClause> idBetween(
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

extension PersonalProfileQueryFilter
    on QueryBuilder<PersonalProfile, PersonalProfile, QFilterCondition> {
  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  availableTimeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'availableTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  availableTimeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'availableTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  availableTimeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'availableTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  availableTimeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'availableTime',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  availableTimeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'availableTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  availableTimeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'availableTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  availableTimeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'availableTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  availableTimeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'availableTime',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  availableTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'availableTime', value: ''),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  availableTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'availableTime', value: ''),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  educationEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'education',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  educationGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'education',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  educationLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'education',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  educationBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'education',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  educationStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'education',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  educationEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'education',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  educationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'education',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  educationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'education',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  educationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'education', value: ''),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  educationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'education', value: ''),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  emailEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'email',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  emailGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'email',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  emailLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'email',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  emailBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'email',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  emailStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'email',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  emailEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'email',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  emailContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'email',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  emailMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'email',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  emailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'email', value: ''),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  emailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'email', value: ''),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  gradeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'grade',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  gradeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'grade',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  gradeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'grade',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  gradeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'grade',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  gradeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'grade',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  gradeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'grade',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  gradeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'grade',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  gradeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'grade',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  gradeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'grade', value: ''),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  gradeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'grade', value: ''),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
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

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
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

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  idBetween(
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

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  intendedCityEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'intendedCity',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  intendedCityGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'intendedCity',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  intendedCityLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'intendedCity',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  intendedCityBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'intendedCity',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  intendedCityStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'intendedCity',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  intendedCityEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'intendedCity',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  intendedCityContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'intendedCity',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  intendedCityMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'intendedCity',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  intendedCityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'intendedCity', value: ''),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  intendedCityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'intendedCity', value: ''),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  majorEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'major',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  majorGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'major',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  majorLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'major',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  majorBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'major',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  majorStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'major',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  majorEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'major',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  majorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'major',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  majorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'major',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  majorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'major', value: ''),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  majorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'major', value: ''),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  nameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  nameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  nameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  phoneEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'phone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  phoneGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'phone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  phoneLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'phone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  phoneBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'phone',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  phoneStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'phone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  phoneEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'phone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  phoneContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'phone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  phoneMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'phone',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  phoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'phone', value: ''),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  phoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'phone', value: ''),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  resumePdfPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'resumePdfPath'),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  resumePdfPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'resumePdfPath'),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  resumePdfPathEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'resumePdfPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  resumePdfPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'resumePdfPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  resumePdfPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'resumePdfPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  resumePdfPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'resumePdfPath',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  resumePdfPathStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'resumePdfPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  resumePdfPathEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'resumePdfPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  resumePdfPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'resumePdfPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  resumePdfPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'resumePdfPath',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  resumePdfPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'resumePdfPath', value: ''),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  resumePdfPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'resumePdfPath', value: ''),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  schoolEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'school',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  schoolGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'school',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  schoolLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'school',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  schoolBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'school',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  schoolStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'school',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  schoolEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'school',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  schoolContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'school',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  schoolMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'school',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  schoolIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'school', value: ''),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  schoolIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'school', value: ''),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
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

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  updatedAtLessThan(DateTime value, {bool include = false}) {
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

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterFilterCondition>
  updatedAtBetween(
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

extension PersonalProfileQueryObject
    on QueryBuilder<PersonalProfile, PersonalProfile, QFilterCondition> {}

extension PersonalProfileQueryLinks
    on QueryBuilder<PersonalProfile, PersonalProfile, QFilterCondition> {}

extension PersonalProfileQuerySortBy
    on QueryBuilder<PersonalProfile, PersonalProfile, QSortBy> {
  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy>
  sortByAvailableTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'availableTime', Sort.asc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy>
  sortByAvailableTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'availableTime', Sort.desc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy>
  sortByEducation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'education', Sort.asc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy>
  sortByEducationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'education', Sort.desc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy> sortByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy>
  sortByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy> sortByGrade() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grade', Sort.asc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy>
  sortByGradeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grade', Sort.desc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy>
  sortByIntendedCity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intendedCity', Sort.asc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy>
  sortByIntendedCityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intendedCity', Sort.desc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy> sortByMajor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'major', Sort.asc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy>
  sortByMajorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'major', Sort.desc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy>
  sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy> sortByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy>
  sortByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy>
  sortByResumePdfPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resumePdfPath', Sort.asc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy>
  sortByResumePdfPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resumePdfPath', Sort.desc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy> sortBySchool() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'school', Sort.asc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy>
  sortBySchoolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'school', Sort.desc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy>
  sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension PersonalProfileQuerySortThenBy
    on QueryBuilder<PersonalProfile, PersonalProfile, QSortThenBy> {
  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy>
  thenByAvailableTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'availableTime', Sort.asc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy>
  thenByAvailableTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'availableTime', Sort.desc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy>
  thenByEducation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'education', Sort.asc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy>
  thenByEducationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'education', Sort.desc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy> thenByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy>
  thenByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy> thenByGrade() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grade', Sort.asc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy>
  thenByGradeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grade', Sort.desc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy>
  thenByIntendedCity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intendedCity', Sort.asc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy>
  thenByIntendedCityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intendedCity', Sort.desc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy> thenByMajor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'major', Sort.asc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy>
  thenByMajorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'major', Sort.desc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy>
  thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy> thenByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy>
  thenByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy>
  thenByResumePdfPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resumePdfPath', Sort.asc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy>
  thenByResumePdfPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resumePdfPath', Sort.desc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy> thenBySchool() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'school', Sort.asc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy>
  thenBySchoolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'school', Sort.desc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy>
  thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension PersonalProfileQueryWhereDistinct
    on QueryBuilder<PersonalProfile, PersonalProfile, QDistinct> {
  QueryBuilder<PersonalProfile, PersonalProfile, QDistinct>
  distinctByAvailableTime({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'availableTime',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QDistinct>
  distinctByEducation({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'education', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QDistinct> distinctByEmail({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'email', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QDistinct> distinctByGrade({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'grade', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QDistinct>
  distinctByIntendedCity({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'intendedCity', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QDistinct> distinctByMajor({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'major', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QDistinct> distinctByPhone({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phone', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QDistinct>
  distinctByResumePdfPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'resumePdfPath',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QDistinct> distinctBySchool({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'school', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PersonalProfile, PersonalProfile, QDistinct>
  distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension PersonalProfileQueryProperty
    on QueryBuilder<PersonalProfile, PersonalProfile, QQueryProperty> {
  QueryBuilder<PersonalProfile, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PersonalProfile, String, QQueryOperations>
  availableTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'availableTime');
    });
  }

  QueryBuilder<PersonalProfile, String, QQueryOperations> educationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'education');
    });
  }

  QueryBuilder<PersonalProfile, String, QQueryOperations> emailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'email');
    });
  }

  QueryBuilder<PersonalProfile, String, QQueryOperations> gradeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'grade');
    });
  }

  QueryBuilder<PersonalProfile, String, QQueryOperations>
  intendedCityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'intendedCity');
    });
  }

  QueryBuilder<PersonalProfile, String, QQueryOperations> majorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'major');
    });
  }

  QueryBuilder<PersonalProfile, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<PersonalProfile, String, QQueryOperations> phoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phone');
    });
  }

  QueryBuilder<PersonalProfile, String?, QQueryOperations>
  resumePdfPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'resumePdfPath');
    });
  }

  QueryBuilder<PersonalProfile, String, QQueryOperations> schoolProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'school');
    });
  }

  QueryBuilder<PersonalProfile, DateTime, QQueryOperations>
  updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
