import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class BuildScanner extends StatefulWidget {
  const BuildScanner({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _BuildScannerState();
  }
}

class _BuildScannerState extends State<BuildScanner> {
  final MobileScannerController controller = MobileScannerController();
  String? url;

  Future<void> _launchURL(BuildContext context) async {
    try {
      await launchUrl(Uri.parse(url ?? ''));
    } on PlatformException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal membuka URL: '${e.message}'."),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: controller,
              onDetect: (BarcodeCapture capture) async {
                final List<Barcode> barcodes = capture.barcodes;
                final barcode = barcodes.first;
                if (barcode.rawValue != null) {
                  setState(() => url = barcode.rawValue);
                }
              },
            ),
          ),
          Center(
            heightFactor: 3,
            child: (url == null || url == '')
                ? const Text('Scan QR Code')
                : GestureDetector(
                    onTap: () => _launchURL(context),
                    child: Text(
                      url ?? '',
                      style: const TextStyle(
                        color: Colors.indigoAccent,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
