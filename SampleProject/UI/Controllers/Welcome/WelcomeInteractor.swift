//
//  WelcomeInteractor.swift
//

import Foundation
import Shakuro_TaskManager

protocol WelcomeInteractorOutput: AnyObject {
    func willSendServerRequest()
    func interactor(_ interactor: WelcomeInteractor, loadedInfo: RoverInfo)
    func interactor(_ interactor: WelcomeInteractor, loadedPhotos: [RoverPhoto])
    func interactor(_ interactor: WelcomeInteractor, didReceiveResponseWithError error: AppError?)
}

final class WelcomeInteractor {

    enum CameraType: String, CaseIterable, PickerInputItem {
        case front = "FHAZ"
        case rear = "RHAZ"
        case mast = "MAST"
        case complex = "CHEMCAM"
        case handLensImager = "MAHLI"
        case descentImager = "MARDI"
        case navigation = "NAVCAM"

        var title: String {
            return localizedName
        }

        var localizedName: String {
            switch self {
            case .front:
                return NSLocalizedString("Front Hazard Avoidance Camera", comment: "")
            case .rear:
                return NSLocalizedString("Rear Hazard Avoidance Camera", comment: "")
            case .mast:
                return NSLocalizedString("Mast Camera", comment: "")
            case .complex:
                return NSLocalizedString("Chemistry and Camera Complex", comment: "")
            case .handLensImager:
                return NSLocalizedString("Mars Hand Lens Imager", comment: "")
            case .descentImager:
                return NSLocalizedString("Mars Descent Imager", comment: "")
            case .navigation:
                return NSLocalizedString("Navigation Camera", comment: "")
            }
        }

    }

    private weak var output: WelcomeInteractorOutput?

    private var curiosityInfoTask: Task<RoverInfo>?
    private var curiosityPhotosTask: Task<[RoverPhoto]>?

    private let taskManager: SampleTaskManagerProtocol

    init(output: WelcomeInteractorOutput, taskManager: SampleTaskManagerProtocol) {
        self.output = output
        self.taskManager = taskManager
    }

}

// MARK: - Public

extension WelcomeInteractor {

    func getCuriosityInfo() {
        output?.willSendServerRequest()
        curiosityInfoTask?.cancel()
        curiosityInfoTask = nil
        let task = taskManager.getCuriosityInfo()
        curiosityInfoTask = task
        task.onComplete(queue: .main, closure: { [weak self] (_, result) in
            guard let actualSelf = self, task === actualSelf.curiosityInfoTask else {
                return
            }
            actualSelf.curiosityInfoTask = nil
            switch result {
            case .success(result: let result):
                actualSelf.output?.interactor(actualSelf, loadedInfo: result)
            case .cancelled:
                break
            case .failure(error: let error):
                actualSelf.output?.interactor(actualSelf, didReceiveResponseWithError: AppError(error))
            }
        })

    }

    func getCuriosityPhotos(info: RoverPhotosSearchInfo) {
        output?.willSendServerRequest()
        curiosityPhotosTask?.cancel()
        curiosityPhotosTask = nil
        let task = taskManager.getCuriosityPhotos(info: info)
        curiosityPhotosTask = task
        task.onComplete(queue: .main, closure: { [weak self] (_, result) in
            guard let actualSelf = self, task === actualSelf.curiosityPhotosTask else {
                return
            }
            actualSelf.curiosityPhotosTask = nil
            switch result {
            case .success(result: let result):
                actualSelf.output?.interactor(actualSelf, loadedPhotos: result)
            case .cancelled:
                break
            case .failure(error: let error):
                actualSelf.output?.interactor(actualSelf, didReceiveResponseWithError: AppError(error))
            }
        })
    }

}
