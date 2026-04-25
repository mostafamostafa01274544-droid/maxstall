abstract interface class UseCase<T, P> {
  Future<T> call(P params);
}

final class NoParams {
  const NoParams();
}
