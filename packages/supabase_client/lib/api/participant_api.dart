//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.0

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class ParticipantApi {
  ParticipantApi([ApiClient apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Performs an HTTP 'DELETE /participant' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] id:
  ///
  /// * [String] createdAt:
  ///
  /// * [String] userId:
  ///
  /// * [String] session:
  ///
  /// * [String] prefer:
  ///   Preference
  Future<Response> participantDeleteWithHttpInfo({ String id, String createdAt, String userId, String session, String prefer, }) async {
    // Verify required params are set.

    // ignore: prefer_const_declarations
    final path = r'/participant';

    // ignore: prefer_final_locals
    Object postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (id != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'id', id));
    }
    if (createdAt != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'created_at', createdAt));
    }
    if (userId != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'userId', userId));
    }
    if (session != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'session', session));
    }

    if (prefer != null) {
      headerParams[r'Prefer'] = parameterToString(prefer);
    }

    const authNames = <String>[];
    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes[0],
      authNames,
    );
  }

  /// Parameters:
  ///
  /// * [String] id:
  ///
  /// * [String] createdAt:
  ///
  /// * [String] userId:
  ///
  /// * [String] session:
  ///
  /// * [String] prefer:
  ///   Preference
  Future<void> participantDelete({ String id, String createdAt, String userId, String session, String prefer, }) async {
    final response = await participantDeleteWithHttpInfo( id: id, createdAt: createdAt, userId: userId, session: session, prefer: prefer, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Performs an HTTP 'GET /participant' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] id:
  ///
  /// * [String] createdAt:
  ///
  /// * [String] userId:
  ///
  /// * [String] session:
  ///
  /// * [String] select:
  ///   Filtering Columns
  ///
  /// * [String] order:
  ///   Ordering
  ///
  /// * [String] range:
  ///   Limiting and Pagination
  ///
  /// * [String] rangeUnit:
  ///   Limiting and Pagination
  ///
  /// * [String] offset:
  ///   Limiting and Pagination
  ///
  /// * [String] limit:
  ///   Limiting and Pagination
  ///
  /// * [String] prefer:
  ///   Preference
  Future<Response> participantGetWithHttpInfo({ String id, String createdAt, String userId, String session, String select, String order, String range, String rangeUnit, String offset, String limit, String prefer, }) async {
    // Verify required params are set.

    // ignore: prefer_const_declarations
    final path = r'/participant';

    // ignore: prefer_final_locals
    Object postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (id != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'id', id));
    }
    if (createdAt != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'created_at', createdAt));
    }
    if (userId != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'userId', userId));
    }
    if (session != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'session', session));
    }
    if (select != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'select', select));
    }
    if (order != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'order', order));
    }
    if (offset != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'offset', offset));
    }
    if (limit != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'limit', limit));
    }

    if (range != null) {
      headerParams[r'Range'] = parameterToString(range);
    }
    if (rangeUnit != null) {
      headerParams[r'Range-Unit'] = parameterToString(rangeUnit);
    }
    if (prefer != null) {
      headerParams[r'Prefer'] = parameterToString(prefer);
    }

    const authNames = <String>[];
    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes[0],
      authNames,
    );
  }

  /// Parameters:
  ///
  /// * [String] id:
  ///
  /// * [String] createdAt:
  ///
  /// * [String] userId:
  ///
  /// * [String] session:
  ///
  /// * [String] select:
  ///   Filtering Columns
  ///
  /// * [String] order:
  ///   Ordering
  ///
  /// * [String] range:
  ///   Limiting and Pagination
  ///
  /// * [String] rangeUnit:
  ///   Limiting and Pagination
  ///
  /// * [String] offset:
  ///   Limiting and Pagination
  ///
  /// * [String] limit:
  ///   Limiting and Pagination
  ///
  /// * [String] prefer:
  ///   Preference
  Future<List<Participant>> participantGet({ String id, String createdAt, String userId, String session, String select, String order, String range, String rangeUnit, String offset, String limit, String prefer, }) async {
    final response = await participantGetWithHttpInfo( id: id, createdAt: createdAt, userId: userId, session: session, select: select, order: order, range: range, rangeUnit: rangeUnit, offset: offset, limit: limit, prefer: prefer, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body != null && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<Participant>') as List)
        .cast<Participant>()
        .toList(growable: false);

    }
    return Future<List<Participant>>.value();
  }

  /// Performs an HTTP 'PATCH /participant' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] id:
  ///
  /// * [String] createdAt:
  ///
  /// * [String] userId:
  ///
  /// * [String] session:
  ///
  /// * [String] prefer:
  ///   Preference
  ///
  /// * [Participant] participant:
  ///   participant
  Future<Response> participantPatchWithHttpInfo({ String id, String createdAt, String userId, String session, String prefer, Participant participant, }) async {
    // Verify required params are set.

    // ignore: prefer_const_declarations
    final path = r'/participant';

    // ignore: prefer_final_locals
    Object postBody = participant;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (id != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'id', id));
    }
    if (createdAt != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'created_at', createdAt));
    }
    if (userId != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'userId', userId));
    }
    if (session != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'session', session));
    }

    if (prefer != null) {
      headerParams[r'Prefer'] = parameterToString(prefer);
    }

    const authNames = <String>[];
    const contentTypes = <String>['application/vnd.pgrst.object+json', 'application/json', 'text/csv'];


    return apiClient.invokeAPI(
      path,
      'PATCH',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes[0],
      authNames,
    );
  }

  /// Parameters:
  ///
  /// * [String] id:
  ///
  /// * [String] createdAt:
  ///
  /// * [String] userId:
  ///
  /// * [String] session:
  ///
  /// * [String] prefer:
  ///   Preference
  ///
  /// * [Participant] participant:
  ///   participant
  Future<void> participantPatch({ String id, String createdAt, String userId, String session, String prefer, Participant participant, }) async {
    final response = await participantPatchWithHttpInfo( id: id, createdAt: createdAt, userId: userId, session: session, prefer: prefer, participant: participant, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Performs an HTTP 'POST /participant' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] select:
  ///   Filtering Columns
  ///
  /// * [String] prefer:
  ///   Preference
  ///
  /// * [Participant] participant:
  ///   participant
  Future<Response> participantPostWithHttpInfo({ String select, String prefer, Participant participant, }) async {
    // Verify required params are set.

    // ignore: prefer_const_declarations
    final path = r'/participant';

    // ignore: prefer_final_locals
    Object postBody = participant;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (select != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'select', select));
    }

    if (prefer != null) {
      headerParams[r'Prefer'] = parameterToString(prefer);
    }

    const authNames = <String>[];
    const contentTypes = <String>['application/vnd.pgrst.object+json', 'application/json', 'text/csv'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes[0],
      authNames,
    );
  }

  /// Parameters:
  ///
  /// * [String] select:
  ///   Filtering Columns
  ///
  /// * [String] prefer:
  ///   Preference
  ///
  /// * [Participant] participant:
  ///   participant
  Future<void> participantPost({ String select, String prefer, Participant participant, }) async {
    final response = await participantPostWithHttpInfo( select: select, prefer: prefer, participant: participant, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }
}
