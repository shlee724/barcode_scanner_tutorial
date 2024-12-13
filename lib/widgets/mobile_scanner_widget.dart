import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class MobileScannerWidget extends StatelessWidget {
  final MobileScannerController cameraController = MobileScannerController();
  List<String?> scannedBarcodes = [];

  //8자리 숫자 and 인식한 모든 리스트의 바코드가 동일 and 바코드 타입이 code39인지 검사
  bool isScannedBarcodeValid(BarcodeFormat format) {
    if (scannedBarcodes[0] != null) {
      bool isEightDigitNumber =
          RegExp(r'^\d{8}$').hasMatch(scannedBarcodes[0]!);
      if (isEightDigitNumber &&
          scannedBarcodes.every((element) =>
              element == scannedBarcodes[0] &&
              format == BarcodeFormat.code39)) {
        return true;
      }
    }
    return false;
  }

  void _handleBarcodeDetection(
      BarcodeCapture capture, BuildContext context) async {
    final barcode = capture.barcodes.first;
    final String? code = barcode.rawValue;
    final format = barcode.format;

    if (scannedBarcodes.length < 3) {
      //바코드가 3번 찍히지 않았으면 찍힌 리스트에 바코드 추가
      scannedBarcodes.add(code);
    } else {
      // 찍힌 바코드가 3개 이상이면 바코드를 제대로 인식했는지 검사하는 알고리즘

      if (isScannedBarcodeValid(format)) {
        final codeResult = scannedBarcodes[0];
        scannedBarcodes = []; //리스트 초기화
        // 카메라를 중지하고, 결과를 팝업으로 전달
        await cameraController.stop();
        Navigator.pop(context, codeResult);
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
