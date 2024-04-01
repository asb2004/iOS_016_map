//
//  AudioListViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 29/03/24.
//

import UIKit

var audioFilesList = [URL]()

class AudioListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var documentPath: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAudioFile))
    }
    
    
    func loadFiles() {
        let files = try? FileManager.default.contentsOfDirectory(atPath: documentPath.path)
        for file in files! {
            let fileExtension = file.components(separatedBy: ["."]).last
            
            if fileExtension == "mp3" {
                audioFilesList.append(documentPath.appendingPathComponent(file))
            }
        }
        tableView.reloadData()
    }
    
    @objc func addAudioFile() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.mp3])
        documentPicker.delegate = self
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        audioFilesList.removeAll()
        
        navigationController?.isNavigationBarHidden = false
        title = "Music"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let filePath = Bundle.main.paths(forResourcesOfType: "mp3", inDirectory: nil)
        
        for path in filePath {
            audioFilesList.append(URL(string: path)!)
        }
        
        documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        loadFiles()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }

}

extension AudioListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioFilesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "audioCell") as! CustomTableViewCell
        
        cell.audioLable.text = audioFilesList[indexPath.row].lastPathComponent
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = audioPlayerStoryboard.instantiateViewController(withIdentifier: "AudioViewController") as! AudioViewController
        vc.index = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}

extension AudioListViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let url = urls.first {
            
            guard url.startAccessingSecurityScopedResource() else { return }
        
            let destinationPath = documentPath.appendingPathComponent(url.lastPathComponent)
            
            do {
                try FileManager.default.copyItem(at: url, to: destinationPath)
                audioFilesList.append(destinationPath)
                self.tableView.reloadData()
            } catch {
                fatalError("Error : \(error)")
            }
        }
    }
}
