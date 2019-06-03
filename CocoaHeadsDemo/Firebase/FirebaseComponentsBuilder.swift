import Foundation
import FirebaseDynamicLinks

private enum Constants {
    enum iOSParameters {
        static let appStoreID = "477967747"
    }
    enum iTunesConnectParameters {
        static let providerToken = "506648"
    }
}

private extension LinkBuildingType {
    var androidMinimumVersion: Int {
        switch self {
        case .invite: return 14600
        }
    }

    var iOSMinimumAppVersion: String {
        switch self {
        case .invite: return "6.30.0"
        }
    }

    var socialMetaTagTitle: String {
        switch self {
        case .invite:
            return "Have you tried this amazing app yet?"
        }
    }

    var socialMetaTagDescription: String {
        switch self {
        case .invite:
            return "Come check out my profile!"
        }
    }

    var socialMetaTagImageURL: URL {
        return URL(string: "https://s3-eu-west-1.amazonaws.com/static.fishbrain.com/user_referral_image.png")!
    }

    var analyticsCampaign: String {
        switch self {
        case .invite:
            return "user_referral"
        }
    }

    var iTunesConnectCampaignToken: String {
        switch self {
        case .invite:
            return "user_referral"
        }
    }
}

// These components can be found in https://docs.google.com/spreadsheets/d/1cYGsOYAuFSdIPmuLqtZ51-hB1SN5Zg6hjCae4EwNlqw/edit#gid=0
struct FirebaseComponentsBuilder {
    private let environment: FirebaseEnvironment

    init(environment: FirebaseEnvironment) {
        self.environment = environment
    }

    func makeComponents(for type: LinkBuildingType, with url: URL) -> DynamicLinkComponents? {
        var urlComponents = URLComponents()
        urlComponents.scheme = environment.webScheme
        urlComponents.host = environment.firebaseDomain
        guard let domainURIPrefix = urlComponents.url,
            let components = DynamicLinkComponents(link: url, domainURIPrefix: domainURIPrefix.absoluteString) else {
                return nil
        }

        // Android Parameters
        components.androidParameters = DynamicLinkAndroidParameters(packageName: environment.bundleID)
        components.androidParameters?.minimumVersion = type.androidMinimumVersion

        // iOS Parameters
        components.iOSParameters = DynamicLinkIOSParameters(bundleID: environment.bundleID)
        components.iOSParameters?.appStoreID = Constants.iOSParameters.appStoreID
        components.iOSParameters?.minimumAppVersion = type.iOSMinimumAppVersion

        // Social Parameters
        components.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        components.socialMetaTagParameters?.title = type.socialMetaTagTitle
        components.socialMetaTagParameters?.descriptionText = type.socialMetaTagDescription
        components.socialMetaTagParameters?.imageURL = type.socialMetaTagImageURL

        // Google Analytic Parameters
        components.analyticsParameters = DynamicLinkGoogleAnalyticsParameters()
        components.analyticsParameters?.campaign = type.analyticsCampaign

        // iTunes Connect Parameters
        components.iTunesConnectParameters = DynamicLinkItunesConnectAnalyticsParameters()
        components.iTunesConnectParameters?.providerToken = Constants.iTunesConnectParameters.providerToken
        components.iTunesConnectParameters?.campaignToken = type.iTunesConnectCampaignToken

        return components
    }
}
