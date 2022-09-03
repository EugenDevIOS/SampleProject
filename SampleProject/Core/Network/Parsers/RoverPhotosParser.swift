//
//  RoverPhotosParser.swift
//

import Foundation
import Shakuro_HTTPClient
import SwiftyJSON

final class RoverPhotosParser: HTTPClientParser {

    typealias ResultType = [RoverPhoto]
    typealias ResponseValueType = JSON

    func serializeResponseData(_ responseData: Data?) throws -> ResponseValueType {
        guard let data = responseData else {
            return JSON()
        }
        return try JSON(data: data)
    }

    func parseForError(response: HTTPURLResponse?, responseData: Data?) -> Swift.Error? {
        guard let responseActual = response else {
            return nil
        }
        switch responseActual.statusCode {
        case 500:
            return ServerAPIError.internalServerError
        case 503:
            return ServerAPIError.serviceUnavailable
        default:
            break
        }
        return nil
    }

    func parseForResult(_ serializedResponse: JSON, response: HTTPURLResponse?) throws -> ResultType {
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
