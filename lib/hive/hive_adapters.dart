import 'package:hive_ce/hive.dart';
import 'entity/add_data.dart';
import 'entity/auth_data.dart';
import 'entity/kode_daerah_data.dart';

part 'hive_adapters.g.dart';

@GenerateAdapters([
  AdapterSpec<AuthData>(),
  AdapterSpec<AddData>(ignoredFields: {'status', 'progress'}),
  AdapterSpec<KodeDaerahData>(),
])
class HiveAdapterConfig {}
