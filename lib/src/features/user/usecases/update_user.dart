part of qiscus_chat_sdk.usecase.user;

@immutable
class UpdateUserParams {
  final String name;
  final String avatarUrl;
  final Map<String, dynamic> extras;
  const UpdateUserParams({
    this.name,
    this.avatarUrl,
    this.extras,
  });
}

class UpdateUserUseCase
    extends UseCase<IUserRepository, Account, UpdateUserParams> {
  final Storage _storage;
  const UpdateUserUseCase(IUserRepository repository, this._storage)
      : super(repository);

  @override
  Future<Either<Error, Account>> call(UpdateUserParams p) async {
    var resp = await repository.updateUser(
      name: p.name,
      avatarUrl: p.avatarUrl,
      extras: p.extras,
    );
    resp.map((user) {
      _storage.currentUser = _storage.currentUser.copy(
        name: user.name ?? immutable,
        avatarUrl: user.avatarUrl ?? immutable,
        extras: user.extras ?? immutable,
      );
    });

    return resp;
  }
}
