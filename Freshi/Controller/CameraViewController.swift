//
//  CameraViewController.swift
//  Freshi
//
//  Created by Jinwook Huh on 2021/07/09.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {

    let captureSession = AVCaptureSession()
    let photoOutput = AVCapturePhotoOutput()
    let sessionQueue = DispatchQueue(label: "session Queue")
    
    @IBOutlet weak var previewView: PreviewView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        previewView.session = captureSession
        checkCameraPermissions()
    }
    

    func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            // Request permission
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else { return }
                self?.sessionQueue.async {
                    self?.setupSession()
                    self?.startSession()
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setupSession()
            startSession()
        
        @unknown default:
            break
        }
    }
    
    func setupSession() {
        captureSession.sessionPreset = .photo
        captureSession.beginConfiguration()
        
        // add video input
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                } else {
                    captureSession.commitConfiguration()
                    return
                }
            } catch {
                print(error)
                captureSession.commitConfiguration()
                return
            }
        }
        
        // add photo output
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        } else {
            captureSession.commitConfiguration()
            return
        }
        
        captureSession.commitConfiguration()
        
    }
    
    func startSession() {
        sessionQueue.async {
            if !self.captureSession.isRunning {
                self.captureSession.startRunning()
            }
        }
    }
    
    func stopSession() {
        sessionQueue.async {
            
            if self.captureSession.isRunning {
                self.captureSession.stopRunning()
            }
        }
    }

}
