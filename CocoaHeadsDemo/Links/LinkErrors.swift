import Foundation

public enum LinkBuildingError: Error {
    case configuration
}

extension LinkBuildingError {
    public var errorDescription: String? {
        switch self {
        case .configuration:
            return "Link could not be build due to a configuration error"

        }
    }
}

public enum LinkHandlingError: Error {
    case unresolvedURL
    case unsupportedHost
    case unsupportedScheme
    case unsupportedAction
    case unsupportedMethod
}

extension LinkHandlingError {
    public var errorDescription: String? {
        switch self {
        case .unresolvedURL:
            return "The URL could not be resolved"
        case .unsupportedAction:
            return "The URL does not belong to any supported action"
        case .unsupportedHost:
            return "The URL's host is not supported by this handler"
        case .unsupportedScheme:
            return "The URL's scheme is not supported by this handler"
        case .unsupportedMethod:
            return "The handler cannot handle URLs through this method"
        }
    }
}
