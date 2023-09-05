import Foundation

#if canImport(BraintreeCore)
import BraintreeCore
#endif

struct BTVenmoAppSwitchRedirectURL {
    
    // MARK: - Internal Properties
    
    /// The base app switch URL for Venmo. Does not include specific parameters.
    static var baseAppSwitchURL: URL? {
        appSwitchBaseURLComponents().url
    }

    // MARK: - Private Properties
    
    static private let xCallbackTemplate: String = "scheme://x-callback-url/path"
    static private let venmoScheme: String = "com.venmo.touch.v2"
    
    private var queryParameters: [String: Any] = [:]
    
    init(
        returnURLScheme: String,
        forMerchantID merchantID: String?,
        accessToken: String?,
        bundleDisplayName: String?,
        environment: String?,
        paymentContextID: String,
        metadata: BTClientMetadata?
    ) throws {
        guard let accessToken,
              let metadata,
              let bundleDisplayName,
              let environment,
              let merchantID
        else {
            throw BTVenmoError.unknown
        }
        
        let venmoMetadata: [String: String] = [
            "version": BTCoreConstants.braintreeSDKVersion,
            "sessionId": metadata.sessionID,
            "integration": metadata.integration.stringValue,
            "platform": "ios"
        ]
        
        let braintreeData: [String: Any] = ["_meta": venmoMetadata]
        let serializedBraintreeData = try? JSONSerialization.data(withJSONObject: braintreeData)
        let base64EncodedBraintreeData = serializedBraintreeData?.base64EncodedString()

        // TODO: - Confirm preservation of optional query params sent before refactor
        queryParameters = [
            "x-success": returnURL(with: returnURLScheme, result: "success"),
            "x-error": returnURL(with: returnURLScheme, result: "error"),
            "x-cancel": returnURL(with: returnURLScheme, result: "cancel"),
            "x-source": bundleDisplayName,
            "braintree_merchant_id": merchantID,
            "braintree_access_token": accessToken,
            "braintree_environment": environment,
            "resource_id": paymentContextID,
            "braintree_sdk_data": base64EncodedBraintreeData ?? ""
        ]
    }

    // MARK: - Internal Methods

    func universalLink() -> URL {
        let universalLink = URL(string: "https://venmo.com/go/checkout")!

        var urlComponent = URLComponents(url: universalLink, resolvingAgainstBaseURL: false)!
        urlComponent.percentEncodedQuery = BTURLUtils.queryString(from: queryParameters as NSDictionary)
        
        return urlComponent.url!
    }

    func urlSchemeLink() -> URL {
        var components = BTVenmoAppSwitchRedirectURL.appSwitchBaseURLComponents()
        components.percentEncodedQuery = BTURLUtils.queryString(from: queryParameters as NSDictionary)
        return components.url!
    }

    // MARK: - Private Helper Methods

    // TODO: - add docstrings or rename these functions, hard to tell what they do
    private func returnURL(with scheme: String, result: String) -> URL? {
        var components = URLComponents(string: BTVenmoAppSwitchRedirectURL.xCallbackTemplate)
        components?.scheme = scheme
        components?.percentEncodedPath = "/vzero/auth/venmo/\(result)"
        return components?.url
    }

    static private func appSwitchBaseURLComponents() -> URLComponents {
        var components: URLComponents = URLComponents(string: xCallbackTemplate) ?? URLComponents()
        components.scheme = venmoScheme
        components.percentEncodedPath = "/vzero/auth"
        return components
    }    
}

// VENMO_APP_OR_MOBILE_AUTH_URL: "https://venmo.com/go/checkout",
// A deep-linked url that will open the Venmo app if installed, or navigate to a Venmo web-login experience if the Venmo app is not present.

// This function in JS constructs the URL - https://github.braintreeps.com/team-sdk/braintree.js/blob/8a285ce469113c82c6c399b83f0411b7784590da/src/venmo/venmo.js#L390-L465

//params.resource_id = venmoPaymentContextID
//params["x-success"]
//params["x-cancel"]
//params["x-error"]
//params.allowAndroidRecreation
//params.braintree_merchant_id
//params.braintree_access_token
//params.braintree_environment
//params.braintree_sdk_data


// ORIGINAL WITH SCHEME
// com.venmo.touch.v2://x-callback-url/vzero/auth?braintree_access_token=access_token%24production%24dfy45jdj3dxkmz5m%245b75d496d61f9aa6a15c11fe5aa11517&x-success=com.braintreepayments.Demo.payments%3A%2F%2Fx-callback-url%2Fvzero%2Fauth%2Fvenmo%2Fsuccess&x-cancel=com.braintreepayments.Demo.payments%3A%2F%2Fx-callback-url%2Fvzero%2Fauth%2Fvenmo%2Fcancel&braintree_merchant_id=3317760510262248112&x-error=com.braintreepayments.Demo.payments%3A%2F%2Fx-callback-url%2Fvzero%2Fauth%2Fvenmo%2Ferror&braintree_sdk_data=eyJfbWV0YSI6eyJzZXNzaW9uSWQiOiI3MTIyRTBGMDAwMTI0QzJGQkRCRDA1QzgxMTI0MTE0RSIsInBsYXRmb3JtIjoiaW9zIiwiaW50ZWdyYXRpb24iOiJjdXN0b20iLCJ2ZXJzaW9uIjoiNi41LjAifX0%3D&braintree_environment=production&x-source=SDK%20Demo&resource_id=cGF5bWVudGNvbnRleHRfZGZ5NDVqZGozZHhrbXo1bSNhNWY5Njc0My1iZjk5LTQ1NmMtYjg1OS1mM2FlOTcxOGY5YjQ%3D


// https://venmo.com/go/checkout?x-cancel=com.braintreepayments.Demo.payments%3A%2F%2Fx-callback-url%2Fvzero%2Fauth%2Fvenmo%2Fcancel&braintree_environment=production&resource_id=cGF5bWVudGNvbnRleHRfZGZ5NDVqZGozZHhrbXo1bSNmZGEzMDc3ZS03NmY0LTQ2MGEtOTAyNC01ZWJjNGFhMzZjODY%3D&braintree_sdk_data=eyJfbWV0YSI6eyJ2ZXJzaW9uIjoiNi41LjAiLCJzZXNzaW9uSWQiOiIyNDVDQ0M3QTY0QTk0N0RFOThENUQxOTNFNDZFNzA0MSIsImludGVncmF0aW9uIjoiY3VzdG9tIiwicGxhdGZvcm0iOiJpb3MifX0%3D&x-error=com.braintreepayments.Demo.payments%3A%2F%2Fx-callback-url%2Fvzero%2Fauth%2Fvenmo%2Ferror&x-source=SDK%20Demo&x-success=com.braintreepayments.Demo.payments%3A%2F%2Fx-callback-url%2Fvzero%2Fauth%2Fvenmo%2Fsuccess&braintree_merchant_id=3317760510262248112&braintree_access_token=access_token%24production%24dfy45jdj3dxkmz5m%245b75d496d61f9aa6a15c11fe5aa11517


// RETURN URL from the above ^

// com.braintreepayments.Demo.payments://x-callback-url/vzero/auth/venmo/success#&username=@Sammy-Cannillo&resource_id=cGF5bWVudGNvbnRleHRfZGZ5NDVqZGozZHhrbXo1bSNhYjI0OTgxYi0wN2YwLTQ0ZjQtYjI1Mi0zMDZjOTU5Y2EzY2I=&paymentMethodNonce=9a499cbb-bf37-1055-9f8f-db25fe5bc5a2

// sandbox com.braintreepayments.Demo.payments://x-callback-url/vzero/auth/venmo/success&username=@Sammy-Cannillo&resource_id=cGF5bWVudGNvbnRleHRfZGNwc3B5MmJyd2RqcjNxbiM2NTUxYzRhNy03ZmRjLTQyODktODk4ZS0yNmZjODBjNWZiYTk=&paymentMethodNonce=fake-venmo-account-nonce

// RETURN URL from OG flow

// com.braintreepayments.Demo.payments://x-callback-url/vzero/auth/venmo/success?username=@Sammy-Cannillo&resource_id=cGF5bWVudGNvbnRleHRfZGZ5NDVqZGozZHhrbXo1bSNjMDZiYzA4ZC0xZTRlLTQ3MGYtYWVmYi00ZWUyY2U0MjdlMDA%3D&paymentMethodNonce=32490150-46bc-0c1d-7fb5-a0a5eb220a0c
