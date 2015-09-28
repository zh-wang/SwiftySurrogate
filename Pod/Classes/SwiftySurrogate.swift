//  SwiftySurrogate
//
//  Copyright (c) 2015 Zhenghong Wang
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

let SURROGATE_BITS: UInt32                = 10
let HIGH_SURROGATE_MASK: UInt32           = (1 << SURROGATE_BITS) - 1
let LOW_SURROGATE_MASK: UInt32            = (1 << SURROGATE_BITS) - 1
let UNICODE_PLANE_MIN: UInt32             = 0x010000

let HIGH_SURROGATE_MIN: UInt32            = 0xD800
let HIGH_SURROGATE_MAX: UInt32            = 0xDBFF
let LOW_SURROGATE_MIN: UInt32             = 0xDC00
let LOW_SURROGATE_MAX: UInt32             = 0xDFFF
let SURROGATE_MIN: UInt32                 = HIGH_SURROGATE_MIN
let SURROGATE_MAX: UInt32                 = LOW_SURROGATE_MAX

let ErrorDomain: String! = "SwiftySurrogateErrorDomain"

let ErrorFailParseHexStringToInt: Int! = 501
let ErrorFailDecodeSurrogatePair: Int! = 503
let ErrorWrongFormatSurrogate: Int! = 502
let ErrorSurrogateIndexOutOfBounds: Int! = 504

// MARK: String Extension Utils
extension String {
    public func contains(other: String) -> Bool {
        return (self as NSString).containsString(other)
    }
}

// MARK: UInt32 readability Utils
extension UInt32 {
    public func hexExpression() -> String {
        return NSString(format:"%2X", self) as String
    }
}

public class SwiftySurrogate {
    
    static var error: NSError?
    
// MARK: Public Methods
    
    public class func lastError() -> NSError? {
        return error
    }
    
    public class func decodeHexStringToUInt32(hexString: String) -> UInt32? {
        let scanner = NSScanner(string: hexString)
        var result: UInt32 = 0
        if scanner.scanHexInt(&result) {
            return result
        }
        error = NSError(domain: ErrorDomain, code: ErrorFailParseHexStringToInt, userInfo: [NSLocalizedDescriptionKey: "Parsing Hex String -> Int Fails"])
        return nil
    }
    
    public class func decodeFromSurrogatePair(surrogatePair surrogatePair: String) -> String? {
        if (!surrogatePair.contains(":")) {
            error = NSError(domain: ErrorDomain, code: ErrorWrongFormatSurrogate, userInfo: [NSLocalizedDescriptionKey: "Invalid Surrogate Pair Format - Colon Not Found"])
            return nil
        }
        var array = surrogatePair.componentsSeparatedByString(":")
        if (array.count > 2) {
            error = NSError(domain: ErrorDomain, code: ErrorWrongFormatSurrogate, userInfo: [NSLocalizedDescriptionKey: "Invalid Surrogate Pair Format - Too Many Colons"])
            return nil
        }
        let high = decodeHexStringToUInt32(array[0])
        let low = decodeHexStringToUInt32(array[1])
        if let high = high {
            if let low = low {
                return decodeFromSurrogatePair(high: high, low: low)
            }
        }
        
        error = NSError(domain: ErrorDomain, code: ErrorFailDecodeSurrogatePair, userInfo: [NSLocalizedDescriptionKey: "Decoding Surrogate Pair is Failed"])
        return nil
    }
    
    public class func decodeFromSurrogatePair(high high: UInt32, low: UInt32) -> String? {
        let unicodeEntry = convSurrogatePairToUnicodeScalar(high: high, low: low)
        if let unicodeEntry = unicodeEntry {
            return String(UnicodeScalar(unicodeEntry))
        }
        return nil
    }
    
    public class func convUnicodeScalarToSurrogatePair(unicodeScalar: UInt32) -> (UInt32?, UInt32?) {
        return (convUnicodeScalarToHighSurrogate(unicodeScalar), convUnicodeScalarToLowSurrogate(unicodeScalar))
    }
    
    public class func convSurrogateToUnicodeScalar(surrogatePair: String) -> UInt32? {
        if (!surrogatePair.contains(":")) {
            error = NSError(domain: ErrorDomain, code: ErrorWrongFormatSurrogate, userInfo: [NSLocalizedDescriptionKey: "Invalid Surrogate Pair Format - Colon Not Found"])
            return nil
        }
        var array = surrogatePair.componentsSeparatedByString(":")
        if (array.count > 2) {
            error = NSError(domain: ErrorDomain, code: ErrorWrongFormatSurrogate, userInfo: [NSLocalizedDescriptionKey: "Invalid Surrogate Pair Format - Too Many Colons"])
            return nil
        }
        let high = decodeHexStringToUInt32(array[0])
        let low = decodeHexStringToUInt32(array[1])
        if let high = high {
            if let low = low {
                return convSurrogatePairToUnicodeScalar(high: high, low: low)
            }
        }
        return nil
    }
    
// MARK: Private Methods
    
    private class func isHighSurrogate(high: UInt32) -> Bool {
        return (high & (~HIGH_SURROGATE_MASK)) == HIGH_SURROGATE_MIN
    }
    
    private class func isLowSurrogate(low: UInt32) -> Bool {
        return (low & (~LOW_SURROGATE_MASK)) == LOW_SURROGATE_MIN
    }
    
    private class func convUnicodeScalarToHighSurrogate(unicodeScalar: UInt32) -> UInt32? {
        let high = (((unicodeScalar - UNICODE_PLANE_MIN) >> SURROGATE_BITS) & HIGH_SURROGATE_MASK) | HIGH_SURROGATE_MIN
        if (isHighSurrogate(high)) {
            return high
        }
        return nil
    }
    
    private class func convUnicodeScalarToLowSurrogate(unicodeScalar: UInt32) -> UInt32? {
        let low = (unicodeScalar & LOW_SURROGATE_MASK) | LOW_SURROGATE_MIN
        if (isLowSurrogate(low)) {
            return low
        }
        return nil
    }
    
    private class func convSurrogatePairToUnicodeScalar(high high: UInt32, low: UInt32) -> UInt32? {
        if (high < HIGH_SURROGATE_MIN) {
            error = NSError(domain: ErrorDomain, code: ErrorSurrogateIndexOutOfBounds, userInfo: [NSLocalizedDescriptionKey: "High Surrogates (\(high.hexExpression())) must be greater than 0xD800"])
            return nil
        }
        if (high > HIGH_SURROGATE_MAX) {
            error = NSError(domain: ErrorDomain, code: ErrorSurrogateIndexOutOfBounds, userInfo: [NSLocalizedDescriptionKey: "High Surrogates (\(high.hexExpression())) must be less than 0xDBFF"])
            return nil
        }
        if (low < LOW_SURROGATE_MIN) {
            error = NSError(domain: ErrorDomain, code: ErrorSurrogateIndexOutOfBounds, userInfo: [NSLocalizedDescriptionKey: "Low Surrogates (\(low.hexExpression())) must be greater than 0xDC00"])
            return nil
        }
        if (low > LOW_SURROGATE_MAX) {
            error = NSError(domain: ErrorDomain, code: ErrorSurrogateIndexOutOfBounds, userInfo: [NSLocalizedDescriptionKey: "Low Surrogates (\(low.hexExpression())) must be less than 0xDFFF"])
            return nil
        }
        return ((high & HIGH_SURROGATE_MASK) << SURROGATE_BITS) + (low & LOW_SURROGATE_MASK) + UNICODE_PLANE_MIN;
    }
    
}
