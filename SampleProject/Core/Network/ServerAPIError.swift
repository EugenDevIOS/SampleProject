//
//  ServerAPIError.swift
//

import Foundation

enum ServerAPIError: AppErrorProtocol {

    case internalServerError
    case serviceUnavailable
    case unknown

    func errorTitle() -> String {
        return NSLocalizedString("Server error", comment: "")
    }

    func errorDescription() -> String {
        switch self {
        case .internalServerError:
            return NSLocalizedString("Unexpected server error.", comment: "")
        case .serviceUnavailable:
            return NSLocalizedString("The server is temporarily offline.", comment: "")
        case .unknown:
            return NSLocalizedString("Unknown", comment: "")
        }
    }

}
