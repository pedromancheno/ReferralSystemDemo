import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var linkHandler: LinkHandling!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        linkHandler = FirebaseDynamicLinkHandler(bundle: Bundle.main)
        FirebaseApp.configure()
        return true
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if let webpageURL = userActivity.webpageURL {

            let completion: LinkHandlingCompletion = { result in
                self.handle(result)
            }
            if linkHandler.handleUniversalLink(webpageURL, completion: completion) { return true }
        }

        return false
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let result = linkHandler.handleURLScheme(url)
        if handle(result) { return true }

        return false
    }

    /// Further handles the result produced by a handler conforiming to LinkHandling protocol.
    ///
    /// - Parameter result: A result to be handled. This can be a success of failure.
    /// - Returns: A boolean indicating if the result could be handled.
    @discardableResult private func handle(_ result: LinkHandlingResult) -> Bool {
        switch result {
        case .success(let action):
            handle(action)
            return true
        case .failure(let error):
            if error is LinkHandlingError {
                print("Error when handling link result. Error: "+error.localizedDescription)
            } else {
                // if is any other type of error, assertFailure and report to Crashlytics
                assertionFailure("Link handler failed to handle url. Error: \(error.localizedDescription)")
            }
            return false
        }
    }

    /// Further handles the action produced by a successful result
    ///
    /// - Parameter action: An action to be handled, i.e. invite, navigate or login action
    private func handle(_ action: LinkHandlingAction) {
        switch action {
        case .invite(let params):
            // attribute referral in Amplitude
            // navigate to deeplink
            print(params)
        }
    }
}

