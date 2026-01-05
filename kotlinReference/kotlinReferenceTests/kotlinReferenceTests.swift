//
//  kotlinReferenceTests.swift
//  kotlinReferenceTests
//
//  Created by Matt Hunt on 1/2/26.
//

import Foundation
import Testing

struct decoderTests {

    @Test func staticPropertiesNotPassedToAllClassInstances() throws {
        class testObject {
            static var shouldBeFive = 5
        }
        
        let instance1 = testObject()
        let instance2 = testObject()
        
        instance1.shouldBeFive = 6
        #expect(instance2.shouldBeFive == 5)
        
    }
    

}
