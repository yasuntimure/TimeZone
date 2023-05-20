//
//  Extension+String.swift
//  TimeZone
//
//  Created by Eyüp on 11.05.2023.
//

import Foundation

extension String {
    
    func getCurrentTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let timeZone = TimeZone(identifier: self)
        dateFormatter.timeZone = timeZone
        let timeString = dateFormatter.string(from: date)
        return timeString
    }
    
    func getCityName() -> String {
        let components = self.split(separator: "/")
        if components.count > 1 {
            return components[1].replacingOccurrences(of: "_", with: " ")
        }
        return " - "
    }
}
