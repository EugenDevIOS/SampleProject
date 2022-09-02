//
//  CameraRollInteractor.swift
//

import Foundation

final class CameraRollInteractor {

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

}
