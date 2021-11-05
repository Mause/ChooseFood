//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.0

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class CountriesApi {
  CountriesApi([ApiClient apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Full list of countries.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id:
  ///
  /// * [String] name:
  ///   Full country name.
  ///
  /// * [String] iso2:
  ///   ISO 3166-1 alpha-2 code.
  ///
  /// * [String] iso3:
  ///   ISO 3166-1 alpha-3 code.
  ///
  /// * [String] localName:
  ///   Local variation of the name.
  ///
  /// * [String] continent:
  ///
  /// * [String] prefer:
  ///   Preference
  Future<Response> countriesDeleteWithHttpInfo({ String id, String name, String iso2, String iso3, String localName, String continent, String prefer, }) async {
    // Verify required params are set.

    // ignore: prefer_const_declarations
    final path = r'/countries';

    // ignore: prefer_final_locals
    Object postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (id != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'id', id));
    }
    if (name != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'name', name));
    }
    if (iso2 != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'iso2', iso2));
    }
    if (iso3 != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'iso3', iso3));
    }
    if (localName != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'local_name', localName));
    }
    if (continent != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'continent', continent));
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

  /// Full list of countries.
  ///
  /// Parameters:
  ///
  /// * [String] id:
  ///
  /// * [String] name:
  ///   Full country name.
  ///
  /// * [String] iso2:
  ///   ISO 3166-1 alpha-2 code.
  ///
  /// * [String] iso3:
  ///   ISO 3166-1 alpha-3 code.
  ///
  /// * [String] localName:
  ///   Local variation of the name.
  ///
  /// * [String] continent:
  ///
  /// * [String] prefer:
  ///   Preference
  Future<void> countriesDelete({ String id, String name, String iso2, String iso3, String localName, String continent, String prefer, }) async {
    final response = await countriesDeleteWithHttpInfo( id: id, name: name, iso2: iso2, iso3: iso3, localName: localName, continent: continent, prefer: prefer, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Full list of countries.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id:
  ///
  /// * [String] name:
  ///   Full country name.
  ///
  /// * [String] iso2:
  ///   ISO 3166-1 alpha-2 code.
  ///
  /// * [String] iso3:
  ///   ISO 3166-1 alpha-3 code.
  ///
  /// * [String] localName:
  ///   Local variation of the name.
  ///
  /// * [String] continent:
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
  Future<Response> countriesGetWithHttpInfo({ String id, String name, String iso2, String iso3, String localName, String continent, String select, String order, String range, String rangeUnit, String offset, String limit, String prefer, }) async {
    // Verify required params are set.

    // ignore: prefer_const_declarations
    final path = r'/countries';

    // ignore: prefer_final_locals
    Object postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (id != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'id', id));
    }
    if (name != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'name', name));
    }
    if (iso2 != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'iso2', iso2));
    }
    if (iso3 != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'iso3', iso3));
    }
    if (localName != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'local_name', localName));
    }
    if (continent != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'continent', continent));
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

  /// Full list of countries.
  ///
  /// Parameters:
  ///
  /// * [String] id:
  ///
  /// * [String] name:
  ///   Full country name.
  ///
  /// * [String] iso2:
  ///   ISO 3166-1 alpha-2 code.
  ///
  /// * [String] iso3:
  ///   ISO 3166-1 alpha-3 code.
  ///
  /// * [String] localName:
  ///   Local variation of the name.
  ///
  /// * [String] continent:
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
  Future<List<Countries>> countriesGet({ String id, String name, String iso2, String iso3, String localName, String continent, String select, String order, String range, String rangeUnit, String offset, String limit, String prefer, }) async {
    final response = await countriesGetWithHttpInfo( id: id, name: name, iso2: iso2, iso3: iso3, localName: localName, continent: continent, select: select, order: order, range: range, rangeUnit: rangeUnit, offset: offset, limit: limit, prefer: prefer, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body != null && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<Countries>') as List)
        .cast<Countries>()
        .toList(growable: false);

    }
    return Future<List<Countries>>.value();
  }

  /// Full list of countries.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id:
  ///
  /// * [String] name:
  ///   Full country name.
  ///
  /// * [String] iso2:
  ///   ISO 3166-1 alpha-2 code.
  ///
  /// * [String] iso3:
  ///   ISO 3166-1 alpha-3 code.
  ///
  /// * [String] localName:
  ///   Local variation of the name.
  ///
  /// * [String] continent:
  ///
  /// * [String] prefer:
  ///   Preference
  ///
  /// * [Countries] countries:
  ///   countries
  Future<Response> countriesPatchWithHttpInfo({ String id, String name, String iso2, String iso3, String localName, String continent, String prefer, Countries countries, }) async {
    // Verify required params are set.

    // ignore: prefer_const_declarations
    final path = r'/countries';

    // ignore: prefer_final_locals
    Object postBody = countries;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (id != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'id', id));
    }
    if (name != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'name', name));
    }
    if (iso2 != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'iso2', iso2));
    }
    if (iso3 != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'iso3', iso3));
    }
    if (localName != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'local_name', localName));
    }
    if (continent != null) {
      queryParams.addAll(_convertParametersForCollectionFormat('', 'continent', continent));
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

  /// Full list of countries.
  ///
  /// Parameters:
  ///
  /// * [String] id:
  ///
  /// * [String] name:
  ///   Full country name.
  ///
  /// * [String] iso2:
  ///   ISO 3166-1 alpha-2 code.
  ///
  /// * [String] iso3:
  ///   ISO 3166-1 alpha-3 code.
  ///
  /// * [String] localName:
  ///   Local variation of the name.
  ///
  /// * [String] continent:
  ///
  /// * [String] prefer:
  ///   Preference
  ///
  /// * [Countries] countries:
  ///   countries
  Future<void> countriesPatch({ String id, String name, String iso2, String iso3, String localName, String continent, String prefer, Countries countries, }) async {
    final response = await countriesPatchWithHttpInfo( id: id, name: name, iso2: iso2, iso3: iso3, localName: localName, continent: continent, prefer: prefer, countries: countries, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Full list of countries.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] select:
  ///   Filtering Columns
  ///
  /// * [String] prefer:
  ///   Preference
  ///
  /// * [Countries] countries:
  ///   countries
  Future<Response> countriesPostWithHttpInfo({ String select, String prefer, Countries countries, }) async {
    // Verify required params are set.

    // ignore: prefer_const_declarations
    final path = r'/countries';

    // ignore: prefer_final_locals
    Object postBody = countries;

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

  /// Full list of countries.
  ///
  /// Parameters:
  ///
  /// * [String] select:
  ///   Filtering Columns
  ///
  /// * [String] prefer:
  ///   Preference
  ///
  /// * [Countries] countries:
  ///   countries
  Future<void> countriesPost({ String select, String prefer, Countries countries, }) async {
    final response = await countriesPostWithHttpInfo( select: select, prefer: prefer, countries: countries, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }
}
