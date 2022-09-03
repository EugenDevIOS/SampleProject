//
//  RoverPhotosSearchInfo.swift
//

import Foundation

struct RoverPhotosSearchInfo {
    let date: Date
    let camera: WelcomeInteractor.CameraType
}

extension RoverPhotosSearchInfo {

    func generateQuery() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let dateStr = dateFormatter.string(from: date)
        let query = "earth_date=\(dateStr)&camera=\(camera.rawValue)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return query
    }

}
