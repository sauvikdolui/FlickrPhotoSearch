//
//  FoundationExtensions.swift
//  FlickrPhotoSearch
//
//  Created by Sauvik Dolui on 24/07/19.
//  Copyright © 2019 Sauvik Dolu. All rights reserved.
//

import Foundation

extension Dictionary where Key == String, Value == String {
    var queryString: String {
        let pairs = map({ return String($0.key + "=" + $0.value) })
        return "?" + pairs.joined(separator: "&")
    }
    static func +(lhs: [String : String], rhs: [String : String]) -> [String : String] {
        var result = lhs
        for (key, val) in rhs { result[key] = val }
        return result
    }
}



extension String {
    func isValidUrl() -> Bool {
        let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: self)
        return result
    }
}
