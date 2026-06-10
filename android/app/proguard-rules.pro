-keep class id.flutter.** { *; }
-keep class com.example.accident_detection.** { *; }
-keep class io.flutter.** { *; }
-keep class com.google.** { *; }
-keep class android.** { *; }

## flutter_background_service
-keep class id.flutter.flutter_background_service.** { *; }

## sensors_plus
-keep class com.example.sensors_plus.** { *; }

## geolocator
-keep class com.baseflow.geolocator.** { *; }

## Hive
-keep class com.hive.** { *; }
-keepclassmembers class * {
    @com.hive.** *;
}

## Kotlin
-keep class kotlin.** { *; }
