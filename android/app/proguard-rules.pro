-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-dontwarn io.flutter.embedding.**
-ignorewarnings
-dontoptimize

-ignorewarnings
-keepclassmembers enum io.scanbot.sdk.** { *; }

-keeppackagenames io.scanbot.sdk.persistence.**
-keep public class io.scanbot.sdk.persistence.**{ *; }

-keep public class io.scanbot.sdk.ui.** { *; }

-keep public class io.scanbot.sap.SapManager { *; }

-keeppackagenames io.scanbot.sdk.core.contourdetector.**
-keep public class io.scanbot.sdk.core.contourdetector.**{ *; }
-keeppackagenames io.scanbot.sdk.contourdetector.**
-keep public class io.scanbot.sdk.contourdetector.**{ *; }
#
-keeppackagenames com.googlecode.tesseract.android.**
-keep public class com.googlecode.tesseract.android.**{ *; }

-keeppackagenames io.scanbot.mrzscanner.**
-keep public class io.scanbot.mrzscanner.**{ *; }
-keeppackagenames io.scanbot.sdk.mrzscanner.**
-keep public class io.scanbot.sdk.mrzscanner.**{ *; }

-keeppackagenames io.scanbot.tiffwriter.**
-keep public class io.scanbot.tiffwriter.**{ *; }

-keeppackagenames io.scanbot.textorientation.**
-keep public class io.scanbot.textorientation.**{ *; }
-keeppackagenames io.scanbot.sdk.textorientation.**
-keep public class io.scanbot.sdk.textorientation.**{ *; }

-keeppackagenames io.scanbot.sdk.barcode.**
-keep public class io.scanbot.sdk.barcode.**{ *; }

-keeppackagenames io.scanbot.hicscanner.**
-keep public class io.scanbot.hicscanner.**{ *; }
-keeppackagenames io.scanbot.sdk.hicscanner.**
-keep public class io.scanbot.sdk.hicscanner.**{ *; }

-keeppackagenames io.scanbot.sdk.docprocessing.**
-keep public class io.scanbot.sdk.docprocessing.**{ *; }

-keeppackagenames io.scanbot.sdk.process.**
-keep public class io.scanbot.sdk.process.**{ *; }

-keeppackagenames io.scanbot.sdk.flutter.**
-keep public class io.scanbot.sdk.flutter.** { *; }
-keeppackagenames io.scanbot.sdk.ui.**
-keep public class io.scanbot.sdk.ui.**{ *; }
