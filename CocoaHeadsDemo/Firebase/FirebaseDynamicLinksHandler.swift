import Foundation
import FirebaseDynamicLinks

struct FirebaseDynamicLinkHandler: LinkHandling {
    let firebaseLinks = DynamicLinks.dynamicLinks()
    let bundle: Bundle

    init(bundle: Bundle = Bundle.main) {
        self.bundle = bundle
    }

    func handleUniversalLink(_ url: URL, completion: @escaping LinkHandlingCompletion) -> Bool {
        guard url.host == bundle.infoDictionary?[LinkConstants.Configuration.Keys.firebaseDomain] as? String else {
                completion(.failure(error: LinkHandlingError.unsupportedHost))
                return false
        }

        let handled = firebaseLinks.handleUniversalLink(url) { (dynamicLink, error) in
            guard let link = dynamicLink else {
                completion(.failure(error: LinkHandlingError.unresolvedURL))
                return
            }

            let result = self.handleDynamicLink(link)
            completion(result)
        }

        return handled
    }

    func handleURLScheme(_ url: URL) -> LinkHandlingResult {
        guard url.scheme == LinkConstants.Configuration.firebaseScheme else {
            return .failure(error: LinkHandlingError.unsupportedScheme)
        }

        guard let link = firebaseLinks.dynamicLink(fromCustomSchemeURL: url) else {
            return .failure(error: LinkHandlingError.unresolvedURL)
        }

        return self.handleDynamicLink(link)
    }

    private func handleDynamicLink(_ link: DynamicLink) -> LinkHandlingResult {
        guard link.matchType == .unique || link.matchType == .default,
            let url = link.url,
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                return .failure(error: LinkHandlingError.unresolvedURL)
        }

        return makeResult(with: components)
    }

    private func makeResult(with components: URLComponents) -> LinkHandlingResult {
        switch components.path {
        case "/invite":
            guard let invite = makeInviteAction(with: components) else {
                return .failure(error: LinkHandlingError.unsupportedAction)
            }
            return .success(action: invite)
        default:
            return .failure(error: LinkHandlingError.unresolvedURL)
        }
    }

    private func makeInviteAction(with components: URLComponents) -> LinkHandlingAction? {
        guard let referrerIDString = components.queryItem(for: LinkConstants.QueryItemKeys.ReferralLink.referrerID),
            let referrerID = Int(referrerIDString) else { return nil }

        let firstName = components.queryItem(for: LinkConstants.QueryItemKeys.ReferralLink.firstName)
        let lastName = components.queryItem(for: LinkConstants.QueryItemKeys.ReferralLink.lastName)

        struct Parameters: ReferralLinkParameters {
            let referrerID: Int
            let firstName: String?
            let lastName: String?
        }

        let params =  Parameters(referrerID: referrerID,
                                 firstName: firstName,
                                 lastName: lastName)

        return LinkHandlingAction.invite(params: params)
    }
}
