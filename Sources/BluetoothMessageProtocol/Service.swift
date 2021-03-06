//
//  Service.swift
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

/// Bluetooth Service base Class
@available(swift 3.1)
@available(iOS 10.0, tvOS 10.0, watchOS 3.0, OSX 10.12, *)
open class Service {

    /// Name of the Service
    open internal(set) var name: String

    /// Service UUID String
    open internal(set) var uuidString: String

    /// Uniform Type Identifier
    open private(set) var uniformIdentifier: String

    /// Creates a Bluetooth Service
    ///
    /// - Parameter name: Service Name
    /// - Parameter uuidString: UUID String
    /// - Parameter uniformIdentifier: Uniform Type Information
    public init(name: String, uuidString: String, uniformIdentifier: String) {

        self.name = name
        self.uuidString = uuidString
        self.uniformIdentifier = uniformIdentifier
    }
}

@available(iOS 10.0, tvOS 10.0, watchOS 3.0, OSX 10.12, *)
public extension Service {

    public var hashValue: Int {
        get {
            return "\(name)\(uuidString)\(uniformIdentifier)".hashValue
        }
    }
}

@available(iOS 10.0, tvOS 10.0, watchOS 3.0, OSX 10.12, *)
public extension Service {

    static public func == (lhs: Service, rhs: Service) -> Bool {
        return (lhs.name == rhs.name) &&
            (lhs.uuidString == rhs.uuidString) &&
            (lhs.uniformIdentifier == rhs.uniformIdentifier)
    }

}

