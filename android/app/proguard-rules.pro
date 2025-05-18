# ProGuard rules for Focus Wheel
# Flutter/Dart obfuscation and minification

# Keep Flutter classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }

# Keep classes required for reflection
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes EnclosingMethod

# Keep all classes extending FlutterActivity
-keep class ** extends io.flutter.embedding.android.FlutterActivity { *; }

# Add your own rules below if needed
