import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keyProperties = Properties()
val keyPropertiesFile = rootProject.file("key.properties")
if (keyPropertiesFile.exists()) {
    keyPropertiesFile.inputStream().use { keyProperties.load(it) }
}

android {
    namespace = "com.moomen.sankomall"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    signingConfigs {
        create("release") {
            val storeFilePath = keyProperties.getProperty("storeFile")
                ?.takeIf { it.isNotBlank() }
                ?: throw GradleException("Missing 'storeFile' in android/key.properties for release signing.")

            storeFile = rootProject.file(storeFilePath)
            storePassword = keyProperties.getProperty("storePassword")
                ?.takeIf { it.isNotBlank() }
                ?: throw GradleException("Missing 'storePassword' in android/key.properties for release signing.")
            keyAlias = keyProperties.getProperty("keyAlias")
                ?.takeIf { it.isNotBlank() }
                ?: throw GradleException("Missing 'keyAlias' in android/key.properties for release signing.")
            keyPassword = keyProperties.getProperty("keyPassword")
                ?.takeIf { it.isNotBlank() }
                ?: throw GradleException("Missing 'keyPassword' in android/key.properties for release signing.")
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.moomen.sankomall"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}

flutter {
    source = "../.."
}
