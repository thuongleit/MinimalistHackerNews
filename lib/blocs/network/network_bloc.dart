import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'network_event.dart';

part 'network_state.dart';

part 'network_cubit.dart';

abstract class NetworkBloc<Event extends NetworkEvent>
    extends Bloc<NetworkEvent, NetworkState> {
  NetworkBloc() : super(const NetworkState.loading());
}
