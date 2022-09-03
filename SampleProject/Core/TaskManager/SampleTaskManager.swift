//
//  SampleTaskManager.swift
//

import Foundation
import Shakuro_TaskManager

protocol SampleTaskManagerProtocol {
}

final class SampleTaskManager: TaskManager {
    private let apiClient = SampleAPIClient()
}

extension SampleTaskManager: SampleTaskManagerProtocol {
}
