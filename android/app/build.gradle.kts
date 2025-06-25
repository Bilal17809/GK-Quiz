//plugins {
//    id("com.android.application")
//    id("kotlin-android")
//    id("com.google.gms.google-services")
//    id("dev.flutter.flutter-gradle-plugin")
//}
//
//val keystoreProperties = Properties()
//val keystorePropertiesFile = rootProject.file("key.properties")
//if (keystorePropertiesFile.exists()) {
//    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
//}
//android {
//    namespace = "com.ma.gkquiz.generalknowledge"
//    compileSdk = 35
//    ndkVersion = "28.0.12916984"
//
//    compileOptions {
//        sourceCompatibility = JavaVersion.VERSION_11
//        targetCompatibility = JavaVersion.VERSION_11
//    }
//
//    kotlinOptions {
//        jvmTarget = JavaVersion.VERSION_11.toString()
//    }
//
//    defaultConfig {
//        applicationId = "com.ma.gkquiz.generalknowledge".
//        minSdk = 23
//        targetSdk = 34
//        versionCode = flutter.versionCode
//        versionName = flutter.versionName
//    }
//
//    signingConfigs {
//        create("release") {
//            keyAlias = keystoreProperties["keyAlias"] as String
//            keyPassword = keystoreProperties["keyPassword"] as String
//            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
//            storePassword = keystoreProperties["storePassword"] as String
//        }
//    }
//    buildTypes {
//        release {
//            signingConfig = signingConfigs.getByName("release")
//        }
//    }
//}
////flutter {
////    source = "../.."
////}
//apply(plugin = "com.google.gms.google-services")
//apply(plugin = "com.google.firebase.crashlytics")
//
//dependencies {
//    implementation("com.google.android.gms:play-services-ads:24.4.0")
////    implementation("com.google.android.gms:play-services-ads:23.6.0")
//    implementation("com.android.billingclient:billing:5.0.0")
//    implementation("com.google.firebase:firebase-analytics")
//    implementation("com.google.firebase:firebase-crashlytics")
//}
//

import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.ma.gkquiz.generalknowledge"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "28.0.12916984"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.ma.gkquiz.generalknowledge"
        minSdkVersion (23)
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

apply(plugin = "com.google.gms.google-services")
apply(plugin = "com.google.firebase.crashlytics")

dependencies {
    implementation("com.google.android.gms:play-services-ads:24.4.0")
    implementation("com.android.billingclient:billing:5.0.0")
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-crashlytics")
}

