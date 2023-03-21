import 'package:get/get.dart';

import '../controllers/certificates_Controller.dart';

class CertificatesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CertificatesController>(
      () => CertificatesController(),
    );
  }
}
