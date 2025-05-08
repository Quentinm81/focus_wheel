// Chemin : C:\Users\quent\CascadeProjects\focus_wheel\android\build.gradle.kts

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
}

android {
    namespace = "com.quentin.focuswheel"
    compileSdk = 34

    // --- redirection du manifeste -----------------------------------------
    // Le vrai fichier est dans app/src/main ; on l'indique ici
    sourceSets["main"].manifest.srcFile("app/src/main/AndroidManifest.xml")
    // ----------------------------------------------------------------------

    defaultConfig {
        applicationId = "com.quentin.focuswheel"
        minSdk = 21
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
        manifestPlaceholders += mapOf(
            "applicationName" to "io.flutter.app.FlutterApplication"
        )
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }
    kotlinOptions { jvmTarget = "1.8" }
}