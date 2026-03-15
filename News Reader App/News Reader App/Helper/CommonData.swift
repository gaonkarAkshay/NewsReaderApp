//
//  CommonData.swift
//  News Reader App
//
//  Created by Akshay  Ashok Gaonkar on 15/03/26.
//

import Foundation

class CommonData {
    static let shared = CommonData()
    
    func formatDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        guard let date = inputFormatter.date(from: dateString) else {
            return dateString
        }
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd MMMM yyyy"
        let day = Calendar.current.component(.day, from: date)
        return "\(day)\(ordinalSuffix(day)) \(outputFormatter.string(from: date).split(separator: " ").dropFirst().joined(separator: " "))"
    }
    
    func ordinalSuffix(_ day: Int) -> String {
        switch day {
        case 11,12,13:
            return "th"
            
        default:
            switch day % 10 {
            case 1: return "st"
            case 2: return "nd"
            case 3: return "rd"
            default: return "th"
            }
        }
    }
    
    func fuzzySearch<T>(searchString: String, fromData data: [T], keyPaths: [KeyPath<T, String?>]) -> [T] {
        let words = searchString
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: " ")
            .map { String($0) }
        guard !words.isEmpty else { return data }
        return data.filter { item in
            let combinedText = keyPaths
                .compactMap { item[keyPath: $0]?.lowercased() }
                .joined(separator: " ")
            
            return words.allSatisfy { word in
                combinedText.contains(word)
            }
        }
    }
}
