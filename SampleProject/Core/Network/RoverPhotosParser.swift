//
//  RoverPhotosParser.swift
//

import Foundation
import Shakuro_HTTPClient
import SwiftyJSON

final class RoverPhotosParser: HTTPClientParser {

    typealias ResultType = Result
    typealias ResponseValueType = JSON


    struct Result {
    }

    func serializeResponseData(_ responseData: Data?) throws -> ResponseValueType {
        return JSON()
    }

    func parseForError(response: HTTPURLResponse?, responseData: Data?) -> Swift.Error? {
        return nil
    }

    func parseForResult(_ serializedResponse: ResponseValueType, response: HTTPURLResponse?) throws -> ResultType {
        return Result()
    }

}
