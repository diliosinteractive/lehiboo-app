# Stripe Push Provisioning — referenced by flutter_stripe but only present
# when the optional Stripe Push Provisioning module is integrated (Google Pay
# / Apple Wallet card provisioning). We don't use it, so silence R8 warnings.
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivity$g
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Args
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Error
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningEphemeralKeyProvider
