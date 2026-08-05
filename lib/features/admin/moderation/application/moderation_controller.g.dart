// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderation_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(openReports)
final openReportsProvider = OpenReportsProvider._();

final class OpenReportsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<({String id, ReportModel model})>>,
          List<({String id, ReportModel model})>,
          FutureOr<List<({String id, ReportModel model})>>
        >
    with
        $FutureModifier<List<({String id, ReportModel model})>>,
        $FutureProvider<List<({String id, ReportModel model})>> {
  OpenReportsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'openReportsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$openReportsHash();

  @$internal
  @override
  $FutureProviderElement<List<({String id, ReportModel model})>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<({String id, ReportModel model})>> create(Ref ref) {
    return openReports(ref);
  }
}

String _$openReportsHash() => r'e369df7e7ab60deb31612b3372086528f1ac386b';

@ProviderFor(reportUser)
final reportUserProvider = ReportUserFamily._();

final class ReportUserProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserModel?>,
          UserModel?,
          FutureOr<UserModel?>
        >
    with $FutureModifier<UserModel?>, $FutureProvider<UserModel?> {
  ReportUserProvider._({
    required ReportUserFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'reportUserProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$reportUserHash();

  @override
  String toString() {
    return r'reportUserProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<UserModel?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<UserModel?> create(Ref ref) {
    final argument = this.argument as String;
    return reportUser(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ReportUserProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$reportUserHash() => r'57b4583e5e2e0a72d3958e5dd92b0ceda8c6c649';

final class ReportUserFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<UserModel?>, String> {
  ReportUserFamily._()
    : super(
        retry: null,
        name: r'reportUserProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ReportUserProvider call(String uid) =>
      ReportUserProvider._(argument: uid, from: this);

  @override
  String toString() => r'reportUserProvider';
}

@ProviderFor(ModerationController)
final moderationControllerProvider = ModerationControllerProvider._();

final class ModerationControllerProvider
    extends $AsyncNotifierProvider<ModerationController, void> {
  ModerationControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'moderationControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$moderationControllerHash();

  @$internal
  @override
  ModerationController create() => ModerationController();
}

String _$moderationControllerHash() =>
    r'f6fea6232137ffd3970330eb6e7ec74dc51dbec4';

abstract class _$ModerationController extends $AsyncNotifier<void> {
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
