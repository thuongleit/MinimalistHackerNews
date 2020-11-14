part of 'network_bloc.dart';

abstract class NetworkEvent extends Equatable {
  const NetworkEvent();

  @override
  List<Object> get props => [];
}

class LoadData extends NetworkEvent {}

class RefreshData extends NetworkEvent {}
