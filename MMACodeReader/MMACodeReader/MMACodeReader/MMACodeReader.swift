//
//  MMACodeReader.swift
//

import UIKit
import AVFoundation

protocol MMACodeReaderDelegate {
    func reader (reader: MMACodeReader, didRead value: String)
    func readerDidFailRead (reader: MMACodeReader)
    func readerDidRejectAccess (reader: MMACodeReader)
}

public class MMACodeReader: UIView {
    
    var avCaptureSession = AVCaptureSession()
    var avCaptureVideoPreviewLayer:AVCaptureVideoPreviewLayer?
    var codeView = UIView()
    var enableRecognition = true
    
    @IBOutlet weak var delegate : NSObject?
    
    private var readerDelegate : MMACodeReaderDelegate? {
        return delegate as? MMACodeReaderDelegate
    }
    
    public init() {
        super.init(frame: CGRectZero)
        setupUI()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    public override func awakeFromNib() {
        setupUI()
    }
    
    override public func layoutSubviews() {
        avCaptureVideoPreviewLayer?.frame = self.layer.bounds
    }
    
    private func setupUI (){
        let status = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        if status == AVAuthorizationStatus.Authorized {
            setupCamera()
        } else if status == AVAuthorizationStatus.NotDetermined {
            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { (granted) -> Void in
                NSOperationQueue.mainQueue().addOperationWithBlock({ 
                    if granted {
                        self.setupCamera()
                    } else {
                        self.readerDelegate?.readerDidRejectAccess(self)
                    }
                })
            })
        } else {
            readerDelegate?.readerDidRejectAccess(self)
        }
    }
    
    private func setupCamera() {
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            avCaptureSession.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            avCaptureSession.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode]
            
            avCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: avCaptureSession)
            avCaptureVideoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            self.layer.addSublayer(avCaptureVideoPreviewLayer!)
            
            avCaptureSession.startRunning()
            
            codeView.layer.borderColor = UIColor.redColor().CGColor
            codeView.layer.borderWidth = 4
            self.addSubview(codeView)
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
    }
    
    func startCamera () {
        if let output = avCaptureSession.outputs.first {
            output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        }
    }
    
    func stopCamera () {
        if let output = avCaptureSession.outputs.first {
            output.setMetadataObjectsDelegate(nil, queue: dispatch_get_main_queue())
        }
        codeView.frame = CGRectZero
    }
    
    func pauseCamera () {
        self.avCaptureVideoPreviewLayer?.connection.enabled = false
        if let output = avCaptureSession.outputs.first {
            output.setMetadataObjectsDelegate(nil, queue: dispatch_get_main_queue())
        }
    }
    
    func resumeCamera() {
        avCaptureVideoPreviewLayer?.connection.enabled = true
        startCamera()
        codeView.frame = CGRectZero
    }
}

extension MMACodeReader: AVCaptureMetadataOutputObjectsDelegate {
    public func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        if !enableRecognition {
            return
        }
        if let metadataObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            if metadataObj.type == AVMetadataObjectTypeQRCode {
                let barCodeObject = avCaptureVideoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj)
                
                if CGRectContainsRect(bounds, barCodeObject!.bounds) {
                    codeView.frame = barCodeObject!.bounds
                    if metadataObj.stringValue != nil {
                        self.pauseCamera()
                        delay(1, closure: {
                            self.readerDelegate?.reader(self, didRead: metadataObj.stringValue)
                        })
                    }
                }
            }
        } else {
            codeView.frame = CGRectZero
            readerDelegate?.readerDidFailRead(self)
        }
    }
    
    private func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}

