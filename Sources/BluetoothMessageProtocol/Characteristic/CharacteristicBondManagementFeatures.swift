//
//  CharacteristicBondManagementFeatures.swift
//  BluetoothMessageProtocol
//
//  Created by Kevin Hoogheem on 9/2/17.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation
import DataDecoder
import FitnessUnits

/// BLE Bond Management Features Characteristic
@available(swift 3.1)
@available(iOS 10.0, tvOS 10.0, watchOS 3.0, OSX 10.12, *)
open class CharacteristicBondManagementFeatures: Characteristic {

    public static var name: String {
        return "Bond Management Features"
    }

    public static var uuidString: String {
        return "2AA5"
    }

    /// Flags
    public struct Flags: OptionSet {
        public let rawValue: UInt32
        public init(rawValue: UInt32) { self.rawValue = rawValue }

        /// Delete Bond of current connection (BR/EDR and LE) supported
        public static let deleteBondCurrentConnectionSupported: Flags               = Flags(rawValue: 1 << 0)
        /// Authorization Code required for Delete bond of current connection (BR/EDR and LE)
        public static let authorizationDeleteBondRequired: Flags                    = Flags(rawValue: 1 << 1)
        /// Delete bond of current connection (BR/EDR transport only) supported
        public static let deleteBondCurrentConnectionBREDROnlySupported: Flags      = Flags(rawValue: 1 << 2)
        /// Authorization Code required for Delete bond of current connection (BR/EDR transport only)
        public static let authorizationDeleteBondBREDRRequired: Flags               = Flags(rawValue: 1 << 3)
        /// Delete bond of current connection (LE transport only) supported
        public static let deleteBondCurrentConnectionLEOnlySupported: Flags         = Flags(rawValue: 1 << 4)
        /// Authorization Code required for Delete bond of current connection (LE transport only)
        public static let authorizationDeleteBondLEOnlyRequired: Flags              = Flags(rawValue: 1 << 5)
        /// Remove all bonds on server (BR/EDR and LE) supported
        public static let removeBondsOnServerSupported: Flags                       = Flags(rawValue: 1 << 6)
        /// Authorization Code required for Remove all bonds on server (BR/EDR and LE) supported
        public static let authorizationRemoveBondsOnServerRequired: Flags           = Flags(rawValue: 1 << 7)
        /// Remove all bonds on server (BR/EDR transport only) supported
        public static let removeBondsOnServerBREDRSupported: Flags                  = Flags(rawValue: 1 << 8)
        /// Authorization Code required for Remove all bonds on server (BR/EDR transport only) supported
        public static let authorizationRemoveBondsOnServerBREDRRequired: Flags      = Flags(rawValue: 1 << 9)
        /// Remove all bonds on server (LE transport only) supported
        public static let removeBondsOnServerLEOnlySupported: Flags                 = Flags(rawValue: 1 << 10)
        /// Authorization Code required for Remove all bonds on server (LE transport only) supported
        public static let authorizationRemoveBondsOnServerLEOnlyRequired: Flags     = Flags(rawValue: 1 << 11)
        /// Remove all but the active bond on server (BR/EDR and LE) supported
        public static let removeNonActiveBondsSupported: Flags                      = Flags(rawValue: 1 << 12)
        /// Authorization Code required for Remove all but the active bond on server (BR/EDR and LE) supported
        public static let authorizationRemoveNonActiveBondsSupported: Flags         = Flags(rawValue: 1 << 13)
        /// Remove all but the active bond on server (BR/EDR transport only) supported
        public static let removeNonActiveBondsBREDRSupported: Flags                 = Flags(rawValue: 1 << 14)
        /// Authorization Code required for Remove all but the active bond on server (BR/EDR transport only) supported
        public static let authorizationRemoveNonActiveBondsBREDRSupported:Flags     = Flags(rawValue: 1 << 15)
        /// Remove all but the active bond on server (LE transport only) supported
        public static let removeNonActiveBondsLEOnlySupported: Flags                = Flags(rawValue: 1 << 16)
        /// Authorization Code required for Remove all but the active bond on server (LE transport only) supported
        public static let authorizationRemoveNonActiveBondsLEOnlySupported: Flags   = Flags(rawValue: 1 << 17)
        /// Identify yourself supported
        public static let identifyYourselfSupported: Flags                          = Flags(rawValue: 1 << 18)
        /// Feature Extension
        public static let featureExtension: Flags                                   = Flags(rawValue: 1 << 23)
    }


    /// Bond Management Features
    private(set) public var features: Flags


    public init(features: Flags) {

        self.features = features

        super.init(name: CharacteristicBondManagementFeatures.name, uuidString: CharacteristicBondManagementFeatures.uuidString)
    }

    open override class func decode(data: Data) throws -> CharacteristicBondManagementFeatures {

        var decoder = DataDecoder(data)

        let features = Flags(rawValue: decoder.decodeUInt32())

        return CharacteristicBondManagementFeatures(features: features)
    }

    open override func encode() throws -> Data {
        //Not Yet Supported
        throw BluetoothMessageProtocolError.init(.unsupported)
    }
}
