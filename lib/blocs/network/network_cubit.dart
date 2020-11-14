part of 'network_bloc.dart';

abstract class NetworkCubit<T> extends Cubit<NetworkState<T>> {
  NetworkCubit() : super(const NetworkState.loading());

  Future<void> fetchData();
}
