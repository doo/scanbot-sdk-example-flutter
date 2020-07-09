-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-dontwarn io.flutter.embedding.**
-ignorewarnings
-dontoptimize

-keep public class net.doo.snap.ui.** { *; }
-keeppackagenames net.doo.snap.ui.**
-keep public class  net.doo.snap.camera.** { *; }
-keeppackagenames net.doo.snap.camera.**
-keep public class io.scanbot.sdk.ui.** { *; }
-keep public class io.scanbot.sap.SapManager { *; }
-keeppackagenames net.doo.snap.lib.detector.**
-keep public class net.doo.snap.lib.detector.**{ *; }

-keeppackagenames net.doo.snap.process.**
-keep public class net.doo.snap.process.**{ *; }

-keeppackagenames com.googlecode.tesseract.android.**
-keep public class com.googlecode.tesseract.android.**{ *; }

-keeppackagenames io.scanbot.sdk.ocr.**
-keep public class io.scanbot.sdk.ocr.**{ *; }

-keeppackagenames io.scanbot.sdk.persistence.**
-keep public class io.scanbot.sdk.persistence.**{ *; }

-keeppackagenames io.scanbot.mrzscanner.**
-keep public class io.scanbot.mrzscanner.**{ *; }
-keeppackagenames io.scanbot.dcscanner.**
-keep public class io.scanbot.dcscanner.**{ *; }
-keeppackagenames io.scanbot.tiffwriter.**
-keep public class io.scanbot.tiffwriter.**{ *; }
-keeppackagenames io.scanbot.chequescanner.**
-keep public class io.scanbot.chequescanner.**{ *; }
-keeppackagenames io.scanbot.textorientation.**
-keep public class io.scanbot.textorientation.**{ *; }
-keeppackagenames io.scanbot.barcodescanner.**
-keep public class io.scanbot.barcodescanner.**{ *; }
-keeppackagenames io.scanbot.hicscanner.**
-keep public class io.scanbot.hicscanner.**{ *; }
-keeppackagenames io.scanbot.sdk.process.**
-keep public class io.scanbot.sdk.process.**{ *; }
# JSR 305 annotations are for embedding nullability information.
-dontwarn javax.annotation.**
-dontwarn org.jetbrains.annotations.**
# Moshi
# JSR 305 annotations are for embedding nullability information.
-dontwarn javax.annotation.**
-keepclasseswithmembers class * {
    @com.squareup.moshi.* <methods>;
}
-keep @com.squareup.moshi.JsonQualifier interface *
# Enum field names are used by the integrated EnumJsonAdapter.
# values() is synthesized by the Kotlin compiler and is used by EnumJsonAdapter indirectly
# Annotate enums with @JsonClass(generateAdapter = false) to use them with Moshi.
-keepclassmembers @com.squareup.moshi.JsonClass class * extends java.lang.Enum {
    <fields>;
    **[] values();
}
# The name of @JsonClass types is used to look up the generated adapter.
-keepnames @com.squareup.moshi.JsonClass class *
# Retain generated target class's synthetic defaults constructor and keep DefaultConstructorMarker's
# name. We will look this up reflectively to invoke the type's constructor.
#
# We can't _just_ keep the defaults constructor because Proguard/R8's spec doesn't allow wildcard
# matching preceding parameters.
-keepnames class kotlin.jvm.internal.DefaultConstructorMarker
-keepclassmembers @com.squareup.moshi.JsonClass @kotlin.Metadata class * {
    synthetic <init>(...);
}
# Retain generated JsonAdapters if annotated type is retained.
-if @com.squareup.moshi.JsonClass class *
-keep class <1>JsonAdapter {
    <init>(...);
    <fields>;
}
-if @com.squareup.moshi.JsonClass class **$*
-keep class <1>_<2>JsonAdapter {
    <init>(...);
    <fields>;
}
-if @com.squareup.moshi.JsonClass class **$*$*
-keep class <1>_<2>_<3>JsonAdapter {
    <init>(...);
    <fields>;
}
-if @com.squareup.moshi.JsonClass class **$*$*$*
-keep class <1>_<2>_<3>_<4>JsonAdapter {
    <init>(...);
    <fields>;
}
-if @com.squareup.moshi.JsonClass class **$*$*$*$*
-keep class <1>_<2>_<3>_<4>_<5>JsonAdapter {
    <init>(...);
    <fields>;
}
-if @com.squareup.moshi.JsonClass class **$*$*$*$*$*
-keep class <1>_<2>_<3>_<4>_<5>_<6>JsonAdapter {
    <init>(...);
    <fields>;
}
-keep public class kotlin.reflect.jvm.internal.impl.** { public *; }
-keepclassmembers class kotlin.Metadata {
    public <methods>;
}

-keeppackagenames io.scanbot.sdk.flutter.**
-keep public class io.scanbot.sdk.flutter.** { *; }
-keeppackagenames io.scanbot.sdk.ui.**
-keep public class io.scanbot.sdk.ui.**{ *; }
