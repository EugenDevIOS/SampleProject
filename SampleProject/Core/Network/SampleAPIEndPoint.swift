//
//  SampleApiEndPoint.swift
//

import Foundation
import Shakuro_HTTPClient

enum SampleAPIEndPoint {

    static let baseURL = "https://api.nasa.gov"

    case curiosityPhoto(query: String)

}

extension SampleAPIEndPoint: HTTPClientAPIEndPoint {

    var apiKey: String {
        return "fIONQyI7YhIPKYb3H8Zi1W9kPPDbZ3F7nmuWMXe8"
    }

    func urlString() -> String {

        let host = SampleAPIEndPoint.baseURL

        switch self {
        case .curiosityPhoto(let query):
            let encodedQuery = query.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return "\(host)/mars-photos/api/v1/rovers/curiosity/photos?api_key=\(apiKey)&\(encodedQuery)"
        }

    }

}
