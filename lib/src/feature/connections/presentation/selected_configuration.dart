import 'package:collection/collection.dart';
import 'package:dbeaver_bookmarks/src/feature/connections/data/connection_configuration_repository.dart';
import 'package:dbeaver_bookmarks/src/feature/connections/domain/connection_configuration.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_configuration.g.dart';

@riverpod
class SelectedConnectionConfiguration
    extends _$SelectedConnectionConfiguration {
  @override
  ConnectionConfiguration? build() {
    var subscription = ref.listen(configurationsProvider, (previous, next) {
      if (state == null) return;
      var selected = next.firstWhereOrNull(
        (element) => element.id == state!.id,
      );
      state = selected;
    });
    ref.onDispose(subscription.close);
    return null;
  }

  void change(ConnectionConfiguration? configFile) {
    state = configFile;
  }
}
