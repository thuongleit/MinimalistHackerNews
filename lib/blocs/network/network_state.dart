part of 'network_bloc.dart';

enum NetworkStatus { loading, success, failure }

class NetworkState<T> extends Equatable {
  final NetworkStatus status;
  final Exception error;
  final T data;

  const NetworkState._({
    this.status = NetworkStatus.loading,
    this.data,
    this.error,
  });

  const NetworkState.loading() : this._();

  const NetworkState.success(T data)
      : this._(status: NetworkStatus.success, data: data);

  const NetworkState.failure({Exception error})
      : this._(
          status: NetworkStatus.failure,
          error: error,
        );

  @override
  List<Object> get props => [status, data, error];
}

extension NetworkStateDescription on NetworkState {
  bool get isLoading => status == NetworkStatus.loading;

  bool get isSuccess => status == NetworkStatus.success;

  bool get isFailure => status == NetworkStatus.failure;
}
