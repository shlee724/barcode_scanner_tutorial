import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String barcodeResult = "No scan result";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Barcode Scanner',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Barcode Scanner'),
        ),
        body: Builder(
          builder: (context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  barcodeResult,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BarcodeScannerScreen()),
                    ).then((result) {
                      if (result != null) {
                        setState(() {
                          barcodeResult = result;
                        });
                      }
                    });
                  },
                  child: const Text('Scan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({Key? key}) : super(key: key);

  @override
  _BarcodeScannerScreenState createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  final MobileScannerController cameraController = MobileScannerController();
  List<String?> scannedBarcodes = [];

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Barcode'),
      ),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (BarcodeCapture capture) async {
          final barcode = capture.barcodes.first;
          final String? code = barcode.rawValue;

          if (scannedBarcodes.length <3) {     //코드 길이가 10을 넘지 않으면 리스트에 코드만 추가
            scannedBarcodes.add(code);
          } else {                              //코드 길이가 10이 되면 바코드를 제대로 인식했는지 검사하는 알고리즘 돌아감

            if (scannedBarcodes[0] != null){
              bool isEightDigitNumber = RegExp(r'^\d{8}$').hasMatch(scannedBarcodes[0]!); // 바코드가 8자리의 숫자로만 이루어져 있는지 판단하는 코드
              if (isEightDigitNumber && scannedBarcodes.every((element) => element == scannedBarcodes[0])) {  //8자리 숫자 and 인식한 모든 리스트의 바코드가 동일
                print(scannedBarcodes);
                final codeResult = scannedBarcodes[0];
                scannedBarcodes = [];   //리스트 초기화
                // 카메라를 중지하고, 결과를 팝업으로 전달
                await cameraController.stop();
                Navigator.pop(context, codeResult);
              }
            }
            scannedBarcodes.removeAt(0);
            scannedBarcodes.add(code);

          }

        },
      ),
    );
  }
}
