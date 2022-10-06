//
//  Copyright (c) 2022 Open Whisper Systems. All rights reserved.
//

import Foundation
import GRDB
import SignalCoreKit

// NOTE: This file is generated by /Scripts/sds_codegen/sds_generate.py.
// Do not manually edit it, instead run `sds_codegen.sh`.

// MARK: - Record

public struct UserProfileRecord: SDSRecord {
    public weak var delegate: SDSRecordDelegate?

    public var tableMetadata: SDSTableMetadata {
        OWSUserProfileSerializer.table
    }

    public static var databaseTableName: String {
        OWSUserProfileSerializer.table.tableName
    }

    public var id: Int64?

    // This defines all of the columns used in the table
    // where this model (and any subclasses) are persisted.
    public let recordType: SDSRecordType
    public let uniqueId: String

    // Properties
    public let avatarFileName: String?
    public let avatarUrlPath: String?
    public let profileKey: Data?
    public let profileName: String?
    public let recipientPhoneNumber: String?
    public let recipientUUID: String?
    public let username: String?
    public let familyName: String?
    public let lastFetchDate: Double?
    public let lastMessagingDate: Double?
    public let bio: String?
    public let bioEmoji: String?
    public let profileBadgeInfo: Data?
    public let isStoriesCapable: Bool
    public let canReceiveGiftBadges: Bool

    public enum CodingKeys: String, CodingKey, ColumnExpression, CaseIterable {
        case id
        case recordType
        case uniqueId
        case avatarFileName
        case avatarUrlPath
        case profileKey
        case profileName
        case recipientPhoneNumber
        case recipientUUID
        case username
        case familyName
        case lastFetchDate
        case lastMessagingDate
        case bio
        case bioEmoji
        case profileBadgeInfo
        case isStoriesCapable
        case canReceiveGiftBadges
    }

    public static func columnName(_ column: UserProfileRecord.CodingKeys, fullyQualified: Bool = false) -> String {
        fullyQualified ? "\(databaseTableName).\(column.rawValue)" : column.rawValue
    }

    public func didInsert(with rowID: Int64, for column: String?) {
        guard let delegate = delegate else {
            owsFailDebug("Missing delegate.")
            return
        }
        delegate.updateRowId(rowID)
    }
}

// MARK: - Row Initializer

public extension UserProfileRecord {
    static var databaseSelection: [SQLSelectable] {
        CodingKeys.allCases
    }

    init(row: Row) {
        id = row[0]
        recordType = row[1]
        uniqueId = row[2]
        avatarFileName = row[3]
        avatarUrlPath = row[4]
        profileKey = row[5]
        profileName = row[6]
        recipientPhoneNumber = row[7]
        recipientUUID = row[8]
        username = row[9]
        familyName = row[10]
        lastFetchDate = row[11]
        lastMessagingDate = row[12]
        bio = row[13]
        bioEmoji = row[14]
        profileBadgeInfo = row[15]
        isStoriesCapable = row[16]
        canReceiveGiftBadges = row[17]
    }
}

// MARK: - StringInterpolation

public extension String.StringInterpolation {
    mutating func appendInterpolation(userProfileColumn column: UserProfileRecord.CodingKeys) {
        appendLiteral(UserProfileRecord.columnName(column))
    }
    mutating func appendInterpolation(userProfileColumnFullyQualified column: UserProfileRecord.CodingKeys) {
        appendLiteral(UserProfileRecord.columnName(column, fullyQualified: true))
    }
}

// MARK: - Deserialization

// TODO: Rework metadata to not include, for example, columns, column indices.
extension OWSUserProfile {
    // This method defines how to deserialize a model, given a
    // database row.  The recordType column is used to determine
    // the corresponding model class.
    class func fromRecord(_ record: UserProfileRecord) throws -> OWSUserProfile {

        guard let recordId = record.id else {
            throw SDSError.invalidValue
        }

        switch record.recordType {
        case .userProfile:

            let uniqueId: String = record.uniqueId
            let avatarFileName: String? = record.avatarFileName
            let avatarUrlPath: String? = record.avatarUrlPath
            let bio: String? = record.bio
            let bioEmoji: String? = record.bioEmoji
            let canReceiveGiftBadges: Bool = record.canReceiveGiftBadges
            let familyName: String? = record.familyName
            let isStoriesCapable: Bool = record.isStoriesCapable
            let lastFetchDateInterval: Double? = record.lastFetchDate
            let lastFetchDate: Date? = SDSDeserialization.optionalDoubleAsDate(lastFetchDateInterval, name: "lastFetchDate")
            let lastMessagingDateInterval: Double? = record.lastMessagingDate
            let lastMessagingDate: Date? = SDSDeserialization.optionalDoubleAsDate(lastMessagingDateInterval, name: "lastMessagingDate")
            let profileBadgeInfoSerialized: Data? = record.profileBadgeInfo
            let profileBadgeInfo: [OWSUserProfileBadgeInfo]? = try SDSDeserialization.optionalUnarchive(profileBadgeInfoSerialized, name: "profileBadgeInfo")
            let profileKeySerialized: Data? = record.profileKey
            let profileKey: OWSAES256Key? = try SDSDeserialization.optionalUnarchive(profileKeySerialized, name: "profileKey")
            let profileName: String? = record.profileName
            let recipientPhoneNumber: String? = record.recipientPhoneNumber
            let recipientUUID: String? = record.recipientUUID
            let username: String? = record.username

            return OWSUserProfile(grdbId: recordId,
                                  uniqueId: uniqueId,
                                  avatarFileName: avatarFileName,
                                  avatarUrlPath: avatarUrlPath,
                                  bio: bio,
                                  bioEmoji: bioEmoji,
                                  canReceiveGiftBadges: canReceiveGiftBadges,
                                  familyName: familyName,
                                  isStoriesCapable: isStoriesCapable,
                                  lastFetchDate: lastFetchDate,
                                  lastMessagingDate: lastMessagingDate,
                                  profileBadgeInfo: profileBadgeInfo,
                                  profileKey: profileKey,
                                  profileName: profileName,
                                  recipientPhoneNumber: recipientPhoneNumber,
                                  recipientUUID: recipientUUID,
                                  username: username)

        default:
            owsFailDebug("Unexpected record type: \(record.recordType)")
            throw SDSError.invalidValue
        }
    }
}

// MARK: - SDSModel

extension OWSUserProfile: SDSModel {
    public var serializer: SDSSerializer {
        // Any subclass can be cast to it's superclass,
        // so the order of this switch statement matters.
        // We need to do a "depth first" search by type.
        switch self {
        default:
            return OWSUserProfileSerializer(model: self)
        }
    }

    public func asRecord() throws -> SDSRecord {
        try serializer.asRecord()
    }

    public var sdsTableName: String {
        UserProfileRecord.databaseTableName
    }

    public static var table: SDSTableMetadata {
        OWSUserProfileSerializer.table
    }

    public class func anyEnumerateIndexable(
        transaction: SDSAnyReadTransaction,
        block: @escaping (SDSIndexableModel) -> Void
    ) {
        anyEnumerate(transaction: transaction, batched: false) { model, _ in
            block(model)
        }
    }
}

// MARK: - DeepCopyable

extension OWSUserProfile: DeepCopyable {

    public func deepCopy() throws -> AnyObject {
        // Any subclass can be cast to it's superclass,
        // so the order of this switch statement matters.
        // We need to do a "depth first" search by type.
        guard let id = self.grdbId?.int64Value else {
            throw OWSAssertionError("Model missing grdbId.")
        }

        do {
            let modelToCopy = self
            assert(type(of: modelToCopy) == OWSUserProfile.self)
            let uniqueId: String = modelToCopy.uniqueId
            let avatarFileName: String? = modelToCopy.avatarFileName
            let avatarUrlPath: String? = modelToCopy.avatarUrlPath
            let bio: String? = modelToCopy.bio
            let bioEmoji: String? = modelToCopy.bioEmoji
            let canReceiveGiftBadges: Bool = modelToCopy.canReceiveGiftBadges
            let familyName: String? = modelToCopy.familyName
            let isStoriesCapable: Bool = modelToCopy.isStoriesCapable
            let lastFetchDate: Date? = modelToCopy.lastFetchDate
            let lastMessagingDate: Date? = modelToCopy.lastMessagingDate
            // NOTE: If this generates build errors, you made need to
            // modify DeepCopy.swift to support this type.
            //
            // That might mean:
            //
            // * Implement DeepCopyable for this type (e.g. a model).
            // * Modify DeepCopies.deepCopy() to support this type (e.g. a collection).
            let profileBadgeInfo: [OWSUserProfileBadgeInfo]?
            if let profileBadgeInfoForCopy = modelToCopy.profileBadgeInfo {
               profileBadgeInfo = try DeepCopies.deepCopy(profileBadgeInfoForCopy)
            } else {
               profileBadgeInfo = nil
            }
            // NOTE: If this generates build errors, you made need to
            // modify DeepCopy.swift to support this type.
            //
            // That might mean:
            //
            // * Implement DeepCopyable for this type (e.g. a model).
            // * Modify DeepCopies.deepCopy() to support this type (e.g. a collection).
            let profileKey: OWSAES256Key?
            if let profileKeyForCopy = modelToCopy.profileKey {
               profileKey = try DeepCopies.deepCopy(profileKeyForCopy)
            } else {
               profileKey = nil
            }
            let profileName: String? = modelToCopy.profileName
            let recipientPhoneNumber: String? = modelToCopy.recipientPhoneNumber
            let recipientUUID: String? = modelToCopy.recipientUUID
            let username: String? = modelToCopy.username

            return OWSUserProfile(grdbId: id,
                                  uniqueId: uniqueId,
                                  avatarFileName: avatarFileName,
                                  avatarUrlPath: avatarUrlPath,
                                  bio: bio,
                                  bioEmoji: bioEmoji,
                                  canReceiveGiftBadges: canReceiveGiftBadges,
                                  familyName: familyName,
                                  isStoriesCapable: isStoriesCapable,
                                  lastFetchDate: lastFetchDate,
                                  lastMessagingDate: lastMessagingDate,
                                  profileBadgeInfo: profileBadgeInfo,
                                  profileKey: profileKey,
                                  profileName: profileName,
                                  recipientPhoneNumber: recipientPhoneNumber,
                                  recipientUUID: recipientUUID,
                                  username: username)
        }

    }
}

// MARK: - Table Metadata

extension OWSUserProfileSerializer {

    // This defines all of the columns used in the table
    // where this model (and any subclasses) are persisted.
    static var idColumn: SDSColumnMetadata { SDSColumnMetadata(columnName: "id", columnType: .primaryKey) }
    static var recordTypeColumn: SDSColumnMetadata { SDSColumnMetadata(columnName: "recordType", columnType: .int64) }
    static var uniqueIdColumn: SDSColumnMetadata { SDSColumnMetadata(columnName: "uniqueId", columnType: .unicodeString, isUnique: true) }
    // Properties
    static var avatarFileNameColumn: SDSColumnMetadata { SDSColumnMetadata(columnName: "avatarFileName", columnType: .unicodeString, isOptional: true) }
    static var avatarUrlPathColumn: SDSColumnMetadata { SDSColumnMetadata(columnName: "avatarUrlPath", columnType: .unicodeString, isOptional: true) }
    static var profileKeyColumn: SDSColumnMetadata { SDSColumnMetadata(columnName: "profileKey", columnType: .blob, isOptional: true) }
    static var profileNameColumn: SDSColumnMetadata { SDSColumnMetadata(columnName: "profileName", columnType: .unicodeString, isOptional: true) }
    static var recipientPhoneNumberColumn: SDSColumnMetadata { SDSColumnMetadata(columnName: "recipientPhoneNumber", columnType: .unicodeString, isOptional: true) }
    static var recipientUUIDColumn: SDSColumnMetadata { SDSColumnMetadata(columnName: "recipientUUID", columnType: .unicodeString, isOptional: true) }
    static var usernameColumn: SDSColumnMetadata { SDSColumnMetadata(columnName: "username", columnType: .unicodeString, isOptional: true) }
    static var familyNameColumn: SDSColumnMetadata { SDSColumnMetadata(columnName: "familyName", columnType: .unicodeString, isOptional: true) }
    static var lastFetchDateColumn: SDSColumnMetadata { SDSColumnMetadata(columnName: "lastFetchDate", columnType: .double, isOptional: true) }
    static var lastMessagingDateColumn: SDSColumnMetadata { SDSColumnMetadata(columnName: "lastMessagingDate", columnType: .double, isOptional: true) }
    static var bioColumn: SDSColumnMetadata { SDSColumnMetadata(columnName: "bio", columnType: .unicodeString, isOptional: true) }
    static var bioEmojiColumn: SDSColumnMetadata { SDSColumnMetadata(columnName: "bioEmoji", columnType: .unicodeString, isOptional: true) }
    static var profileBadgeInfoColumn: SDSColumnMetadata { SDSColumnMetadata(columnName: "profileBadgeInfo", columnType: .blob, isOptional: true) }
    static var isStoriesCapableColumn: SDSColumnMetadata { SDSColumnMetadata(columnName: "isStoriesCapable", columnType: .int) }
    static var canReceiveGiftBadgesColumn: SDSColumnMetadata { SDSColumnMetadata(columnName: "canReceiveGiftBadges", columnType: .int) }

    // TODO: We should decide on a naming convention for
    //       tables that store models.
    public static var table: SDSTableMetadata {
        SDSTableMetadata(collection: OWSUserProfile.collection(),
                         tableName: "model_OWSUserProfile",
                         columns: [
        idColumn,
        recordTypeColumn,
        uniqueIdColumn,
        avatarFileNameColumn,
        avatarUrlPathColumn,
        profileKeyColumn,
        profileNameColumn,
        recipientPhoneNumberColumn,
        recipientUUIDColumn,
        usernameColumn,
        familyNameColumn,
        lastFetchDateColumn,
        lastMessagingDateColumn,
        bioColumn,
        bioEmojiColumn,
        profileBadgeInfoColumn,
        isStoriesCapableColumn,
        canReceiveGiftBadgesColumn
        ])
    }
}

// MARK: - Save/Remove/Update

@objc
public extension OWSUserProfile {
    func anyInsert(transaction: SDSAnyWriteTransaction) {
        sdsSave(saveMode: .insert, transaction: transaction)
    }

    // Avoid this method whenever feasible.
    //
    // If the record has previously been saved, this method does an overwriting
    // update of the corresponding row, otherwise if it's a new record, this
    // method inserts a new row.
    //
    // For performance, when possible, you should explicitly specify whether
    // you are inserting or updating rather than calling this method.
    func anyUpsert(transaction: SDSAnyWriteTransaction) {
        let isInserting: Bool
        if OWSUserProfile.anyFetch(uniqueId: uniqueId, transaction: transaction) != nil {
            isInserting = false
        } else {
            isInserting = true
        }
        sdsSave(saveMode: isInserting ? .insert : .update, transaction: transaction)
    }

    // This method is used by "updateWith..." methods.
    //
    // This model may be updated from many threads. We don't want to save
    // our local copy (this instance) since it may be out of date.  We also
    // want to avoid re-saving a model that has been deleted.  Therefore, we
    // use "updateWith..." methods to:
    //
    // a) Update a property of this instance.
    // b) If a copy of this model exists in the database, load an up-to-date copy,
    //    and update and save that copy.
    // b) If a copy of this model _DOES NOT_ exist in the database, do _NOT_ save
    //    this local instance.
    //
    // After "updateWith...":
    //
    // a) Any copy of this model in the database will have been updated.
    // b) The local property on this instance will always have been updated.
    // c) Other properties on this instance may be out of date.
    //
    // All mutable properties of this class have been made read-only to
    // prevent accidentally modifying them directly.
    //
    // This isn't a perfect arrangement, but in practice this will prevent
    // data loss and will resolve all known issues.
    func anyUpdate(transaction: SDSAnyWriteTransaction, block: (OWSUserProfile) -> Void) {

        block(self)

        guard let dbCopy = type(of: self).anyFetch(uniqueId: uniqueId,
                                                   transaction: transaction) else {
            return
        }

        // Don't apply the block twice to the same instance.
        // It's at least unnecessary and actually wrong for some blocks.
        // e.g. `block: { $0 in $0.someField++ }`
        if dbCopy !== self {
            block(dbCopy)
        }

        dbCopy.sdsSave(saveMode: .update, transaction: transaction)
    }

    // This method is an alternative to `anyUpdate(transaction:block:)` methods.
    //
    // We should generally use `anyUpdate` to ensure we're not unintentionally
    // clobbering other columns in the database when another concurrent update
    // has occurred.
    //
    // There are cases when this doesn't make sense, e.g. when  we know we've
    // just loaded the model in the same transaction. In those cases it is
    // safe and faster to do a "overwriting" update
    func anyOverwritingUpdate(transaction: SDSAnyWriteTransaction) {
        sdsSave(saveMode: .update, transaction: transaction)
    }

    func anyRemove(transaction: SDSAnyWriteTransaction) {
        sdsRemove(transaction: transaction)
    }

    func anyReload(transaction: SDSAnyReadTransaction) {
        anyReload(transaction: transaction, ignoreMissing: false)
    }

    func anyReload(transaction: SDSAnyReadTransaction, ignoreMissing: Bool) {
        guard let latestVersion = type(of: self).anyFetch(uniqueId: uniqueId, transaction: transaction) else {
            if !ignoreMissing {
                owsFailDebug("`latest` was unexpectedly nil")
            }
            return
        }

        setValuesForKeys(latestVersion.dictionaryValue)
    }
}

// MARK: - OWSUserProfileCursor

@objc
public class OWSUserProfileCursor: NSObject, SDSCursor {
    private let transaction: GRDBReadTransaction
    private let cursor: RecordCursor<UserProfileRecord>?

    init(transaction: GRDBReadTransaction, cursor: RecordCursor<UserProfileRecord>?) {
        self.transaction = transaction
        self.cursor = cursor
    }

    public func next() throws -> OWSUserProfile? {
        guard let cursor = cursor else {
            return nil
        }
        guard let record = try cursor.next() else {
            return nil
        }
        let value = try OWSUserProfile.fromRecord(record)
        Self.modelReadCaches.userProfileReadCache.didReadUserProfile(value, transaction: transaction.asAnyRead)
        return value
    }

    public func all() throws -> [OWSUserProfile] {
        var result = [OWSUserProfile]()
        while true {
            guard let model = try next() else {
                break
            }
            result.append(model)
        }
        return result
    }
}

// MARK: - Obj-C Fetch

// TODO: We may eventually want to define some combination of:
//
// * fetchCursor, fetchOne, fetchAll, etc. (ala GRDB)
// * Optional "where clause" parameters for filtering.
// * Async flavors with completions.
//
// TODO: I've defined flavors that take a read transaction.
//       Or we might take a "connection" if we end up having that class.
@objc
public extension OWSUserProfile {
    class func grdbFetchCursor(transaction: GRDBReadTransaction) -> OWSUserProfileCursor {
        let database = transaction.database
        do {
            let cursor = try UserProfileRecord.fetchCursor(database)
            return OWSUserProfileCursor(transaction: transaction, cursor: cursor)
        } catch {
            owsFailDebug("Read failed: \(error)")
            return OWSUserProfileCursor(transaction: transaction, cursor: nil)
        }
    }

    // Fetches a single model by "unique id".
    class func anyFetch(uniqueId: String,
                        transaction: SDSAnyReadTransaction) -> OWSUserProfile? {
        assert(uniqueId.count > 0)

        switch transaction.readTransaction {
        case .grdbRead(let grdbTransaction):
            let sql = "SELECT * FROM \(UserProfileRecord.databaseTableName) WHERE \(userProfileColumn: .uniqueId) = ?"
            return grdbFetchOne(sql: sql, arguments: [uniqueId], transaction: grdbTransaction)
        }
    }

    // Traverses all records.
    // Records are not visited in any particular order.
    class func anyEnumerate(transaction: SDSAnyReadTransaction,
                            block: @escaping (OWSUserProfile, UnsafeMutablePointer<ObjCBool>) -> Void) {
        anyEnumerate(transaction: transaction, batched: false, block: block)
    }

    // Traverses all records.
    // Records are not visited in any particular order.
    class func anyEnumerate(transaction: SDSAnyReadTransaction,
                            batched: Bool = false,
                            block: @escaping (OWSUserProfile, UnsafeMutablePointer<ObjCBool>) -> Void) {
        let batchSize = batched ? Batching.kDefaultBatchSize : 0
        anyEnumerate(transaction: transaction, batchSize: batchSize, block: block)
    }

    // Traverses all records.
    // Records are not visited in any particular order.
    //
    // If batchSize > 0, the enumeration is performed in autoreleased batches.
    class func anyEnumerate(transaction: SDSAnyReadTransaction,
                            batchSize: UInt,
                            block: @escaping (OWSUserProfile, UnsafeMutablePointer<ObjCBool>) -> Void) {
        switch transaction.readTransaction {
        case .grdbRead(let grdbTransaction):
            let cursor = OWSUserProfile.grdbFetchCursor(transaction: grdbTransaction)
            Batching.loop(batchSize: batchSize,
                          loopBlock: { stop in
                                do {
                                    guard let value = try cursor.next() else {
                                        stop.pointee = true
                                        return
                                    }
                                    block(value, stop)
                                } catch let error {
                                    owsFailDebug("Couldn't fetch model: \(error)")
                                }
                              })
        }
    }

    // Traverses all records' unique ids.
    // Records are not visited in any particular order.
    class func anyEnumerateUniqueIds(transaction: SDSAnyReadTransaction,
                                     block: @escaping (String, UnsafeMutablePointer<ObjCBool>) -> Void) {
        anyEnumerateUniqueIds(transaction: transaction, batched: false, block: block)
    }

    // Traverses all records' unique ids.
    // Records are not visited in any particular order.
    class func anyEnumerateUniqueIds(transaction: SDSAnyReadTransaction,
                                     batched: Bool = false,
                                     block: @escaping (String, UnsafeMutablePointer<ObjCBool>) -> Void) {
        let batchSize = batched ? Batching.kDefaultBatchSize : 0
        anyEnumerateUniqueIds(transaction: transaction, batchSize: batchSize, block: block)
    }

    // Traverses all records' unique ids.
    // Records are not visited in any particular order.
    //
    // If batchSize > 0, the enumeration is performed in autoreleased batches.
    class func anyEnumerateUniqueIds(transaction: SDSAnyReadTransaction,
                                     batchSize: UInt,
                                     block: @escaping (String, UnsafeMutablePointer<ObjCBool>) -> Void) {
        switch transaction.readTransaction {
        case .grdbRead(let grdbTransaction):
            grdbEnumerateUniqueIds(transaction: grdbTransaction,
                                   sql: """
                    SELECT \(userProfileColumn: .uniqueId)
                    FROM \(UserProfileRecord.databaseTableName)
                """,
                batchSize: batchSize,
                block: block)
        }
    }

    // Does not order the results.
    class func anyFetchAll(transaction: SDSAnyReadTransaction) -> [OWSUserProfile] {
        var result = [OWSUserProfile]()
        anyEnumerate(transaction: transaction) { (model, _) in
            result.append(model)
        }
        return result
    }

    // Does not order the results.
    class func anyAllUniqueIds(transaction: SDSAnyReadTransaction) -> [String] {
        var result = [String]()
        anyEnumerateUniqueIds(transaction: transaction) { (uniqueId, _) in
            result.append(uniqueId)
        }
        return result
    }

    class func anyCount(transaction: SDSAnyReadTransaction) -> UInt {
        switch transaction.readTransaction {
        case .grdbRead(let grdbTransaction):
            return UserProfileRecord.ows_fetchCount(grdbTransaction.database)
        }
    }

    // WARNING: Do not use this method for any models which do cleanup
    //          in their anyWillRemove(), anyDidRemove() methods.
    class func anyRemoveAllWithoutInstantation(transaction: SDSAnyWriteTransaction) {
        switch transaction.writeTransaction {
        case .grdbWrite(let grdbTransaction):
            do {
                try UserProfileRecord.deleteAll(grdbTransaction.database)
            } catch {
                owsFailDebug("deleteAll() failed: \(error)")
            }
        }

        if ftsIndexMode != .never {
            FullTextSearchFinder.allModelsWereRemoved(collection: collection(), transaction: transaction)
        }
    }

    class func anyRemoveAllWithInstantation(transaction: SDSAnyWriteTransaction) {
        // To avoid mutationDuringEnumerationException, we need
        // to remove the instances outside the enumeration.
        let uniqueIds = anyAllUniqueIds(transaction: transaction)

        var index: Int = 0
        Batching.loop(batchSize: Batching.kDefaultBatchSize,
                      loopBlock: { stop in
            guard index < uniqueIds.count else {
                stop.pointee = true
                return
            }
            let uniqueId = uniqueIds[index]
            index += 1
            guard let instance = anyFetch(uniqueId: uniqueId, transaction: transaction) else {
                owsFailDebug("Missing instance.")
                return
            }
            instance.anyRemove(transaction: transaction)
        })

        if ftsIndexMode != .never {
            FullTextSearchFinder.allModelsWereRemoved(collection: collection(), transaction: transaction)
        }
    }

    class func anyExists(
        uniqueId: String,
        transaction: SDSAnyReadTransaction
    ) -> Bool {
        assert(uniqueId.count > 0)

        switch transaction.readTransaction {
        case .grdbRead(let grdbTransaction):
            let sql = "SELECT EXISTS ( SELECT 1 FROM \(UserProfileRecord.databaseTableName) WHERE \(userProfileColumn: .uniqueId) = ? )"
            let arguments: StatementArguments = [uniqueId]
            return try! Bool.fetchOne(grdbTransaction.database, sql: sql, arguments: arguments) ?? false
        }
    }
}

// MARK: - Swift Fetch

public extension OWSUserProfile {
    class func grdbFetchCursor(sql: String,
                               arguments: StatementArguments = StatementArguments(),
                               transaction: GRDBReadTransaction) -> OWSUserProfileCursor {
        do {
            let sqlRequest = SQLRequest<Void>(sql: sql, arguments: arguments, cached: true)
            let cursor = try UserProfileRecord.fetchCursor(transaction.database, sqlRequest)
            return OWSUserProfileCursor(transaction: transaction, cursor: cursor)
        } catch {
            Logger.verbose("sql: \(sql)")
            owsFailDebug("Read failed: \(error)")
            return OWSUserProfileCursor(transaction: transaction, cursor: nil)
        }
    }

    class func grdbFetchOne(sql: String,
                            arguments: StatementArguments = StatementArguments(),
                            transaction: GRDBReadTransaction) -> OWSUserProfile? {
        assert(sql.count > 0)

        do {
            let sqlRequest = SQLRequest<Void>(sql: sql, arguments: arguments, cached: true)
            guard let record = try UserProfileRecord.fetchOne(transaction.database, sqlRequest) else {
                return nil
            }

            let value = try OWSUserProfile.fromRecord(record)
            Self.modelReadCaches.userProfileReadCache.didReadUserProfile(value, transaction: transaction.asAnyRead)
            return value
        } catch {
            owsFailDebug("error: \(error)")
            return nil
        }
    }
}

// MARK: - SDSSerializer

// The SDSSerializer protocol specifies how to insert and update the
// row that corresponds to this model.
class OWSUserProfileSerializer: SDSSerializer {

    private let model: OWSUserProfile
    public required init(model: OWSUserProfile) {
        self.model = model
    }

    // MARK: - Record

    func asRecord() throws -> SDSRecord {
        let id: Int64? = model.grdbId?.int64Value

        let recordType: SDSRecordType = .userProfile
        let uniqueId: String = model.uniqueId

        // Properties
        let avatarFileName: String? = model.avatarFileName
        let avatarUrlPath: String? = model.avatarUrlPath
        let profileKey: Data? = optionalArchive(model.profileKey)
        let profileName: String? = model.profileName
        let recipientPhoneNumber: String? = model.recipientPhoneNumber
        let recipientUUID: String? = model.recipientUUID
        let username: String? = model.username
        let familyName: String? = model.familyName
        let lastFetchDate: Double? = archiveOptionalDate(model.lastFetchDate)
        let lastMessagingDate: Double? = archiveOptionalDate(model.lastMessagingDate)
        let bio: String? = model.bio
        let bioEmoji: String? = model.bioEmoji
        let profileBadgeInfo: Data? = optionalArchive(model.profileBadgeInfo)
        let isStoriesCapable: Bool = model.isStoriesCapable
        let canReceiveGiftBadges: Bool = model.canReceiveGiftBadges

        return UserProfileRecord(delegate: model, id: id, recordType: recordType, uniqueId: uniqueId, avatarFileName: avatarFileName, avatarUrlPath: avatarUrlPath, profileKey: profileKey, profileName: profileName, recipientPhoneNumber: recipientPhoneNumber, recipientUUID: recipientUUID, username: username, familyName: familyName, lastFetchDate: lastFetchDate, lastMessagingDate: lastMessagingDate, bio: bio, bioEmoji: bioEmoji, profileBadgeInfo: profileBadgeInfo, isStoriesCapable: isStoriesCapable, canReceiveGiftBadges: canReceiveGiftBadges)
    }
}

// MARK: - Deep Copy

#if TESTABLE_BUILD
@objc
public extension OWSUserProfile {
    // We're not using this method at the moment,
    // but we might use it for validation of
    // other deep copy methods.
    func deepCopyUsingRecord() throws -> OWSUserProfile {
        guard let record = try asRecord() as? UserProfileRecord else {
            throw OWSAssertionError("Could not convert to record.")
        }
        return try OWSUserProfile.fromRecord(record)
    }
}
#endif
