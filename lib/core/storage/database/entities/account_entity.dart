import 'package:floor/floor.dart';

@Entity(tableName: 'accounts')
class AccountEntity {
  @PrimaryKey()
  final String id;

  @ColumnInfo(name: 'user_id')
  final String userId;

  @ColumnInfo(name: 'encrypted_secret')
  final String encryptedSecret;

  @ColumnInfo(name: 'service_name')
  final String serviceName;

  @ColumnInfo(name: 'account_name')
  final String accountName;

  @ColumnInfo(name: 'issuer')
  final String issuer;

  @ColumnInfo(name: 'algorithm')
  final String algorithm;

  @ColumnInfo(name: 'digits')
  final int digits;

  @ColumnInfo(name: 'period')
  final int period;

  @ColumnInfo(name: 'counter')
  final int? counter;

  @ColumnInfo(name: 'type')
  final String type;

  @ColumnInfo(name: 'icon_url')
  final String? iconUrl;

  @ColumnInfo(name: 'category')
  final String? category;

  @ColumnInfo(name: 'tags')
  final String? tags;

  @ColumnInfo(name: 'notes')
  final String? notes;

  @ColumnInfo(name: 'color')
  final String? color;

  @ColumnInfo(name: 'sort_order')
  final int sortOrder;

  @ColumnInfo(name: 'is_favorite')
  final bool isFavorite;

  @ColumnInfo(name: 'is_archived')
  final bool isArchived;

  @ColumnInfo(name: 'last_used_at')
  final int? lastUsedAt;

  @ColumnInfo(name: 'created_at')
  final int createdAt;

  @ColumnInfo(name: 'updated_at')
  final int updatedAt;

  @ColumnInfo(name: 'sync_status')
  final String syncStatus;

  @ColumnInfo(name: 'version')
  final int version;

  const AccountEntity({
    required this.id,
    required this.userId,
    required this.encryptedSecret,
    required this.serviceName,
    required this.accountName,
    required this.issuer,
    required this.algorithm,
    required this.digits,
    required this.period,
    this.counter,
    required this.type,
    this.iconUrl,
    this.category,
    this.tags,
    this.notes,
    this.color,
    required this.sortOrder,
    required this.isFavorite,
    required this.isArchived,
    this.lastUsedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    required this.version,
  });

  AccountEntity copyWith({
    String? id,
    String? userId,
    String? encryptedSecret,
    String? serviceName,
    String? accountName,
    String? issuer,
    String? algorithm,
    int? digits,
    int? period,
    int? counter,
    String? type,
    String? iconUrl,
    String? category,
    String? tags,
    String? notes,
    String? color,
    int? sortOrder,
    bool? isFavorite,
    bool? isArchived,
    int? lastUsedAt,
    int? createdAt,
    int? updatedAt,
    String? syncStatus,
    int? version,
  }) {
    return AccountEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      encryptedSecret: encryptedSecret ?? this.encryptedSecret,
      serviceName: serviceName ?? this.serviceName,
      accountName: accountName ?? this.accountName,
      issuer: issuer ?? this.issuer,
      algorithm: algorithm ?? this.algorithm,
      digits: digits ?? this.digits,
      period: period ?? this.period,
      counter: counter ?? this.counter,
      type: type ?? this.type,
      iconUrl: iconUrl ?? this.iconUrl,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      color: color ?? this.color,
      sortOrder: sortOrder ?? this.sortOrder,
      isFavorite: isFavorite ?? this.isFavorite,
      isArchived: isArchived ?? this.isArchived,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
    );
  }
}