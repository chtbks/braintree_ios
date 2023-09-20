import XCTest
@testable import BraintreeCore

class BTPaymentMethodNonceParser_Tests: XCTestCase {
    var parser : BTPaymentMethodNonceParser = BTPaymentMethodNonceParser()
    
    func testParseJSON_forPayPal_returnsValidNonceType() {
        let JSON = BTJSON(value: [
            "nonce": "a-nonce",
            "type": "PayPalAccount"
            ] as [String: Any])

        let unknownNonce = parser.parseJSON(JSON)!

        XCTAssertEqual(unknownNonce.nonce, "a-nonce")
        XCTAssertEqual(unknownNonce.type, "PayPalAccount")
    }
    
    func testParseJSON_forApplePay_returnsValidNonceType() {
        // todo
    }
    
    func testParseJSON_forVenmo_returnsValidNonceType() {
        // todo
    }
    
    func testParseJSON_forCreditCard_returnsValidNonceType() {
        // todo
    }
    
    func testParseJSON_whenTypeIsNotRegisteredAndJSONContainsNonce_returnsBasicTokenizationObject() {
        let json = BTJSON(value: ["nonce": "valid-nonce", "type": "bogus"])

        let paymentMethodNonce = parser.parseJSON(json)
        
        XCTAssertEqual(paymentMethodNonce?.nonce, "valid-nonce")
        XCTAssertEqual(paymentMethodNonce?.type, "Unknown")
    }
    
    func testParseJSON_whenTypeIsNotRegisteredAndJSONDoesNotContainNonce_returnsNil() {
        let json = BTJSON(value: ["type": "bogus"])

        let paymentMethodNonce = parser.parseJSON(json)

       XCTAssertNil(paymentMethodNonce)
    }

    func testSharedParser_whenTypeIsUnknown_returnsBasePaymentMethodNonce() {
        let JSON = BTJSON(value: [
            "consumed": false,
            "description": "Some thing",
            "details": [] as [Any?],
            "isLocked": false,
            "nonce": "a-nonce",
            "type": "asdfasdfasdf",
            "default": true
            ] as [String: Any])

        let unknownNonce = parser.parseJSON(JSON)!

        XCTAssertEqual(unknownNonce.nonce, "a-nonce")
        XCTAssertEqual(unknownNonce.type, "Unknown")
        XCTAssertTrue(unknownNonce.isDefault)
    }
}
