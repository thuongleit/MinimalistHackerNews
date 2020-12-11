import 'package:hydrated_bloc/hydrated_bloc.dart';

enum ViewMode { titleOnly, minimalist, withDetail }

class ViewModeCubit extends HydratedCubit<ViewMode> {
  static const _prefKey = 'view_mode';

  ViewModeCubit() : super(ViewMode.minimalist);

  void changeViewMode(ViewMode mode) => emit(mode);

  @override
  ViewMode fromJson(Map<String, dynamic> json) {
    final prefCode = json[_prefKey] as int;
    return ViewMode.values[prefCode];
  }

  @override
  Map<String, dynamic> toJson(ViewMode state) {
    return <String, int>{_prefKey: state.index};
  }
}
