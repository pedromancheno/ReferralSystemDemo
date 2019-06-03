import Foundation

/// Describes the different results of handling a link
///
/// - success: The link resolves into a predefined action
/// - failure: The link does not resolve into anything we have previously defined
public enum LinkHandlingResult {
    case success(action: LinkHandlingAction)
    case failure(error: Error)
}

/// Describes the different actions that can be produced by a link
///
/// - invite: The link resolves into an invite action with associated parameters
/// - navigate: The link resolves into a navigation action with associated route
public enum LinkHandlingAction {
    case invite(params: ReferralLinkParameters)
    //case navigate(route: NavigationLinkRoute)
}

public typealias LinkHandlingCompletion = (LinkHandlingResult) -> Void

/// Defines a common inteface for all the services which can handle dynamic liks
public protocol LinkHandling {

    /// Handles a universal link. This method will be typically invoked by the
    /// `application:continueUserActivity:restorationHandler` method of a UIApplicationDelegate
    ///
    /// - Parameters:
    ///   - url: A URL describing a universal link
    ///   - completion: A closure passing a handling result
    /// - Returns: A Boolean declaring wether the universal link could be handled
    func handleUniversalLink(_ url: URL, completion: @escaping LinkHandlingCompletion) -> Bool

    /// Handles a URL scheme. This method will be typically invoked by the
    /// `application:openURL:options` method of a UIApplicationDelegate
    ///
    /// - Parameter url: A URL describing a URL Scheme
    /// - Returns: A handling result
    func handleURLScheme(_ url: URL) -> LinkHandlingResult
}
