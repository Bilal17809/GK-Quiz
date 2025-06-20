plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")
    // START: FlutterFire Configuration
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.ma.gkquiz.generalknowledge"
    compileSdk = 35
    ndkVersion = "28.0.12916984"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.ma.gkquiz.generalknowledge"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 23
        targetSdk = 34
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}
//flutter {
//    source = "../.."
//}
apply(plugin = "com.google.gms.google-services")
apply(plugin = "com.google.firebase.crashlytics")

dependencies {
    implementation("com.google.android.gms:play-services-ads:23.6.0")
    implementation("com.android.billingclient:billing:5.0.0")
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-crashlytics")
}

