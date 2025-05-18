plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.quentin.focuswheel"
    compileSdk = 35

    compileOptions {
        // sourceCompatibility = JavaVersion.VERSION_11 // Commented out
        // targetCompatibility = JavaVersion.VERSION_11 // Commented out
        // isCoreLibraryDesugaringEnabled = true // Commented out
    }

    kotlinOptions {
        // jvmTarget = JavaVersion.VERSION_11.toString() // Commented out
    }

    defaultConfig {
        applicationId = "com.quentin.focuswheel"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 33
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4") // Commented out
}
