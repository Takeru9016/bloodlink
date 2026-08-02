// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_center_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(notificationCenterList)
final notificationCenterListProvider = NotificationCenterListProvider._();

final class NotificationCenterListProvider
    extends
        $FunctionalProvider<
          AsyncValue<NotificationCenterState>,
          NotificationCenterState,
          FutureOr<NotificationCenterState>
        >
    with
        $FutureModifier<NotificationCenterState>,
        $FutureProvider<NotificationCenterState> {
  NotificationCenterListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationCenterListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationCenterListHash();

  @$internal
  @override
  $FutureProviderElement<NotificationCenterState> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<NotificationCenterState> create(Ref ref) {
    return notificationCenterList(ref);
  }
}

String _$notificationCenterListHash() =>
    r'a33f644c6b96aa889f62185ed1d0f2413a26f5c2';

@ProviderFor(NotificationCenterController)
final notificationCenterControllerProvider =
    NotificationCenterControllerProvider._();

final class NotificationCenterControllerProvider
    extends $AsyncNotifierProvider<NotificationCenterController, void> {
  NotificationCenterControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationCenterControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationCenterControllerHash();

  @$internal
  @override
  NotificationCenterController create() => NotificationCenterController();
}

String _$notificationCenterControllerHash() =>
    r'f9b0368e23fd87dd4c4dcb9edd9963d56df2a1c5';

abstract class _$NotificationCenterController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
