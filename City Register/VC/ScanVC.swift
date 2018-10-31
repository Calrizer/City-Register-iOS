//
//  ScanVC.swift
//  City Register
//
//  Created by Callum Drain on 25/10/2018.
//  Copyright © 2018 Calrizer. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class ScanVC: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    
    var captureSession = AVCaptureSession()
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.qr]
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var launched : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closeButton.layer.cornerRadius = 25
        closeButton.clipsToBounds = true
        
        bottomView.addShadow(location: .top, color: UIColor.black, opacity: 0.02, radius: -3)
        
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            //            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        captureSession.startRunning()
        
        // Move the message label and top bar to the front
        view.bringSubviewToFront(bottomView)
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.red.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubviewToFront(qrCodeFrameView)
        }
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if (launched == false) {
            
            if #available(iOS 11.0, *) {
                
                bottomView.frame = CGRect(x:bottomView.frame.origin.x, y:bottomView.frame.origin.y - view.safeAreaInsets.bottom, width:bottomView.frame.size.width, height:bottomView.frame.size.height)
                
                launched = true
                
            }
            
        }

    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
    
        self.navigationController?.popViewController(animated: true)
    
    }

}

extension ScanVC: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil && metadataObj.stringValue!.contains("CITY-REG"){
                
                let impact = UIImpactFeedbackGenerator()
                impact.impactOccurred()
                
                let data = metadataObj.stringValue!.components(separatedBy: ":")
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                let context = appDelegate.persistentContainer.viewContext
                
                let entity = NSEntityDescription.entity(forEntityName: "Recents", in: context)
                let recent = NSManagedObject(entity: entity!, insertInto: context)
                
                recent.setValue(data[1], forKey: "id")
                recent.setValue(data[2], forKey: "title")
                recent.setValue("\(Calendar.current.component(.day, from: Date()))\(daySuffix(from: Date())) \(DateFormatter().monthSymbols[Calendar.current.component(.month, from: Date())])", forKey: "date")
                recent.setValue(data[3], forKey: "lecturer")
                
                do {
                    
                    try context.save()
                    
                } catch {
                    
                    print("Failed saving")
                }
            
                captureSession.stopRunning()
                performSegue(withIdentifier: "scanSuccessSegue", sender: self)
                
            }
        
        }
        
    }
    
    func daySuffix(from date: Date) -> String {
        
        let calendar = Calendar.current
        let dayOfMonth = calendar.component(.day, from: date)
        
        switch dayOfMonth {
        case 1, 21, 31: return "st"
        case 2, 22: return "nd"
        case 3, 23: return "rd"
        default: return "th"
        
        }
    
    }
    
}
