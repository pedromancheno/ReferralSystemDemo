import Foundation


/// Describes the different parameters that will be appended to the link
public protocol ReferralLinkParameters {
    var referrerID: Int { get }
    var firstName: String? { get }
    var lastName: String? { get }
}

// Optional URL, warnings and error
public typealias LinkBuildingCompletion = (URL?, [String]?, Error?) -> Void

public enum LinkBuildingType {
    case invite(params: ReferralLinkParameters)
    //case profile(params: ProfileLinkParameters)

    var path: String {
        return "/invite"
    }
}

/// Defines a common interface for all the services which can build dynamic links
public protocol LinkBuilding {
    /// Initializes an instance of the object
    ///
    /// - Parameter bundle: A bundle containing configuration data
    init(bundle: Bundle)

    /// Build a link
    ///
    /// - Parameters:
    ///   - type: The type of link to be built
    ///   - completion: A completion closure that will return optional URL, warnings and error
    func makeLink(for type: LinkBuildingType, completion: @escaping LinkBuildingCompletion)
}
