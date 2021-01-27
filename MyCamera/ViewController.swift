
/*
            This is the common custom camera manual
            
            - AVFoundation
            - CapturedSession...etc
 */
 

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCapturePhotoCaptureDelegate {

    @IBOutlet var captureImageViewButton: UIButton!
    
    @IBOutlet var previewView: UIView!
    
    @IBOutlet var takePhotoButton: UIButton!
    
    
    
    
    var captureSession: AVCaptureSession!
    
    var output: AVCapturePhotoOutput!
    
    var previewViewVideoLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        takePhotoButton.layer.cornerRadius = takePhotoButton.frame.width / 2
        
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        captureSession = AVCaptureSession()
                
        guard let camera = AVCaptureDevice.default(for: AVMediaType.video) else {
            
            print("Can not create the camera.")
            
            return
            
        }
        
        do {
            
            let input = try AVCaptureDeviceInput(device: camera)
            
            output = AVCapturePhotoOutput()
            
            if captureSession.canAddInput(input) && captureSession.canAddOutput(output) {
                
                captureSession.addInput(input)
                
                captureSession.addOutput(output)
                
                setupLiveVideoOnScreen()
                
            }
            
            
        } catch let error {
            
            print("\(error.localizedDescription)")
            
        }
        
    }
    
    func setupLiveVideoOnScreen() {
        
        previewViewVideoLayer = AVCaptureVideoPreviewLayer()
        
        previewViewVideoLayer.session = captureSession
        
        previewViewVideoLayer.videoGravity = .resizeAspect
        
        previewViewVideoLayer?.connection?.videoOrientation = .portrait
        
        previewView.layer.addSublayer(previewViewVideoLayer)
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            self.captureSession.startRunning()
            
            DispatchQueue.main.async {
                
                self.previewViewVideoLayer.frame = self.previewView.bounds

            }
            
        }
        
    }
    
    @IBAction func takePhotoButtoDidTouch(_ sender: Any) {
        
        takePhotoButton.transform = CGAffineTransform(scaleX: -1, y: 1)

        UIView.animate(withDuration: 0.3, animations: { () -> Void in

            self.takePhotoButton.transform = CGAffineTransform(scaleX: 1,y: 1)

        })
        
        
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        
        output.capturePhoto(with: settings, delegate: self)
        
    }
    
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation() else { return }
        
        let image = UIImage(data: imageData)
        
        captureImageViewButton.setImage(image, for: .normal)
    }
    
    
    
}

