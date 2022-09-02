//
//  SampleApiEndPoint.swift
//

import Foundation

enum SampleApiEndPoint {

    static let baseURL = "https://api.nasa.gov"

    case curiosityPhoto(query: String)

}

extension SampleApiEndPoint {

    var apiKey: String {
        return "fIONQyI7YhIPKYb3H8Zi1W9kPPDbZ3F7nmuWMXe8"
    }

    // swiftlint:disable cyclomatic_complexity
    func urlString() -> String {

        let host = SampleApiEndPoint.baseURL

        switch self {
        case .curiosityPhoto(let query):
            let encodedQuery = query.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return "\(host)/mars-photos/api/v1/rovers/curiosity/photos?api_key=\(apiKey)&\(encodedQuery)"
        }

    }

}

