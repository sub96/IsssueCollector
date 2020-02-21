//
//  PreviewView.swift
//  IssueCollector
//
//  Created by Suhaib on 03/01/2020.
//  Copyright © 2020 Suhaib Al Saghir. All rights reserved.
//

import UIKit
import AVFoundation

enum Previewtype {
    case image(UIImage)
    case video(URL)
}

class PreviewView: UIView, XibConnected {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var playButton: UIButton!
    
    private var imageView: UIImageView?
    private var playerLayer: AVPlayerLayer?
    private var player: AVPlayer?
    
    private var previewType: Previewtype? {
        didSet {
            switch previewType {
            case .image(let image):
                imageView = UIImageView.init(image: image)
                self.playButton.isHidden = true
                self.containerView.addSubview(imageView!)
                imageView?.constraint(to: self)
                imageView?.contentMode = .scaleAspectFit
                
            case .video(let url):
                configureVideoPlayer(with: url)

            case .none:
                break
            }
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
    
    @IBAction private func playButtonPressed(_ sender: Any) {
        play()
    }

    func configure(with previewType: Previewtype) {
        self.previewType = previewType
    }
    
    private func configureVideoPlayer(with url: URL) {
        player = AVPlayer.init(url: url)
        playerLayer = AVPlayerLayer.init(player: player)
        playerLayer?.frame = self.frame
        playerLayer?.videoGravity = .resizeAspect
        if let playerLayer = playerLayer {
            self.containerView.layer.addSublayer(playerLayer)
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(reachTheEndOfTheVideo(_:)),
                                                   name: .AVPlayerItemDidPlayToEndTime,
                                                   object: self.player?.currentItem)
        }
    }

    @objc private func play() {
        if player?.timeControlStatus != AVPlayer.TimeControlStatus.playing {
            self.playButton.isSelected = true
            player?.play()
        } else {
            self.playButton.isSelected = false
            player?.pause()
        }
    }
    
    @objc func reachTheEndOfTheVideo(_ notification: Notification) {
        player?.pause()
        player?.seek(to: .zero)
        self.playButton.isSelected = false
    }
}
