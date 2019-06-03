import Foundation

struct FirebaseEnvironment {
    let bundleID: String
    let webScheme: String
    let webHost: String
    let firebaseDomain: String

    init(bundle: Bundle = Bundle.main) {
        guard let bundleID = bundle.bundleIdentifier,
            let webScheme = bundle.infoDictionary?[LinkConstants.Configuration.Keys.webScheme] as? String,
            let webHost = bundle.infoDictionary?[LinkConstants.Configuration.Keys.webHost] as? String,
            let firebaseDomain = bundle.infoDictionary?[LinkConstants.Configuration.Keys.firebaseDomain] as? String else {
                fatalError("No bundle")
        }

        self.bundleID = bundleID
        self.webScheme = webScheme
        self.webHost = webHost
        self.firebaseDomain = firebaseDomain
    }
}
