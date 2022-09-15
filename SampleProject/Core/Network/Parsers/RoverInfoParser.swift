//
//  RoverInfoParser.swift
//

import Shakuro_HTTPClient
import SwiftyJSON

struct RoverInfo {
    let name: String
    let landingDate: Date
    let launchDate: Date
    let status: String
    let maxSol: Int
    let maxDate: Date
    let totalPhotos: Int
}

final class RoverInfoParser: AppAPIClientParser<RoverInfo> {

    override func parseForResult(_ serializedResponse: JSON, response: HTTPURLResponse?) throws -> RoverInfo {
        let info = serializedResponse["photo_manifest"]
        let dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            return dateFormatter
        }()
        guard let name = info["name"].string,
              let landingDate = dateFormatter.date(from: info["landing_date"].stringValue),
              let launchDate = dateFormatter.date(from: info["launch_date"].stringValue),
              let maxDate = dateFormatter.date(from: info["max_date"].stringValue),
              let totalPhotos = info["name"].int else {
            throw HTTPClient.Error.cantParseSerializedResponse(underlyingError: nil)
        }
        return RoverInfo(name: name,
                         landingDate: landingDate,
                         launchDate: launchDate,
                         status: info["status"].stringValue,
                         maxSol: info["max_sol"].intValue,
                         maxDate: maxDate,
                         totalPhotos: totalPhotos)
    }

}
