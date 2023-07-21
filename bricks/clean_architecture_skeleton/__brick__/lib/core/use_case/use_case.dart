import 'package:{{name.snakeCase()}}/core/failures/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

abstract class UseCase<Type, Params, Repo> {
  Repo get repo;
  Future<Either<Failure, Type>> call(Params param);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}

class IDParams extends Equatable {
  final String id;

  const IDParams({required this.id});

  @override
  List<Object?> get props => [id];
}

class UsingQueryParams extends Equatable {
  final Map<String, dynamic>? queryParams;

  const UsingQueryParams({this.queryParams});

  @override
  List<Object?> get props => [queryParams];
}
