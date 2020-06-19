import 'package:barcode_scan/barcode_scan.dart';

Future<String> getSeedFromQR() async {
  var result = await BarcodeScanner.scan();
  String totpLink = result.rawContent;
  if(totpLink.contains('?secret='))
    return totpLink.split('?secret=').last;
  return 'ERROR';
}