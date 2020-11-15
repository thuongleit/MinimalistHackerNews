import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'network_state.dart';

abstract class NetworkCubit<T> extends Cubit<NetworkState<T>> {
  NetworkCubit() : super(const NetworkState());

  Future<void> refresh() async {}
}
