// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fcm_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FcmController)
final fcmControllerProvider = FcmControllerProvider._();

final class FcmControllerProvider
    extends $AsyncNotifierProvider<FcmController, void> {
  FcmControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fcmControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fcmControllerHash();

  @$internal
  @override
  FcmController create() => FcmController();
}

String _$fcmControllerHash() => r'ba964bacd78dc3bf3bd3268abba55f6157476e66';

abstract class _$FcmController extends $AsyncNotifier<void> {
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
