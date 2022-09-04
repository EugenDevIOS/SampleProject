//
//  AppError.swift
//

import Foundation

internal protocol AppErrorProtocol: Error {
    func errorTitle() -> String
    func errorDescription() -> String
}

internal struct AppError: AppErrorProtocol {

    internal let underlyingError: Error

    init(_ aError: Error) {
        underlyingError = aError
    }

    func errorTitle() -> String {
        let title: String
        switch underlyingError {
        case let knownError as AppErrorProtocol:
            title = knownError.errorTitle()
        case _ as NSError:
            title = NSLocalizedString("General.Error", comment: "")
        default:
            title = NSLocalizedString("Unknown.Header", comment: "")
        }
        return title
    }

    func errorDescription() -> String {
        let description: String
        switch underlyingError {
        case let knownError as AppErrorProtocol:
            description = knownError.errorDescription()
        case let standardError as NSError:
            description = standardError.localizedDescription
        default:
            description = underlyingError.localizedDescription
        }
        return description
    }

}
