import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:qiscus_chat_sdk/src/core/core.dart';

import 'api.dart';
import 'entity.dart';

abstract class CoreRepository {
  Task<Either<QError, AppConfig>> getConfig();
}

class CoreRepositoryImpl implements CoreRepository {
  const CoreRepositoryImpl(this._api);

  final CoreApi _api;

  @override
  Task<Either<QError, AppConfig>> getConfig() {
    return Task(() => _api.getConfig())
        .attempt()
        .leftMapToQError()
        .rightMap((str) {
      var json = jsonDecode(str) as Map<String, dynamic>;
      var config = AppConfig.fromJson(json['results'] as Map<String, dynamic>);
      return config;
    });
  }
}
