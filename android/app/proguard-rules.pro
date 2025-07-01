# Razorpay SDK fix
-keep class proguard.annotation.Keep { *; }
-keep class proguard.annotation.KeepClassMembers { *; }

# Razorpay core classes
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# General keep rules to avoid R8 removing important classes
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
