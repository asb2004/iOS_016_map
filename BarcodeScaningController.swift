//
//  BarcodeScaningController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 26/04/24.
//

import UIKit
import AVFoundation

class BarcodeScaningController: UIViewController {

    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var resultLabel: UILabel!
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCoadFrame: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            print("Failed to find camera device")
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            print(error)
            return
        }
        
        if self.captureSession.canAddInput(videoInput) {
            self.captureSession.addInput(videoInput)
        } else {
            print("input device is not added.")
        }
        
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetadataOutput)
        
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [.qr, .ean8, .ean13, .pdf417, .aztec, .code128, .code39Mod43, .code39, .code93, .upce]
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        captureSession.stopRunning()
        
        view.bringSubviewToFront(resultView)
        
        qrCoadFrame = UIView()
        
        if let qrCoadFrame = qrCoadFrame {
            qrCoadFrame.layer.borderColor = UIColor.green.cgColor
            qrCoadFrame.layer.borderWidth = 5.0
            view.addSubview(qrCoadFrame)
            view.bringSubviewToFront(qrCoadFrame)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if captureSession.isRunning == false {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if captureSession.isRunning == true {
            captureSession.stopRunning()
        }
    }

}

extension BarcodeScaningController: AVCaptureMetadataOutputObjectsDelegate {
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCoadFrame?.frame = CGRect.zero
            resultLabel.text = "No QR code is detected"
            return
        }

        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject

        //if metadataObj.type == AVMetadataObject.ObjectType.qr {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCoadFrame?.frame = barCodeObject!.bounds

            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            if metadataObj.stringValue != nil {
                resultLabel.text = metadataObj.stringValue
            }
//        } else {
//            guard let stringValue = metadataObj.stringValue else  {
//                print("Not able to read")
//                return
//            }
//            resultLabel.text = stringValue
//        }
    }
    
}
