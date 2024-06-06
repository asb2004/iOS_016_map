//
//  TextToSpeechViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 25/04/24.
//

import UIKit
import AVFoundation

class TextToSpeechViewController: UIViewController {

    @IBOutlet weak var text: UITextView!
    @IBOutlet weak var speechButton: UIButton!
    
    let synthesizer = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        text.delegate = self
        synthesizer.delegate = self
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
    }
    
    @IBAction func speechButtonTapped(_ sender: UIButton) {
        
        if synthesizer.isPaused {
            synthesizer.continueSpeaking()
            self.speechButton.setTitle("Pause", for: .normal)
        } else if synthesizer.isSpeaking {
            synthesizer.pauseSpeaking(at: .immediate)
            self.speechButton.setTitle("Continue", for: .normal)
        } else {
            if let text = text.text {
                if text.count == 0 {
                    let avc = UIAlertController(title: "Enter Text", message: nil, preferredStyle: .alert)
                    avc.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    present(avc, animated: true, completion: nil)
                } else {
                    let uttarance = AVSpeechUtterance(string: text)
                    uttarance.voice = AVSpeechSynthesisVoice(language: "en")
                    //uttarance.rate = 1.0
                    
                    synthesizer.speak(uttarance)
                    self.speechButton.setTitle("Pause", for: .normal)
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.synthesizer.isSpeaking {
            self.synthesizer.stopSpeaking(at: .immediate)
        }
    }
}

extension TextToSpeechViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if synthesizer.isSpeaking || synthesizer.isPaused {
            synthesizer.stopSpeaking(at: .immediate)
            self.speechButton.setTitle("Speak", for: .normal)
        }
    }
}

extension TextToSpeechViewController: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.speechButton.setTitle("Speak", for: .normal)
    }
}
