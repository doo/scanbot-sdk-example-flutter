import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> initialize() async {
  // Please note: this is just an example license key string (it is not a valid license)
  var licenseKey = "fXbN2PmyqEAZ+btdkSIS36TuX2j/EE5qxVNcZMXYErbLQ" +
      "3OBnE10aOQxYI8L4UKwHiZ63jthvoFwUevttctBk0wVJ7Z" +
      "+Psz3/Ry8w7pXvfpB1o+JrnzGGcfwBnRi/5raQ2THDeokR" +
      "RB1keky2VBOFYbCfYt3Hqms5txF2z70PE/SBTMTIVuxL7q" +
      "1xcHDHclbEBriDtrHw8Pmhh9FqTg/r/4kRN/oEX37QGp+Y" +
      "3ogwIBbSmV+Cv+VuwtI31uXY3/GkyN/pSJZspIl+exwQDv" +
      "O0O1/R/oAURpfM4ydaWReRJtjW8+b1r9rUgPERguaXfcse" +
      "HlnclItgDfBHzUUFJJU/g==\nU2NhbmJvdFNESwppby5zY" +
      "2FuYm90LmRlbW8ueGFtYXJpbgoxNDg0NjExMTk5CjcxNjc" +
      "KMw==\n";

  var config = SdkConfiguration(
    licenseKey: licenseKey,
    loggingEnabled: true,
  );

  await ScanbotSdk.initialize(config);
}
