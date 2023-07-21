import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/media_store/media_store.dart';
import 'shared/data/data_sources/access_token_local_data_source.dart';
import 'shared/data/data_sources/profile_local_data_source.dart';
import 'shared/data/data_sources/profile_remote_data_source.dart';
import 'shared/data/repositories/access_token_repository_impl.dart';
import 'shared/data/repositories/profile_repository_impl.dart';
import 'shared/domain/repositories/access_token_repository.dart';
import 'shared/domain/repositories/profile_repository.dart';

class Injection {
  Injection._();

  static final Injection _instance = Injection._();

  static Injection get instance => _instance;

  // Data Source
  AccessTokenLocalDataSource accessTokenLocalDataSource() =>
      AccessTokenLocalDataSourceImpl();
  ProfileLocalDataSource profileLocalDataSource() =>
      ProfileLocalDataSourceImpl();
  ProfileRemoteDataSource profileRemoteDataSource() =>
      ProfileRemoteDataSourceImpl();

  // Repository
  AccessTokenRepository accessTokenRepository() => AccessTokenRepositoryImpl();
  ProfileRepository profileRepository() => ProfileRepositoryImpl();

  // Other
  MediaStore mediaStore() => MediaStoreImpl();

  // Bloc
  //TODO: add your initial bloc providers here.
  List<BlocProvider> initBloc() => [];

  T getFromBlocProvider<T extends BlocBase<Object?>>(BuildContext context) =>
      BlocProvider.of<T>(context);
}
