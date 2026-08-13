import 'bootstrap.dart';
import 'firebase_options_prod.dart';

/// Prod entrypoint: `flutter run -t lib/main_prod.dart`. Throws at startup
/// until `bloodlink-prod` is provisioned — see `firebase_options_prod.dart`.
Future<void> main() async {
  await bootstrap(DefaultFirebaseOptionsProd.currentPlatform);
}
