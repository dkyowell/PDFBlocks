/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension FormatStyle where Self == IntegerFormatStyle<Int> {
    static var nogroup: IntegerFormatStyle<Int> {
        .number
            .grouping(.never)
    }
}

extension FormatStyle where Self == Date.FormatStyle {
    static var mmddyy: Date.FormatStyle {
        Date.FormatStyle()
            .month(.defaultDigits)
            .day(.defaultDigits)
            .year(.twoDigits)
    }
}

func loadData<T>(_: T.Type, from: String) -> [T] where T: Decodable {
    guard let data = from.data(using: .utf8) else {
        return []
    }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
    guard let result = try? decoder.decode([T].self, from: data) else {
        return []
    }
    return result
}
