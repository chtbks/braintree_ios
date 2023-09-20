import Foundation

// TODO: - Update docstring
///  A JSON parser that parses `BTJSON` into concrete `BTPaymentMethodNonce` objects. It supports registration of parsers at runtime.
///
///  `BTPaymentMethodNonceParser` provides access to JSON parsing for different payment options
///  without introducing compile-time dependencies on payment option frameworks and their symbols.
@objcMembers public class BTPaymentMethodNonceParser: NSObject {

    // MARK: - Private Properties
    
    private let validNonceTypes = ["CreditCard", "VenmoAccount", "PayPalAccount", "ApplePayCard"]

    // MARK: - Public Methods
    
    ///  Parses tokenized payment information that has been serialized to JSON, and returns a `BTPaymentMethodNonce` object.
    ///
    ///  The `BTPaymentMethodNonce` object is created by the JSON parsing block that has been registered for the tokenization type.
    ///
    ///  If the `type` has not been registered, this method will attempt to read the nonce from the JSON and return
    ///  a basic object; if it fails, it will return `nil`.
    /// - Parameters:
    ///   - json: The tokenized payment info, serialized to JSON
    /// - Returns: A `BTPaymentMethodNonce` object, or `nil` if the tokenized payment info JSON does not contain a nonce
    public func parseJSON(_ json: BTJSON?) -> BTPaymentMethodNonce? {
        if json == nil {
            return nil
        }

        if json?["nonce"].isString != false {
            return BTPaymentMethodNonce(
                nonce: json?["nonce"].asString() ?? "",
                type: determineNonceType(json?["type"].asString()),
                isDefault: json?["default"].isTrue ?? false
            )
        }

        return nil
    }
    
    // MARK: - Private Methods
    
    private func determineNonceType(_ type: String?) -> String {
        guard let type else { return "Unknown" }
        
        if validNonceTypes.contains(type) {
            return type
        } else {
            return "Unknown"
        }
    }
}
