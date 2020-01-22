//
//  StopRecordingView.swift
//  IssueCollector
//
//  Created by Suhaib on 03/01/2020.
//  Copyright © 2020 Suhaib Al Saghir. All rights reserved.
//

import UIKit
import ReplayKit
import Photos

class StopRecordingView: UIView, XibConnected {
    
    enum Side {
        case left
        case right
    }
    
    @IBOutlet weak var stopButton: UIButton! {
        didSet {
            let tapGesture = UITapGestureRecognizer.init(target: self,
                                                         action: #selector(stopRecordingButtonDidPressed))
            let longGesture = UIPanGestureRecognizer.init(target: self,
                                                          action: #selector(handlePan))
            
            stopButton.addGestureRecognizer(tapGesture)
            stopButton.addGestureRecognizer(longGesture)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        connectXib(to: self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        connectXib(to: self)
    }

    @objc func stopRecordingButtonDidPressed(_ sender: UIGestureRecognizer) {
        let recorder = RPScreenRecorder.shared()
        
        recorder.stopRecording { (preview, error) in
            if let preview = preview {
                let nav = UINavigationController.init(rootViewController: preview)
                preview.previewControllerDelegate = self
                
                let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
                nav.isNavigationBarHidden = true
                preview.isModalInPresentation = false
                nav.isModalInPresentation = false

                window?.rootViewController?.present(nav, animated: true, completion: nil)

            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}


// MARK:- Screen recording methods
extension StopRecordingView: RPPreviewViewControllerDelegate {
    func previewController(_ previewController: RPPreviewViewController, didFinishWithActivityTypes activityTypes: Set<String>) {
        self.removeFromSuperview()
        handle(previewController, activityTypes: activityTypes)
    }
}

extension StopRecordingView {
    private func handle(_ previewController: RPPreviewViewController, activityTypes: Set<String>) {
        guard let activity = activityTypes.first else {
            previewController.dismiss(animated: true, completion: nil)
            return
        }

        if activity.contains("Save") {
            let status = PHPhotoLibrary.authorizationStatus()
            if status == .authorized {
                self.getVideoPath(previewController)
            } else {
                previewController.presentFailureAlert(with: "This feaure is not supported for this specific App. Please ask the developer to implement it")
            }
        } else {
            previewController.dismiss(animated: true, completion: nil)
        }
    }
    
    private func getVideoPath(_ previewController: RPPreviewViewController) {
        PHPhotoLibrary.shared().performChanges({
         }) { [weak self] (saved, error) in
             if saved {
                 let fetchOption = PHFetchOptions()
                 fetchOption.sortDescriptors = [NSSortDescriptor.init(key: "creationDate",
                                                                      ascending: true)]
                 let fetchResult = PHAsset.fetchAssets(with: .video, options: fetchOption).lastObject
                 PHImageManager().requestAVAsset(forVideo: fetchResult!, options: nil) { (asset, _, _) in
                    let newOBJ = asset as! AVURLAsset
                    DispatchQueue.main.async {
                        self?.presentIssueCollectorFlow(previewController,
                                                        with: newOBJ.url)
                    }
                 }
             }
         }
    }
    
    private func presentIssueCollectorFlow(_ previewController: RPPreviewViewController, with url: URL) {
        DispatchQueue.main.async {
            guard let nav = UIStoryboard.init(name: "Details",
                                             bundle: Bundle.init(for: Self.self))
                .instantiateInitialViewController() as? UINavigationController,
                let vc = nav.topViewController as? DetailsViewController else { return }
            vc.prepareWith(.video(url))
            let presenting = previewController.presentingViewController
            previewController.dismiss(animated: true) {
                presenting?.present(nav, animated: true, completion: nil)
            }
        }
    }
}



// MARK:- Translation methods
extension StopRecordingView {
    @objc private func handlePan(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self)
        
        switch recognizer.state {
        case .ended:
            handleEnd()
            
        default:
            self.center = CGPoint.init(x: self.center.x + translation.x,
                                       y: self.center.y + translation.y)
        }
        recognizer.setTranslation(.zero, in: self)
    }
    
    private func handleEnd() {
        guard let superview = self.superview else { return }
        func stick(to side: Side) {
            switch side {
            case .left:
                self.frame.origin = CGPoint.init(x: 0,
                                                 y: self.frame.origin.y)
                
            case .right:
                self.frame.origin = CGPoint.init(x: superview.frame.width - self.frame.width,
                                                 y: self.frame.origin.y)
            }
        }
        
        self.center.x >= superview.center.x ?
            stick(to: .right) : stick(to: .left
        )
    }
}
