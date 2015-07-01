// https://github.com/Quick/Quick

import Quick
import Nimble
import SwiftySurrogate

class TableOfContentsSpec: QuickSpec {
    override func spec() {
        
        it("hex expression ok?") {
            expect("12FF") == UInt32(0x12FF).hexExpression()
        }
        
        it("emoji test: 😄 surrogate -> scalar ok?") {
            expect("\u{1F604}") == SwiftySurrogate.decodeFromSurrogatePair(surrogatePair: "D83D:DE04")
        }
        
        it("2-way conversion ok?") {
            expect("D83D:DE04") == "\(SwiftySurrogate.convUnicodeScalarToSurrogate(0x1F604).0.hexExpression()):\(SwiftySurrogate.convUnicodeScalarToSurrogate(0x1F604).1.hexExpression())"
            
            expect(UInt32(0x1F604)) == SwiftySurrogate.convSurrogateToUnicodeScalar("D83D:DE04")
        }
        
    }
}
