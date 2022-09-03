//
//  SampleTaskManager.swift
//

import Foundation
import Shakuro_TaskManager

protocol SampleTaskManagerProtocol {
    func getRoverPhotos(info: RoverPhotosSearchInfo) -> Task<[RoverPhoto]>
}

final class SampleTaskManager: TaskManager {
    private let apiClient = SampleAPIClient()

    init() {
        super.init(name: "\(UIApplication.bundleIdentifier).app.taskmanager.queue", qualityOfService: .userInteractive, maxConcurrentOperationCount: 5)
    }

}

extension SampleTaskManager: SampleTaskManagerProtocol {

    func getRoverPhotos(info: RoverPhotosSearchInfo) -> Task<[RoverPhoto]> {
        let opt = RoverPhotosOperationOptions(apiClient: apiClient, searchInfo: info)
        return performOperation(operationType: RoverPhotosOperation.self,
                                options: opt)
    }

}
