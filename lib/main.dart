import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                barcodeResult,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  String barcodeScanRes = "여기에 스캐너를 알맞게 넣으면 됨";
                  // 스캔 결과를 화면에 표시하도록 setState 사용
                  setState(() {
                    barcodeResult = barcodeScanRes;
                  });
                },
                child: const Text('Scan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

