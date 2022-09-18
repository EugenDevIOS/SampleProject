//
//  SampleTaskManager.swift
//

import Foundation
import Shakuro_TaskManager

protocol SampleTaskManagerProtocol {
    func getCuriosityInfo() -> Task<RoverInfo>
    func getCuriosityPhotos(info: RoverPhotosSearchInfo) -> Task<[RoverPhoto]>
}

final class SampleTaskManager: TaskManager {
    private let apiClient = SampleAPIClient()

    init() {
        super.init(name: "\(UIApplication.bundleIdentifier).app.taskmanager.queue", qualityOfService: .userInteractive, maxConcurrentOperationCount: 5)
    }

}

extension SampleTaskManager: SampleTaskManagerProtocol {

    func getCuriosityInfo() -> Shakuro_TaskManager.Task<RoverInfo> {
        let opt = GetCuriosityInfoOperationOptions(apiClient: apiClient)
        return performOperation(operationType: GetCuriosityInfoOperation.self,
                                options: opt)
    }

    func getCuriosityPhotos(info: RoverPhotosSearchInfo) -> Task<[RoverPhoto]> {
        let opt = GetCuriosityPhotosOperationOptions(apiClient: apiClient, searchInfo: info)
        return performOperation(operationType: GetCuriosityPhotosOperation.self,
                                options: opt)
    }

}
