// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_blood_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RequestBloodController)
final requestBloodControllerProvider = RequestBloodControllerProvider._();

final class RequestBloodControllerProvider
    extends $AsyncNotifierProvider<RequestBloodController, void> {
  RequestBloodControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'requestBloodControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$requestBloodControllerHash();

  @$internal
  @override
  RequestBloodController create() => RequestBloodController();
}

String _$requestBloodControllerHash() =>
    r'eb34b71cdbc4971438af93139a54ba8a15f2bf8f';

abstract class _$RequestBloodController extends $AsyncNotifier<void> {
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
