//
//  Converter.swift
//
//
//  Created by Elvis on 17/06/2024.
//

import Foundation

class Converter {
    static func convertStringToTime(_ time: String?) -> TimeInterval {
        guard let time = time else {
            return 0
        }
        let timeComponents = time.components(separatedBy: ":")
        if timeComponents.count == 2 {
            guard let minutes = Double(timeComponents[0]) else {
                return 0
            }
            guard let seconds = Double(timeComponents[1]) else {
                return 0
            }
            return (minutes * 60) + seconds
        }
        if timeComponents.count == 1 {
            guard let seconds = Double(timeComponents[0]) else {
                return 0
            }
            return seconds
        }
        return 0
    }
}
