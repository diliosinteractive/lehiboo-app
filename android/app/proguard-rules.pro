# flutter_stripe includes optional Stripe Issuing push-provisioning bridge code.
# The app does not use push provisioning, so these optional Stripe Android SDK
# classes are not packaged and can be ignored by R8.
-dontwarn com.stripe.android.pushProvisioning.**
