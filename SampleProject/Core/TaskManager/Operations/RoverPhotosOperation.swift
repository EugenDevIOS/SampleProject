//
//  RoverPhotosOperation.swift
//

import Alamofire
import Foundation
import Shakuro_TaskManager

final class RoverPhotosOperationOptions: BaseOperationOptions {
    let apiClient: SampleAPIClient

    init(apiClient: SampleAPIClient) {
        self.apiClient = apiClient
    }
}

final class RoverPhotosOperation: BaseOperation<Void, RoverPhotosOperationOptions> {

    private var request: Alamofire.Request?

    override func main() {
        finish(result: .success(result: ()))
    }

    override func internalFinished() {
        request = nil
    }

    override func internalCancel() {
        request?.cancel()
    }

}
