// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LoginUsersTable extends LoginUsers
    with TableInfo<$LoginUsersTable, LoginUser> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LoginUsersTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _passwordMeta = const VerificationMeta(
    'password',
  );
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
    'password',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, email, password, name, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'login_users';
  @override
  VerificationContext validateIntegrity(
    Insertable<LoginUser> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('password')) {
      context.handle(
        _passwordMeta,
        password.isAcceptableOrUnknown(data['password']!, _passwordMeta),
      );
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LoginUser map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LoginUser(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      password: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
    );
  }

  @override
  $LoginUsersTable createAlias(String alias) {
    return $LoginUsersTable(attachedDatabase, alias);
  }
}

class LoginUser extends DataClass implements Insertable<LoginUser> {
  final int id;
  final String email;
  final String password;
  final String? name;
  final DateTime? createdAt;
  const LoginUser({
    required this.id,
    required this.email,
    required this.password,
    this.name,
    this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['email'] = Variable<String>(email);
    map['password'] = Variable<String>(password);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  LoginUsersCompanion toCompanion(bool nullToAbsent) {
    return LoginUsersCompanion(
      id: Value(id),
      email: Value(email),
      password: Value(password),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory LoginUser.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LoginUser(
      id: serializer.fromJson<int>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      password: serializer.fromJson<String>(json['password']),
      name: serializer.fromJson<String?>(json['name']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'email': serializer.toJson<String>(email),
      'password': serializer.toJson<String>(password),
      'name': serializer.toJson<String?>(name),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  LoginUser copyWith({
    int? id,
    String? email,
    String? password,
    Value<String?> name = const Value.absent(),
    Value<DateTime?> createdAt = const Value.absent(),
  }) => LoginUser(
    id: id ?? this.id,
    email: email ?? this.email,
    password: password ?? this.password,
    name: name.present ? name.value : this.name,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
  );
  LoginUser copyWithCompanion(LoginUsersCompanion data) {
    return LoginUser(
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      password: data.password.present ? data.password.value : this.password,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LoginUser(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('password: $password, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, email, password, name, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LoginUser &&
          other.id == this.id &&
          other.email == this.email &&
          other.password == this.password &&
          other.name == this.name &&
          other.createdAt == this.createdAt);
}

class LoginUsersCompanion extends UpdateCompanion<LoginUser> {
  final Value<int> id;
  final Value<String> email;
  final Value<String> password;
  final Value<String?> name;
  final Value<DateTime?> createdAt;
  const LoginUsersCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.password = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  LoginUsersCompanion.insert({
    this.id = const Value.absent(),
    required String email,
    required String password,
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : email = Value(email),
       password = Value(password);
  static Insertable<LoginUser> custom({
    Expression<int>? id,
    Expression<String>? email,
    Expression<String>? password,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (password != null) 'password': password,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  LoginUsersCompanion copyWith({
    Value<int>? id,
    Value<String>? email,
    Value<String>? password,
    Value<String?>? name,
    Value<DateTime?>? createdAt,
  }) {
    return LoginUsersCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LoginUsersCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('password: $password, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $LessonSlotsTable extends LessonSlots
    with TableInfo<$LessonSlotsTable, LessonSlot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonSlotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES login_users (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeSlotMeta = const VerificationMeta(
    'timeSlot',
  );
  @override
  late final GeneratedColumn<String> timeSlot = GeneratedColumn<String>(
    'time_slot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalSpots5Meta = const VerificationMeta(
    'totalSpots5',
  );
  @override
  late final GeneratedColumn<int> totalSpots5 = GeneratedColumn<int>(
    'total_spots5',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _availableSpotsMeta = const VerificationMeta(
    'availableSpots',
  );
  @override
  late final GeneratedColumn<int> availableSpots = GeneratedColumn<int>(
    'available_spots',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isBookedMeta = const VerificationMeta(
    'isBooked',
  );
  @override
  late final GeneratedColumn<bool> isBooked = GeneratedColumn<bool>(
    'is_booked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_booked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _studentNameMeta = const VerificationMeta(
    'studentName',
  );
  @override
  late final GeneratedColumn<String> studentName = GeneratedColumn<String>(
    'student_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _studentPhoneMeta = const VerificationMeta(
    'studentPhone',
  );
  @override
  late final GeneratedColumn<String> studentPhone = GeneratedColumn<String>(
    'student_phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _studentEmailMeta = const VerificationMeta(
    'studentEmail',
  );
  @override
  late final GeneratedColumn<String> studentEmail = GeneratedColumn<String>(
    'student_email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    title,
    date,
    timeSlot,
    totalSpots5,
    availableSpots,
    isBooked,
    studentName,
    studentPhone,
    studentEmail,
    price,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lesson_slots';
  @override
  VerificationContext validateIntegrity(
    Insertable<LessonSlot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('time_slot')) {
      context.handle(
        _timeSlotMeta,
        timeSlot.isAcceptableOrUnknown(data['time_slot']!, _timeSlotMeta),
      );
    } else if (isInserting) {
      context.missing(_timeSlotMeta);
    }
    if (data.containsKey('total_spots5')) {
      context.handle(
        _totalSpots5Meta,
        totalSpots5.isAcceptableOrUnknown(
          data['total_spots5']!,
          _totalSpots5Meta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalSpots5Meta);
    }
    if (data.containsKey('available_spots')) {
      context.handle(
        _availableSpotsMeta,
        availableSpots.isAcceptableOrUnknown(
          data['available_spots']!,
          _availableSpotsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_availableSpotsMeta);
    }
    if (data.containsKey('is_booked')) {
      context.handle(
        _isBookedMeta,
        isBooked.isAcceptableOrUnknown(data['is_booked']!, _isBookedMeta),
      );
    }
    if (data.containsKey('student_name')) {
      context.handle(
        _studentNameMeta,
        studentName.isAcceptableOrUnknown(
          data['student_name']!,
          _studentNameMeta,
        ),
      );
    }
    if (data.containsKey('student_phone')) {
      context.handle(
        _studentPhoneMeta,
        studentPhone.isAcceptableOrUnknown(
          data['student_phone']!,
          _studentPhoneMeta,
        ),
      );
    }
    if (data.containsKey('student_email')) {
      context.handle(
        _studentEmailMeta,
        studentEmail.isAcceptableOrUnknown(
          data['student_email']!,
          _studentEmailMeta,
        ),
      );
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LessonSlot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LessonSlot(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      timeSlot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_slot'],
      )!,
      totalSpots5: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_spots5'],
      )!,
      availableSpots: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}available_spots'],
      )!,
      isBooked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_booked'],
      )!,
      studentName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_name'],
      ),
      studentPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_phone'],
      ),
      studentEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_email'],
      ),
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
    );
  }

  @override
  $LessonSlotsTable createAlias(String alias) {
    return $LessonSlotsTable(attachedDatabase, alias);
  }
}

class LessonSlot extends DataClass implements Insertable<LessonSlot> {
  final String id;
  final int? userId;
  final String title;
  final String date;
  final String timeSlot;
  final int totalSpots5;
  final int availableSpots;
  final bool isBooked;
  final String? studentName;
  final String? studentPhone;
  final String? studentEmail;
  final double price;
  const LessonSlot({
    required this.id,
    this.userId,
    required this.title,
    required this.date,
    required this.timeSlot,
    required this.totalSpots5,
    required this.availableSpots,
    required this.isBooked,
    this.studentName,
    this.studentPhone,
    this.studentEmail,
    required this.price,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<int>(userId);
    }
    map['title'] = Variable<String>(title);
    map['date'] = Variable<String>(date);
    map['time_slot'] = Variable<String>(timeSlot);
    map['total_spots5'] = Variable<int>(totalSpots5);
    map['available_spots'] = Variable<int>(availableSpots);
    map['is_booked'] = Variable<bool>(isBooked);
    if (!nullToAbsent || studentName != null) {
      map['student_name'] = Variable<String>(studentName);
    }
    if (!nullToAbsent || studentPhone != null) {
      map['student_phone'] = Variable<String>(studentPhone);
    }
    if (!nullToAbsent || studentEmail != null) {
      map['student_email'] = Variable<String>(studentEmail);
    }
    map['price'] = Variable<double>(price);
    return map;
  }

  LessonSlotsCompanion toCompanion(bool nullToAbsent) {
    return LessonSlotsCompanion(
      id: Value(id),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      title: Value(title),
      date: Value(date),
      timeSlot: Value(timeSlot),
      totalSpots5: Value(totalSpots5),
      availableSpots: Value(availableSpots),
      isBooked: Value(isBooked),
      studentName: studentName == null && nullToAbsent
          ? const Value.absent()
          : Value(studentName),
      studentPhone: studentPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(studentPhone),
      studentEmail: studentEmail == null && nullToAbsent
          ? const Value.absent()
          : Value(studentEmail),
      price: Value(price),
    );
  }

  factory LessonSlot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LessonSlot(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<int?>(json['userId']),
      title: serializer.fromJson<String>(json['title']),
      date: serializer.fromJson<String>(json['date']),
      timeSlot: serializer.fromJson<String>(json['timeSlot']),
      totalSpots5: serializer.fromJson<int>(json['totalSpots5']),
      availableSpots: serializer.fromJson<int>(json['availableSpots']),
      isBooked: serializer.fromJson<bool>(json['isBooked']),
      studentName: serializer.fromJson<String?>(json['studentName']),
      studentPhone: serializer.fromJson<String?>(json['studentPhone']),
      studentEmail: serializer.fromJson<String?>(json['studentEmail']),
      price: serializer.fromJson<double>(json['price']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<int?>(userId),
      'title': serializer.toJson<String>(title),
      'date': serializer.toJson<String>(date),
      'timeSlot': serializer.toJson<String>(timeSlot),
      'totalSpots5': serializer.toJson<int>(totalSpots5),
      'availableSpots': serializer.toJson<int>(availableSpots),
      'isBooked': serializer.toJson<bool>(isBooked),
      'studentName': serializer.toJson<String?>(studentName),
      'studentPhone': serializer.toJson<String?>(studentPhone),
      'studentEmail': serializer.toJson<String?>(studentEmail),
      'price': serializer.toJson<double>(price),
    };
  }

  LessonSlot copyWith({
    String? id,
    Value<int?> userId = const Value.absent(),
    String? title,
    String? date,
    String? timeSlot,
    int? totalSpots5,
    int? availableSpots,
    bool? isBooked,
    Value<String?> studentName = const Value.absent(),
    Value<String?> studentPhone = const Value.absent(),
    Value<String?> studentEmail = const Value.absent(),
    double? price,
  }) => LessonSlot(
    id: id ?? this.id,
    userId: userId.present ? userId.value : this.userId,
    title: title ?? this.title,
    date: date ?? this.date,
    timeSlot: timeSlot ?? this.timeSlot,
    totalSpots5: totalSpots5 ?? this.totalSpots5,
    availableSpots: availableSpots ?? this.availableSpots,
    isBooked: isBooked ?? this.isBooked,
    studentName: studentName.present ? studentName.value : this.studentName,
    studentPhone: studentPhone.present ? studentPhone.value : this.studentPhone,
    studentEmail: studentEmail.present ? studentEmail.value : this.studentEmail,
    price: price ?? this.price,
  );
  LessonSlot copyWithCompanion(LessonSlotsCompanion data) {
    return LessonSlot(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      title: data.title.present ? data.title.value : this.title,
      date: data.date.present ? data.date.value : this.date,
      timeSlot: data.timeSlot.present ? data.timeSlot.value : this.timeSlot,
      totalSpots5: data.totalSpots5.present
          ? data.totalSpots5.value
          : this.totalSpots5,
      availableSpots: data.availableSpots.present
          ? data.availableSpots.value
          : this.availableSpots,
      isBooked: data.isBooked.present ? data.isBooked.value : this.isBooked,
      studentName: data.studentName.present
          ? data.studentName.value
          : this.studentName,
      studentPhone: data.studentPhone.present
          ? data.studentPhone.value
          : this.studentPhone,
      studentEmail: data.studentEmail.present
          ? data.studentEmail.value
          : this.studentEmail,
      price: data.price.present ? data.price.value : this.price,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LessonSlot(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('date: $date, ')
          ..write('timeSlot: $timeSlot, ')
          ..write('totalSpots5: $totalSpots5, ')
          ..write('availableSpots: $availableSpots, ')
          ..write('isBooked: $isBooked, ')
          ..write('studentName: $studentName, ')
          ..write('studentPhone: $studentPhone, ')
          ..write('studentEmail: $studentEmail, ')
          ..write('price: $price')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    title,
    date,
    timeSlot,
    totalSpots5,
    availableSpots,
    isBooked,
    studentName,
    studentPhone,
    studentEmail,
    price,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LessonSlot &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.title == this.title &&
          other.date == this.date &&
          other.timeSlot == this.timeSlot &&
          other.totalSpots5 == this.totalSpots5 &&
          other.availableSpots == this.availableSpots &&
          other.isBooked == this.isBooked &&
          other.studentName == this.studentName &&
          other.studentPhone == this.studentPhone &&
          other.studentEmail == this.studentEmail &&
          other.price == this.price);
}

class LessonSlotsCompanion extends UpdateCompanion<LessonSlot> {
  final Value<String> id;
  final Value<int?> userId;
  final Value<String> title;
  final Value<String> date;
  final Value<String> timeSlot;
  final Value<int> totalSpots5;
  final Value<int> availableSpots;
  final Value<bool> isBooked;
  final Value<String?> studentName;
  final Value<String?> studentPhone;
  final Value<String?> studentEmail;
  final Value<double> price;
  final Value<int> rowid;
  const LessonSlotsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.title = const Value.absent(),
    this.date = const Value.absent(),
    this.timeSlot = const Value.absent(),
    this.totalSpots5 = const Value.absent(),
    this.availableSpots = const Value.absent(),
    this.isBooked = const Value.absent(),
    this.studentName = const Value.absent(),
    this.studentPhone = const Value.absent(),
    this.studentEmail = const Value.absent(),
    this.price = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LessonSlotsCompanion.insert({
    required String id,
    this.userId = const Value.absent(),
    required String title,
    required String date,
    required String timeSlot,
    required int totalSpots5,
    required int availableSpots,
    this.isBooked = const Value.absent(),
    this.studentName = const Value.absent(),
    this.studentPhone = const Value.absent(),
    this.studentEmail = const Value.absent(),
    this.price = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       date = Value(date),
       timeSlot = Value(timeSlot),
       totalSpots5 = Value(totalSpots5),
       availableSpots = Value(availableSpots);
  static Insertable<LessonSlot> custom({
    Expression<String>? id,
    Expression<int>? userId,
    Expression<String>? title,
    Expression<String>? date,
    Expression<String>? timeSlot,
    Expression<int>? totalSpots5,
    Expression<int>? availableSpots,
    Expression<bool>? isBooked,
    Expression<String>? studentName,
    Expression<String>? studentPhone,
    Expression<String>? studentEmail,
    Expression<double>? price,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (title != null) 'title': title,
      if (date != null) 'date': date,
      if (timeSlot != null) 'time_slot': timeSlot,
      if (totalSpots5 != null) 'total_spots5': totalSpots5,
      if (availableSpots != null) 'available_spots': availableSpots,
      if (isBooked != null) 'is_booked': isBooked,
      if (studentName != null) 'student_name': studentName,
      if (studentPhone != null) 'student_phone': studentPhone,
      if (studentEmail != null) 'student_email': studentEmail,
      if (price != null) 'price': price,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LessonSlotsCompanion copyWith({
    Value<String>? id,
    Value<int?>? userId,
    Value<String>? title,
    Value<String>? date,
    Value<String>? timeSlot,
    Value<int>? totalSpots5,
    Value<int>? availableSpots,
    Value<bool>? isBooked,
    Value<String?>? studentName,
    Value<String?>? studentPhone,
    Value<String?>? studentEmail,
    Value<double>? price,
    Value<int>? rowid,
  }) {
    return LessonSlotsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      date: date ?? this.date,
      timeSlot: timeSlot ?? this.timeSlot,
      totalSpots5: totalSpots5 ?? this.totalSpots5,
      availableSpots: availableSpots ?? this.availableSpots,
      isBooked: isBooked ?? this.isBooked,
      studentName: studentName ?? this.studentName,
      studentPhone: studentPhone ?? this.studentPhone,
      studentEmail: studentEmail ?? this.studentEmail,
      price: price ?? this.price,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (timeSlot.present) {
      map['time_slot'] = Variable<String>(timeSlot.value);
    }
    if (totalSpots5.present) {
      map['total_spots5'] = Variable<int>(totalSpots5.value);
    }
    if (availableSpots.present) {
      map['available_spots'] = Variable<int>(availableSpots.value);
    }
    if (isBooked.present) {
      map['is_booked'] = Variable<bool>(isBooked.value);
    }
    if (studentName.present) {
      map['student_name'] = Variable<String>(studentName.value);
    }
    if (studentPhone.present) {
      map['student_phone'] = Variable<String>(studentPhone.value);
    }
    if (studentEmail.present) {
      map['student_email'] = Variable<String>(studentEmail.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonSlotsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('date: $date, ')
          ..write('timeSlot: $timeSlot, ')
          ..write('totalSpots5: $totalSpots5, ')
          ..write('availableSpots: $availableSpots, ')
          ..write('isBooked: $isBooked, ')
          ..write('studentName: $studentName, ')
          ..write('studentPhone: $studentPhone, ')
          ..write('studentEmail: $studentEmail, ')
          ..write('price: $price, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AvailabilitySlotsTable extends AvailabilitySlots
    with TableInfo<$AvailabilitySlotsTable, AvailabilitySlot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AvailabilitySlotsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<String> day = GeneratedColumn<String>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<String> time = GeneratedColumn<String>(
    'time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, day, time, price];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'availability_slots';
  @override
  VerificationContext validateIntegrity(
    Insertable<AvailabilitySlot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('time')) {
      context.handle(
        _timeMeta,
        time.isAcceptableOrUnknown(data['time']!, _timeMeta),
      );
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AvailabilitySlot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AvailabilitySlot(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day'],
      )!,
      time: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
    );
  }

  @override
  $AvailabilitySlotsTable createAlias(String alias) {
    return $AvailabilitySlotsTable(attachedDatabase, alias);
  }
}

class AvailabilitySlot extends DataClass
    implements Insertable<AvailabilitySlot> {
  final int id;
  final String day;
  final String time;
  final double price;
  const AvailabilitySlot({
    required this.id,
    required this.day,
    required this.time,
    required this.price,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['day'] = Variable<String>(day);
    map['time'] = Variable<String>(time);
    map['price'] = Variable<double>(price);
    return map;
  }

  AvailabilitySlotsCompanion toCompanion(bool nullToAbsent) {
    return AvailabilitySlotsCompanion(
      id: Value(id),
      day: Value(day),
      time: Value(time),
      price: Value(price),
    );
  }

  factory AvailabilitySlot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AvailabilitySlot(
      id: serializer.fromJson<int>(json['id']),
      day: serializer.fromJson<String>(json['day']),
      time: serializer.fromJson<String>(json['time']),
      price: serializer.fromJson<double>(json['price']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'day': serializer.toJson<String>(day),
      'time': serializer.toJson<String>(time),
      'price': serializer.toJson<double>(price),
    };
  }

  AvailabilitySlot copyWith({
    int? id,
    String? day,
    String? time,
    double? price,
  }) => AvailabilitySlot(
    id: id ?? this.id,
    day: day ?? this.day,
    time: time ?? this.time,
    price: price ?? this.price,
  );
  AvailabilitySlot copyWithCompanion(AvailabilitySlotsCompanion data) {
    return AvailabilitySlot(
      id: data.id.present ? data.id.value : this.id,
      day: data.day.present ? data.day.value : this.day,
      time: data.time.present ? data.time.value : this.time,
      price: data.price.present ? data.price.value : this.price,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AvailabilitySlot(')
          ..write('id: $id, ')
          ..write('day: $day, ')
          ..write('time: $time, ')
          ..write('price: $price')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, day, time, price);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AvailabilitySlot &&
          other.id == this.id &&
          other.day == this.day &&
          other.time == this.time &&
          other.price == this.price);
}

class AvailabilitySlotsCompanion extends UpdateCompanion<AvailabilitySlot> {
  final Value<int> id;
  final Value<String> day;
  final Value<String> time;
  final Value<double> price;
  const AvailabilitySlotsCompanion({
    this.id = const Value.absent(),
    this.day = const Value.absent(),
    this.time = const Value.absent(),
    this.price = const Value.absent(),
  });
  AvailabilitySlotsCompanion.insert({
    this.id = const Value.absent(),
    required String day,
    required String time,
    required double price,
  }) : day = Value(day),
       time = Value(time),
       price = Value(price);
  static Insertable<AvailabilitySlot> custom({
    Expression<int>? id,
    Expression<String>? day,
    Expression<String>? time,
    Expression<double>? price,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (day != null) 'day': day,
      if (time != null) 'time': time,
      if (price != null) 'price': price,
    });
  }

  AvailabilitySlotsCompanion copyWith({
    Value<int>? id,
    Value<String>? day,
    Value<String>? time,
    Value<double>? price,
  }) {
    return AvailabilitySlotsCompanion(
      id: id ?? this.id,
      day: day ?? this.day,
      time: time ?? this.time,
      price: price ?? this.price,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (day.present) {
      map['day'] = Variable<String>(day.value);
    }
    if (time.present) {
      map['time'] = Variable<String>(time.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AvailabilitySlotsCompanion(')
          ..write('id: $id, ')
          ..write('day: $day, ')
          ..write('time: $time, ')
          ..write('price: $price')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LoginUsersTable loginUsers = $LoginUsersTable(this);
  late final $LessonSlotsTable lessonSlots = $LessonSlotsTable(this);
  late final $AvailabilitySlotsTable availabilitySlots =
      $AvailabilitySlotsTable(this);
  late final LessonSlotsDao lessonSlotsDao = LessonSlotsDao(
    this as AppDatabase,
  );
  late final AvailabilityDao availabilityDao = AvailabilityDao(
    this as AppDatabase,
  );
  late final LoginDao loginDao = LoginDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    loginUsers,
    lessonSlots,
    availabilitySlots,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'login_users',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('lesson_slots', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$LoginUsersTableCreateCompanionBuilder =
    LoginUsersCompanion Function({
      Value<int> id,
      required String email,
      required String password,
      Value<String?> name,
      Value<DateTime?> createdAt,
    });
typedef $$LoginUsersTableUpdateCompanionBuilder =
    LoginUsersCompanion Function({
      Value<int> id,
      Value<String> email,
      Value<String> password,
      Value<String?> name,
      Value<DateTime?> createdAt,
    });

final class $$LoginUsersTableReferences
    extends BaseReferences<_$AppDatabase, $LoginUsersTable, LoginUser> {
  $$LoginUsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$LessonSlotsTable, List<LessonSlot>>
  _lessonSlotsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.lessonSlots,
    aliasName: $_aliasNameGenerator(db.loginUsers.id, db.lessonSlots.userId),
  );

  $$LessonSlotsTableProcessedTableManager get lessonSlotsRefs {
    final manager = $$LessonSlotsTableTableManager(
      $_db,
      $_db.lessonSlots,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_lessonSlotsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LoginUsersTableFilterComposer
    extends Composer<_$AppDatabase, $LoginUsersTable> {
  $$LoginUsersTableFilterComposer({
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

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> lessonSlotsRefs(
    Expression<bool> Function($$LessonSlotsTableFilterComposer f) f,
  ) {
    final $$LessonSlotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lessonSlots,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonSlotsTableFilterComposer(
            $db: $db,
            $table: $db.lessonSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LoginUsersTableOrderingComposer
    extends Composer<_$AppDatabase, $LoginUsersTable> {
  $$LoginUsersTableOrderingComposer({
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

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LoginUsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $LoginUsersTable> {
  $$LoginUsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> lessonSlotsRefs<T extends Object>(
    Expression<T> Function($$LessonSlotsTableAnnotationComposer a) f,
  ) {
    final $$LessonSlotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lessonSlots,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonSlotsTableAnnotationComposer(
            $db: $db,
            $table: $db.lessonSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LoginUsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LoginUsersTable,
          LoginUser,
          $$LoginUsersTableFilterComposer,
          $$LoginUsersTableOrderingComposer,
          $$LoginUsersTableAnnotationComposer,
          $$LoginUsersTableCreateCompanionBuilder,
          $$LoginUsersTableUpdateCompanionBuilder,
          (LoginUser, $$LoginUsersTableReferences),
          LoginUser,
          PrefetchHooks Function({bool lessonSlotsRefs})
        > {
  $$LoginUsersTableTableManager(_$AppDatabase db, $LoginUsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LoginUsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LoginUsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LoginUsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> password = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
              }) => LoginUsersCompanion(
                id: id,
                email: email,
                password: password,
                name: name,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String email,
                required String password,
                Value<String?> name = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
              }) => LoginUsersCompanion.insert(
                id: id,
                email: email,
                password: password,
                name: name,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LoginUsersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({lessonSlotsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (lessonSlotsRefs) db.lessonSlots],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (lessonSlotsRefs)
                    await $_getPrefetchedData<
                      LoginUser,
                      $LoginUsersTable,
                      LessonSlot
                    >(
                      currentTable: table,
                      referencedTable: $$LoginUsersTableReferences
                          ._lessonSlotsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$LoginUsersTableReferences(
                            db,
                            table,
                            p0,
                          ).lessonSlotsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.userId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$LoginUsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LoginUsersTable,
      LoginUser,
      $$LoginUsersTableFilterComposer,
      $$LoginUsersTableOrderingComposer,
      $$LoginUsersTableAnnotationComposer,
      $$LoginUsersTableCreateCompanionBuilder,
      $$LoginUsersTableUpdateCompanionBuilder,
      (LoginUser, $$LoginUsersTableReferences),
      LoginUser,
      PrefetchHooks Function({bool lessonSlotsRefs})
    >;
typedef $$LessonSlotsTableCreateCompanionBuilder =
    LessonSlotsCompanion Function({
      required String id,
      Value<int?> userId,
      required String title,
      required String date,
      required String timeSlot,
      required int totalSpots5,
      required int availableSpots,
      Value<bool> isBooked,
      Value<String?> studentName,
      Value<String?> studentPhone,
      Value<String?> studentEmail,
      Value<double> price,
      Value<int> rowid,
    });
typedef $$LessonSlotsTableUpdateCompanionBuilder =
    LessonSlotsCompanion Function({
      Value<String> id,
      Value<int?> userId,
      Value<String> title,
      Value<String> date,
      Value<String> timeSlot,
      Value<int> totalSpots5,
      Value<int> availableSpots,
      Value<bool> isBooked,
      Value<String?> studentName,
      Value<String?> studentPhone,
      Value<String?> studentEmail,
      Value<double> price,
      Value<int> rowid,
    });

final class $$LessonSlotsTableReferences
    extends BaseReferences<_$AppDatabase, $LessonSlotsTable, LessonSlot> {
  $$LessonSlotsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LoginUsersTable _userIdTable(_$AppDatabase db) =>
      db.loginUsers.createAlias(
        $_aliasNameGenerator(db.lessonSlots.userId, db.loginUsers.id),
      );

  $$LoginUsersTableProcessedTableManager? get userId {
    final $_column = $_itemColumn<int>('user_id');
    if ($_column == null) return null;
    final manager = $$LoginUsersTableTableManager(
      $_db,
      $_db.loginUsers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LessonSlotsTableFilterComposer
    extends Composer<_$AppDatabase, $LessonSlotsTable> {
  $$LessonSlotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timeSlot => $composableBuilder(
    column: $table.timeSlot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalSpots5 => $composableBuilder(
    column: $table.totalSpots5,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get availableSpots => $composableBuilder(
    column: $table.availableSpots,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isBooked => $composableBuilder(
    column: $table.isBooked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get studentName => $composableBuilder(
    column: $table.studentName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get studentPhone => $composableBuilder(
    column: $table.studentPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get studentEmail => $composableBuilder(
    column: $table.studentEmail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  $$LoginUsersTableFilterComposer get userId {
    final $$LoginUsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.loginUsers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoginUsersTableFilterComposer(
            $db: $db,
            $table: $db.loginUsers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LessonSlotsTableOrderingComposer
    extends Composer<_$AppDatabase, $LessonSlotsTable> {
  $$LessonSlotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timeSlot => $composableBuilder(
    column: $table.timeSlot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalSpots5 => $composableBuilder(
    column: $table.totalSpots5,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get availableSpots => $composableBuilder(
    column: $table.availableSpots,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isBooked => $composableBuilder(
    column: $table.isBooked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get studentName => $composableBuilder(
    column: $table.studentName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get studentPhone => $composableBuilder(
    column: $table.studentPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get studentEmail => $composableBuilder(
    column: $table.studentEmail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  $$LoginUsersTableOrderingComposer get userId {
    final $$LoginUsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.loginUsers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoginUsersTableOrderingComposer(
            $db: $db,
            $table: $db.loginUsers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LessonSlotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LessonSlotsTable> {
  $$LessonSlotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get timeSlot =>
      $composableBuilder(column: $table.timeSlot, builder: (column) => column);

  GeneratedColumn<int> get totalSpots5 => $composableBuilder(
    column: $table.totalSpots5,
    builder: (column) => column,
  );

  GeneratedColumn<int> get availableSpots => $composableBuilder(
    column: $table.availableSpots,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isBooked =>
      $composableBuilder(column: $table.isBooked, builder: (column) => column);

  GeneratedColumn<String> get studentName => $composableBuilder(
    column: $table.studentName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get studentPhone => $composableBuilder(
    column: $table.studentPhone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get studentEmail => $composableBuilder(
    column: $table.studentEmail,
    builder: (column) => column,
  );

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  $$LoginUsersTableAnnotationComposer get userId {
    final $$LoginUsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.loginUsers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoginUsersTableAnnotationComposer(
            $db: $db,
            $table: $db.loginUsers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LessonSlotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LessonSlotsTable,
          LessonSlot,
          $$LessonSlotsTableFilterComposer,
          $$LessonSlotsTableOrderingComposer,
          $$LessonSlotsTableAnnotationComposer,
          $$LessonSlotsTableCreateCompanionBuilder,
          $$LessonSlotsTableUpdateCompanionBuilder,
          (LessonSlot, $$LessonSlotsTableReferences),
          LessonSlot,
          PrefetchHooks Function({bool userId})
        > {
  $$LessonSlotsTableTableManager(_$AppDatabase db, $LessonSlotsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonSlotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonSlotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LessonSlotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int?> userId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String> timeSlot = const Value.absent(),
                Value<int> totalSpots5 = const Value.absent(),
                Value<int> availableSpots = const Value.absent(),
                Value<bool> isBooked = const Value.absent(),
                Value<String?> studentName = const Value.absent(),
                Value<String?> studentPhone = const Value.absent(),
                Value<String?> studentEmail = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LessonSlotsCompanion(
                id: id,
                userId: userId,
                title: title,
                date: date,
                timeSlot: timeSlot,
                totalSpots5: totalSpots5,
                availableSpots: availableSpots,
                isBooked: isBooked,
                studentName: studentName,
                studentPhone: studentPhone,
                studentEmail: studentEmail,
                price: price,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<int?> userId = const Value.absent(),
                required String title,
                required String date,
                required String timeSlot,
                required int totalSpots5,
                required int availableSpots,
                Value<bool> isBooked = const Value.absent(),
                Value<String?> studentName = const Value.absent(),
                Value<String?> studentPhone = const Value.absent(),
                Value<String?> studentEmail = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LessonSlotsCompanion.insert(
                id: id,
                userId: userId,
                title: title,
                date: date,
                timeSlot: timeSlot,
                totalSpots5: totalSpots5,
                availableSpots: availableSpots,
                isBooked: isBooked,
                studentName: studentName,
                studentPhone: studentPhone,
                studentEmail: studentEmail,
                price: price,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LessonSlotsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable: $$LessonSlotsTableReferences
                                    ._userIdTable(db),
                                referencedColumn: $$LessonSlotsTableReferences
                                    ._userIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LessonSlotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LessonSlotsTable,
      LessonSlot,
      $$LessonSlotsTableFilterComposer,
      $$LessonSlotsTableOrderingComposer,
      $$LessonSlotsTableAnnotationComposer,
      $$LessonSlotsTableCreateCompanionBuilder,
      $$LessonSlotsTableUpdateCompanionBuilder,
      (LessonSlot, $$LessonSlotsTableReferences),
      LessonSlot,
      PrefetchHooks Function({bool userId})
    >;
typedef $$AvailabilitySlotsTableCreateCompanionBuilder =
    AvailabilitySlotsCompanion Function({
      Value<int> id,
      required String day,
      required String time,
      required double price,
    });
typedef $$AvailabilitySlotsTableUpdateCompanionBuilder =
    AvailabilitySlotsCompanion Function({
      Value<int> id,
      Value<String> day,
      Value<String> time,
      Value<double> price,
    });

class $$AvailabilitySlotsTableFilterComposer
    extends Composer<_$AppDatabase, $AvailabilitySlotsTable> {
  $$AvailabilitySlotsTableFilterComposer({
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

  ColumnFilters<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AvailabilitySlotsTableOrderingComposer
    extends Composer<_$AppDatabase, $AvailabilitySlotsTable> {
  $$AvailabilitySlotsTableOrderingComposer({
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

  ColumnOrderings<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AvailabilitySlotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AvailabilitySlotsTable> {
  $$AvailabilitySlotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<String> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);
}

class $$AvailabilitySlotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AvailabilitySlotsTable,
          AvailabilitySlot,
          $$AvailabilitySlotsTableFilterComposer,
          $$AvailabilitySlotsTableOrderingComposer,
          $$AvailabilitySlotsTableAnnotationComposer,
          $$AvailabilitySlotsTableCreateCompanionBuilder,
          $$AvailabilitySlotsTableUpdateCompanionBuilder,
          (
            AvailabilitySlot,
            BaseReferences<
              _$AppDatabase,
              $AvailabilitySlotsTable,
              AvailabilitySlot
            >,
          ),
          AvailabilitySlot,
          PrefetchHooks Function()
        > {
  $$AvailabilitySlotsTableTableManager(
    _$AppDatabase db,
    $AvailabilitySlotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AvailabilitySlotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AvailabilitySlotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AvailabilitySlotsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> day = const Value.absent(),
                Value<String> time = const Value.absent(),
                Value<double> price = const Value.absent(),
              }) => AvailabilitySlotsCompanion(
                id: id,
                day: day,
                time: time,
                price: price,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String day,
                required String time,
                required double price,
              }) => AvailabilitySlotsCompanion.insert(
                id: id,
                day: day,
                time: time,
                price: price,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AvailabilitySlotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AvailabilitySlotsTable,
      AvailabilitySlot,
      $$AvailabilitySlotsTableFilterComposer,
      $$AvailabilitySlotsTableOrderingComposer,
      $$AvailabilitySlotsTableAnnotationComposer,
      $$AvailabilitySlotsTableCreateCompanionBuilder,
      $$AvailabilitySlotsTableUpdateCompanionBuilder,
      (
        AvailabilitySlot,
        BaseReferences<
          _$AppDatabase,
          $AvailabilitySlotsTable,
          AvailabilitySlot
        >,
      ),
      AvailabilitySlot,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LoginUsersTableTableManager get loginUsers =>
      $$LoginUsersTableTableManager(_db, _db.loginUsers);
  $$LessonSlotsTableTableManager get lessonSlots =>
      $$LessonSlotsTableTableManager(_db, _db.lessonSlots);
  $$AvailabilitySlotsTableTableManager get availabilitySlots =>
      $$AvailabilitySlotsTableTableManager(_db, _db.availabilitySlots);
}
