import Photos

class PermissionManager {
    static let shared = PermissionManager()
    
    func checkPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .authorized, .limited:
            completion(true)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                completion(newStatus == .authorized || newStatus == .limited)
            }
        default:
            completion(false)
        }
    }
}
