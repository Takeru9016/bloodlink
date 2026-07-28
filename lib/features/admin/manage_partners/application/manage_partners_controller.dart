import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/models/partner_model.dart';
import '../../../../data/repositories/partner_repository.dart';

part 'manage_partners_controller.g.dart';

@riverpod
class ManagePartnersController extends _$ManagePartnersController {
  @override
  Future<List<({String id, PartnerModel partner})>> build() {
    return ref.read(partnerRepositoryProvider).listPartners();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
