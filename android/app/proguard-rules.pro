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

-keeppackagenames com.googlecode.tesseract.android.**
-keep public class com.googlecode.tesseract.android.**{ *; }

-keeppackagenames io.scanbot.mrzscanner.**
-keep public class io.scanbot.mrzscanner.**{ *; }

-keeppackagenames io.scanbot.sdk.mcrecognizer.**
-keep public class io.scanbot.sdk.mcrecognizer.**{ *; }

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

-keeppackagenames io.scanbot.sdk.vin.**
-keep public class io.scanbot.sdk.vin.**{ *; }
# Gson
# Gson uses generic type information stored in a class file when working with fields. Proguard
# removes such information by default, so configure it to keep all this information.
-keepattributes Signature

# For using GSON @Expose annotation
-keepattributes *Annotation*

# Gson specific classes
-dontwarn sun.misc.**
-keep class com.google.gson.stream.** { *; }

# Prevent proguard from stripping interface information from TypeAdapter, TypeAdapterFactory,
# JsonSerializer, JsonDeserializer instances (so they can be used in @JsonAdapter)
-keep class * implements com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# Prevent R8 from leaving Data object members always null
-keepclassmembers,allowobfuscation class * {
  @com.google.gson.annotations.SerializedName <fields>;
}
