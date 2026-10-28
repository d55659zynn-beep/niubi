import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:wangshen_app/db/application_repo.dart';
import 'package:wangshen_app/db/isar_service.dart';
import 'package:wangshen_app/db/schemas/application_record.dart';

import 'isar_test_helper.dart';

/// 投递记录数据层测试：状态 + 备注持久化、按岗位关联、去重更新。
void main() {
  late Directory tmpDir;

  setUpAll(() async {
    tmpDir = Directory.systemTemp.createTempSync('ws_apply_test');
    loadIsarNativeLib();
    await IsarService.instance.init(directoryOverride: tmpDir.path);
  });

  tearDownAll(() async {
    await IsarService.instance.isar.close();
    tmpDir.deleteSync(recursive: true);
  });

  test('保存投递状态与备注后可读取', () async {
    await ApplicationRepo.instance.upsert(
      jobId: 1001,
      status: ApplyStatus.submitted,
      note: '已投递，等待笔试',
    );
    final record = await ApplicationRepo.instance.getByJobId(1001);
    expect(record, isNotNull);
    expect(record!.jobId, 1001);
    expect(record.status, ApplyStatus.submitted.index);
    expect(record.note, '已投递，等待笔试');
    expect(record.createdAt, isNotNull);
    expect(record.updatedAt, isNotNull);
  });

  test('同一岗位再次保存为覆盖更新，不产生多条记录', () async {
    await ApplicationRepo.instance.upsert(
      jobId: 1001,
      status: ApplyStatus.interviewing,
      note: '面试时间 11-05',
    );
    final records = await ApplicationRepo.instance.getAll();
    expect(records.length, 1, reason: '同一岗位只保留一条投递记录');
    expect(records.single.status, ApplyStatus.interviewing.index);
    expect(records.single.note, '面试时间 11-05');
  });

  test('getAllMap 按岗位 Id 返回映射', () async {
    await ApplicationRepo.instance.upsert(
      jobId: 1002,
      status: ApplyStatus.pending,
      note: '',
    );
    final map = await ApplicationRepo.instance.getAllMap();
    expect(map.containsKey(1001), isTrue);
    expect(map.containsKey(1002), isTrue);
    expect(map[1002]!.status, ApplyStatus.pending.index);
  });

  test('删除投递记录', () async {
    await ApplicationRepo.instance.deleteByJobId(1002);
    expect(await ApplicationRepo.instance.getByJobId(1002), isNull);
  });

  test('投递状态中文标签齐全', () {
    for (final status in ApplyStatus.values) {
      expect(applyStatusLabels[status], isNotEmpty, reason: '$status 缺少中文标签');
    }
  });
}