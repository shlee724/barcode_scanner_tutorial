import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class MobileScannerWidget extends StatelessWidget {
  final MobileScannerController cameraController = MobileScannerController();
  List<String?> scannedBarcodes = [];

  void dispose() {
    cameraController.dispose();
  }

  void _handleBarcodeDetection(
      BarcodeCapture capture, BuildContext context) async {
    final barcode = capture.barcodes.first;
    final String? code = barcode.rawValue;
    final format = barcode.format;
    print("barcode type: $format");
    if (format == BarcodeFormat.code39) {
      print(true);
    }

    if (scannedBarcodes.length < 3) {
      //코드 길이가 10을 넘지 않으면 리스트에 코드만 추가
      scannedBarcodes.add(code);
    } else {
      //코드 길이가 10이 되면 바코드를 제대로 인식했는지 검사하는 알고리즘 돌아감

      if (scannedBarcodes[0] != null) {
        bool isEightDigitNumber = RegExp(r'^\d{8}$')
            .hasMatch(scannedBarcodes[0]!); // 바코드가 8자리의 숫자로만 이루어져 있는지 판단하는 코드
        if (isEightDigitNumber &&
            scannedBarcodes.every((element) =>
                element == scannedBarcodes[0] &&
                format == BarcodeFormat.code39)) {
          //8자리 숫자 and 인식한 모든 리스트의 바코드가 동일 and 바코드 타입이 code39
          print(scannedBarcodes);
          final codeResult = scannedBarcodes[0];
          scannedBarcodes = []; //리스트 초기화
          // 카메라를 중지하고, 결과를 팝업으로 전달
          await cameraController.stop();
          Navigator.pop(context, codeResult);
        }
      }
      scannedBarcodes.removeAt(0);
      scannedBarcodes.add(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      controller: cameraController,
      onDetect: (BarcodeCapture capture) {
        _handleBarcodeDetection(capture, context);
      },
    );
  }
}
