//
//  kotlinReferenceTests.swift
//  kotlinReferenceTests
//
//  Created by Matt Hunt on 1/2/26.
//

import Foundation
import Testing

struct decoderTests {

    @Test func canDecodeJSONObject() async throws {
        // When
        let JSONObject = "".data(using: .utf8)
        // Then
        let decoder = JSONDecoder()
        decoder.decode(Note.self, from: JSONObject)
        
        // Expect
    }

}
