//
//  RoverPhotosOperation.swift
//

import Alamofire
import Foundation
import Shakuro_HTTPClient
import Shakuro_TaskManager

final class RoverPhotosOperationOptions: BaseOperationOptions {
    let apiClient: SampleAPIClient
    let searchInfo: RoverPhotosSearchInfo

    init(apiClient: SampleAPIClient, searchInfo: RoverPhotosSearchInfo) {
        self.apiClient = apiClient
        self.searchInfo = searchInfo
    }
}

final class RoverPhotosOperation: BaseOperation<[RoverPhoto], RoverPhotosOperationOptions> {

    private var request: Alamofire.Request?

    override func main() {
        let requestOptions = HTTPClient.RequestOptions(endpoint: SampleAPIEndPoint.curiosityPhoto(query: options.searchInfo.generateQuery()),
                                                       method: .get,
                                                       parser: RoverPhotosParser())
        request = options.apiClient.sendRequest(options: requestOptions, completion: { (result) in
            guard !self.isCancelled else {
                self.finish(result: .cancelled)
                return
            }
            switch result {
            case .success(result: let result):
                self.finish(result: .success(result: result))
            case .cancelled:
                self.finish(result: .cancelled)
            case .failure(error: let error):
                self.finish(result: .failure(error: error))
            }
        })
    }

    override func internalFinished() {
        request = nil
    }

    override func internalCancel() {
        request?.cancel()
    }

}
