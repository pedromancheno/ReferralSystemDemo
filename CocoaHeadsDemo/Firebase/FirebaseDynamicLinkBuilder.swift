import Foundation
import FirebaseDynamicLinks

struct FirebaseDynamicLinkBuilder: LinkBuilding {
    private let environment: FirebaseEnvironment
    private let urlBuilder: FirebaseURLBuilder
    private let componentsBuilder: FirebaseComponentsBuilder

    init(bundle: Bundle = Bundle.main) {
        self.environment = FirebaseEnvironment(bundle: bundle)
        self.urlBuilder = FirebaseURLBuilder(environment: environment)
        self.componentsBuilder = FirebaseComponentsBuilder(environment: environment)
    }
}

// MARK: - Link Building
extension FirebaseDynamicLinkBuilder {
    func makeLink(for type: LinkBuildingType, completion: @escaping LinkBuildingCompletion) {
        let url = urlBuilder.makeURL(for: type)
        guard let components = componentsBuilder.makeComponents(for: type, with: url) else {
            completion(nil, nil, LinkBuildingError.configuration)
            return
        }
        components.shorten(completion: completion)
    }
}
