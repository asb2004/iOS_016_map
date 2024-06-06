//
//  SpeechToTextViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 26/04/24.
//

import UIKit
import Speech

class SpeechToTextViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var speechText: UILabel!
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognizerTask: SFSpeechRecognitionTask?
    
    var isTransmitting: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestAuthorization()
        configureAudioSession()
    }

    @IBAction func startButtonTapped(_ sender: UIButton) {
        
        if isTransmitting {
            self.cancelRecognization()
            self.startButton.setTitle("Start", for: .normal)
        } else {
            self.recordAndRecognizeSpeech()
            self.startButton.setTitle("Stop", for: .normal)
            self.speechText.text = ""
        }
        isTransmitting = !isTransmitting
    }
    
    func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .notDetermined:
                    self.startButton.isEnabled = false
                    print("Not Authorized")
                case .denied:
                    self.startButton.isEnabled = false
                    print("You denied permission for speech recognization")
                case .restricted:
                    self.startButton.isEnabled = false
                    print("You restricted permission for speech recognization")
                case .authorized:
                    self.startButton.isEnabled = true
                }
            }
        }
    }
    
    func configureAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Audio session setup failed: \(error)")
        }
    }
    
    func recordAndRecognizeSpeech() {
        //guard let node = audioEngine.inputNode else { return }
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
            
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        
        audioEngine.prepare()
        do{
            try audioEngine.start()
        } catch {
            print(error)
        }
        
        guard let myRecognizer = SFSpeechRecognizer() else {
            print("recognizer not supported for current local")
            return
        }
        if !myRecognizer.isAvailable {
            print("Recognizer is not available")
        }
        
        recognizerTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                let outputString = result.bestTranscription.formattedString
                self.speechText.text = outputString
            }
            
            if let error = error {
                print(error)
            }
        })
        
    }
    
    func cancelRecognization() {
        recognizerTask?.finish()
        recognizerTask?.cancel()
        recognizerTask = nil
        
        request.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
}
