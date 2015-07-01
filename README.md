# SwiftySurrogate

[![CI Status](http://img.shields.io/travis/zh-wang/SwiftySurrogate.svg?style=flat)](https://travis-ci.org/zh-wang/SwiftySurrogate)
[![Version](https://img.shields.io/cocoapods/v/SwiftySurrogate.svg?style=flat)](http://cocoapods.org/pods/SwiftySurrogate)
[![License](https://img.shields.io/cocoapods/l/SwiftySurrogate.svg?style=flat)](http://cocoapods.org/pods/SwiftySurrogate)
[![Platform](https://img.shields.io/cocoapods/p/SwiftySurrogate.svg?style=flat)](http://cocoapods.org/pods/SwiftySurrogate)

## Usage

Use UTF16 surrogate easier in Swift.

```swift
    var emoji1 = SwiftySurrogate.decodeFromSurrogatePair(surrogatePair: "D83D:DCC9")
    var emoji2 = SwiftySurrogate.decodeFromSurrogatePair(high: 0xD83C, low: 0xDF80)
```

You can convert between surrogate pair to unicode scalar.

```swift
    expect("D83D:DE04") == "\(SwiftySurrogate.convUnicodeScalarToSurrogatePair(0x1F604).0!.hexExpression()):\(SwiftySurrogate.convUnicodeScalarToSurrogatePair(0x1F604).1!.hexExpression())"
    // true

    expect(UInt32(0x1F604)) == SwiftySurrogate.convSurrogateToUnicodeScalar("D83D:DE04")
    // true
```

Catch decoding error by optional check.

```swift
    // This will fail
    if let res = SwiftySurrogate.decodeFromSurrogatePair(surrogatePair: "FFFF:DE04") {

    } else {
        // Get the error
        println(SwiftySurrogate.lastError())
        // print -> Optional(Error Domain=SwiftySurrogateErrorDomain Code=504 "High Surrogates (FFFF) must be less than 0xDBFF" 
    }
```

## Requirements

iOS 8.0

## Installation

### Cocoapods
```ruby
pod "SwiftySurrogate"
```

## Author

zh-wang, viennakanon@gmail.com

## License

SwiftySurrogate is available under the MIT license. See the LICENSE file for more info.
