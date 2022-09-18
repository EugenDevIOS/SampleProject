//
//  BaseSampleAPIParser.swift
//

import Foundation
import Shakuro_HTTPClient
import SwiftyJSON

class AppAPIClientParser<T>: HTTPClientParser {

    typealias ResultType = T
    typealias ResponseValueType = JSON

    func serializeResponseData(_ responseData: Data?) throws -> JSON {
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

    func parseForResult(_ serializedResponse: JSON, response: HTTPURLResponse?) throws -> T {
        fatalError("abstract")
    }

}

final class DefaultParser: AppAPIClientParser<Void> {

    override func parseForResult(_ serializedResponse: JSON, response: HTTPURLResponse?) throws {
        return ()
    }

}
