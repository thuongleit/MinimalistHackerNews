import 'package:hydrated_bloc/hydrated_bloc.dart';

enum ReadingMode { titleOnly, minimalist, withContent }

extension ReadingModeX on ReadingMode {
  bool get isTitleOnly => this == ReadingMode.titleOnly;
  bool get isMinimalist => this == ReadingMode.minimalist;
  bool get isWithContent => this == ReadingMode.withContent;
}

class ReadingModeCubit extends HydratedCubit<ReadingMode> {
  static const _prefKey = 'reading_mode';

  ReadingModeCubit() : super(ReadingMode.minimalist);

  void changeMode(ReadingMode mode) => emit(mode);

  @override
  ReadingMode fromJson(Map<String, dynamic> json) {
    final prefCode = json[_prefKey] as int;
    return ReadingMode.values[prefCode];
  }

  @override
  Map<String, dynamic> toJson(ReadingMode state) {
    return <String, int>{_prefKey: state.index};
  }
}
