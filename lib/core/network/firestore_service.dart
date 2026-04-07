import 'package:cloud_firestore/cloud_firestore.dart';
import '../error/failure_mapper.dart';
import '../error/result.dart';
import '../utils/execute_and_handle_errors.dart';

typedef FirestoreData = Map<String, Object?>;

final class FirestoreDocument {
  const FirestoreDocument({required this.id, required this.data});

  final String id;
  final FirestoreData data;
}

sealed class FirestoreBatchOperation {
  const FirestoreBatchOperation({
    required this.collectionPath,
    required this.documentId,
  });

  final String collectionPath;
  final String documentId;
}

final class FirestoreBatchSetOperation extends FirestoreBatchOperation {
  const FirestoreBatchSetOperation({
    required super.collectionPath,
    required super.documentId,
    required this.data,
    this.merge = false,
  });

  final FirestoreData data;
  final bool merge;
}

final class FirestoreBatchUpdateOperation extends FirestoreBatchOperation {
  const FirestoreBatchUpdateOperation({
    required super.collectionPath,
    required super.documentId,
    required this.data,
  });

  final FirestoreData data;
}

final class FirestoreBatchDeleteOperation extends FirestoreBatchOperation {
  const FirestoreBatchDeleteOperation({
    required super.collectionPath,
    required super.documentId,
  });
}

final class FirestoreService {
  const FirestoreService({
    required FirebaseFirestore firestore,
    FailureMapper failureMapper = const FailureMapper(),
  }) : _firestore = firestore,
       _failureMapper = failureMapper;

  final FirebaseFirestore _firestore;
  final FailureMapper _failureMapper;

  Future<Result<String>> addDocument({
    required String collectionPath,
    required FirestoreData data,
  }) => executeAndHandleErrors(
    () async {
      final docRef = await _collection(collectionPath).add(_toRawData(data));
      return docRef.id;
    },
    tag: 'FirestoreService.addDocument',
    mapper: _failureMapper,
  );

  Future<Result<FirestoreDocument?>> getDocument({
    required String collectionPath,
    required String documentId,
  }) => executeAndHandleErrors(
    () async {
      final snapshot = await _document(collectionPath, documentId).get();
      return _fromDocumentSnapshot(snapshot);
    },
    tag: 'FirestoreService.getDocument',
    mapper: _failureMapper,
  );

  Stream<Result<FirestoreDocument?>> watchDocument({
    required String collectionPath,
    required String documentId,
  }) => executeStreamAndHandleErrors(
    () => _document(
      collectionPath,
      documentId,
    ).snapshots().map(_fromDocumentSnapshot),
    tag: 'FirestoreService.watchDocument',
    mapper: _failureMapper,
  );

  Future<Result<List<FirestoreDocument>>> getCollection({
    required String collectionPath,
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>> query)?
    queryBuilder,
  }) => executeAndHandleErrors(
    () async {
      final query = _buildQuery(
        collectionPath: collectionPath,
        queryBuilder: queryBuilder,
      );
      final snapshot = await query.get();
      return snapshot.docs.map(_fromQuerySnapshot).toList(growable: false);
    },
    tag: 'FirestoreService.getCollection',
    mapper: _failureMapper,
  );

  Stream<Result<List<FirestoreDocument>>> watchCollection({
    required String collectionPath,
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>> query)?
    queryBuilder,
  }) => executeStreamAndHandleErrors(
    () {
      final query = _buildQuery(
        collectionPath: collectionPath,
        queryBuilder: queryBuilder,
      );
      return query.snapshots().map(
        (snapshot) => snapshot.docs.map(_fromQuerySnapshot).toList(),
      );
    },
    tag: 'FirestoreService.watchCollection',
    mapper: _failureMapper,
  );

  Future<Result<void>> setDocument({
    required String collectionPath,
    required String documentId,
    required FirestoreData data,
    bool merge = true,
  }) => executeAndHandleErrors(
    () => _document(
      collectionPath,
      documentId,
    ).set(_toRawData(data), SetOptions(merge: merge)),
    tag: 'FirestoreService.setDocument',
    mapper: _failureMapper,
  );

  Future<Result<void>> updateDocument({
    required String collectionPath,
    required String documentId,
    required FirestoreData data,
  }) => executeAndHandleErrors(
    () => _document(collectionPath, documentId).update(_toRawData(data)),
    tag: 'FirestoreService.updateDocument',
    mapper: _failureMapper,
  );

  Future<Result<void>> deleteDocument({
    required String collectionPath,
    required String documentId,
  }) => executeAndHandleErrors(
    () => _document(collectionPath, documentId).delete(),
    tag: 'FirestoreService.deleteDocument',
    mapper: _failureMapper,
  );

  Future<Result<void>> writeBatch({
    required List<FirestoreBatchOperation> operations,
  }) => executeAndHandleErrors(
    () async {
      final batch = _firestore.batch();
      for (final operation in operations) {
        _applyBatchOperation(batch: batch, operation: operation);
      }
      await batch.commit();
    },
    tag: 'FirestoreService.writeBatch',
    mapper: _failureMapper,
  );

  Future<Result<T>> runTransaction<T>({
    required Future<T> Function(Transaction transaction) action,
  }) => executeAndHandleErrors(
    () => _firestore.runTransaction(action),
    tag: 'FirestoreService.runTransaction',
    mapper: _failureMapper,
  );

  CollectionReference<Map<String, dynamic>> _collection(String path) =>
      _firestore.collection(path);

  DocumentReference<Map<String, dynamic>> _document(
    String collectionPath,
    String documentId,
  ) => _collection(collectionPath).doc(documentId);

  Query<Map<String, dynamic>> _buildQuery({
    required String collectionPath,
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>> query)?
    queryBuilder,
  }) {
    final query = _collection(collectionPath);
    if (queryBuilder == null) {
      return query;
    }
    return queryBuilder(query);
  }

  FirestoreDocument? _fromDocumentSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    if (data == null) {
      return null;
    }
    return FirestoreDocument(id: snapshot.id, data: _toFirestoreData(data));
  }

  FirestoreDocument _fromQuerySnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
  ) => FirestoreDocument(
    id: snapshot.id,
    data: _toFirestoreData(snapshot.data()),
  );

  FirestoreData _toFirestoreData(Map<String, dynamic> data) =>
      Map<String, Object?>.from(data);

  Map<String, dynamic> _toRawData(FirestoreData data) =>
      Map<String, dynamic>.from(data);

  void _applyBatchOperation({
    required WriteBatch batch,
    required FirestoreBatchOperation operation,
  }) {
    final docRef = _document(operation.collectionPath, operation.documentId);
    switch (operation) {
      case FirestoreBatchSetOperation(:final data, :final merge):
        batch.set(docRef, _toRawData(data), SetOptions(merge: merge));
      case FirestoreBatchUpdateOperation(:final data):
        batch.update(docRef, _toRawData(data));
      case FirestoreBatchDeleteOperation():
        batch.delete(docRef);
    }
  }
}
