//
//  FZSwiftQRCodeVC.swift
//
//  Created by Jack on 2021/11/18.
//

import UIKit
import AVFoundation
import FZCommitKit

private let scanAnimationDuration = 2.0//扫描时长
private let needSound = true //扫描结束是否需要播放声音
private let scanWidth : CGFloat = 300 //扫描框宽度
private let scanHeight : CGFloat = 300 //扫描框高度
private let isRecoScanSize = true //是否仅识别框内
private let scanBoxImagePath = "QRCode_ScanBox" //扫描框图片
private let scanLineImagePath = "QRCode_ScanLine" //扫描线图片
private let soundFilePath = "noticeMusic.caf" //声音文件

class FZSwiftQRCodeVC: UIViewController {
    
    enum AuthorizationStatus {
        case authorized
        case denied
        case unknown
    }
    
    /// 扫码结果的回调
    var scanSuccessResultBlock:((String) -> Void)?
    
    /// 点击了关闭按钮的回调事件
    var scanDismissCompletionBlock:(() -> Void)?

    var scanPane: UIImageView! /// 扫描框
    var scanPreviewLayer: AVCaptureVideoPreviewLayer! // 预览图层
    var output: AVCaptureMetadataOutput!
    var scanSession:  AVCaptureSession?
    
    private lazy var scanLine: UIImageView = {
        let scanLine = UIImageView()
        scanLine.frame = CGRect(x: 0, y: 0, width: scanWidth, height: 3)
        scanLine.image = UIImage(named: scanLineImagePath)
        return scanLine
    }()
    
    private lazy var closeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "scan_Close"), for: .normal)
        btn.fz_addActionBlock {[weak self] btn in
            fz_getCurrentVC()?.dismiss(animated: true, completion: nil)
            self?.scanDismissCompletionBlock?()
        }
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        setupScanSession()
        NotificationCenter.default.addObserver(self, selector: #selector(receiverNotification), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc private func receiverNotification() {
        setLayerOrientationByDeviceOritation()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        startScan()
    }
    
    // 初始化界面
    private func initView()  {
        scanPane = UIImageView()
        scanPane.frame = CGRect(x: 300, y: 100, width: 400, height: 400)
        scanPane.image = UIImage(named: scanBoxImagePath)
        view.addSubview(scanPane)
        view.addSubview(closeBtn)
        closeBtn.frame = CGRect(x: UIScreen.kScreenWidth - 60, y: 30, width: 40, height: 40)

        // 增加约束
        addConstraint()
        scanPane.addSubview(scanLine)
    }
    
    // 扫描完成回调
    private func qrCodeCallBack(_ codeString : String?) {
        fz_getCurrentVC()?.dismiss(animated: true)
        guard let codeString = codeString else { return }
        if let block = self.scanSuccessResultBlock {
            block(codeString)
        }
    }
    
    private func addConstraint() {
        guard let scanPane = scanPane else { return }
        scanPane.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = NSLayoutConstraint(item: scanPane, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: scanWidth)
        let heightConstraint = NSLayoutConstraint(item: scanPane, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: scanHeight)
        let centerX = NSLayoutConstraint(item: scanPane, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0)
        let centerY = NSLayoutConstraint(item: scanPane, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0)
        view.addConstraints([widthConstraint,heightConstraint,centerX,centerY])
    }
    
    // 初始化scanSession
    private func setupScanSession() {
        do {
            // 设置捕捉设备
            guard let device = AVCaptureDevice.default(for: AVMediaType.video) else {
                return
            }
            // 设置设备输入输出
            let input = try AVCaptureDeviceInput(device: device)
            
            let output = AVCaptureMetadataOutput()
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            self.output = output
            
            // 设置会话
            let scanSession = AVCaptureSession()
            scanSession.canSetSessionPreset(.high)
            
            if scanSession.canAddInput(input){
                scanSession.addInput(input)
            }
            
            if scanSession.canAddOutput(output){
                scanSession.addOutput(output)
            }
            
            // 设置扫描类型(二维码和条形码)
            output.metadataObjectTypes = [.qr, .code39, .code128, .code39Mod43, .ean13, .ean8, .code93]

            // 预览图层
            let scanPreviewLayer = AVCaptureVideoPreviewLayer(session:scanSession)
            scanPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            scanPreviewLayer.frame = view.layer.bounds
            self.scanPreviewLayer = scanPreviewLayer
            
            setLayerOrientationByDeviceOritation()
            
            // 保存会话
            self.scanSession = scanSession
            
        } catch {
            // 摄像头不可用
            self.confirm(title: "温馨提示", message: "摄像头不可用", controller: self)
            return
        }
    }
    
    private func setLayerOrientationByDeviceOritation() {
        if(scanPreviewLayer == nil) { return }
        scanPreviewLayer.frame = view.layer.bounds
        view.layer.insertSublayer(scanPreviewLayer, at: 0)
        let screenOrientation = UIDevice.current.orientation
        if(screenOrientation == .portrait) {
            scanPreviewLayer.connection?.videoOrientation = .portrait
        } else if (screenOrientation == .landscapeLeft) {
            scanPreviewLayer.connection?.videoOrientation = .landscapeRight
        } else if (screenOrientation == .landscapeRight) {
            scanPreviewLayer.connection?.videoOrientation = .landscapeLeft
        } else if (screenOrientation == .portraitUpsideDown) {
            scanPreviewLayer.connection?.videoOrientation = .portraitUpsideDown
        } else {
            scanPreviewLayer.connection?.videoOrientation = .landscapeRight
        }
        
        // 设置扫描区域
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVCaptureInputPortFormatDescriptionDidChange, object: nil, queue: nil, using: { (noti) in
            if (isRecoScanSize) {
                self.output.rectOfInterest = self.scanPreviewLayer.metadataOutputRectConverted(fromLayerRect: self.scanPane.frame)
            } else {
                self.output.rectOfInterest = CGRect(x: 0, y: 0, width: 1, height: 1)
            }
        })
    }

    // 设备旋转后重新布局
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setLayerOrientationByDeviceOritation()
    }
    
    // 开始扫描
    fileprivate func startScan() {
        scanLine.layer.add(scanAnimation(), forKey: "scan")
        guard let scanSession = scanSession else { return }
        if !scanSession.isRunning {
            scanSession.startRunning()
        }
    }
    
    // 扫描动画
    private func scanAnimation() -> CABasicAnimation{
        let startPoint = CGPoint(x: scanLine .center.x  , y: 1)
        let endPoint = CGPoint(x: scanLine.center.x, y: scanHeight - 2)
        let translation = CABasicAnimation(keyPath: "position")
        translation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        translation.fromValue = NSValue(cgPoint: startPoint)
        translation.toValue = NSValue(cgPoint: endPoint)
        translation.duration = scanAnimationDuration
        translation.repeatCount = MAXFLOAT
        translation.autoreverses = true
        return translation
    }
    
    // MARK: Dealloc
    deinit {
        ///移除通知
        NotificationCenter.default.removeObserver(self)
    }
}

extension FZSwiftQRCodeVC: AVCaptureMetadataOutputObjectsDelegate {
    // 捕捉扫描结果
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        // 停止扫描
        self.scanLine.layer.removeAllAnimations()
        self.scanSession!.stopRunning()
        
        // 播放声音
        if(needSound){
            self.playAlertSound()
        }
        
        // 扫描完成
        if metadataObjects.count > 0 {
            if let resultObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject{
                self.qrCodeCallBack(resultObj.stringValue)
            }
        }
    }
    
    // 弹出确认框
    private func confirm(title: String?, message: String?, controller: UIViewController, handler: ( (UIAlertAction) -> Swift.Void)? = nil) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let entureAction = UIAlertAction(title: "确定", style: .destructive, handler: handler)
        alertVC.addAction(entureAction)
        controller.present(alertVC, animated: true, completion: nil)
        
    }
    
    // 播放声音
    private func playAlertSound() {
        guard let soundPath = Bundle.main.path(forResource: soundFilePath, ofType: nil) else { return }
        guard let soundUrl = NSURL(string: soundPath) else { return }
        var soundID: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(soundUrl, &soundID)
        AudioServicesPlaySystemSound(soundID)
    }
}



