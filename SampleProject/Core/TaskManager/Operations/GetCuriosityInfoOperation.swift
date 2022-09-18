//
//  GetCuriosityInfoOperation.swift
//

import Alamofire
import Foundation
import Shakuro_HTTPClient
import Shakuro_TaskManager

final class GetCuriosityInfoOperationOptions: BaseOperationOptions {
    let apiClient: SampleAPIClient

    init(apiClient: SampleAPIClient) {
        self.apiClient = apiClient
    }
}

final class GetCuriosityInfoOperation: BaseOperation<RoverInfo, GetCuriosityInfoOperationOptions> {

    private var request: Alamofire.Request?

    override func main() {
        let requestOptions = HTTPClient.RequestOptions(endpoint: SampleAPIEndPoint.curiosityInfo,
                                                       method: .get,
                                                       parser: RoverInfoParser())
        request = options.apiClient.sendRequest(options: requestOptions, completion: { (response) in
            guard !self.isCancelled else {
                self.finish(result: .cancelled)
                return
            }
            switch response {
            case .success(let result):
                self.finish(result: .success(result: result))
            case .cancelled:
                self.finish(result: .cancelled)
            case .failure(let error):
                self.finish(result: .failure(error: error))
            }
        })

    }

    override func internalCancel() {
        request?.cancel()
    }

    override func internalFinished() {
        request = nil
    }

}
