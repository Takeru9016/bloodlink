// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_status_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(requestStatusList)
final requestStatusListProvider = RequestStatusListProvider._();

final class RequestStatusListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RequestStatusEntry>>,
          List<RequestStatusEntry>,
          FutureOr<List<RequestStatusEntry>>
        >
    with
        $FutureModifier<List<RequestStatusEntry>>,
        $FutureProvider<List<RequestStatusEntry>> {
  RequestStatusListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'requestStatusListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$requestStatusListHash();

  @$internal
  @override
  $FutureProviderElement<List<RequestStatusEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RequestStatusEntry>> create(Ref ref) {
    return requestStatusList(ref);
  }
}

String _$requestStatusListHash() => r'8acd387c0a384578716e8116afa68a2c1235cefb';

@ProviderFor(RequestStatusController)
final requestStatusControllerProvider = RequestStatusControllerProvider._();

final class RequestStatusControllerProvider
    extends $AsyncNotifierProvider<RequestStatusController, void> {
  RequestStatusControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'requestStatusControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$requestStatusControllerHash();

  @$internal
  @override
  RequestStatusController create() => RequestStatusController();
}

String _$requestStatusControllerHash() =>
    r'cf9d289597e1442da5ceba7775a9f994700eaa05';

abstract class _$RequestStatusController extends $AsyncNotifier<void> {
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
