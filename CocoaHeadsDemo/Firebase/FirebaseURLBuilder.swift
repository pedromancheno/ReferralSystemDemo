import Foundation

struct FirebaseURLBuilder {
    private let environment: FirebaseEnvironment

    init(environment: FirebaseEnvironment) {
        self.environment = environment
    }

    func makeURL(for type: LinkBuildingType) -> URL {
        var components = URLComponents()
        components.scheme = environment.webScheme
        components.host = environment.webHost
        components.path = type.path

        switch type {
        case .invite(let params):
            var queryItems = [URLQueryItem]()
            queryItems.append(URLQueryItem(name: LinkConstants.QueryItemKeys.ReferralLink.referrerID, value: String(params.referrerID)))
            if let lastName = params.lastName {
                queryItems.append(URLQueryItem(name: LinkConstants.QueryItemKeys.ReferralLink.lastName, value: lastName))
            }
            if let firstName = params.firstName {
                queryItems.append(URLQueryItem(name: LinkConstants.QueryItemKeys.ReferralLink.firstName, value: firstName))
            }
            components.queryItems = queryItems
        }

        return components.url!
    }
}
