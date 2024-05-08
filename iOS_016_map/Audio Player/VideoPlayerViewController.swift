//
//  VideoPlayerViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 01/04/24.
//

import UIKit
import AVFoundation
import MediaPlayer

class VideoPlayerViewController: UIViewController {
    
    var volumeView: MPVolumeView?

    @IBOutlet weak var volumeSlider: UISlider!
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
        
        volumeView = MPVolumeView(frame: CGRect(x: -CGFloat.greatestFiniteMagnitude, y: 0, width: 0, height: 0))
            
        if let volumeView = volumeView {
            view.addSubview(volumeView)
        }
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            self?.updateSliderWithSystemVolume()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        controllerVIew.layer.cornerRadius = 10.0
        videoPlayerLayer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(videoPlayerTapped)))
        
        navigationController?.isNavigationBarHidden = true
        setUpVideoControlls()
        
    }
    
    func updateSliderWithSystemVolume() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(true)
            let currentVolume = audioSession.outputVolume
            volumeSlider.value = currentVolume
        } catch {
            print("Error setting active audio session: \(error.localizedDescription)")
        }
    }
    
    @objc func videoPlayerTapped() {
        UIView.animate(withDuration: 0.5) {
            if self.isControllerHidden {
                self.controllerVIew.isHidden = false
                self.isControllerHidden = false
            } else {
                self.controllerVIew.isHidden = true
                self.isControllerHidden = true
            }
        }
    }
    
    func setUpVideoControlls() {
        sliderView.value = 0.0
        
        currentTimelabel.text = "00:00"

        playVideo()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timeInterval), userInfo: nil, repeats: true)
        avPlayer.play()
    }
    
    @objc func timeInterval() {
        if let currentItem = avPlayer.currentItem {
            let currentTime = CMTimeGetSeconds(currentItem.currentTime())
            let duration = CMTimeGetSeconds(currentItem.duration)
            
            sliderView.minimumValue = 0.0
            sliderView.maximumValue = Float(duration - 1)
            sliderView.value = 0.0
            
            (th, tm, ts) = secondsToHoursMinutesSeconds(Int(duration))
            totalTimeLabel.text = String(format: "%0.2d:%0.2d", tm, ts)

            let (_, m, s) = secondsToHoursMinutesSeconds(Int(currentTime + 1))
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
        playerLayer.frame = view.frame
        if isFullScreen {
            playerLayer.videoGravity = .resizeAspectFill
        } else {
            playerLayer.videoGravity = .resizeAspect
        }
        videoPlayerLayer.layer.addSublayer(playerLayer)
        videoPlayerLayer.layoutIfNeeded()
        playerLayer.layoutIfNeeded()
        
        avPlayer.volume = 0.5
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        } catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(videoFinished), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem)
    }
    
    @objc func videoFinished() {
        currentTimelabel.text = "00:00"
        self.playerLayer.removeFromSuperlayer()
        self.timer.invalidate()
        self.avPlayer.seek(to: .zero)
        self.setUpVideoControlls()
    }
    
    @IBAction func previousButtonTapped(_ sender: UIButton) {
        playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        isPlaying = true
        playerLayer.removeFromSuperlayer()
        timer.invalidate()
        if index > 0 {
            index -= 1
        } else {
            index = videoFilesURL.count - 1
        }
        setUpVideoControlls()
    }
    
    @IBAction func backwardButtonTapped(_ sender: UIButton) {
        
        avPlayer.pause()
        
        let currentTime = CMTimeGetSeconds(avPlayer.currentTime())
        if currentTime > 10 {
            avPlayer.seek(to: CMTime(seconds: currentTime - 10, preferredTimescale: 1))
            avPlayer.seek(to: CMTime(seconds: currentTime - 10, preferredTimescale: 1)) { complete in
                if self.isPlaying {
                    self.avPlayer.play()
                }
            }
        } else {
            avPlayer.seek(to: .zero) { complete in
                if self.isPlaying {
                    self.avPlayer.play()
                }
            }
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
        
        avPlayer.pause()
        
        let currentTime = CMTimeGetSeconds(avPlayer.currentTime())
        let totalTime = CMTimeGetSeconds(avPlayer.currentItem!.duration)
        print(currentTime)
        if currentTime < totalTime - 10 {
            avPlayer.seek(to: CMTime(seconds: currentTime.advanced(by: 10.0), preferredTimescale: 1)) { completed in
                if self.isPlaying {
                    self.avPlayer.play()
                }
            }
        } else {
            avPlayer.seek(to: CMTime(seconds: currentTime.advanced(by: 10.0), preferredTimescale: 1)) { completed in
                if self.isPlaying {
                    self.avPlayer.play()
                }
            }
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        isPlaying = true
        playerLayer.removeFromSuperlayer()
        timer.invalidate()
        if index < videoFilesURL.count - 1 {
            index += 1
        } else {
            index = 0
        }
        setUpVideoControlls()
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        avPlayer.seek(to: CMTime(seconds: Double(sliderView.value), preferredTimescale: 60))
        if isPlaying {
            avPlayer.play()
        }
        
    }
    
    @IBAction func sliderValueUpdated(_ sender: Any) {
        print("slider value : \(sliderView.value)")
    }
    
    @IBAction func volumeSliderChanged(_ sender: UISlider) {
        //avPlayer.volume = sender.value
        let volume = sender.value
        let volumeViewSlider = volumeView?.subviews.first(where: { $0 is UISlider }) as? UISlider
            volumeViewSlider?.setValue(volume, animated: false)
    }
    
    @IBAction func fullScreenButtonTapped(_ sender: UIButton) {
        if isFullScreen {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            
        } else {
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        }
        
        UIViewController.attemptRotationToDeviceOrientation()
        playerLayer.frame = videoPlayerLayer.bounds
        isFullScreen = !isFullScreen
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        self.playerLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        if UIDevice.current.orientation.isLandscape {
            self.isFullScreen = true
        } else if UIDevice.current.orientation.isPortrait {
            self.isFullScreen = false
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
        avPlayer.pause()
        
    }
    
}
