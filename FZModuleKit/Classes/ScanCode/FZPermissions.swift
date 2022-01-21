//
//  FZPermissions.swift
//
//  Created by Jack on 2021/12/27.
//

import UIKit
import AVFoundation
import Photos
import AssetsLibrary

class FZPermissions: NSObject {
    
    // 获取相册权限
    static func authorizePhotoWith(comletion: @escaping (Bool) -> Void) {
        let granted = PHPhotoLibrary.authorizationStatus()
        switch granted {
        case PHAuthorizationStatus.authorized:
            comletion(true)
        case PHAuthorizationStatus.denied, PHAuthorizationStatus.restricted:
            comletion(false)
        case PHAuthorizationStatus.notDetermined:
            PHPhotoLibrary.requestAuthorization({ status in
                DispatchQueue.main.async {
                    comletion(status == PHAuthorizationStatus.authorized)
                }
            })
        case .limited:
            comletion(true)
        @unknown default:
            comletion(false)
        }
    }
    
    /// 相机权限
    static func checkAuthorizeCameraWithStatus(completion: @escaping (Bool) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch status {
        case .authorized:
            completion(true)
        case .denied, .restricted:
            completion(false)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) in
                DispatchQueue.main.async {
                    completion(granted)
                }
            })
        default:
            completion(false)
        }
    }

    /// 跳转到APP系统设置权限界面
    static func requestCameraPermission(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { isGranted in
            DispatchQueue.main.async {
                completion(isGranted)
            }
        }
    }
    
}
