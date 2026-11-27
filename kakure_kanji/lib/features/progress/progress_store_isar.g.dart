// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_store_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetClearRecordEntityCollection on Isar {
  IsarCollection<ClearRecordEntity> get clearRecordEntitys => this.collection();
}

const ClearRecordEntitySchema = CollectionSchema(
  name: r'ClearRecordEntity',
  id: -443153428580974541,
  properties: {
    r'clearCount': PropertySchema(
      id: 0,
      name: r'clearCount',
      type: IsarType.long,
    ),
    r'firstClearedAt': PropertySchema(
      id: 1,
      name: r'firstClearedAt',
      type: IsarType.dateTime,
    ),
    r'kanji': PropertySchema(
      id: 2,
      name: r'kanji',
      type: IsarType.string,
    )
  },
  estimateSize: _clearRecordEntityEstimateSize,
  serialize: _clearRecordEntitySerialize,
  deserialize: _clearRecordEntityDeserialize,
  deserializeProp: _clearRecordEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'kanji': IndexSchema(
      id: -554343575354360898,
      name: r'kanji',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'kanji',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _clearRecordEntityGetId,
  getLinks: _clearRecordEntityGetLinks,
  attach: _clearRecordEntityAttach,
  version: '3.1.0+1',
);

int _clearRecordEntityEstimateSize(
  ClearRecordEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.kanji.length * 3;
  return bytesCount;
}

void _clearRecordEntitySerialize(
  ClearRecordEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.clearCount);
  writer.writeDateTime(offsets[1], object.firstClearedAt);
  writer.writeString(offsets[2], object.kanji);
}

ClearRecordEntity _clearRecordEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ClearRecordEntity();
  object.clearCount = reader.readLong(offsets[0]);
  object.firstClearedAt = reader.readDateTime(offsets[1]);
  object.id = id;
  object.kanji = reader.readString(offsets[2]);
  return object;
}

P _clearRecordEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _clearRecordEntityGetId(ClearRecordEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _clearRecordEntityGetLinks(
    ClearRecordEntity object) {
  return [];
}

void _clearRecordEntityAttach(
    IsarCollection<dynamic> col, Id id, ClearRecordEntity object) {
  object.id = id;
}

extension ClearRecordEntityByIndex on IsarCollection<ClearRecordEntity> {
  Future<ClearRecordEntity?> getByKanji(String kanji) {
    return getByIndex(r'kanji', [kanji]);
  }

  ClearRecordEntity? getByKanjiSync(String kanji) {
    return getByIndexSync(r'kanji', [kanji]);
  }

  Future<bool> deleteByKanji(String kanji) {
    return deleteByIndex(r'kanji', [kanji]);
  }

  bool deleteByKanjiSync(String kanji) {
    return deleteByIndexSync(r'kanji', [kanji]);
  }

  Future<List<ClearRecordEntity?>> getAllByKanji(List<String> kanjiValues) {
    final values = kanjiValues.map((e) => [e]).toList();
    return getAllByIndex(r'kanji', values);
  }

  List<ClearRecordEntity?> getAllByKanjiSync(List<String> kanjiValues) {
    final values = kanjiValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'kanji', values);
  }

  Future<int> deleteAllByKanji(List<String> kanjiValues) {
    final values = kanjiValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'kanji', values);
  }

  int deleteAllByKanjiSync(List<String> kanjiValues) {
    final values = kanjiValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'kanji', values);
  }

  Future<Id> putByKanji(ClearRecordEntity object) {
    return putByIndex(r'kanji', object);
  }

  Id putByKanjiSync(ClearRecordEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'kanji', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByKanji(List<ClearRecordEntity> objects) {
    return putAllByIndex(r'kanji', objects);
  }

  List<Id> putAllByKanjiSync(List<ClearRecordEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'kanji', objects, saveLinks: saveLinks);
  }
}

extension ClearRecordEntityQueryWhereSort
    on QueryBuilder<ClearRecordEntity, ClearRecordEntity, QWhere> {
  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ClearRecordEntityQueryWhere
    on QueryBuilder<ClearRecordEntity, ClearRecordEntity, QWhereClause> {
  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterWhereClause>
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

  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterWhereClause>
      kanjiEqualTo(String kanji) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'kanji',
        value: [kanji],
      ));
    });
  }

  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterWhereClause>
      kanjiNotEqualTo(String kanji) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'kanji',
              lower: [],
              upper: [kanji],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'kanji',
              lower: [kanji],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'kanji',
              lower: [kanji],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'kanji',
              lower: [],
              upper: [kanji],
              includeUpper: false,
            ));
      }
    });
  }
}

extension ClearRecordEntityQueryFilter
    on QueryBuilder<ClearRecordEntity, ClearRecordEntity, QFilterCondition> {
  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterFilterCondition>
      clearCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clearCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterFilterCondition>
      clearCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'clearCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterFilterCondition>
      clearCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'clearCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterFilterCondition>
      clearCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'clearCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterFilterCondition>
      firstClearedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'firstClearedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterFilterCondition>
      firstClearedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'firstClearedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterFilterCondition>
      firstClearedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'firstClearedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterFilterCondition>
      firstClearedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'firstClearedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterFilterCondition>
      kanjiEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'kanji',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterFilterCondition>
      kanjiGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'kanji',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterFilterCondition>
      kanjiLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'kanji',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterFilterCondition>
      kanjiBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'kanji',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterFilterCondition>
      kanjiStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'kanji',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterFilterCondition>
      kanjiEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'kanji',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterFilterCondition>
      kanjiContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'kanji',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterFilterCondition>
      kanjiMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'kanji',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterFilterCondition>
      kanjiIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'kanji',
        value: '',
      ));
    });
  }

  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterFilterCondition>
      kanjiIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'kanji',
        value: '',
      ));
    });
  }
}

extension ClearRecordEntityQueryObject
    on QueryBuilder<ClearRecordEntity, ClearRecordEntity, QFilterCondition> {}

extension ClearRecordEntityQueryLinks
    on QueryBuilder<ClearRecordEntity, ClearRecordEntity, QFilterCondition> {}

extension ClearRecordEntityQuerySortBy
    on QueryBuilder<ClearRecordEntity, ClearRecordEntity, QSortBy> {
  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterSortBy>
      sortByClearCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clearCount', Sort.asc);
    });
  }

  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterSortBy>
      sortByClearCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clearCount', Sort.desc);
    });
  }

  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterSortBy>
      sortByFirstClearedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstClearedAt', Sort.asc);
    });
  }

  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterSortBy>
      sortByFirstClearedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstClearedAt', Sort.desc);
    });
  }

  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterSortBy>
      sortByKanji() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kanji', Sort.asc);
    });
  }

  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterSortBy>
      sortByKanjiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kanji', Sort.desc);
    });
  }
}

extension ClearRecordEntityQuerySortThenBy
    on QueryBuilder<ClearRecordEntity, ClearRecordEntity, QSortThenBy> {
  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterSortBy>
      thenByClearCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clearCount', Sort.asc);
    });
  }

  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterSortBy>
      thenByClearCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clearCount', Sort.desc);
    });
  }

  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterSortBy>
      thenByFirstClearedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstClearedAt', Sort.asc);
    });
  }

  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterSortBy>
      thenByFirstClearedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstClearedAt', Sort.desc);
    });
  }

  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterSortBy>
      thenByKanji() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kanji', Sort.asc);
    });
  }

  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QAfterSortBy>
      thenByKanjiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kanji', Sort.desc);
    });
  }
}

extension ClearRecordEntityQueryWhereDistinct
    on QueryBuilder<ClearRecordEntity, ClearRecordEntity, QDistinct> {
  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QDistinct>
      distinctByClearCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'clearCount');
    });
  }

  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QDistinct>
      distinctByFirstClearedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'firstClearedAt');
    });
  }

  QueryBuilder<ClearRecordEntity, ClearRecordEntity, QDistinct> distinctByKanji(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'kanji', caseSensitive: caseSensitive);
    });
  }
}

extension ClearRecordEntityQueryProperty
    on QueryBuilder<ClearRecordEntity, ClearRecordEntity, QQueryProperty> {
  QueryBuilder<ClearRecordEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ClearRecordEntity, int, QQueryOperations> clearCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'clearCount');
    });
  }

  QueryBuilder<ClearRecordEntity, DateTime, QQueryOperations>
      firstClearedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'firstClearedAt');
    });
  }

  QueryBuilder<ClearRecordEntity, String, QQueryOperations> kanjiProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'kanji');
    });
  }
}
