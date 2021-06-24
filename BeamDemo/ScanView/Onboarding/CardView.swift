//
//  OnboardingView.swift
//  BeamDemo
//
//  Created by Tiana  on 19/02/2021.
//

import UIKit
import AVKit
import SwiftMessages

class CardView: MessageView {
    @IBOutlet weak var videoView: UIView!
    //Button action callback
    var buttonAction: (() -> Void)?
    var player: AVPlayer?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func onButtonPress() {
        buttonAction?()
    }
    
    public func configurePlayer(url: String){
        player = AVPlayer(url: URL(string: url)!)
        let playerLayer = AVPlayerLayer(player: player!)
        playerLayer.frame = videoView.bounds
        playerLayer.videoGravity = .resizeAspectFill
        videoView.layer.addSublayer(playerLayer)
        player?.isMuted = true
        player?.play()
    }
    
}
