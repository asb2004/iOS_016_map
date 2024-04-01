//
//  VideoPlayerViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 01/04/24.
//

import UIKit
import AVFoundation

class VideoPlayerViewController: UIViewController {

    @IBOutlet weak var controllerVIew: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var sliderView: UISlider!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var currentTimelabel: UILabel!
    @IBOutlet weak var videoPlayerLayer: UIView!
    
    var index = 0
    var avPlayer: AVPlayer!
    var timer: Timer!
    var (th, tm, ts) = (0, 0, 0)
    var isPlaying: Bool = true
    var playerLayer: AVPlayerLayer!
    var isFullScreen = false
    var isControllerHidden = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        controllerVIew.layer.cornerRadius = 10.0
        videoPlayerLayer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(videoPlayerTapped)))

        navigationController?.navigationBar.prefersLargeTitles = false
        title = videoFilesURL[index].lastPathComponent
        
        setUpVideoControlls()
        
    }
    
    @objc func videoPlayerTapped() {
        if isControllerHidden {
            controllerVIew.isHidden = false
            isControllerHidden = false
        } else {
            controllerVIew.isHidden = true
            isControllerHidden = true
        }
    }
    
    func setUpVideoControlls() {
        
        playVideo()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timeInterval), userInfo: nil, repeats: true)
        avPlayer.play()
    }
    
    @objc func timeInterval() {
        if let currentItem = avPlayer.currentItem {
            let currentTime = CMTimeGetSeconds(currentItem.currentTime())
            let duration = CMTimeGetSeconds(currentItem.duration)
            
            sliderView.minimumValue = 0.0
            sliderView.maximumValue = Float(duration)
            sliderView.value = 0.0
            
            (th, tm, ts) = secondsToHoursMinutesSeconds(Int(duration))
            totalTimeLabel.text = String(format: "%0.2d:%0.2d", tm, ts)

            let (_, m, s) = secondsToHoursMinutesSeconds(Int(currentTime))
            currentTimelabel.text = String(format: "%0.2d:%0.2d", m, s)
            sliderView.value = Float(currentTime)
        }
    }
    
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func playVideo() {
        
        avPlayer = AVPlayer(url: videoFilesURL[index])
        playerLayer = AVPlayerLayer(player: avPlayer)
        playerLayer.frame = videoPlayerLayer.bounds
        playerLayer.videoGravity = .resizeAspect
        videoPlayerLayer.layer.addSublayer(playerLayer)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        } catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(videoFinished), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem)
    }
    
    @objc func videoFinished() {
        print("finished")
        self.timer.invalidate()
        self.avPlayer.seek(to: .zero)
        self.setUpVideoControlls()
    }
    
    @IBAction func previousButtonTapped(_ sender: UIButton) {
        playerLayer.removeFromSuperlayer()
        timer.invalidate()
        if index > 0 {
            index -= 1
            setUpVideoControlls()
        } else {
            index = videoFilesURL.count - 1
            setUpVideoControlls()
        }
    }
    
    @IBAction func backwardButtonTapped(_ sender: UIButton) {
        let currentTime = CMTimeGetSeconds(avPlayer.currentItem!.currentTime())
        if currentTime > 10 {
            avPlayer.seek(to: CMTime(seconds: currentTime - 11, preferredTimescale: 600))
            avPlayer.play()
        } else {
            avPlayer.seek(to: .zero)
            avPlayer.play()
        }
    }
    
    @IBAction func playButtinTapped(_ sender: UIButton) {
        if isPlaying {
            avPlayer.pause()
            isPlaying = false
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            avPlayer.play()
            isPlaying = true
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
    @IBAction func forwardButtonTapped(_ sender: UIButton) {
        let currentTime = CMTimeGetSeconds(avPlayer.currentItem!.currentTime())
        let totalTime = CMTimeGetSeconds(avPlayer.currentItem!.duration)
        if currentTime < totalTime - 10 {
            avPlayer.seek(to: CMTime(seconds: currentTime + 9, preferredTimescale: 600))
            avPlayer.play()
        } else {
            avPlayer.seek(to: CMTime(seconds: totalTime, preferredTimescale: 600))
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        playerLayer.removeFromSuperlayer()
        timer.invalidate()
        if index < videoFilesURL.count - 1 {
            index += 1
            setUpVideoControlls()
        } else {
            index = 0
            setUpVideoControlls()
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        avPlayer.seek(to: CMTime(seconds: Double(sliderView.value), preferredTimescale: 60))
        avPlayer.play()
    }
    
    @IBAction func volumeSliderChanged(_ sender: UISlider) {
        avPlayer.volume = sender.value
    }
    
    @IBAction func fullScreenButtonTapped(_ sender: UIButton) {
        if isFullScreen {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
            playerLayer.frame = videoPlayerLayer.bounds
            playerLayer.videoGravity = .resizeAspect
            isFullScreen = false
        } else {
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
            playerLayer.frame = videoPlayerLayer.bounds
            playerLayer.videoGravity = .resizeAspectFill
            isFullScreen = true
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
        avPlayer.pause()
        
        
    }
    
}
