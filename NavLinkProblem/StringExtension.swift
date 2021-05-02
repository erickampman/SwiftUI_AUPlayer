//
//  StringExtension.swift
//  OSTypeTranslate
//
//  Created by Eric Kampman on 6/15/19.
//  Copyright © 2019 Eric Kampman. All rights reserved.
//

import Foundation

extension String {
    func osType() -> OSType? {
        let s = self.utf8
        switch s.count {
        case 4:
            var ret: OSType = 0
            for c in s {
                if (0x79 < c) {
                    return .none
                }
                ret = ret << 8 | UInt32(c)
            }
            return ret
        default:
            return .none
        }
    }
	static func from(osType: OSType) -> String {
		var ret = String();
		var b = osType >> 24 & 0xFF
		ret.append(Character(UnicodeScalar(b)!))
		b = osType >> 16 & 0xFF
		ret.append(Character(UnicodeScalar(b)!))
		b = osType >> 8 & 0xFF
		ret.append(Character(UnicodeScalar(b)!))
		b = osType & 0xFF
		ret.append(Character(UnicodeScalar(b)!))
		return ret
	}

}
