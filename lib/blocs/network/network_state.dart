part of 'network_cubit.dart';

enum NetworkStatus { initial, loading, success, failure }

class NetworkState<T> extends Equatable {
  final NetworkStatus status;
  final Exception error;
  final T data;

  const NetworkState({
    this.status = NetworkStatus.initial,
    this.data,
    this.error,
  });

  const NetworkState.loading() : this(status: NetworkStatus.loading);

  const NetworkState.success(T data)
      : this(status: NetworkStatus.success, data: data);

  const NetworkState.failure({Exception error})
      : this(
          status: NetworkStatus.failure,
          error: error,
        );

  @override
  List<Object> get props => [status, data, error];
}

extension NetworkStateDescription on NetworkState {
  bool get isInitial => status == NetworkStatus.initial;

  bool get isLoading => status == NetworkStatus.loading;

  bool get isSuccess => status == NetworkStatus.success;

  bool get isFailure => status == NetworkStatus.failure;

  bool get hasData => data != null;
}
