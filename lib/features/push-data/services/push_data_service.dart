import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../cores/base/base_service.dart';

final pushDataService = Provider((ref) => PushDataService());

class PushDataService extends BaseService {}
