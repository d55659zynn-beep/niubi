// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_mapping.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types, experimental_member_use

extension GetFormMappingCollection on Isar {
  IsarCollection<FormMapping> get formMappings => this.collection();
}

const FormMappingSchema = CollectionSchema(
  name: r'FormMapping',
  id: -2882654379653201371,
  properties: {
    r'host': PropertySchema(id: 0, name: r'host', type: IsarType.string),
    r'rules': PropertySchema(
      id: 1,
      name: r'rules',
      type: IsarType.objectList,

      target: r'FieldMapRule',
    ),
    r'updatedAt': PropertySchema(
      id: 2,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _formMappingEstimateSize,
  serialize: _formMappingSerialize,
  deserialize: _formMappingDeserialize,
  deserializeProp: _formMappingDeserializeProp,
  idName: r'id',
  indexes: {
    r'host': IndexSchema(
      id: -7602099240340412494,
      name: r'host',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'host',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {r'FieldMapRule': FieldMapRuleSchema},

  getId: _formMappingGetId,
  getLinks: _formMappingGetLinks,
  attach: _formMappingAttach,
  version: '3.4.1',
);

int _formMappingEstimateSize(
  FormMapping object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.host.length * 3;
  bytesCount += 3 + object.rules.length * 3;
  {
    final offsets = allOffsets[FieldMapRule]!;
    for (var i = 0; i < object.rules.length; i++) {
      final value = object.rules[i];
      bytesCount += FieldMapRuleSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _formMappingSerialize(
  FormMapping object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.host);
  writer.writeObjectList<FieldMapRule>(
    offsets[1],
    allOffsets,
    FieldMapRuleSchema.serialize,
    object.rules,
  );
  writer.writeDateTime(offsets[2], object.updatedAt);
}

FormMapping _formMappingDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FormMapping();
  object.host = reader.readString(offsets[0]);
  object.id = id;
  object.rules =
      reader.readObjectList<FieldMapRule>(
        offsets[1],
        FieldMapRuleSchema.deserialize,
        allOffsets,
        FieldMapRule(),
      ) ??
      [];
  object.updatedAt = reader.readDateTime(offsets[2]);
  return object;
}

P _formMappingDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readObjectList<FieldMapRule>(
                offset,
                FieldMapRuleSchema.deserialize,
                allOffsets,
                FieldMapRule(),
              ) ??
              [])
          as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _formMappingGetId(FormMapping object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _formMappingGetLinks(FormMapping object) {
  return [];
}

void _formMappingAttach(
  IsarCollection<dynamic> col,
  Id id,
  FormMapping object,
) {
  object.id = id;
}

extension FormMappingByIndex on IsarCollection<FormMapping> {
  Future<FormMapping?> getByHost(String host) {
    return getByIndex(r'host', [host]);
  }

  FormMapping? getByHostSync(String host) {
    return getByIndexSync(r'host', [host]);
  }

  Future<bool> deleteByHost(String host) {
    return deleteByIndex(r'host', [host]);
  }

  bool deleteByHostSync(String host) {
    return deleteByIndexSync(r'host', [host]);
  }

  Future<List<FormMapping?>> getAllByHost(List<String> hostValues) {
    final values = hostValues.map((e) => [e]).toList();
    return getAllByIndex(r'host', values);
  }

  List<FormMapping?> getAllByHostSync(List<String> hostValues) {
    final values = hostValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'host', values);
  }

  Future<int> deleteAllByHost(List<String> hostValues) {
    final values = hostValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'host', values);
  }

  int deleteAllByHostSync(List<String> hostValues) {
    final values = hostValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'host', values);
  }

  Future<Id> putByHost(FormMapping object) {
    return putByIndex(r'host', object);
  }

  Id putByHostSync(FormMapping object, {bool saveLinks = true}) {
    return putByIndexSync(r'host', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByHost(List<FormMapping> objects) {
    return putAllByIndex(r'host', objects);
  }

  List<Id> putAllByHostSync(
    List<FormMapping> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'host', objects, saveLinks: saveLinks);
  }
}

extension FormMappingQueryWhereSort
    on QueryBuilder<FormMapping, FormMapping, QWhere> {
  QueryBuilder<FormMapping, FormMapping, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FormMappingQueryWhere
    on QueryBuilder<FormMapping, FormMapping, QWhereClause> {
  QueryBuilder<FormMapping, FormMapping, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<FormMapping, FormMapping, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<FormMapping, FormMapping, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FormMapping, FormMapping, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FormMapping, FormMapping, QAfterWhereClause> idBetween(
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

  QueryBuilder<FormMapping, FormMapping, QAfterWhereClause> hostEqualTo(
    String host,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'host', value: [host]),
      );
    });
  }

  QueryBuilder<FormMapping, FormMapping, QAfterWhereClause> hostNotEqualTo(
    String host,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'host',
                lower: [],
                upper: [host],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'host',
                lower: [host],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'host',
                lower: [host],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'host',
                lower: [],
                upper: [host],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension FormMappingQueryFilter
    on QueryBuilder<FormMapping, FormMapping, QFilterCondition> {
  QueryBuilder<FormMapping, FormMapping, QAfterFilterCondition> hostEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'host',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FormMapping, FormMapping, QAfterFilterCondition> hostGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'host',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FormMapping, FormMapping, QAfterFilterCondition> hostLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'host',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FormMapping, FormMapping, QAfterFilterCondition> hostBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'host',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FormMapping, FormMapping, QAfterFilterCondition> hostStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'host',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FormMapping, FormMapping, QAfterFilterCondition> hostEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'host',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FormMapping, FormMapping, QAfterFilterCondition> hostContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'host',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FormMapping, FormMapping, QAfterFilterCondition> hostMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'host',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FormMapping, FormMapping, QAfterFilterCondition> hostIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'host', value: ''),
      );
    });
  }

  QueryBuilder<FormMapping, FormMapping, QAfterFilterCondition>
  hostIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'host', value: ''),
      );
    });
  }

  QueryBuilder<FormMapping, FormMapping, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<FormMapping, FormMapping, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<FormMapping, FormMapping, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<FormMapping, FormMapping, QAfterFilterCondition> idBetween(
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

  QueryBuilder<FormMapping, FormMapping, QAfterFilterCondition>
  rulesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'rules', length, true, length, true);
    });
  }

  QueryBuilder<FormMapping, FormMapping, QAfterFilterCondition> rulesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'rules', 0, true, 0, true);
    });
  }

  QueryBuilder<FormMapping, FormMapping, QAfterFilterCondition>
  rulesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'rules', 0, false, 999999, true);
    });
  }

  QueryBuilder<FormMapping, FormMapping, QAfterFilterCondition>
  rulesLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'rules', 0, true, length, include);
    });
  }

  QueryBuilder<FormMapping, FormMapping, QAfterFilterCondition>
  rulesLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'rules', length, include, 999999, true);
    });
  }

  QueryBuilder<FormMapping, FormMapping, QAfterFilterCondition>
  rulesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'rules',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<FormMapping, FormMapping, QAfterFilterCondition>
  updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<FormMapping, FormMapping, QAfterFilterCondition>
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

  QueryBuilder<FormMapping, FormMapping, QAfterFilterCondition>
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

  QueryBuilder<FormMapping, FormMapping, QAfterFilterCondition>
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

extension FormMappingQueryObject
    on QueryBuilder<FormMapping, FormMapping, QFilterCondition> {
  QueryBuilder<FormMapping, FormMapping, QAfterFilterCondition> rulesElement(
    FilterQuery<FieldMapRule> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'rules');
    });
  }
}

extension FormMappingQueryLinks
    on QueryBuilder<FormMapping, FormMapping, QFilterCondition> {}

extension FormMappingQuerySortBy
    on QueryBuilder<FormMapping, FormMapping, QSortBy> {
  QueryBuilder<FormMapping, FormMapping, QAfterSortBy> sortByHost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'host', Sort.asc);
    });
  }

  QueryBuilder<FormMapping, FormMapping, QAfterSortBy> sortByHostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'host', Sort.desc);
    });
  }

  QueryBuilder<FormMapping, FormMapping, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<FormMapping, FormMapping, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension FormMappingQuerySortThenBy
    on QueryBuilder<FormMapping, FormMapping, QSortThenBy> {
  QueryBuilder<FormMapping, FormMapping, QAfterSortBy> thenByHost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'host', Sort.asc);
    });
  }

  QueryBuilder<FormMapping, FormMapping, QAfterSortBy> thenByHostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'host', Sort.desc);
    });
  }

  QueryBuilder<FormMapping, FormMapping, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FormMapping, FormMapping, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FormMapping, FormMapping, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<FormMapping, FormMapping, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension FormMappingQueryWhereDistinct
    on QueryBuilder<FormMapping, FormMapping, QDistinct> {
  QueryBuilder<FormMapping, FormMapping, QDistinct> distinctByHost({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'host', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FormMapping, FormMapping, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension FormMappingQueryProperty
    on QueryBuilder<FormMapping, FormMapping, QQueryProperty> {
  QueryBuilder<FormMapping, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FormMapping, String, QQueryOperations> hostProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'host');
    });
  }

  QueryBuilder<FormMapping, List<FieldMapRule>, QQueryOperations>
  rulesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rules');
    });
  }

  QueryBuilder<FormMapping, DateTime, QQueryOperations> updatedAtProperty() {
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

const FieldMapRuleSchema = Schema(
  name: r'FieldMapRule',
  id: 393534654304202862,
  properties: {
    r'cssSelector': PropertySchema(
      id: 0,
      name: r'cssSelector',
      type: IsarType.string,
    ),
    r'inputType': PropertySchema(
      id: 1,
      name: r'inputType',
      type: IsarType.string,
    ),
    r'resumeFieldKey': PropertySchema(
      id: 2,
      name: r'resumeFieldKey',
      type: IsarType.string,
    ),
  },

  estimateSize: _fieldMapRuleEstimateSize,
  serialize: _fieldMapRuleSerialize,
  deserialize: _fieldMapRuleDeserialize,
  deserializeProp: _fieldMapRuleDeserializeProp,
);

int _fieldMapRuleEstimateSize(
  FieldMapRule object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.cssSelector.length * 3;
  bytesCount += 3 + object.inputType.length * 3;
  bytesCount += 3 + object.resumeFieldKey.length * 3;
  return bytesCount;
}

void _fieldMapRuleSerialize(
  FieldMapRule object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.cssSelector);
  writer.writeString(offsets[1], object.inputType);
  writer.writeString(offsets[2], object.resumeFieldKey);
}

FieldMapRule _fieldMapRuleDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FieldMapRule();
  object.cssSelector = reader.readString(offsets[0]);
  object.inputType = reader.readString(offsets[1]);
  object.resumeFieldKey = reader.readString(offsets[2]);
  return object;
}

P _fieldMapRuleDeserializeProp<P>(
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
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension FieldMapRuleQueryFilter
    on QueryBuilder<FieldMapRule, FieldMapRule, QFilterCondition> {
  QueryBuilder<FieldMapRule, FieldMapRule, QAfterFilterCondition>
  cssSelectorEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'cssSelector',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FieldMapRule, FieldMapRule, QAfterFilterCondition>
  cssSelectorGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'cssSelector',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FieldMapRule, FieldMapRule, QAfterFilterCondition>
  cssSelectorLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'cssSelector',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FieldMapRule, FieldMapRule, QAfterFilterCondition>
  cssSelectorBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'cssSelector',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FieldMapRule, FieldMapRule, QAfterFilterCondition>
  cssSelectorStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'cssSelector',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FieldMapRule, FieldMapRule, QAfterFilterCondition>
  cssSelectorEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'cssSelector',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FieldMapRule, FieldMapRule, QAfterFilterCondition>
  cssSelectorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'cssSelector',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FieldMapRule, FieldMapRule, QAfterFilterCondition>
  cssSelectorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'cssSelector',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FieldMapRule, FieldMapRule, QAfterFilterCondition>
  cssSelectorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'cssSelector', value: ''),
      );
    });
  }

  QueryBuilder<FieldMapRule, FieldMapRule, QAfterFilterCondition>
  cssSelectorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'cssSelector', value: ''),
      );
    });
  }

  QueryBuilder<FieldMapRule, FieldMapRule, QAfterFilterCondition>
  inputTypeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'inputType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FieldMapRule, FieldMapRule, QAfterFilterCondition>
  inputTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'inputType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FieldMapRule, FieldMapRule, QAfterFilterCondition>
  inputTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'inputType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FieldMapRule, FieldMapRule, QAfterFilterCondition>
  inputTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'inputType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FieldMapRule, FieldMapRule, QAfterFilterCondition>
  inputTypeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'inputType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FieldMapRule, FieldMapRule, QAfterFilterCondition>
  inputTypeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'inputType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FieldMapRule, FieldMapRule, QAfterFilterCondition>
  inputTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'inputType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FieldMapRule, FieldMapRule, QAfterFilterCondition>
  inputTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'inputType',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FieldMapRule, FieldMapRule, QAfterFilterCondition>
  inputTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'inputType', value: ''),
      );
    });
  }

  QueryBuilder<FieldMapRule, FieldMapRule, QAfterFilterCondition>
  inputTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'inputType', value: ''),
      );
    });
  }

  QueryBuilder<FieldMapRule, FieldMapRule, QAfterFilterCondition>
  resumeFieldKeyEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'resumeFieldKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FieldMapRule, FieldMapRule, QAfterFilterCondition>
  resumeFieldKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'resumeFieldKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FieldMapRule, FieldMapRule, QAfterFilterCondition>
  resumeFieldKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'resumeFieldKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FieldMapRule, FieldMapRule, QAfterFilterCondition>
  resumeFieldKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'resumeFieldKey',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FieldMapRule, FieldMapRule, QAfterFilterCondition>
  resumeFieldKeyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'resumeFieldKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FieldMapRule, FieldMapRule, QAfterFilterCondition>
  resumeFieldKeyEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'resumeFieldKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FieldMapRule, FieldMapRule, QAfterFilterCondition>
  resumeFieldKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'resumeFieldKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FieldMapRule, FieldMapRule, QAfterFilterCondition>
  resumeFieldKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'resumeFieldKey',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FieldMapRule, FieldMapRule, QAfterFilterCondition>
  resumeFieldKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'resumeFieldKey', value: ''),
      );
    });
  }

  QueryBuilder<FieldMapRule, FieldMapRule, QAfterFilterCondition>
  resumeFieldKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'resumeFieldKey', value: ''),
      );
    });
  }
}

extension FieldMapRuleQueryObject
    on QueryBuilder<FieldMapRule, FieldMapRule, QFilterCondition> {}
