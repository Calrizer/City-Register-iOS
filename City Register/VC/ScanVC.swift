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
            
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
        } catch {
         
            print(error)
            return
        
        }
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        captureSession.startRunning()
        
        view.bringSubviewToFront(bottomView)
        
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
        
        if metadataObjects.count == 0 {
        
            qrCodeFrameView?.frame = CGRect.zero
            return
        
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            
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
                recent.setValue("\(Calendar.current.component(.day, from: Date()))\(daySuffix(from: Date())) \(DateFormatter().monthSymbols[Calendar.current.component(.month, from: Date()) - 1])", forKey: "date")
                recent.setValue(data[3], forKey: "lecturer")
                
                do {
                    
                    try context.save()
                    
                } catch {
                    
                    print("Failed saving")
                    
                }
                
                let prehash = data[1] + "1234"
                var hash = 0
                
                for char in prehash {
                    let s = String(char).unicodeScalars
                    hash = hash + (Int(s[s.startIndex].value) * 256)
                }
                
                print(hash)
                
                let url = URL(string: "http://ec2-35-178-179-182.eu-west-2.compute.amazonaws.com:3000/api/register/\(data[1])?studentID=1234&checksum=\(hash)")
                let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                    print(data ?? "Error")
                }
                task.resume()
            
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
