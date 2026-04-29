import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  // Override `window` so any SDK that walks `UIApplication.shared.delegate.window`
  // (notably flutter_stripe's iOS bridge) finds the currently-active key window
  // instead of a stale AppDelegate-owned window. Without this, on iOS 13+ scene
  // apps Stripe presents from a detached UIViewController and PaymentSheet hangs
  // with "view is not in the window hierarchy".
  private var _appDelegateWindow: UIWindow?

  override var window: UIWindow? {
    get {
      if let activeKeyWindow = UIApplication.shared.connectedScenes
        .compactMap({ $0 as? UIWindowScene })
        .flatMap({ $0.windows })
        .first(where: { $0.isKeyWindow }) {
        return activeKeyWindow
      }
      return _appDelegateWindow
    }
    set {
      _appDelegateWindow = newValue
    }
  }

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
