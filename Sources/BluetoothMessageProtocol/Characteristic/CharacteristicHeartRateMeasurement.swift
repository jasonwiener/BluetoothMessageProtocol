//
//  CharacteristicHeartRateMeasurement.swift
//  BluetoothMessageProtocol
//
//  Created by Kevin Hoogheem on 8/5/17.
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

/// BLE Heart Rate Meassurement Characteristic
@available(swift 3.1)
@available(iOS 10.0, tvOS 10.0, watchOS 3.0, OSX 10.12, *)
open class CharacteristicHeartRateMeasurement: Characteristic {

    /// Characteristic Name
    public static var name: String {
        return "Heart Rate Meassurement"
    }

    /// Characteristic UUID
    public static var uuidString: String {
        return "2A37"
    }

    /// Contact Status of Sensor
    public enum ContactStatus: UInt8 {
        /// Sensor Contact feature is not supported in the current connection
        case notSupported       = 0
        /// Sensor Contact feature is not supported in the current connection
        case stillNotSupportd   = 1
        /// Sensor Contact feature is supported, but contact is not detected
        case notDetected        = 2
        /// Sensor Contact feature is supported and contact is detected
        case detected           = 3

        public var stringValue: String {

            switch self {
            case .notSupported, .stillNotSupportd:
                return "Sensor Contact feature is not supported"
            case .notDetected:
                return "Sensor Contact not detected"
            case .detected:
                return "Sensor Contact detected"
            }
        }
    }

    fileprivate struct Flags {
        /// Heart Rate Value Format is set to UINT16. Units: beats per minute (bpm)
        private(set) public var isFormatUInt16: Bool
        /// Sensor Contact Status
        private(set) public var contact: ContactStatus
        /// Energy Expended field is present
        private(set) public var isEnergyExpendedPresent: Bool
        /// One or more RR-Interval values are present
        private(set) public var isRRIntervalPresent: Bool

        /// Rawvalue
        public var rawValue: UInt8 {
            var value: UInt8 = UInt8(isFormatUInt16 == true ? 1 : 0)
            value |= contact.rawValue << 1
            value |=  UInt8(isEnergyExpendedPresent == true ? 1 : 0) << 3
            value |=  UInt8(isRRIntervalPresent == true ? 1 : 0) << 4

            return UInt8(value)
        }

        /// Creates Flags Struct
        ///
        /// - Parameter value: UInt8 Flag Data
        public init(_ value: UInt8) {
            self.isFormatUInt16 = (value & 0x01).boolValue

            let contactStatusBits = (value | 0x06) >> 1

            contact = ContactStatus(rawValue: contactStatusBits) ?? .notSupported

            isEnergyExpendedPresent = (value & 0x08 == 0x08)

            isRRIntervalPresent = (value & 0x10 == 0x10)

        }

        /// Creates Flags Structs
        ///
        /// - Parameters:
        ///   - isFormatUInt16: HR Format is UInt16
        ///   - contactStatus: Contact Status
        ///   - isEnergyExpendedPresent: Energy Expended Present
        ///   - isRRIntervalPresent: One or more RR Values Present
        public init(isFormatUInt16: Bool, contactStatus: ContactStatus, isEnergyExpendedPresent: Bool, isRRIntervalPresent: Bool) {
            self.isFormatUInt16 = isFormatUInt16
            self.contact = contactStatus
            self.isEnergyExpendedPresent = isEnergyExpendedPresent
            self.isRRIntervalPresent = isRRIntervalPresent
        }
    }

    /// Contact status of sensor
    private(set) public var contactStatus: ContactStatus = .notSupported

    /// Heart Rate Value
    private(set) public var heartRate: Measurement<UnitCadence>

    /// Energy Expended
    private(set) public var energyExpended: Measurement<UnitEnergy>?

    /// RR-Interval
    private(set) public var rrIntervals: [Measurement<UnitDuration>]?

    /// Creates Heart Rate Meassurement Characteristic
    ///
    /// - Parameters:
    ///   - contactStatus: Contact status of sensor
    ///   - heartRate: Heart Rate Value
    ///   - energyExpended: Energy Expended
    ///   - rrIntervals: RR-Intervals
    public init(contactStatus: ContactStatus, heartRate: Measurement<UnitCadence>, energyExpended: Measurement<UnitEnergy>? = nil, rrIntervals: [Measurement<UnitDuration>]? = nil) {

        self.contactStatus = contactStatus
        self.heartRate = heartRate
        self.energyExpended = energyExpended
        self.rrIntervals = rrIntervals

        super.init(name: CharacteristicHeartRateMeasurement.name,
                   uuidString: CharacteristicHeartRateMeasurement.uuidString)
    }

    /// Deocdes the BLE Data
    ///
    /// - Parameter data: Data from sensor
    /// - Returns: Characteristic Instance
    /// - Throws: BluetoothMessageProtocolError
    open override class func decode(data: Data) throws -> CharacteristicHeartRateMeasurement {

        var decoder = DataDecoder(data)

        let flags = Flags(decoder.decodeUInt8())

        let contactStatus = flags.contact

        var heartRate: Measurement = Measurement(value: 0, unit: UnitCadence.beatsPerMinute)

        if flags.isFormatUInt16 == true {
            heartRate.value = Double(decoder.decodeUInt16())
        } else {
            heartRate.value = Double(decoder.decodeUInt8())
        }

        var energy: Measurement<UnitEnergy>? = nil

        if flags.isEnergyExpendedPresent == true {
            let expended = decoder.decodeUInt16()
            energy = Measurement(value: Double(expended), unit: UnitEnergy.kilojoules)
        }

        var rrIntervals: [Measurement<UnitDuration>]?

        //RR Intervals
        if flags.isRRIntervalPresent == true {

            var seconds = decoder.decodeUInt16()

            while seconds != 0 {
                let interval = Measurement(value: Double(seconds), unit: UnitDuration.seconds)

                if rrIntervals == nil {
                    rrIntervals = [Measurement<UnitDuration>]()
                }
                rrIntervals?.append(interval)

                seconds = decoder.decodeUInt16()
            }
        }

        return CharacteristicHeartRateMeasurement(contactStatus: contactStatus,
                                                  heartRate: heartRate,
                                                  energyExpended: energy,
                                                  rrIntervals: rrIntervals)
    }

    /// Encodes the Characteristic into Data
    ///
    /// - Returns: Data representation of the Characteristic
    /// - Throws: BluetoothMessageProtocolError
    open override func encode() throws -> Data {
        //Not Yet Supported
        throw BluetoothMessageProtocolError.init(.unsupported)
    }

}

