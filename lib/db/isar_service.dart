import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'schemas/app_setting.dart';
import 'schemas/application_record.dart';
import 'schemas/form_mapping.dart';
import 'schemas/job_posting.dart';
import 'schemas/personal_profile.dart';
import 'schemas/resume_template.dart';

/// 本地 Isar 单例。数据只写本机目录，不做任何网络同步。
class IsarService {
  IsarService._();
  static final IsarService instance = IsarService._();

  Isar? _isar;

  Isar get isar {
    final db = _isar;
    if (db == null) {
      throw StateError('Isar 尚未初始化，请先调用 IsarService.instance.init()');
    }
    return db;
  }

  Future<void> init({String? directoryOverride}) async {
    if (_isar != null) return;
    // 测试环境传 directoryOverride（临时目录），避免依赖 path_provider 平台通道
    final dir = directoryOverride ??
        (await getApplicationDocumentsDirectory()).path;
    _isar = await Isar.open(
      [
        JobPostingSchema,
        ResumeTemplateSchema,
        FormMappingSchema,
        PersonalProfileSchema,
        ApplicationRecordSchema,
        AppSettingSchema,
      ],
      directory: dir,
      name: 'wangshen_local',
    );
  }
}
