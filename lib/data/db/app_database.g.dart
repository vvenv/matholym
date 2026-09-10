// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProfilesTable extends Profiles with TableInfo<$ProfilesTable, Profile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nicknameMeta = const VerificationMeta(
    'nickname',
  );
  @override
  late final GeneratedColumn<String> nickname = GeneratedColumn<String>(
    'nickname',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stageMeta = const VerificationMeta('stage');
  @override
  late final GeneratedColumn<String> stage = GeneratedColumn<String>(
    'stage',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nickname, stage, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Profile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nickname')) {
      context.handle(
        _nicknameMeta,
        nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta),
      );
    } else if (isInserting) {
      context.missing(_nicknameMeta);
    }
    if (data.containsKey('stage')) {
      context.handle(
        _stageMeta,
        stage.isAcceptableOrUnknown(data['stage']!, _stageMeta),
      );
    } else if (isInserting) {
      context.missing(_stageMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Profile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Profile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nickname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nickname'],
      )!,
      stage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stage'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }
}

class Profile extends DataClass implements Insertable<Profile> {
  final int id;
  final String nickname;
  final String stage;
  final DateTime createdAt;
  const Profile({
    required this.id,
    required this.nickname,
    required this.stage,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nickname'] = Variable<String>(nickname);
    map['stage'] = Variable<String>(stage);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      nickname: Value(nickname),
      stage: Value(stage),
      createdAt: Value(createdAt),
    );
  }

  factory Profile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Profile(
      id: serializer.fromJson<int>(json['id']),
      nickname: serializer.fromJson<String>(json['nickname']),
      stage: serializer.fromJson<String>(json['stage']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nickname': serializer.toJson<String>(nickname),
      'stage': serializer.toJson<String>(stage),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Profile copyWith({
    int? id,
    String? nickname,
    String? stage,
    DateTime? createdAt,
  }) => Profile(
    id: id ?? this.id,
    nickname: nickname ?? this.nickname,
    stage: stage ?? this.stage,
    createdAt: createdAt ?? this.createdAt,
  );
  Profile copyWithCompanion(ProfilesCompanion data) {
    return Profile(
      id: data.id.present ? data.id.value : this.id,
      nickname: data.nickname.present ? data.nickname.value : this.nickname,
      stage: data.stage.present ? data.stage.value : this.stage,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Profile(')
          ..write('id: $id, ')
          ..write('nickname: $nickname, ')
          ..write('stage: $stage, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nickname, stage, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Profile &&
          other.id == this.id &&
          other.nickname == this.nickname &&
          other.stage == this.stage &&
          other.createdAt == this.createdAt);
}

class ProfilesCompanion extends UpdateCompanion<Profile> {
  final Value<int> id;
  final Value<String> nickname;
  final Value<String> stage;
  final Value<DateTime> createdAt;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.nickname = const Value.absent(),
    this.stage = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ProfilesCompanion.insert({
    this.id = const Value.absent(),
    required String nickname,
    required String stage,
    required DateTime createdAt,
  }) : nickname = Value(nickname),
       stage = Value(stage),
       createdAt = Value(createdAt);
  static Insertable<Profile> custom({
    Expression<int>? id,
    Expression<String>? nickname,
    Expression<String>? stage,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nickname != null) 'nickname': nickname,
      if (stage != null) 'stage': stage,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ProfilesCompanion copyWith({
    Value<int>? id,
    Value<String>? nickname,
    Value<String>? stage,
    Value<DateTime>? createdAt,
  }) {
    return ProfilesCompanion(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      stage: stage ?? this.stage,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    if (stage.present) {
      map['stage'] = Variable<String>(stage.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('nickname: $nickname, ')
          ..write('stage: $stage, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $NodeProgressRowsTable extends NodeProgressRows
    with TableInfo<$NodeProgressRowsTable, NodeProgressRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NodeProgressRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nodeIdMeta = const VerificationMeta('nodeId');
  @override
  late final GeneratedColumn<String> nodeId = GeneratedColumn<String>(
    'node_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unlockedMeta = const VerificationMeta(
    'unlocked',
  );
  @override
  late final GeneratedColumn<bool> unlocked = GeneratedColumn<bool>(
    'unlocked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("unlocked" IN (0, 1))',
    ),
  );
  static const VerificationMeta _masteredMeta = const VerificationMeta(
    'mastered',
  );
  @override
  late final GeneratedColumn<bool> mastered = GeneratedColumn<bool>(
    'mastered',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("mastered" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _correctCountMeta = const VerificationMeta(
    'correctCount',
  );
  @override
  late final GeneratedColumn<int> correctCount = GeneratedColumn<int>(
    'correct_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _consecutiveMeta = const VerificationMeta(
    'consecutive',
  );
  @override
  late final GeneratedColumn<int> consecutive = GeneratedColumn<int>(
    'consecutive',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _unlockedAtMeta = const VerificationMeta(
    'unlockedAt',
  );
  @override
  late final GeneratedColumn<DateTime> unlockedAt = GeneratedColumn<DateTime>(
    'unlocked_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _masteredAtMeta = const VerificationMeta(
    'masteredAt',
  );
  @override
  late final GeneratedColumn<DateTime> masteredAt = GeneratedColumn<DateTime>(
    'mastered_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    profileId,
    nodeId,
    unlocked,
    mastered,
    attempts,
    correctCount,
    consecutive,
    unlockedAt,
    masteredAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'node_progress_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<NodeProgressRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('node_id')) {
      context.handle(
        _nodeIdMeta,
        nodeId.isAcceptableOrUnknown(data['node_id']!, _nodeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_nodeIdMeta);
    }
    if (data.containsKey('unlocked')) {
      context.handle(
        _unlockedMeta,
        unlocked.isAcceptableOrUnknown(data['unlocked']!, _unlockedMeta),
      );
    } else if (isInserting) {
      context.missing(_unlockedMeta);
    }
    if (data.containsKey('mastered')) {
      context.handle(
        _masteredMeta,
        mastered.isAcceptableOrUnknown(data['mastered']!, _masteredMeta),
      );
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('correct_count')) {
      context.handle(
        _correctCountMeta,
        correctCount.isAcceptableOrUnknown(
          data['correct_count']!,
          _correctCountMeta,
        ),
      );
    }
    if (data.containsKey('consecutive')) {
      context.handle(
        _consecutiveMeta,
        consecutive.isAcceptableOrUnknown(
          data['consecutive']!,
          _consecutiveMeta,
        ),
      );
    }
    if (data.containsKey('unlocked_at')) {
      context.handle(
        _unlockedAtMeta,
        unlockedAt.isAcceptableOrUnknown(data['unlocked_at']!, _unlockedAtMeta),
      );
    }
    if (data.containsKey('mastered_at')) {
      context.handle(
        _masteredAtMeta,
        masteredAt.isAcceptableOrUnknown(data['mastered_at']!, _masteredAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {profileId, nodeId};
  @override
  NodeProgressRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NodeProgressRow(
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      nodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}node_id'],
      )!,
      unlocked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}unlocked'],
      )!,
      mastered: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}mastered'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      correctCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct_count'],
      )!,
      consecutive: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}consecutive'],
      )!,
      unlockedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}unlocked_at'],
      ),
      masteredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}mastered_at'],
      ),
    );
  }

  @override
  $NodeProgressRowsTable createAlias(String alias) {
    return $NodeProgressRowsTable(attachedDatabase, alias);
  }
}

class NodeProgressRow extends DataClass implements Insertable<NodeProgressRow> {
  final int profileId;
  final String nodeId;
  final bool unlocked;
  final bool mastered;
  final int attempts;
  final int correctCount;
  final int consecutive;
  final DateTime? unlockedAt;
  final DateTime? masteredAt;
  const NodeProgressRow({
    required this.profileId,
    required this.nodeId,
    required this.unlocked,
    required this.mastered,
    required this.attempts,
    required this.correctCount,
    required this.consecutive,
    this.unlockedAt,
    this.masteredAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profile_id'] = Variable<int>(profileId);
    map['node_id'] = Variable<String>(nodeId);
    map['unlocked'] = Variable<bool>(unlocked);
    map['mastered'] = Variable<bool>(mastered);
    map['attempts'] = Variable<int>(attempts);
    map['correct_count'] = Variable<int>(correctCount);
    map['consecutive'] = Variable<int>(consecutive);
    if (!nullToAbsent || unlockedAt != null) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt);
    }
    if (!nullToAbsent || masteredAt != null) {
      map['mastered_at'] = Variable<DateTime>(masteredAt);
    }
    return map;
  }

  NodeProgressRowsCompanion toCompanion(bool nullToAbsent) {
    return NodeProgressRowsCompanion(
      profileId: Value(profileId),
      nodeId: Value(nodeId),
      unlocked: Value(unlocked),
      mastered: Value(mastered),
      attempts: Value(attempts),
      correctCount: Value(correctCount),
      consecutive: Value(consecutive),
      unlockedAt: unlockedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(unlockedAt),
      masteredAt: masteredAt == null && nullToAbsent
          ? const Value.absent()
          : Value(masteredAt),
    );
  }

  factory NodeProgressRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NodeProgressRow(
      profileId: serializer.fromJson<int>(json['profileId']),
      nodeId: serializer.fromJson<String>(json['nodeId']),
      unlocked: serializer.fromJson<bool>(json['unlocked']),
      mastered: serializer.fromJson<bool>(json['mastered']),
      attempts: serializer.fromJson<int>(json['attempts']),
      correctCount: serializer.fromJson<int>(json['correctCount']),
      consecutive: serializer.fromJson<int>(json['consecutive']),
      unlockedAt: serializer.fromJson<DateTime?>(json['unlockedAt']),
      masteredAt: serializer.fromJson<DateTime?>(json['masteredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profileId': serializer.toJson<int>(profileId),
      'nodeId': serializer.toJson<String>(nodeId),
      'unlocked': serializer.toJson<bool>(unlocked),
      'mastered': serializer.toJson<bool>(mastered),
      'attempts': serializer.toJson<int>(attempts),
      'correctCount': serializer.toJson<int>(correctCount),
      'consecutive': serializer.toJson<int>(consecutive),
      'unlockedAt': serializer.toJson<DateTime?>(unlockedAt),
      'masteredAt': serializer.toJson<DateTime?>(masteredAt),
    };
  }

  NodeProgressRow copyWith({
    int? profileId,
    String? nodeId,
    bool? unlocked,
    bool? mastered,
    int? attempts,
    int? correctCount,
    int? consecutive,
    Value<DateTime?> unlockedAt = const Value.absent(),
    Value<DateTime?> masteredAt = const Value.absent(),
  }) => NodeProgressRow(
    profileId: profileId ?? this.profileId,
    nodeId: nodeId ?? this.nodeId,
    unlocked: unlocked ?? this.unlocked,
    mastered: mastered ?? this.mastered,
    attempts: attempts ?? this.attempts,
    correctCount: correctCount ?? this.correctCount,
    consecutive: consecutive ?? this.consecutive,
    unlockedAt: unlockedAt.present ? unlockedAt.value : this.unlockedAt,
    masteredAt: masteredAt.present ? masteredAt.value : this.masteredAt,
  );
  NodeProgressRow copyWithCompanion(NodeProgressRowsCompanion data) {
    return NodeProgressRow(
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      nodeId: data.nodeId.present ? data.nodeId.value : this.nodeId,
      unlocked: data.unlocked.present ? data.unlocked.value : this.unlocked,
      mastered: data.mastered.present ? data.mastered.value : this.mastered,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      correctCount: data.correctCount.present
          ? data.correctCount.value
          : this.correctCount,
      consecutive: data.consecutive.present
          ? data.consecutive.value
          : this.consecutive,
      unlockedAt: data.unlockedAt.present
          ? data.unlockedAt.value
          : this.unlockedAt,
      masteredAt: data.masteredAt.present
          ? data.masteredAt.value
          : this.masteredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NodeProgressRow(')
          ..write('profileId: $profileId, ')
          ..write('nodeId: $nodeId, ')
          ..write('unlocked: $unlocked, ')
          ..write('mastered: $mastered, ')
          ..write('attempts: $attempts, ')
          ..write('correctCount: $correctCount, ')
          ..write('consecutive: $consecutive, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('masteredAt: $masteredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    profileId,
    nodeId,
    unlocked,
    mastered,
    attempts,
    correctCount,
    consecutive,
    unlockedAt,
    masteredAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NodeProgressRow &&
          other.profileId == this.profileId &&
          other.nodeId == this.nodeId &&
          other.unlocked == this.unlocked &&
          other.mastered == this.mastered &&
          other.attempts == this.attempts &&
          other.correctCount == this.correctCount &&
          other.consecutive == this.consecutive &&
          other.unlockedAt == this.unlockedAt &&
          other.masteredAt == this.masteredAt);
}

class NodeProgressRowsCompanion extends UpdateCompanion<NodeProgressRow> {
  final Value<int> profileId;
  final Value<String> nodeId;
  final Value<bool> unlocked;
  final Value<bool> mastered;
  final Value<int> attempts;
  final Value<int> correctCount;
  final Value<int> consecutive;
  final Value<DateTime?> unlockedAt;
  final Value<DateTime?> masteredAt;
  final Value<int> rowid;
  const NodeProgressRowsCompanion({
    this.profileId = const Value.absent(),
    this.nodeId = const Value.absent(),
    this.unlocked = const Value.absent(),
    this.mastered = const Value.absent(),
    this.attempts = const Value.absent(),
    this.correctCount = const Value.absent(),
    this.consecutive = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    this.masteredAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NodeProgressRowsCompanion.insert({
    required int profileId,
    required String nodeId,
    required bool unlocked,
    this.mastered = const Value.absent(),
    this.attempts = const Value.absent(),
    this.correctCount = const Value.absent(),
    this.consecutive = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    this.masteredAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : profileId = Value(profileId),
       nodeId = Value(nodeId),
       unlocked = Value(unlocked);
  static Insertable<NodeProgressRow> custom({
    Expression<int>? profileId,
    Expression<String>? nodeId,
    Expression<bool>? unlocked,
    Expression<bool>? mastered,
    Expression<int>? attempts,
    Expression<int>? correctCount,
    Expression<int>? consecutive,
    Expression<DateTime>? unlockedAt,
    Expression<DateTime>? masteredAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (profileId != null) 'profile_id': profileId,
      if (nodeId != null) 'node_id': nodeId,
      if (unlocked != null) 'unlocked': unlocked,
      if (mastered != null) 'mastered': mastered,
      if (attempts != null) 'attempts': attempts,
      if (correctCount != null) 'correct_count': correctCount,
      if (consecutive != null) 'consecutive': consecutive,
      if (unlockedAt != null) 'unlocked_at': unlockedAt,
      if (masteredAt != null) 'mastered_at': masteredAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NodeProgressRowsCompanion copyWith({
    Value<int>? profileId,
    Value<String>? nodeId,
    Value<bool>? unlocked,
    Value<bool>? mastered,
    Value<int>? attempts,
    Value<int>? correctCount,
    Value<int>? consecutive,
    Value<DateTime?>? unlockedAt,
    Value<DateTime?>? masteredAt,
    Value<int>? rowid,
  }) {
    return NodeProgressRowsCompanion(
      profileId: profileId ?? this.profileId,
      nodeId: nodeId ?? this.nodeId,
      unlocked: unlocked ?? this.unlocked,
      mastered: mastered ?? this.mastered,
      attempts: attempts ?? this.attempts,
      correctCount: correctCount ?? this.correctCount,
      consecutive: consecutive ?? this.consecutive,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      masteredAt: masteredAt ?? this.masteredAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (nodeId.present) {
      map['node_id'] = Variable<String>(nodeId.value);
    }
    if (unlocked.present) {
      map['unlocked'] = Variable<bool>(unlocked.value);
    }
    if (mastered.present) {
      map['mastered'] = Variable<bool>(mastered.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (correctCount.present) {
      map['correct_count'] = Variable<int>(correctCount.value);
    }
    if (consecutive.present) {
      map['consecutive'] = Variable<int>(consecutive.value);
    }
    if (unlockedAt.present) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt.value);
    }
    if (masteredAt.present) {
      map['mastered_at'] = Variable<DateTime>(masteredAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NodeProgressRowsCompanion(')
          ..write('profileId: $profileId, ')
          ..write('nodeId: $nodeId, ')
          ..write('unlocked: $unlocked, ')
          ..write('mastered: $mastered, ')
          ..write('attempts: $attempts, ')
          ..write('correctCount: $correctCount, ')
          ..write('consecutive: $consecutive, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('masteredAt: $masteredAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AttemptsTable extends Attempts with TableInfo<$AttemptsTable, Attempt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttemptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nodeIdMeta = const VerificationMeta('nodeId');
  @override
  late final GeneratedColumn<String> nodeId = GeneratedColumn<String>(
    'node_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _templateIdMeta = const VerificationMeta(
    'templateId',
  );
  @override
  late final GeneratedColumn<String> templateId = GeneratedColumn<String>(
    'template_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seedMeta = const VerificationMeta('seed');
  @override
  late final GeneratedColumn<int> seed = GeneratedColumn<int>(
    'seed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userAnswerMeta = const VerificationMeta(
    'userAnswer',
  );
  @override
  late final GeneratedColumn<String> userAnswer = GeneratedColumn<String>(
    'user_answer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCorrectMeta = const VerificationMeta(
    'isCorrect',
  );
  @override
  late final GeneratedColumn<bool> isCorrect = GeneratedColumn<bool>(
    'is_correct',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_correct" IN (0, 1))',
    ),
  );
  static const VerificationMeta _hintsUsedMeta = const VerificationMeta(
    'hintsUsed',
  );
  @override
  late final GeneratedColumn<int> hintsUsed = GeneratedColumn<int>(
    'hints_used',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _errorCauseMeta = const VerificationMeta(
    'errorCause',
  );
  @override
  late final GeneratedColumn<String> errorCause = GeneratedColumn<String>(
    'error_cause',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _attributedNodeIdMeta = const VerificationMeta(
    'attributedNodeId',
  );
  @override
  late final GeneratedColumn<String> attributedNodeId = GeneratedColumn<String>(
    'attributed_node_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
    'mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    nodeId,
    templateId,
    seed,
    userAnswer,
    isCorrect,
    hintsUsed,
    errorCause,
    attributedNodeId,
    sessionId,
    mode,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attempts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Attempt> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('node_id')) {
      context.handle(
        _nodeIdMeta,
        nodeId.isAcceptableOrUnknown(data['node_id']!, _nodeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_nodeIdMeta);
    }
    if (data.containsKey('template_id')) {
      context.handle(
        _templateIdMeta,
        templateId.isAcceptableOrUnknown(data['template_id']!, _templateIdMeta),
      );
    } else if (isInserting) {
      context.missing(_templateIdMeta);
    }
    if (data.containsKey('seed')) {
      context.handle(
        _seedMeta,
        seed.isAcceptableOrUnknown(data['seed']!, _seedMeta),
      );
    } else if (isInserting) {
      context.missing(_seedMeta);
    }
    if (data.containsKey('user_answer')) {
      context.handle(
        _userAnswerMeta,
        userAnswer.isAcceptableOrUnknown(data['user_answer']!, _userAnswerMeta),
      );
    } else if (isInserting) {
      context.missing(_userAnswerMeta);
    }
    if (data.containsKey('is_correct')) {
      context.handle(
        _isCorrectMeta,
        isCorrect.isAcceptableOrUnknown(data['is_correct']!, _isCorrectMeta),
      );
    } else if (isInserting) {
      context.missing(_isCorrectMeta);
    }
    if (data.containsKey('hints_used')) {
      context.handle(
        _hintsUsedMeta,
        hintsUsed.isAcceptableOrUnknown(data['hints_used']!, _hintsUsedMeta),
      );
    } else if (isInserting) {
      context.missing(_hintsUsedMeta);
    }
    if (data.containsKey('error_cause')) {
      context.handle(
        _errorCauseMeta,
        errorCause.isAcceptableOrUnknown(data['error_cause']!, _errorCauseMeta),
      );
    }
    if (data.containsKey('attributed_node_id')) {
      context.handle(
        _attributedNodeIdMeta,
        attributedNodeId.isAcceptableOrUnknown(
          data['attributed_node_id']!,
          _attributedNodeIdMeta,
        ),
      );
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    } else if (isInserting) {
      context.missing(_modeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Attempt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Attempt(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      nodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}node_id'],
      )!,
      templateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_id'],
      )!,
      seed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seed'],
      )!,
      userAnswer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_answer'],
      )!,
      isCorrect: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_correct'],
      )!,
      hintsUsed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hints_used'],
      )!,
      errorCause: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_cause'],
      ),
      attributedNodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attributed_node_id'],
      ),
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      mode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mode'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AttemptsTable createAlias(String alias) {
    return $AttemptsTable(attachedDatabase, alias);
  }
}

class Attempt extends DataClass implements Insertable<Attempt> {
  final int id;
  final int profileId;
  final String nodeId;
  final String templateId;
  final int seed;
  final String userAnswer;
  final bool isCorrect;
  final int hintsUsed;
  final String? errorCause;
  final String? attributedNodeId;
  final String sessionId;
  final String mode;
  final DateTime createdAt;
  const Attempt({
    required this.id,
    required this.profileId,
    required this.nodeId,
    required this.templateId,
    required this.seed,
    required this.userAnswer,
    required this.isCorrect,
    required this.hintsUsed,
    this.errorCause,
    this.attributedNodeId,
    required this.sessionId,
    required this.mode,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<int>(profileId);
    map['node_id'] = Variable<String>(nodeId);
    map['template_id'] = Variable<String>(templateId);
    map['seed'] = Variable<int>(seed);
    map['user_answer'] = Variable<String>(userAnswer);
    map['is_correct'] = Variable<bool>(isCorrect);
    map['hints_used'] = Variable<int>(hintsUsed);
    if (!nullToAbsent || errorCause != null) {
      map['error_cause'] = Variable<String>(errorCause);
    }
    if (!nullToAbsent || attributedNodeId != null) {
      map['attributed_node_id'] = Variable<String>(attributedNodeId);
    }
    map['session_id'] = Variable<String>(sessionId);
    map['mode'] = Variable<String>(mode);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AttemptsCompanion toCompanion(bool nullToAbsent) {
    return AttemptsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      nodeId: Value(nodeId),
      templateId: Value(templateId),
      seed: Value(seed),
      userAnswer: Value(userAnswer),
      isCorrect: Value(isCorrect),
      hintsUsed: Value(hintsUsed),
      errorCause: errorCause == null && nullToAbsent
          ? const Value.absent()
          : Value(errorCause),
      attributedNodeId: attributedNodeId == null && nullToAbsent
          ? const Value.absent()
          : Value(attributedNodeId),
      sessionId: Value(sessionId),
      mode: Value(mode),
      createdAt: Value(createdAt),
    );
  }

  factory Attempt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Attempt(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<int>(json['profileId']),
      nodeId: serializer.fromJson<String>(json['nodeId']),
      templateId: serializer.fromJson<String>(json['templateId']),
      seed: serializer.fromJson<int>(json['seed']),
      userAnswer: serializer.fromJson<String>(json['userAnswer']),
      isCorrect: serializer.fromJson<bool>(json['isCorrect']),
      hintsUsed: serializer.fromJson<int>(json['hintsUsed']),
      errorCause: serializer.fromJson<String?>(json['errorCause']),
      attributedNodeId: serializer.fromJson<String?>(json['attributedNodeId']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      mode: serializer.fromJson<String>(json['mode']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<int>(profileId),
      'nodeId': serializer.toJson<String>(nodeId),
      'templateId': serializer.toJson<String>(templateId),
      'seed': serializer.toJson<int>(seed),
      'userAnswer': serializer.toJson<String>(userAnswer),
      'isCorrect': serializer.toJson<bool>(isCorrect),
      'hintsUsed': serializer.toJson<int>(hintsUsed),
      'errorCause': serializer.toJson<String?>(errorCause),
      'attributedNodeId': serializer.toJson<String?>(attributedNodeId),
      'sessionId': serializer.toJson<String>(sessionId),
      'mode': serializer.toJson<String>(mode),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Attempt copyWith({
    int? id,
    int? profileId,
    String? nodeId,
    String? templateId,
    int? seed,
    String? userAnswer,
    bool? isCorrect,
    int? hintsUsed,
    Value<String?> errorCause = const Value.absent(),
    Value<String?> attributedNodeId = const Value.absent(),
    String? sessionId,
    String? mode,
    DateTime? createdAt,
  }) => Attempt(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    nodeId: nodeId ?? this.nodeId,
    templateId: templateId ?? this.templateId,
    seed: seed ?? this.seed,
    userAnswer: userAnswer ?? this.userAnswer,
    isCorrect: isCorrect ?? this.isCorrect,
    hintsUsed: hintsUsed ?? this.hintsUsed,
    errorCause: errorCause.present ? errorCause.value : this.errorCause,
    attributedNodeId: attributedNodeId.present
        ? attributedNodeId.value
        : this.attributedNodeId,
    sessionId: sessionId ?? this.sessionId,
    mode: mode ?? this.mode,
    createdAt: createdAt ?? this.createdAt,
  );
  Attempt copyWithCompanion(AttemptsCompanion data) {
    return Attempt(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      nodeId: data.nodeId.present ? data.nodeId.value : this.nodeId,
      templateId: data.templateId.present
          ? data.templateId.value
          : this.templateId,
      seed: data.seed.present ? data.seed.value : this.seed,
      userAnswer: data.userAnswer.present
          ? data.userAnswer.value
          : this.userAnswer,
      isCorrect: data.isCorrect.present ? data.isCorrect.value : this.isCorrect,
      hintsUsed: data.hintsUsed.present ? data.hintsUsed.value : this.hintsUsed,
      errorCause: data.errorCause.present
          ? data.errorCause.value
          : this.errorCause,
      attributedNodeId: data.attributedNodeId.present
          ? data.attributedNodeId.value
          : this.attributedNodeId,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      mode: data.mode.present ? data.mode.value : this.mode,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Attempt(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('nodeId: $nodeId, ')
          ..write('templateId: $templateId, ')
          ..write('seed: $seed, ')
          ..write('userAnswer: $userAnswer, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('hintsUsed: $hintsUsed, ')
          ..write('errorCause: $errorCause, ')
          ..write('attributedNodeId: $attributedNodeId, ')
          ..write('sessionId: $sessionId, ')
          ..write('mode: $mode, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    profileId,
    nodeId,
    templateId,
    seed,
    userAnswer,
    isCorrect,
    hintsUsed,
    errorCause,
    attributedNodeId,
    sessionId,
    mode,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Attempt &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.nodeId == this.nodeId &&
          other.templateId == this.templateId &&
          other.seed == this.seed &&
          other.userAnswer == this.userAnswer &&
          other.isCorrect == this.isCorrect &&
          other.hintsUsed == this.hintsUsed &&
          other.errorCause == this.errorCause &&
          other.attributedNodeId == this.attributedNodeId &&
          other.sessionId == this.sessionId &&
          other.mode == this.mode &&
          other.createdAt == this.createdAt);
}

class AttemptsCompanion extends UpdateCompanion<Attempt> {
  final Value<int> id;
  final Value<int> profileId;
  final Value<String> nodeId;
  final Value<String> templateId;
  final Value<int> seed;
  final Value<String> userAnswer;
  final Value<bool> isCorrect;
  final Value<int> hintsUsed;
  final Value<String?> errorCause;
  final Value<String?> attributedNodeId;
  final Value<String> sessionId;
  final Value<String> mode;
  final Value<DateTime> createdAt;
  const AttemptsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.nodeId = const Value.absent(),
    this.templateId = const Value.absent(),
    this.seed = const Value.absent(),
    this.userAnswer = const Value.absent(),
    this.isCorrect = const Value.absent(),
    this.hintsUsed = const Value.absent(),
    this.errorCause = const Value.absent(),
    this.attributedNodeId = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.mode = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AttemptsCompanion.insert({
    this.id = const Value.absent(),
    required int profileId,
    required String nodeId,
    required String templateId,
    required int seed,
    required String userAnswer,
    required bool isCorrect,
    required int hintsUsed,
    this.errorCause = const Value.absent(),
    this.attributedNodeId = const Value.absent(),
    required String sessionId,
    required String mode,
    required DateTime createdAt,
  }) : profileId = Value(profileId),
       nodeId = Value(nodeId),
       templateId = Value(templateId),
       seed = Value(seed),
       userAnswer = Value(userAnswer),
       isCorrect = Value(isCorrect),
       hintsUsed = Value(hintsUsed),
       sessionId = Value(sessionId),
       mode = Value(mode),
       createdAt = Value(createdAt);
  static Insertable<Attempt> custom({
    Expression<int>? id,
    Expression<int>? profileId,
    Expression<String>? nodeId,
    Expression<String>? templateId,
    Expression<int>? seed,
    Expression<String>? userAnswer,
    Expression<bool>? isCorrect,
    Expression<int>? hintsUsed,
    Expression<String>? errorCause,
    Expression<String>? attributedNodeId,
    Expression<String>? sessionId,
    Expression<String>? mode,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (nodeId != null) 'node_id': nodeId,
      if (templateId != null) 'template_id': templateId,
      if (seed != null) 'seed': seed,
      if (userAnswer != null) 'user_answer': userAnswer,
      if (isCorrect != null) 'is_correct': isCorrect,
      if (hintsUsed != null) 'hints_used': hintsUsed,
      if (errorCause != null) 'error_cause': errorCause,
      if (attributedNodeId != null) 'attributed_node_id': attributedNodeId,
      if (sessionId != null) 'session_id': sessionId,
      if (mode != null) 'mode': mode,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AttemptsCompanion copyWith({
    Value<int>? id,
    Value<int>? profileId,
    Value<String>? nodeId,
    Value<String>? templateId,
    Value<int>? seed,
    Value<String>? userAnswer,
    Value<bool>? isCorrect,
    Value<int>? hintsUsed,
    Value<String?>? errorCause,
    Value<String?>? attributedNodeId,
    Value<String>? sessionId,
    Value<String>? mode,
    Value<DateTime>? createdAt,
  }) {
    return AttemptsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      nodeId: nodeId ?? this.nodeId,
      templateId: templateId ?? this.templateId,
      seed: seed ?? this.seed,
      userAnswer: userAnswer ?? this.userAnswer,
      isCorrect: isCorrect ?? this.isCorrect,
      hintsUsed: hintsUsed ?? this.hintsUsed,
      errorCause: errorCause ?? this.errorCause,
      attributedNodeId: attributedNodeId ?? this.attributedNodeId,
      sessionId: sessionId ?? this.sessionId,
      mode: mode ?? this.mode,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (nodeId.present) {
      map['node_id'] = Variable<String>(nodeId.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<String>(templateId.value);
    }
    if (seed.present) {
      map['seed'] = Variable<int>(seed.value);
    }
    if (userAnswer.present) {
      map['user_answer'] = Variable<String>(userAnswer.value);
    }
    if (isCorrect.present) {
      map['is_correct'] = Variable<bool>(isCorrect.value);
    }
    if (hintsUsed.present) {
      map['hints_used'] = Variable<int>(hintsUsed.value);
    }
    if (errorCause.present) {
      map['error_cause'] = Variable<String>(errorCause.value);
    }
    if (attributedNodeId.present) {
      map['attributed_node_id'] = Variable<String>(attributedNodeId.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttemptsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('nodeId: $nodeId, ')
          ..write('templateId: $templateId, ')
          ..write('seed: $seed, ')
          ..write('userAnswer: $userAnswer, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('hintsUsed: $hintsUsed, ')
          ..write('errorCause: $errorCause, ')
          ..write('attributedNodeId: $attributedNodeId, ')
          ..write('sessionId: $sessionId, ')
          ..write('mode: $mode, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $WrongItemsTable extends WrongItems
    with TableInfo<$WrongItemsTable, WrongItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WrongItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _attemptIdMeta = const VerificationMeta(
    'attemptId',
  );
  @override
  late final GeneratedColumn<int> attemptId = GeneratedColumn<int>(
    'attempt_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nodeIdMeta = const VerificationMeta('nodeId');
  @override
  late final GeneratedColumn<String> nodeId = GeneratedColumn<String>(
    'node_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attributedNodeIdMeta = const VerificationMeta(
    'attributedNodeId',
  );
  @override
  late final GeneratedColumn<String> attributedNodeId = GeneratedColumn<String>(
    'attributed_node_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _errorCauseMeta = const VerificationMeta(
    'errorCause',
  );
  @override
  late final GeneratedColumn<String> errorCause = GeneratedColumn<String>(
    'error_cause',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _digestedMeta = const VerificationMeta(
    'digested',
  );
  @override
  late final GeneratedColumn<bool> digested = GeneratedColumn<bool>(
    'digested',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("digested" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _snapshotStemMeta = const VerificationMeta(
    'snapshotStem',
  );
  @override
  late final GeneratedColumn<String> snapshotStem = GeneratedColumn<String>(
    'snapshot_stem',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _snapshotAnswerMeta = const VerificationMeta(
    'snapshotAnswer',
  );
  @override
  late final GeneratedColumn<String> snapshotAnswer = GeneratedColumn<String>(
    'snapshot_answer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _templateIdMeta = const VerificationMeta(
    'templateId',
  );
  @override
  late final GeneratedColumn<String> templateId = GeneratedColumn<String>(
    'template_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seedMeta = const VerificationMeta('seed');
  @override
  late final GeneratedColumn<int> seed = GeneratedColumn<int>(
    'seed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    attemptId,
    profileId,
    nodeId,
    attributedNodeId,
    errorCause,
    digested,
    snapshotStem,
    snapshotAnswer,
    templateId,
    seed,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wrong_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<WrongItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('attempt_id')) {
      context.handle(
        _attemptIdMeta,
        attemptId.isAcceptableOrUnknown(data['attempt_id']!, _attemptIdMeta),
      );
    } else if (isInserting) {
      context.missing(_attemptIdMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('node_id')) {
      context.handle(
        _nodeIdMeta,
        nodeId.isAcceptableOrUnknown(data['node_id']!, _nodeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_nodeIdMeta);
    }
    if (data.containsKey('attributed_node_id')) {
      context.handle(
        _attributedNodeIdMeta,
        attributedNodeId.isAcceptableOrUnknown(
          data['attributed_node_id']!,
          _attributedNodeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_attributedNodeIdMeta);
    }
    if (data.containsKey('error_cause')) {
      context.handle(
        _errorCauseMeta,
        errorCause.isAcceptableOrUnknown(data['error_cause']!, _errorCauseMeta),
      );
    } else if (isInserting) {
      context.missing(_errorCauseMeta);
    }
    if (data.containsKey('digested')) {
      context.handle(
        _digestedMeta,
        digested.isAcceptableOrUnknown(data['digested']!, _digestedMeta),
      );
    }
    if (data.containsKey('snapshot_stem')) {
      context.handle(
        _snapshotStemMeta,
        snapshotStem.isAcceptableOrUnknown(
          data['snapshot_stem']!,
          _snapshotStemMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_snapshotStemMeta);
    }
    if (data.containsKey('snapshot_answer')) {
      context.handle(
        _snapshotAnswerMeta,
        snapshotAnswer.isAcceptableOrUnknown(
          data['snapshot_answer']!,
          _snapshotAnswerMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_snapshotAnswerMeta);
    }
    if (data.containsKey('template_id')) {
      context.handle(
        _templateIdMeta,
        templateId.isAcceptableOrUnknown(data['template_id']!, _templateIdMeta),
      );
    } else if (isInserting) {
      context.missing(_templateIdMeta);
    }
    if (data.containsKey('seed')) {
      context.handle(
        _seedMeta,
        seed.isAcceptableOrUnknown(data['seed']!, _seedMeta),
      );
    } else if (isInserting) {
      context.missing(_seedMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WrongItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WrongItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      attemptId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt_id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      nodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}node_id'],
      )!,
      attributedNodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attributed_node_id'],
      )!,
      errorCause: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_cause'],
      )!,
      digested: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}digested'],
      )!,
      snapshotStem: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}snapshot_stem'],
      )!,
      snapshotAnswer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}snapshot_answer'],
      )!,
      templateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_id'],
      )!,
      seed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seed'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $WrongItemsTable createAlias(String alias) {
    return $WrongItemsTable(attachedDatabase, alias);
  }
}

class WrongItem extends DataClass implements Insertable<WrongItem> {
  final int id;
  final int attemptId;
  final int profileId;
  final String nodeId;
  final String attributedNodeId;
  final String errorCause;
  final bool digested;
  final String snapshotStem;
  final String snapshotAnswer;
  final String templateId;
  final int seed;
  final DateTime createdAt;
  const WrongItem({
    required this.id,
    required this.attemptId,
    required this.profileId,
    required this.nodeId,
    required this.attributedNodeId,
    required this.errorCause,
    required this.digested,
    required this.snapshotStem,
    required this.snapshotAnswer,
    required this.templateId,
    required this.seed,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['attempt_id'] = Variable<int>(attemptId);
    map['profile_id'] = Variable<int>(profileId);
    map['node_id'] = Variable<String>(nodeId);
    map['attributed_node_id'] = Variable<String>(attributedNodeId);
    map['error_cause'] = Variable<String>(errorCause);
    map['digested'] = Variable<bool>(digested);
    map['snapshot_stem'] = Variable<String>(snapshotStem);
    map['snapshot_answer'] = Variable<String>(snapshotAnswer);
    map['template_id'] = Variable<String>(templateId);
    map['seed'] = Variable<int>(seed);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  WrongItemsCompanion toCompanion(bool nullToAbsent) {
    return WrongItemsCompanion(
      id: Value(id),
      attemptId: Value(attemptId),
      profileId: Value(profileId),
      nodeId: Value(nodeId),
      attributedNodeId: Value(attributedNodeId),
      errorCause: Value(errorCause),
      digested: Value(digested),
      snapshotStem: Value(snapshotStem),
      snapshotAnswer: Value(snapshotAnswer),
      templateId: Value(templateId),
      seed: Value(seed),
      createdAt: Value(createdAt),
    );
  }

  factory WrongItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WrongItem(
      id: serializer.fromJson<int>(json['id']),
      attemptId: serializer.fromJson<int>(json['attemptId']),
      profileId: serializer.fromJson<int>(json['profileId']),
      nodeId: serializer.fromJson<String>(json['nodeId']),
      attributedNodeId: serializer.fromJson<String>(json['attributedNodeId']),
      errorCause: serializer.fromJson<String>(json['errorCause']),
      digested: serializer.fromJson<bool>(json['digested']),
      snapshotStem: serializer.fromJson<String>(json['snapshotStem']),
      snapshotAnswer: serializer.fromJson<String>(json['snapshotAnswer']),
      templateId: serializer.fromJson<String>(json['templateId']),
      seed: serializer.fromJson<int>(json['seed']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'attemptId': serializer.toJson<int>(attemptId),
      'profileId': serializer.toJson<int>(profileId),
      'nodeId': serializer.toJson<String>(nodeId),
      'attributedNodeId': serializer.toJson<String>(attributedNodeId),
      'errorCause': serializer.toJson<String>(errorCause),
      'digested': serializer.toJson<bool>(digested),
      'snapshotStem': serializer.toJson<String>(snapshotStem),
      'snapshotAnswer': serializer.toJson<String>(snapshotAnswer),
      'templateId': serializer.toJson<String>(templateId),
      'seed': serializer.toJson<int>(seed),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  WrongItem copyWith({
    int? id,
    int? attemptId,
    int? profileId,
    String? nodeId,
    String? attributedNodeId,
    String? errorCause,
    bool? digested,
    String? snapshotStem,
    String? snapshotAnswer,
    String? templateId,
    int? seed,
    DateTime? createdAt,
  }) => WrongItem(
    id: id ?? this.id,
    attemptId: attemptId ?? this.attemptId,
    profileId: profileId ?? this.profileId,
    nodeId: nodeId ?? this.nodeId,
    attributedNodeId: attributedNodeId ?? this.attributedNodeId,
    errorCause: errorCause ?? this.errorCause,
    digested: digested ?? this.digested,
    snapshotStem: snapshotStem ?? this.snapshotStem,
    snapshotAnswer: snapshotAnswer ?? this.snapshotAnswer,
    templateId: templateId ?? this.templateId,
    seed: seed ?? this.seed,
    createdAt: createdAt ?? this.createdAt,
  );
  WrongItem copyWithCompanion(WrongItemsCompanion data) {
    return WrongItem(
      id: data.id.present ? data.id.value : this.id,
      attemptId: data.attemptId.present ? data.attemptId.value : this.attemptId,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      nodeId: data.nodeId.present ? data.nodeId.value : this.nodeId,
      attributedNodeId: data.attributedNodeId.present
          ? data.attributedNodeId.value
          : this.attributedNodeId,
      errorCause: data.errorCause.present
          ? data.errorCause.value
          : this.errorCause,
      digested: data.digested.present ? data.digested.value : this.digested,
      snapshotStem: data.snapshotStem.present
          ? data.snapshotStem.value
          : this.snapshotStem,
      snapshotAnswer: data.snapshotAnswer.present
          ? data.snapshotAnswer.value
          : this.snapshotAnswer,
      templateId: data.templateId.present
          ? data.templateId.value
          : this.templateId,
      seed: data.seed.present ? data.seed.value : this.seed,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WrongItem(')
          ..write('id: $id, ')
          ..write('attemptId: $attemptId, ')
          ..write('profileId: $profileId, ')
          ..write('nodeId: $nodeId, ')
          ..write('attributedNodeId: $attributedNodeId, ')
          ..write('errorCause: $errorCause, ')
          ..write('digested: $digested, ')
          ..write('snapshotStem: $snapshotStem, ')
          ..write('snapshotAnswer: $snapshotAnswer, ')
          ..write('templateId: $templateId, ')
          ..write('seed: $seed, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    attemptId,
    profileId,
    nodeId,
    attributedNodeId,
    errorCause,
    digested,
    snapshotStem,
    snapshotAnswer,
    templateId,
    seed,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WrongItem &&
          other.id == this.id &&
          other.attemptId == this.attemptId &&
          other.profileId == this.profileId &&
          other.nodeId == this.nodeId &&
          other.attributedNodeId == this.attributedNodeId &&
          other.errorCause == this.errorCause &&
          other.digested == this.digested &&
          other.snapshotStem == this.snapshotStem &&
          other.snapshotAnswer == this.snapshotAnswer &&
          other.templateId == this.templateId &&
          other.seed == this.seed &&
          other.createdAt == this.createdAt);
}

class WrongItemsCompanion extends UpdateCompanion<WrongItem> {
  final Value<int> id;
  final Value<int> attemptId;
  final Value<int> profileId;
  final Value<String> nodeId;
  final Value<String> attributedNodeId;
  final Value<String> errorCause;
  final Value<bool> digested;
  final Value<String> snapshotStem;
  final Value<String> snapshotAnswer;
  final Value<String> templateId;
  final Value<int> seed;
  final Value<DateTime> createdAt;
  const WrongItemsCompanion({
    this.id = const Value.absent(),
    this.attemptId = const Value.absent(),
    this.profileId = const Value.absent(),
    this.nodeId = const Value.absent(),
    this.attributedNodeId = const Value.absent(),
    this.errorCause = const Value.absent(),
    this.digested = const Value.absent(),
    this.snapshotStem = const Value.absent(),
    this.snapshotAnswer = const Value.absent(),
    this.templateId = const Value.absent(),
    this.seed = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  WrongItemsCompanion.insert({
    this.id = const Value.absent(),
    required int attemptId,
    required int profileId,
    required String nodeId,
    required String attributedNodeId,
    required String errorCause,
    this.digested = const Value.absent(),
    required String snapshotStem,
    required String snapshotAnswer,
    required String templateId,
    required int seed,
    required DateTime createdAt,
  }) : attemptId = Value(attemptId),
       profileId = Value(profileId),
       nodeId = Value(nodeId),
       attributedNodeId = Value(attributedNodeId),
       errorCause = Value(errorCause),
       snapshotStem = Value(snapshotStem),
       snapshotAnswer = Value(snapshotAnswer),
       templateId = Value(templateId),
       seed = Value(seed),
       createdAt = Value(createdAt);
  static Insertable<WrongItem> custom({
    Expression<int>? id,
    Expression<int>? attemptId,
    Expression<int>? profileId,
    Expression<String>? nodeId,
    Expression<String>? attributedNodeId,
    Expression<String>? errorCause,
    Expression<bool>? digested,
    Expression<String>? snapshotStem,
    Expression<String>? snapshotAnswer,
    Expression<String>? templateId,
    Expression<int>? seed,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (attemptId != null) 'attempt_id': attemptId,
      if (profileId != null) 'profile_id': profileId,
      if (nodeId != null) 'node_id': nodeId,
      if (attributedNodeId != null) 'attributed_node_id': attributedNodeId,
      if (errorCause != null) 'error_cause': errorCause,
      if (digested != null) 'digested': digested,
      if (snapshotStem != null) 'snapshot_stem': snapshotStem,
      if (snapshotAnswer != null) 'snapshot_answer': snapshotAnswer,
      if (templateId != null) 'template_id': templateId,
      if (seed != null) 'seed': seed,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  WrongItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? attemptId,
    Value<int>? profileId,
    Value<String>? nodeId,
    Value<String>? attributedNodeId,
    Value<String>? errorCause,
    Value<bool>? digested,
    Value<String>? snapshotStem,
    Value<String>? snapshotAnswer,
    Value<String>? templateId,
    Value<int>? seed,
    Value<DateTime>? createdAt,
  }) {
    return WrongItemsCompanion(
      id: id ?? this.id,
      attemptId: attemptId ?? this.attemptId,
      profileId: profileId ?? this.profileId,
      nodeId: nodeId ?? this.nodeId,
      attributedNodeId: attributedNodeId ?? this.attributedNodeId,
      errorCause: errorCause ?? this.errorCause,
      digested: digested ?? this.digested,
      snapshotStem: snapshotStem ?? this.snapshotStem,
      snapshotAnswer: snapshotAnswer ?? this.snapshotAnswer,
      templateId: templateId ?? this.templateId,
      seed: seed ?? this.seed,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (attemptId.present) {
      map['attempt_id'] = Variable<int>(attemptId.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (nodeId.present) {
      map['node_id'] = Variable<String>(nodeId.value);
    }
    if (attributedNodeId.present) {
      map['attributed_node_id'] = Variable<String>(attributedNodeId.value);
    }
    if (errorCause.present) {
      map['error_cause'] = Variable<String>(errorCause.value);
    }
    if (digested.present) {
      map['digested'] = Variable<bool>(digested.value);
    }
    if (snapshotStem.present) {
      map['snapshot_stem'] = Variable<String>(snapshotStem.value);
    }
    if (snapshotAnswer.present) {
      map['snapshot_answer'] = Variable<String>(snapshotAnswer.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<String>(templateId.value);
    }
    if (seed.present) {
      map['seed'] = Variable<int>(seed.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WrongItemsCompanion(')
          ..write('id: $id, ')
          ..write('attemptId: $attemptId, ')
          ..write('profileId: $profileId, ')
          ..write('nodeId: $nodeId, ')
          ..write('attributedNodeId: $attributedNodeId, ')
          ..write('errorCause: $errorCause, ')
          ..write('digested: $digested, ')
          ..write('snapshotStem: $snapshotStem, ')
          ..write('snapshotAnswer: $snapshotAnswer, ')
          ..write('templateId: $templateId, ')
          ..write('seed: $seed, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $NodeProgressRowsTable nodeProgressRows = $NodeProgressRowsTable(
    this,
  );
  late final $AttemptsTable attempts = $AttemptsTable(this);
  late final $WrongItemsTable wrongItems = $WrongItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    profiles,
    nodeProgressRows,
    attempts,
    wrongItems,
  ];
}

typedef $$ProfilesTableCreateCompanionBuilder =
    ProfilesCompanion Function({
      Value<int> id,
      required String nickname,
      required String stage,
      required DateTime createdAt,
    });
typedef $$ProfilesTableUpdateCompanionBuilder =
    ProfilesCompanion Function({
      Value<int> id,
      Value<String> nickname,
      Value<String> stage,
      Value<DateTime> createdAt,
    });

class $$ProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stage => $composableBuilder(
    column: $table.stage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stage => $composableBuilder(
    column: $table.stage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nickname =>
      $composableBuilder(column: $table.nickname, builder: (column) => column);

  GeneratedColumn<String> get stage =>
      $composableBuilder(column: $table.stage, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfilesTable,
          Profile,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (Profile, BaseReferences<_$AppDatabase, $ProfilesTable, Profile>),
          Profile,
          PrefetchHooks Function()
        > {
  $$ProfilesTableTableManager(_$AppDatabase db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nickname = const Value.absent(),
                Value<String> stage = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProfilesCompanion(
                id: id,
                nickname: nickname,
                stage: stage,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nickname,
                required String stage,
                required DateTime createdAt,
              }) => ProfilesCompanion.insert(
                id: id,
                nickname: nickname,
                stage: stage,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfilesTable,
      Profile,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (Profile, BaseReferences<_$AppDatabase, $ProfilesTable, Profile>),
      Profile,
      PrefetchHooks Function()
    >;
typedef $$NodeProgressRowsTableCreateCompanionBuilder =
    NodeProgressRowsCompanion Function({
      required int profileId,
      required String nodeId,
      required bool unlocked,
      Value<bool> mastered,
      Value<int> attempts,
      Value<int> correctCount,
      Value<int> consecutive,
      Value<DateTime?> unlockedAt,
      Value<DateTime?> masteredAt,
      Value<int> rowid,
    });
typedef $$NodeProgressRowsTableUpdateCompanionBuilder =
    NodeProgressRowsCompanion Function({
      Value<int> profileId,
      Value<String> nodeId,
      Value<bool> unlocked,
      Value<bool> mastered,
      Value<int> attempts,
      Value<int> correctCount,
      Value<int> consecutive,
      Value<DateTime?> unlockedAt,
      Value<DateTime?> masteredAt,
      Value<int> rowid,
    });

class $$NodeProgressRowsTableFilterComposer
    extends Composer<_$AppDatabase, $NodeProgressRowsTable> {
  $$NodeProgressRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nodeId => $composableBuilder(
    column: $table.nodeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get unlocked => $composableBuilder(
    column: $table.unlocked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get mastered => $composableBuilder(
    column: $table.mastered,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correctCount => $composableBuilder(
    column: $table.correctCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get consecutive => $composableBuilder(
    column: $table.consecutive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get masteredAt => $composableBuilder(
    column: $table.masteredAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NodeProgressRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $NodeProgressRowsTable> {
  $$NodeProgressRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nodeId => $composableBuilder(
    column: $table.nodeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get unlocked => $composableBuilder(
    column: $table.unlocked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get mastered => $composableBuilder(
    column: $table.mastered,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctCount => $composableBuilder(
    column: $table.correctCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get consecutive => $composableBuilder(
    column: $table.consecutive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get masteredAt => $composableBuilder(
    column: $table.masteredAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NodeProgressRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NodeProgressRowsTable> {
  $$NodeProgressRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get nodeId =>
      $composableBuilder(column: $table.nodeId, builder: (column) => column);

  GeneratedColumn<bool> get unlocked =>
      $composableBuilder(column: $table.unlocked, builder: (column) => column);

  GeneratedColumn<bool> get mastered =>
      $composableBuilder(column: $table.mastered, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<int> get correctCount => $composableBuilder(
    column: $table.correctCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get consecutive => $composableBuilder(
    column: $table.consecutive,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get masteredAt => $composableBuilder(
    column: $table.masteredAt,
    builder: (column) => column,
  );
}

class $$NodeProgressRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NodeProgressRowsTable,
          NodeProgressRow,
          $$NodeProgressRowsTableFilterComposer,
          $$NodeProgressRowsTableOrderingComposer,
          $$NodeProgressRowsTableAnnotationComposer,
          $$NodeProgressRowsTableCreateCompanionBuilder,
          $$NodeProgressRowsTableUpdateCompanionBuilder,
          (
            NodeProgressRow,
            BaseReferences<
              _$AppDatabase,
              $NodeProgressRowsTable,
              NodeProgressRow
            >,
          ),
          NodeProgressRow,
          PrefetchHooks Function()
        > {
  $$NodeProgressRowsTableTableManager(
    _$AppDatabase db,
    $NodeProgressRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NodeProgressRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NodeProgressRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NodeProgressRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> profileId = const Value.absent(),
                Value<String> nodeId = const Value.absent(),
                Value<bool> unlocked = const Value.absent(),
                Value<bool> mastered = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<int> correctCount = const Value.absent(),
                Value<int> consecutive = const Value.absent(),
                Value<DateTime?> unlockedAt = const Value.absent(),
                Value<DateTime?> masteredAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NodeProgressRowsCompanion(
                profileId: profileId,
                nodeId: nodeId,
                unlocked: unlocked,
                mastered: mastered,
                attempts: attempts,
                correctCount: correctCount,
                consecutive: consecutive,
                unlockedAt: unlockedAt,
                masteredAt: masteredAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int profileId,
                required String nodeId,
                required bool unlocked,
                Value<bool> mastered = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<int> correctCount = const Value.absent(),
                Value<int> consecutive = const Value.absent(),
                Value<DateTime?> unlockedAt = const Value.absent(),
                Value<DateTime?> masteredAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NodeProgressRowsCompanion.insert(
                profileId: profileId,
                nodeId: nodeId,
                unlocked: unlocked,
                mastered: mastered,
                attempts: attempts,
                correctCount: correctCount,
                consecutive: consecutive,
                unlockedAt: unlockedAt,
                masteredAt: masteredAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NodeProgressRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NodeProgressRowsTable,
      NodeProgressRow,
      $$NodeProgressRowsTableFilterComposer,
      $$NodeProgressRowsTableOrderingComposer,
      $$NodeProgressRowsTableAnnotationComposer,
      $$NodeProgressRowsTableCreateCompanionBuilder,
      $$NodeProgressRowsTableUpdateCompanionBuilder,
      (
        NodeProgressRow,
        BaseReferences<_$AppDatabase, $NodeProgressRowsTable, NodeProgressRow>,
      ),
      NodeProgressRow,
      PrefetchHooks Function()
    >;
typedef $$AttemptsTableCreateCompanionBuilder =
    AttemptsCompanion Function({
      Value<int> id,
      required int profileId,
      required String nodeId,
      required String templateId,
      required int seed,
      required String userAnswer,
      required bool isCorrect,
      required int hintsUsed,
      Value<String?> errorCause,
      Value<String?> attributedNodeId,
      required String sessionId,
      required String mode,
      required DateTime createdAt,
    });
typedef $$AttemptsTableUpdateCompanionBuilder =
    AttemptsCompanion Function({
      Value<int> id,
      Value<int> profileId,
      Value<String> nodeId,
      Value<String> templateId,
      Value<int> seed,
      Value<String> userAnswer,
      Value<bool> isCorrect,
      Value<int> hintsUsed,
      Value<String?> errorCause,
      Value<String?> attributedNodeId,
      Value<String> sessionId,
      Value<String> mode,
      Value<DateTime> createdAt,
    });

class $$AttemptsTableFilterComposer
    extends Composer<_$AppDatabase, $AttemptsTable> {
  $$AttemptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nodeId => $composableBuilder(
    column: $table.nodeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seed => $composableBuilder(
    column: $table.seed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userAnswer => $composableBuilder(
    column: $table.userAnswer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCorrect => $composableBuilder(
    column: $table.isCorrect,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hintsUsed => $composableBuilder(
    column: $table.hintsUsed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorCause => $composableBuilder(
    column: $table.errorCause,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get attributedNodeId => $composableBuilder(
    column: $table.attributedNodeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AttemptsTableOrderingComposer
    extends Composer<_$AppDatabase, $AttemptsTable> {
  $$AttemptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nodeId => $composableBuilder(
    column: $table.nodeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seed => $composableBuilder(
    column: $table.seed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userAnswer => $composableBuilder(
    column: $table.userAnswer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCorrect => $composableBuilder(
    column: $table.isCorrect,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hintsUsed => $composableBuilder(
    column: $table.hintsUsed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorCause => $composableBuilder(
    column: $table.errorCause,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attributedNodeId => $composableBuilder(
    column: $table.attributedNodeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AttemptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttemptsTable> {
  $$AttemptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get nodeId =>
      $composableBuilder(column: $table.nodeId, builder: (column) => column);

  GeneratedColumn<String> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get seed =>
      $composableBuilder(column: $table.seed, builder: (column) => column);

  GeneratedColumn<String> get userAnswer => $composableBuilder(
    column: $table.userAnswer,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCorrect =>
      $composableBuilder(column: $table.isCorrect, builder: (column) => column);

  GeneratedColumn<int> get hintsUsed =>
      $composableBuilder(column: $table.hintsUsed, builder: (column) => column);

  GeneratedColumn<String> get errorCause => $composableBuilder(
    column: $table.errorCause,
    builder: (column) => column,
  );

  GeneratedColumn<String> get attributedNodeId => $composableBuilder(
    column: $table.attributedNodeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AttemptsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AttemptsTable,
          Attempt,
          $$AttemptsTableFilterComposer,
          $$AttemptsTableOrderingComposer,
          $$AttemptsTableAnnotationComposer,
          $$AttemptsTableCreateCompanionBuilder,
          $$AttemptsTableUpdateCompanionBuilder,
          (Attempt, BaseReferences<_$AppDatabase, $AttemptsTable, Attempt>),
          Attempt,
          PrefetchHooks Function()
        > {
  $$AttemptsTableTableManager(_$AppDatabase db, $AttemptsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttemptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttemptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttemptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> profileId = const Value.absent(),
                Value<String> nodeId = const Value.absent(),
                Value<String> templateId = const Value.absent(),
                Value<int> seed = const Value.absent(),
                Value<String> userAnswer = const Value.absent(),
                Value<bool> isCorrect = const Value.absent(),
                Value<int> hintsUsed = const Value.absent(),
                Value<String?> errorCause = const Value.absent(),
                Value<String?> attributedNodeId = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AttemptsCompanion(
                id: id,
                profileId: profileId,
                nodeId: nodeId,
                templateId: templateId,
                seed: seed,
                userAnswer: userAnswer,
                isCorrect: isCorrect,
                hintsUsed: hintsUsed,
                errorCause: errorCause,
                attributedNodeId: attributedNodeId,
                sessionId: sessionId,
                mode: mode,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int profileId,
                required String nodeId,
                required String templateId,
                required int seed,
                required String userAnswer,
                required bool isCorrect,
                required int hintsUsed,
                Value<String?> errorCause = const Value.absent(),
                Value<String?> attributedNodeId = const Value.absent(),
                required String sessionId,
                required String mode,
                required DateTime createdAt,
              }) => AttemptsCompanion.insert(
                id: id,
                profileId: profileId,
                nodeId: nodeId,
                templateId: templateId,
                seed: seed,
                userAnswer: userAnswer,
                isCorrect: isCorrect,
                hintsUsed: hintsUsed,
                errorCause: errorCause,
                attributedNodeId: attributedNodeId,
                sessionId: sessionId,
                mode: mode,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AttemptsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AttemptsTable,
      Attempt,
      $$AttemptsTableFilterComposer,
      $$AttemptsTableOrderingComposer,
      $$AttemptsTableAnnotationComposer,
      $$AttemptsTableCreateCompanionBuilder,
      $$AttemptsTableUpdateCompanionBuilder,
      (Attempt, BaseReferences<_$AppDatabase, $AttemptsTable, Attempt>),
      Attempt,
      PrefetchHooks Function()
    >;
typedef $$WrongItemsTableCreateCompanionBuilder =
    WrongItemsCompanion Function({
      Value<int> id,
      required int attemptId,
      required int profileId,
      required String nodeId,
      required String attributedNodeId,
      required String errorCause,
      Value<bool> digested,
      required String snapshotStem,
      required String snapshotAnswer,
      required String templateId,
      required int seed,
      required DateTime createdAt,
    });
typedef $$WrongItemsTableUpdateCompanionBuilder =
    WrongItemsCompanion Function({
      Value<int> id,
      Value<int> attemptId,
      Value<int> profileId,
      Value<String> nodeId,
      Value<String> attributedNodeId,
      Value<String> errorCause,
      Value<bool> digested,
      Value<String> snapshotStem,
      Value<String> snapshotAnswer,
      Value<String> templateId,
      Value<int> seed,
      Value<DateTime> createdAt,
    });

class $$WrongItemsTableFilterComposer
    extends Composer<_$AppDatabase, $WrongItemsTable> {
  $$WrongItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attemptId => $composableBuilder(
    column: $table.attemptId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nodeId => $composableBuilder(
    column: $table.nodeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get attributedNodeId => $composableBuilder(
    column: $table.attributedNodeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorCause => $composableBuilder(
    column: $table.errorCause,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get digested => $composableBuilder(
    column: $table.digested,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get snapshotStem => $composableBuilder(
    column: $table.snapshotStem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get snapshotAnswer => $composableBuilder(
    column: $table.snapshotAnswer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seed => $composableBuilder(
    column: $table.seed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WrongItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $WrongItemsTable> {
  $$WrongItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attemptId => $composableBuilder(
    column: $table.attemptId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nodeId => $composableBuilder(
    column: $table.nodeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attributedNodeId => $composableBuilder(
    column: $table.attributedNodeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorCause => $composableBuilder(
    column: $table.errorCause,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get digested => $composableBuilder(
    column: $table.digested,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get snapshotStem => $composableBuilder(
    column: $table.snapshotStem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get snapshotAnswer => $composableBuilder(
    column: $table.snapshotAnswer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seed => $composableBuilder(
    column: $table.seed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WrongItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WrongItemsTable> {
  $$WrongItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get attemptId =>
      $composableBuilder(column: $table.attemptId, builder: (column) => column);

  GeneratedColumn<int> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get nodeId =>
      $composableBuilder(column: $table.nodeId, builder: (column) => column);

  GeneratedColumn<String> get attributedNodeId => $composableBuilder(
    column: $table.attributedNodeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get errorCause => $composableBuilder(
    column: $table.errorCause,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get digested =>
      $composableBuilder(column: $table.digested, builder: (column) => column);

  GeneratedColumn<String> get snapshotStem => $composableBuilder(
    column: $table.snapshotStem,
    builder: (column) => column,
  );

  GeneratedColumn<String> get snapshotAnswer => $composableBuilder(
    column: $table.snapshotAnswer,
    builder: (column) => column,
  );

  GeneratedColumn<String> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get seed =>
      $composableBuilder(column: $table.seed, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$WrongItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WrongItemsTable,
          WrongItem,
          $$WrongItemsTableFilterComposer,
          $$WrongItemsTableOrderingComposer,
          $$WrongItemsTableAnnotationComposer,
          $$WrongItemsTableCreateCompanionBuilder,
          $$WrongItemsTableUpdateCompanionBuilder,
          (
            WrongItem,
            BaseReferences<_$AppDatabase, $WrongItemsTable, WrongItem>,
          ),
          WrongItem,
          PrefetchHooks Function()
        > {
  $$WrongItemsTableTableManager(_$AppDatabase db, $WrongItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WrongItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WrongItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WrongItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> attemptId = const Value.absent(),
                Value<int> profileId = const Value.absent(),
                Value<String> nodeId = const Value.absent(),
                Value<String> attributedNodeId = const Value.absent(),
                Value<String> errorCause = const Value.absent(),
                Value<bool> digested = const Value.absent(),
                Value<String> snapshotStem = const Value.absent(),
                Value<String> snapshotAnswer = const Value.absent(),
                Value<String> templateId = const Value.absent(),
                Value<int> seed = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => WrongItemsCompanion(
                id: id,
                attemptId: attemptId,
                profileId: profileId,
                nodeId: nodeId,
                attributedNodeId: attributedNodeId,
                errorCause: errorCause,
                digested: digested,
                snapshotStem: snapshotStem,
                snapshotAnswer: snapshotAnswer,
                templateId: templateId,
                seed: seed,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int attemptId,
                required int profileId,
                required String nodeId,
                required String attributedNodeId,
                required String errorCause,
                Value<bool> digested = const Value.absent(),
                required String snapshotStem,
                required String snapshotAnswer,
                required String templateId,
                required int seed,
                required DateTime createdAt,
              }) => WrongItemsCompanion.insert(
                id: id,
                attemptId: attemptId,
                profileId: profileId,
                nodeId: nodeId,
                attributedNodeId: attributedNodeId,
                errorCause: errorCause,
                digested: digested,
                snapshotStem: snapshotStem,
                snapshotAnswer: snapshotAnswer,
                templateId: templateId,
                seed: seed,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WrongItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WrongItemsTable,
      WrongItem,
      $$WrongItemsTableFilterComposer,
      $$WrongItemsTableOrderingComposer,
      $$WrongItemsTableAnnotationComposer,
      $$WrongItemsTableCreateCompanionBuilder,
      $$WrongItemsTableUpdateCompanionBuilder,
      (WrongItem, BaseReferences<_$AppDatabase, $WrongItemsTable, WrongItem>),
      WrongItem,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$NodeProgressRowsTableTableManager get nodeProgressRows =>
      $$NodeProgressRowsTableTableManager(_db, _db.nodeProgressRows);
  $$AttemptsTableTableManager get attempts =>
      $$AttemptsTableTableManager(_db, _db.attempts);
  $$WrongItemsTableTableManager get wrongItems =>
      $$WrongItemsTableTableManager(_db, _db.wrongItems);
}
