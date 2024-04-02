//
//  AudioViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 29/03/24.
//

import UIKit
import AVFoundation
import MediaPlayer

let audioPlayerStoryboard = UIStoryboard(name: "audio", bundle: nil)

class AudioViewController: UIViewController, AVAudioPlayerDelegate {
    
    var volumeView: MPVolumeView?
    
    var avPlayer: AVAudioPlayer!
    var timer: Timer!
    var (th, tm, ts) = (0, 0, 0)
    var filePath: URL!
    var index: Int = 0

    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var sliderView: UISlider!
    @IBOutlet weak var audioLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    var isPlaying: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        volumeView = MPVolumeView(frame: CGRect(x: -CGFloat.greatestFiniteMagnitude, y: 0, width: 0, height: 0))
            
        if let volumeView = volumeView {
            view.addSubview(volumeView)
        }
        
        imageView.layer.cornerRadius = 10.0
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            self?.updateSliderWithSystemVolume()
        }
        
        setAudioControls()
        
        sliderView.addTarget(self, action: #selector(sliderValueChanged(sender: event:)), for: .valueChanged)
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        title = "Music"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    
    func setAudioControls() {
        filePath = audioFilesList[index]
        audioLabel.text = filePath.lastPathComponent
        
        avPlayer = try? AVAudioPlayer(contentsOf: filePath!)
        avPlayer.delegate = self
        avPlayer?.play()
        avPlayer.volume = 0.5
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timeInterval), userInfo: nil, repeats: true)
        
        (th, tm, ts) = secondsToHoursMinutesSeconds(Int(avPlayer.duration))
        totalTimeLabel.text = String(format: "%0.2d:%0.2d", tm, ts)
        
        sliderView.minimumValue = Float(avPlayer.currentTime)
        sliderView.maximumValue = Float(avPlayer.duration)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        } catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
    }
    
    @objc func timeInterval() {
        let (_, m, s) = secondsToHoursMinutesSeconds(Int(avPlayer.currentTime))
        
        sliderView.value = Float(avPlayer.currentTime)
        
        currentTimeLabel.text = String(format: "%0.2d:%0.2d", m, s)
    }
    
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    @IBAction func playButton(_ sender: Any) {
        if isPlaying {
            isPlaying = false
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            
            avPlayer.pause()
        } else {
            isPlaying = true
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            
            avPlayer.play()
        }
    }
    
    @IBAction func backwardButton(_ sender: UIButton) {
        if avPlayer.currentTime > 10 {
            avPlayer.currentTime = avPlayer.currentTime - 11
        } else {
            avPlayer.currentTime = 0
        }
    }
    
    @IBAction func forward(_ sender: UIButton) {
        if avPlayer.currentTime < avPlayer.duration - 10 {
            avPlayer.currentTime = avPlayer.currentTime + 9
        } else {
            avPlayer.currentTime = avPlayer.duration
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        isPlaying = true
        playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        if index < audioFilesList.count - 1 {
            index += 1
            setAudioControls()
        } else {
            index = 0
            setAudioControls()
        }
    }
    
    @IBAction func previousButtonTapped(_ sender: UIButton) {
        isPlaying = true
        playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        if index > 0 {
            index -= 1
            setAudioControls()
        } else {
            index = audioFilesList.count - 1
            setAudioControls()
        }
    }
    
    @objc func sliderValueChanged(sender: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            if touchEvent.phase == .ended {
                avPlayer.currentTime = TimeInterval(sliderView.value)
                if isPlaying {
                    avPlayer.play(atTime: avPlayer.currentTime)
                }
            }
        }
    }
    
    @IBAction func volumeValueChanged(_ sender: UISlider) {
        //avPlayer.volume = volumeSlider.value
        let volume = sender.value
        let volumeViewSlider = volumeView?.subviews.first(where: { $0 is UISlider }) as? UISlider
            volumeViewSlider?.setValue(volume, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        avPlayer.pause()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        timer.invalidate()
        avPlayer.currentTime = 0
        setAudioControls()
    }
}
