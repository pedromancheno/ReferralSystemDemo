import Foundation

extension URLComponents {
    /// Returs the value for the first matching query item name for a given key
    ///
    /// - Parameter key: A key to compare against the receiver's name
    /// - Returns: The value of a query item for the first match between the name and given key
    func queryItem(for key: String) -> String? {
        return queryItems?.first(where: {$0.name == key})?.value
    }
}
