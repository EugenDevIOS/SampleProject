//
//  RoverPhotosParser.swift
//

import Foundation
import Shakuro_HTTPClient
import SwiftyJSON

final class RoverPhotosParser: AppAPIClientParser<[RoverPhoto]> {

    override func parseForResult(_ serializedResponse: JSON, response: HTTPURLResponse?) throws -> [RoverPhoto] {
        guard let photos = serializedResponse["photos"].array else {
            return []
        }
        let roverPhotos = photos.compactMap({ (photo) -> RoverPhoto? in
            guard let identifier = photo["id"].int,
                  let url = URL(string: photo["img_src"].stringValue) else {
                return nil
            }
            return RoverPhoto(identifier: identifier, url: url)
        })
        return roverPhotos
    }

}
