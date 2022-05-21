//
//  DateExtension.swift
//  TopAnime
//
//  Created by Jenny on 2022/5/19.
//

import Foundation

extension DateFormatter {
  static let iso8601Full: DateFormatter = {
      //1997-07-22T00:00:00+00:00
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:sszzz"
    return formatter
  }()
}

extension Optional where Wrapped == Date {
    func toDate() -> String {
        if let dt = self {
         return dt.stringValue("yyyy-MM-dd")
        } else {
            return "n/a"
        }
    }
}

extension Date {
    func stringValue(_ formatStyle: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = formatStyle
        
        return formatter.string(from: self)
    }
}

extension String {
    private func dateValue(_ formatStyle: String) -> Date? {
        if self.isEmpty == true {
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = formatStyle
        
        return formatter.date(from: self)
    }
}



