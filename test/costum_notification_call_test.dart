import 'package:flutter_test/flutter_test.dart';
import 'package:mc_custom_notification/src/mc_custom_notification_platform_interface.dart';
import 'package:mc_custom_notification/src/mc_custom_notification_method_channel.dart';

// class MockCostumNotificationCallPlatform
//     with MockPlatformInterfaceMixin
//     implements CostumNotificationCallPlatform {

//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

void main() {
  final McCustomNotificationPlatform initialPlatform =
      McCustomNotificationPlatform.instance;

  test('$MethodChannelMcCustomNotification is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMcCustomNotification>());
  });

  test('getPlatformVersion', () async {
    // CostumNotificationCall costumNotificationCallPlugin = CostumNotificationCall();
    // MockCostumNotificationCallPlatform fakePlatform = MockCostumNotificationCallPlatform();
    // CostumNotificationCallPlatform.instance = fakePlatform;

    // expect(await costumNotificationCallPlugin.getPlatformVersion(), '42');
  });
}
