// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resume_template.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types, experimental_member_use

extension GetResumeTemplateCollection on Isar {
  IsarCollection<ResumeTemplate> get resumeTemplates => this.collection();
}

const ResumeTemplateSchema = CollectionSchema(
  name: r'ResumeTemplate',
  id: 2787463847874969876,
  properties: {
    r'customFields': PropertySchema(
      id: 0,
      name: r'customFields',
      type: IsarType.objectList,

      target: r'CustomField',
    ),
    r'education': PropertySchema(
      id: 1,
      name: r'education',
      type: IsarType.string,
    ),
    r'email': PropertySchema(id: 2, name: r'email', type: IsarType.string),
    r'internships': PropertySchema(
      id: 3,
      name: r'internships',
      type: IsarType.objectList,

      target: r'ResumeExperience',
    ),
    r'isActive': PropertySchema(id: 4, name: r'isActive', type: IsarType.bool),
    r'major': PropertySchema(id: 5, name: r'major', type: IsarType.string),
    r'pdfLocalPath': PropertySchema(
      id: 6,
      name: r'pdfLocalPath',
      type: IsarType.string,
    ),
    r'personName': PropertySchema(
      id: 7,
      name: r'personName',
      type: IsarType.string,
    ),
    r'phone': PropertySchema(id: 8, name: r'phone', type: IsarType.string),
    r'projects': PropertySchema(
      id: 9,
      name: r'projects',
      type: IsarType.objectList,

      target: r'ResumeExperience',
    ),
    r'school': PropertySchema(id: 10, name: r'school', type: IsarType.string),
    r'skills': PropertySchema(id: 11, name: r'skills', type: IsarType.string),
    r'templateName': PropertySchema(
      id: 12,
      name: r'templateName',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 13,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _resumeTemplateEstimateSize,
  serialize: _resumeTemplateSerialize,
  deserialize: _resumeTemplateDeserialize,
  deserializeProp: _resumeTemplateDeserializeProp,
  idName: r'id',
  indexes: {
    r'isActive': IndexSchema(
      id: 8092228061260947457,
      name: r'isActive',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isActive',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {
    r'ResumeExperience': ResumeExperienceSchema,
    r'CustomField': CustomFieldSchema,
  },

  getId: _resumeTemplateGetId,
  getLinks: _resumeTemplateGetLinks,
  attach: _resumeTemplateAttach,
  version: '3.4.1',
);

int _resumeTemplateEstimateSize(
  ResumeTemplate object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.customFields.length * 3;
  {
    final offsets = allOffsets[CustomField]!;
    for (var i = 0; i < object.customFields.length; i++) {
      final value = object.customFields[i];
      bytesCount += CustomFieldSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.education.length * 3;
  bytesCount += 3 + object.email.length * 3;
  bytesCount += 3 + object.internships.length * 3;
  {
    final offsets = allOffsets[ResumeExperience]!;
    for (var i = 0; i < object.internships.length; i++) {
      final value = object.internships[i];
      bytesCount += ResumeExperienceSchema.estimateSize(
        value,
        offsets,
        allOffsets,
      );
    }
  }
  bytesCount += 3 + object.major.length * 3;
  {
    final value = object.pdfLocalPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.personName.length * 3;
  bytesCount += 3 + object.phone.length * 3;
  bytesCount += 3 + object.projects.length * 3;
  {
    final offsets = allOffsets[ResumeExperience]!;
    for (var i = 0; i < object.projects.length; i++) {
      final value = object.projects[i];
      bytesCount += ResumeExperienceSchema.estimateSize(
        value,
        offsets,
        allOffsets,
      );
    }
  }
  bytesCount += 3 + object.school.length * 3;
  bytesCount += 3 + object.skills.length * 3;
  bytesCount += 3 + object.templateName.length * 3;
  return bytesCount;
}

void _resumeTemplateSerialize(
  ResumeTemplate object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<CustomField>(
    offsets[0],
    allOffsets,
    CustomFieldSchema.serialize,
    object.customFields,
  );
  writer.writeString(offsets[1], object.education);
  writer.writeString(offsets[2], object.email);
  writer.writeObjectList<ResumeExperience>(
    offsets[3],
    allOffsets,
    ResumeExperienceSchema.serialize,
    object.internships,
  );
  writer.writeBool(offsets[4], object.isActive);
  writer.writeString(offsets[5], object.major);
  writer.writeString(offsets[6], object.pdfLocalPath);
  writer.writeString(offsets[7], object.personName);
  writer.writeString(offsets[8], object.phone);
  writer.writeObjectList<ResumeExperience>(
    offsets[9],
    allOffsets,
    ResumeExperienceSchema.serialize,
    object.projects,
  );
  writer.writeString(offsets[10], object.school);
  writer.writeString(offsets[11], object.skills);
  writer.writeString(offsets[12], object.templateName);
  writer.writeDateTime(offsets[13], object.updatedAt);
}

ResumeTemplate _resumeTemplateDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ResumeTemplate();
  object.customFields =
      reader.readObjectList<CustomField>(
        offsets[0],
        CustomFieldSchema.deserialize,
        allOffsets,
        CustomField(),
      ) ??
      [];
  object.education = reader.readString(offsets[1]);
  object.email = reader.readString(offsets[2]);
  object.id = id;
  object.internships =
      reader.readObjectList<ResumeExperience>(
        offsets[3],
        ResumeExperienceSchema.deserialize,
        allOffsets,
        ResumeExperience(),
      ) ??
      [];
  object.isActive = reader.readBool(offsets[4]);
  object.major = reader.readString(offsets[5]);
  object.pdfLocalPath = reader.readStringOrNull(offsets[6]);
  object.personName = reader.readString(offsets[7]);
  object.phone = reader.readString(offsets[8]);
  object.projects =
      reader.readObjectList<ResumeExperience>(
        offsets[9],
        ResumeExperienceSchema.deserialize,
        allOffsets,
        ResumeExperience(),
      ) ??
      [];
  object.school = reader.readString(offsets[10]);
  object.skills = reader.readString(offsets[11]);
  object.templateName = reader.readString(offsets[12]);
  object.updatedAt = reader.readDateTime(offsets[13]);
  return object;
}

P _resumeTemplateDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectList<CustomField>(
                offset,
                CustomFieldSchema.deserialize,
                allOffsets,
                CustomField(),
              ) ??
              [])
          as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readObjectList<ResumeExperience>(
                offset,
                ResumeExperienceSchema.deserialize,
                allOffsets,
                ResumeExperience(),
              ) ??
              [])
          as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readObjectList<ResumeExperience>(
                offset,
                ResumeExperienceSchema.deserialize,
                allOffsets,
                ResumeExperience(),
              ) ??
              [])
          as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _resumeTemplateGetId(ResumeTemplate object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _resumeTemplateGetLinks(ResumeTemplate object) {
  return [];
}

void _resumeTemplateAttach(
  IsarCollection<dynamic> col,
  Id id,
  ResumeTemplate object,
) {
  object.id = id;
}

extension ResumeTemplateQueryWhereSort
    on QueryBuilder<ResumeTemplate, ResumeTemplate, QWhere> {
  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterWhere> anyIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isActive'),
      );
    });
  }
}

extension ResumeTemplateQueryWhere
    on QueryBuilder<ResumeTemplate, ResumeTemplate, QWhereClause> {
  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterWhereClause> idBetween(
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterWhereClause>
  isActiveEqualTo(bool isActive) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'isActive', value: [isActive]),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterWhereClause>
  isActiveNotEqualTo(bool isActive) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isActive',
                lower: [],
                upper: [isActive],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isActive',
                lower: [isActive],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isActive',
                lower: [isActive],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isActive',
                lower: [],
                upper: [isActive],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension ResumeTemplateQueryFilter
    on QueryBuilder<ResumeTemplate, ResumeTemplate, QFilterCondition> {
  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  customFieldsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'customFields', length, true, length, true);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  customFieldsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'customFields', 0, true, 0, true);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  customFieldsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'customFields', 0, false, 999999, true);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  customFieldsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'customFields', 0, true, length, include);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  customFieldsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'customFields', length, include, 999999, true);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  customFieldsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'customFields',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  educationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'education', value: ''),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  educationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'education', value: ''),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  emailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'email', value: ''),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  emailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'email', value: ''),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  internshipsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'internships', length, true, length, true);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  internshipsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'internships', 0, true, 0, true);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  internshipsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'internships', 0, false, 999999, true);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  internshipsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'internships', 0, true, length, include);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  internshipsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'internships', length, include, 999999, true);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  internshipsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'internships',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  isActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isActive', value: value),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  majorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'major', value: ''),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  majorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'major', value: ''),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  pdfLocalPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'pdfLocalPath'),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  pdfLocalPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'pdfLocalPath'),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  pdfLocalPathEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'pdfLocalPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  pdfLocalPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'pdfLocalPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  pdfLocalPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'pdfLocalPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  pdfLocalPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'pdfLocalPath',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  pdfLocalPathStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'pdfLocalPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  pdfLocalPathEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'pdfLocalPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  pdfLocalPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'pdfLocalPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  pdfLocalPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'pdfLocalPath',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  pdfLocalPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'pdfLocalPath', value: ''),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  pdfLocalPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'pdfLocalPath', value: ''),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  personNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'personName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  personNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'personName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  personNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'personName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  personNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'personName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  personNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'personName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  personNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'personName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  personNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'personName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  personNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'personName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  personNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'personName', value: ''),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  personNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'personName', value: ''),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  phoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'phone', value: ''),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  phoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'phone', value: ''),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  projectsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'projects', length, true, length, true);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  projectsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'projects', 0, true, 0, true);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  projectsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'projects', 0, false, 999999, true);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  projectsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'projects', 0, true, length, include);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  projectsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'projects', length, include, 999999, true);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  projectsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'projects',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  schoolIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'school', value: ''),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  schoolIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'school', value: ''),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  skillsEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'skills',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  skillsGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'skills',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  skillsLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'skills',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  skillsBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'skills',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  skillsStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'skills',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  skillsEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'skills',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  skillsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'skills',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  skillsMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'skills',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  skillsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'skills', value: ''),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  skillsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'skills', value: ''),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  templateNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'templateName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  templateNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'templateName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  templateNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'templateName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  templateNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'templateName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  templateNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'templateName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  templateNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'templateName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  templateNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'templateName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  templateNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'templateName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  templateNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'templateName', value: ''),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  templateNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'templateName', value: ''),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
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

extension ResumeTemplateQueryObject
    on QueryBuilder<ResumeTemplate, ResumeTemplate, QFilterCondition> {
  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  customFieldsElement(FilterQuery<CustomField> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'customFields');
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  internshipsElement(FilterQuery<ResumeExperience> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'internships');
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterFilterCondition>
  projectsElement(FilterQuery<ResumeExperience> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'projects');
    });
  }
}

extension ResumeTemplateQueryLinks
    on QueryBuilder<ResumeTemplate, ResumeTemplate, QFilterCondition> {}

extension ResumeTemplateQuerySortBy
    on QueryBuilder<ResumeTemplate, ResumeTemplate, QSortBy> {
  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy> sortByEducation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'education', Sort.asc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy>
  sortByEducationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'education', Sort.desc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy> sortByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy> sortByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy> sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy>
  sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy> sortByMajor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'major', Sort.asc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy> sortByMajorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'major', Sort.desc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy>
  sortByPdfLocalPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pdfLocalPath', Sort.asc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy>
  sortByPdfLocalPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pdfLocalPath', Sort.desc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy>
  sortByPersonName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'personName', Sort.asc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy>
  sortByPersonNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'personName', Sort.desc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy> sortByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy> sortByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy> sortBySchool() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'school', Sort.asc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy>
  sortBySchoolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'school', Sort.desc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy> sortBySkills() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skills', Sort.asc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy>
  sortBySkillsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skills', Sort.desc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy>
  sortByTemplateName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'templateName', Sort.asc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy>
  sortByTemplateNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'templateName', Sort.desc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension ResumeTemplateQuerySortThenBy
    on QueryBuilder<ResumeTemplate, ResumeTemplate, QSortThenBy> {
  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy> thenByEducation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'education', Sort.asc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy>
  thenByEducationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'education', Sort.desc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy> thenByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy> thenByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy> thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy>
  thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy> thenByMajor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'major', Sort.asc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy> thenByMajorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'major', Sort.desc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy>
  thenByPdfLocalPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pdfLocalPath', Sort.asc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy>
  thenByPdfLocalPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pdfLocalPath', Sort.desc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy>
  thenByPersonName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'personName', Sort.asc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy>
  thenByPersonNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'personName', Sort.desc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy> thenByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy> thenByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy> thenBySchool() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'school', Sort.asc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy>
  thenBySchoolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'school', Sort.desc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy> thenBySkills() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skills', Sort.asc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy>
  thenBySkillsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skills', Sort.desc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy>
  thenByTemplateName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'templateName', Sort.asc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy>
  thenByTemplateNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'templateName', Sort.desc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension ResumeTemplateQueryWhereDistinct
    on QueryBuilder<ResumeTemplate, ResumeTemplate, QDistinct> {
  QueryBuilder<ResumeTemplate, ResumeTemplate, QDistinct> distinctByEducation({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'education', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QDistinct> distinctByEmail({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'email', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QDistinct> distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QDistinct> distinctByMajor({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'major', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QDistinct>
  distinctByPdfLocalPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pdfLocalPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QDistinct> distinctByPersonName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'personName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QDistinct> distinctByPhone({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phone', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QDistinct> distinctBySchool({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'school', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QDistinct> distinctBySkills({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'skills', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QDistinct>
  distinctByTemplateName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'templateName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ResumeTemplate, ResumeTemplate, QDistinct>
  distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension ResumeTemplateQueryProperty
    on QueryBuilder<ResumeTemplate, ResumeTemplate, QQueryProperty> {
  QueryBuilder<ResumeTemplate, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ResumeTemplate, List<CustomField>, QQueryOperations>
  customFieldsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customFields');
    });
  }

  QueryBuilder<ResumeTemplate, String, QQueryOperations> educationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'education');
    });
  }

  QueryBuilder<ResumeTemplate, String, QQueryOperations> emailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'email');
    });
  }

  QueryBuilder<ResumeTemplate, List<ResumeExperience>, QQueryOperations>
  internshipsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'internships');
    });
  }

  QueryBuilder<ResumeTemplate, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<ResumeTemplate, String, QQueryOperations> majorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'major');
    });
  }

  QueryBuilder<ResumeTemplate, String?, QQueryOperations>
  pdfLocalPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pdfLocalPath');
    });
  }

  QueryBuilder<ResumeTemplate, String, QQueryOperations> personNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'personName');
    });
  }

  QueryBuilder<ResumeTemplate, String, QQueryOperations> phoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phone');
    });
  }

  QueryBuilder<ResumeTemplate, List<ResumeExperience>, QQueryOperations>
  projectsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'projects');
    });
  }

  QueryBuilder<ResumeTemplate, String, QQueryOperations> schoolProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'school');
    });
  }

  QueryBuilder<ResumeTemplate, String, QQueryOperations> skillsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'skills');
    });
  }

  QueryBuilder<ResumeTemplate, String, QQueryOperations>
  templateNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'templateName');
    });
  }

  QueryBuilder<ResumeTemplate, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types, experimental_member_use

const ResumeExperienceSchema = Schema(
  name: r'ResumeExperience',
  id: -1861716742678372406,
  properties: {
    r'content': PropertySchema(id: 0, name: r'content', type: IsarType.string),
    r'org': PropertySchema(id: 1, name: r'org', type: IsarType.string),
    r'timeRange': PropertySchema(
      id: 2,
      name: r'timeRange',
      type: IsarType.string,
    ),
    r'title': PropertySchema(id: 3, name: r'title', type: IsarType.string),
  },

  estimateSize: _resumeExperienceEstimateSize,
  serialize: _resumeExperienceSerialize,
  deserialize: _resumeExperienceDeserialize,
  deserializeProp: _resumeExperienceDeserializeProp,
);

int _resumeExperienceEstimateSize(
  ResumeExperience object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.content.length * 3;
  bytesCount += 3 + object.org.length * 3;
  bytesCount += 3 + object.timeRange.length * 3;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _resumeExperienceSerialize(
  ResumeExperience object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.content);
  writer.writeString(offsets[1], object.org);
  writer.writeString(offsets[2], object.timeRange);
  writer.writeString(offsets[3], object.title);
}

ResumeExperience _resumeExperienceDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ResumeExperience();
  object.content = reader.readString(offsets[0]);
  object.org = reader.readString(offsets[1]);
  object.timeRange = reader.readString(offsets[2]);
  object.title = reader.readString(offsets[3]);
  return object;
}

P _resumeExperienceDeserializeProp<P>(
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
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension ResumeExperienceQueryFilter
    on QueryBuilder<ResumeExperience, ResumeExperience, QFilterCondition> {
  QueryBuilder<ResumeExperience, ResumeExperience, QAfterFilterCondition>
  contentEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'content',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeExperience, ResumeExperience, QAfterFilterCondition>
  contentGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'content',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeExperience, ResumeExperience, QAfterFilterCondition>
  contentLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'content',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeExperience, ResumeExperience, QAfterFilterCondition>
  contentBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'content',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeExperience, ResumeExperience, QAfterFilterCondition>
  contentStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'content',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeExperience, ResumeExperience, QAfterFilterCondition>
  contentEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'content',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeExperience, ResumeExperience, QAfterFilterCondition>
  contentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'content',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeExperience, ResumeExperience, QAfterFilterCondition>
  contentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'content',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeExperience, ResumeExperience, QAfterFilterCondition>
  contentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'content', value: ''),
      );
    });
  }

  QueryBuilder<ResumeExperience, ResumeExperience, QAfterFilterCondition>
  contentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'content', value: ''),
      );
    });
  }

  QueryBuilder<ResumeExperience, ResumeExperience, QAfterFilterCondition>
  orgEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'org',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeExperience, ResumeExperience, QAfterFilterCondition>
  orgGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'org',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeExperience, ResumeExperience, QAfterFilterCondition>
  orgLessThan(String value, {bool include = false, bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'org',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeExperience, ResumeExperience, QAfterFilterCondition>
  orgBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'org',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeExperience, ResumeExperience, QAfterFilterCondition>
  orgStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'org',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeExperience, ResumeExperience, QAfterFilterCondition>
  orgEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'org',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeExperience, ResumeExperience, QAfterFilterCondition>
  orgContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'org',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeExperience, ResumeExperience, QAfterFilterCondition>
  orgMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'org',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeExperience, ResumeExperience, QAfterFilterCondition>
  orgIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'org', value: ''),
      );
    });
  }

  QueryBuilder<ResumeExperience, ResumeExperience, QAfterFilterCondition>
  orgIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'org', value: ''),
      );
    });
  }

  QueryBuilder<ResumeExperience, ResumeExperience, QAfterFilterCondition>
  timeRangeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'timeRange',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeExperience, ResumeExperience, QAfterFilterCondition>
  timeRangeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'timeRange',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeExperience, ResumeExperience, QAfterFilterCondition>
  timeRangeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'timeRange',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeExperience, ResumeExperience, QAfterFilterCondition>
  timeRangeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'timeRange',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeExperience, ResumeExperience, QAfterFilterCondition>
  timeRangeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'timeRange',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeExperience, ResumeExperience, QAfterFilterCondition>
  timeRangeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'timeRange',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeExperience, ResumeExperience, QAfterFilterCondition>
  timeRangeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'timeRange',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeExperience, ResumeExperience, QAfterFilterCondition>
  timeRangeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'timeRange',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeExperience, ResumeExperience, QAfterFilterCondition>
  timeRangeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'timeRange', value: ''),
      );
    });
  }

  QueryBuilder<ResumeExperience, ResumeExperience, QAfterFilterCondition>
  timeRangeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'timeRange', value: ''),
      );
    });
  }

  QueryBuilder<ResumeExperience, ResumeExperience, QAfterFilterCondition>
  titleEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeExperience, ResumeExperience, QAfterFilterCondition>
  titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeExperience, ResumeExperience, QAfterFilterCondition>
  titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeExperience, ResumeExperience, QAfterFilterCondition>
  titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'title',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeExperience, ResumeExperience, QAfterFilterCondition>
  titleStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeExperience, ResumeExperience, QAfterFilterCondition>
  titleEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeExperience, ResumeExperience, QAfterFilterCondition>
  titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeExperience, ResumeExperience, QAfterFilterCondition>
  titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'title',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ResumeExperience, ResumeExperience, QAfterFilterCondition>
  titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<ResumeExperience, ResumeExperience, QAfterFilterCondition>
  titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'title', value: ''),
      );
    });
  }
}

extension ResumeExperienceQueryObject
    on QueryBuilder<ResumeExperience, ResumeExperience, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types, experimental_member_use

const CustomFieldSchema = Schema(
  name: r'CustomField',
  id: 5620322749960993402,
  properties: {
    r'key': PropertySchema(id: 0, name: r'key', type: IsarType.string),
    r'value': PropertySchema(id: 1, name: r'value', type: IsarType.string),
  },

  estimateSize: _customFieldEstimateSize,
  serialize: _customFieldSerialize,
  deserialize: _customFieldDeserialize,
  deserializeProp: _customFieldDeserializeProp,
);

int _customFieldEstimateSize(
  CustomField object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.key.length * 3;
  bytesCount += 3 + object.value.length * 3;
  return bytesCount;
}

void _customFieldSerialize(
  CustomField object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.key);
  writer.writeString(offsets[1], object.value);
}

CustomField _customFieldDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CustomField();
  object.key = reader.readString(offsets[0]);
  object.value = reader.readString(offsets[1]);
  return object;
}

P _customFieldDeserializeProp<P>(
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
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension CustomFieldQueryFilter
    on QueryBuilder<CustomField, CustomField, QFilterCondition> {
  QueryBuilder<CustomField, CustomField, QAfterFilterCondition> keyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomField, CustomField, QAfterFilterCondition> keyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomField, CustomField, QAfterFilterCondition> keyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomField, CustomField, QAfterFilterCondition> keyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'key',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomField, CustomField, QAfterFilterCondition> keyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomField, CustomField, QAfterFilterCondition> keyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomField, CustomField, QAfterFilterCondition> keyContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomField, CustomField, QAfterFilterCondition> keyMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'key',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomField, CustomField, QAfterFilterCondition> keyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'key', value: ''),
      );
    });
  }

  QueryBuilder<CustomField, CustomField, QAfterFilterCondition>
  keyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'key', value: ''),
      );
    });
  }

  QueryBuilder<CustomField, CustomField, QAfterFilterCondition> valueEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'value',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomField, CustomField, QAfterFilterCondition>
  valueGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'value',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomField, CustomField, QAfterFilterCondition> valueLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'value',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomField, CustomField, QAfterFilterCondition> valueBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'value',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomField, CustomField, QAfterFilterCondition> valueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'value',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomField, CustomField, QAfterFilterCondition> valueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'value',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomField, CustomField, QAfterFilterCondition> valueContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'value',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomField, CustomField, QAfterFilterCondition> valueMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'value',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomField, CustomField, QAfterFilterCondition> valueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'value', value: ''),
      );
    });
  }

  QueryBuilder<CustomField, CustomField, QAfterFilterCondition>
  valueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'value', value: ''),
      );
    });
  }
}

extension CustomFieldQueryObject
    on QueryBuilder<CustomField, CustomField, QFilterCondition> {}
