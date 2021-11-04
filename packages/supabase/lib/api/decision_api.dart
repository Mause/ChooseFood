//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.0

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class DecisionApi {
  DecisionApi([ApiClient apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Performs an HTTP 'DELETE /decision' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] id:
  ///
  /// * [String] createdAt:
  ///
  /// * [String] sessionId:
  ///
  /// * [bool] decision:
  ///
  /// * [String] placeReference:
  ///
  /// * [String] prefer:
  ///   Preference
  Future<Response> decisionDeleteWithHttpInfo({ String id, String createdAt, String sessionId, bool decision, String placeReference, String prefer, }) async {
    // Verify required params are set.

    // ignore: prefer_const_declarations
    final path = r'/decision';

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
    if (sessionId != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'sessionId', sessionId));
    }
    if (decision != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'decision', decision));
    }
    if (placeReference != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'placeReference', placeReference));
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
  /// * [String] sessionId:
  ///
  /// * [bool] decision:
  ///
  /// * [String] placeReference:
  ///
  /// * [String] prefer:
  ///   Preference
  Future<void> decisionDelete({ String id, String createdAt, String sessionId, bool decision, String placeReference, String prefer, }) async {
    final response = await decisionDeleteWithHttpInfo( id: id, createdAt: createdAt, sessionId: sessionId, decision: decision, placeReference: placeReference, prefer: prefer, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Performs an HTTP 'GET /decision' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] id:
  ///
  /// * [String] createdAt:
  ///
  /// * [String] sessionId:
  ///
  /// * [bool] decision:
  ///
  /// * [String] placeReference:
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
  Future<Response> decisionGetWithHttpInfo({ String id, String createdAt, String sessionId, bool decision, String placeReference, String select, String order, String range, String rangeUnit, String offset, String limit, String prefer, }) async {
    // Verify required params are set.

    // ignore: prefer_const_declarations
    final path = r'/decision';

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
    if (sessionId != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'sessionId', sessionId));
    }
    if (decision != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'decision', decision));
    }
    if (placeReference != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'placeReference', placeReference));
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
  /// * [String] sessionId:
  ///
  /// * [bool] decision:
  ///
  /// * [String] placeReference:
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
  Future<List<Decision>> decisionGet({ String id, String createdAt, String sessionId, bool decision, String placeReference, String select, String order, String range, String rangeUnit, String offset, String limit, String prefer, }) async {
    final response = await decisionGetWithHttpInfo( id: id, createdAt: createdAt, sessionId: sessionId, decision: decision, placeReference: placeReference, select: select, order: order, range: range, rangeUnit: rangeUnit, offset: offset, limit: limit, prefer: prefer, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body != null && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<Decision>') as List)
        .cast<Decision>()
        .toList(growable: false);

    }
    return Future<List<Decision>>.value();
  }

  /// Performs an HTTP 'PATCH /decision' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] id:
  ///
  /// * [String] createdAt:
  ///
  /// * [String] sessionId:
  ///
  /// * [String] placeReference:
  ///
  /// * [String] prefer:
  ///   Preference
  ///
  /// * [Decision] decision:
  ///   decision
  Future<Response> decisionPatchWithHttpInfo({ String id, String createdAt, String sessionId, String placeReference, String prefer, Decision decision, }) async {
    // Verify required params are set.

    // ignore: prefer_const_declarations
    final path = r'/decision';

    // ignore: prefer_final_locals
    Object postBody = decision;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (id != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'id', id));
    }
    if (createdAt != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'created_at', createdAt));
    }
    if (sessionId != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'sessionId', sessionId));
    }
    if (placeReference != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'placeReference', placeReference));
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
  /// * [String] sessionId:
  ///
  /// * [String] placeReference:
  ///
  /// * [String] prefer:
  ///   Preference
  ///
  /// * [Decision] decision:
  ///   decision
  Future<void> decisionPatch({ String id, String createdAt, String sessionId, String placeReference, String prefer, Decision decision, }) async {
    final response = await decisionPatchWithHttpInfo( id: id, createdAt: createdAt, sessionId: sessionId, placeReference: placeReference, prefer: prefer, decision: decision, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Performs an HTTP 'POST /decision' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] select:
  ///   Filtering Columns
  ///
  /// * [String] prefer:
  ///   Preference
  ///
  /// * [Decision] decision:
  ///   decision
  Future<Response> decisionPostWithHttpInfo({ String select, String prefer, Decision decision, }) async {
    // Verify required params are set.

    // ignore: prefer_const_declarations
    final path = r'/decision';

    // ignore: prefer_final_locals
    Object postBody = decision;

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
  /// * [Decision] decision:
  ///   decision
  Future<void> decisionPost({ String select, String prefer, Decision decision, }) async {
    final response = await decisionPostWithHttpInfo( select: select, prefer: prefer, decision: decision, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }
}
