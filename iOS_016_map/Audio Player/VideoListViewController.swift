//
//  VideoListViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 01/04/24.
//

import UIKit
import AVKit
import AVFoundation
import Photos

var videoFilesURL = [URL]()

class VideoListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var documentPath: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.collectionViewLayout = CustomFlow()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longpressOnCell)))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addVideoFile))
        
        videoFilesURL.removeAll()
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                self.loadAllVideos()
            case .denied, .restricted, .notDetermined:
                print("Permission denied")
            @unknown default:
                fatalError("Unknown authorization status")
            }
        }
    }
    
    func loadAllVideos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.video.rawValue)
        
        DispatchQueue.global(qos: .userInitiated).async {
            let allVideos = PHAsset.fetchAssets(with: fetchOptions)
            
            allVideos.enumerateObjects { (asset, index, stop) in
                self.getVideo(asset: asset)
            }
        }
    }
    
    func getVideo(asset: PHAsset) {
        let options = PHVideoRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        
        PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { (avAsset, audioMix, info) in
            if let urlAsset = avAsset as? AVURLAsset {
                let localVideoUrl = urlAsset.url
                
                
                videoFilesURL.append(localVideoUrl)
                
                print(localVideoUrl)
                print(videoFilesURL.count)
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //videoFilesURL.removeAll()
        
        navigationController?.isNavigationBarHidden = false
        title = "Video"
        navigationController?.navigationBar.prefersLargeTitles = true
        
//        var filePath = Bundle.main.paths(forResourcesOfType: "mp4", inDirectory: nil)
//
//        for path in filePath {
//            videoFilesURL.append(URL(string: "file://\(path)")!)
//        }
//
//        filePath = Bundle.main.paths(forResourcesOfType: "mov", inDirectory: nil)
//
//        for path in filePath {
//            videoFilesURL.append(URL(string: "file://\(path)")!)
//        }
//
//        documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        loadFiles()
    }
    
    func loadFiles() {
        let files = try? FileManager.default.contentsOfDirectory(atPath: documentPath.path)
        for file in files! {
            let fileExtension = file.components(separatedBy: ["."]).last
            
            if fileExtension == "mp4" || fileExtension == "mov" {
                videoFilesURL.append(documentPath.appendingPathComponent(file))
            }
        }
        print(videoFilesURL)
    }
    
    @objc func addVideoFile() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.mpeg4Movie, .movie])
        documentPicker.delegate = self
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    private func createVideoThumbnail(from url: URL) -> UIImage? {

        let asset = AVAsset(url: url)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true

        let time = CMTimeMakeWithSeconds(1, preferredTimescale: 60)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        }
        catch {
          print(error.localizedDescription)
          return nil
        }

    }

    @objc func longpressOnCell(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: collectionView)
        
        if let indexPath = self.collectionView.indexPathForItem(at: location) {
            
            let avplayer = AVPlayer(url: videoFilesURL[indexPath.row])
            let playerController = AVPlayerViewController()
            playerController.player = avplayer
            present(playerController, animated: true, completion: nil)
            avplayer.play()
            
        } else {
            print("couldn't find index path")
        }
    }
}

extension VideoListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoCell", for: indexPath) as! VideoCollectionViewCell
        if let image = createVideoThumbnail(from: videoFilesURL[indexPath.row]) {
            cell.thumbImageView.image = image
        }
        cell.videoLabel.text = videoFilesURL[indexPath.row].lastPathComponent
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoFilesURL.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = audioPlayerStoryboard.instantiateViewController(withIdentifier: "VideoPlayerViewController") as! VideoPlayerViewController
        vc.index = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension VideoListViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let url = urls.first {
            
            guard url.startAccessingSecurityScopedResource() else { return }
        
            let destinationPath = documentPath.appendingPathComponent(url.lastPathComponent)
            
            if FileManager.default.fileExists(atPath: destinationPath.path) {
                try? FileManager.default.removeItem(at: destinationPath)
                videoFilesURL.remove(at: videoFilesURL.firstIndex(of: destinationPath)!)
            }
            
            do {
                try FileManager.default.copyItem(at: url, to: destinationPath)
                videoFilesURL.append(destinationPath)
                self.collectionView.reloadData()
            } catch {
                fatalError("Error : \(error)")
            }
        }
    }
}

class CustomFlow: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        if let collectionView = collectionView {
            let itemWidth = collectionView.bounds.width / 2
            let itemHeight = itemWidth + 30
            
            itemSize = CGSize(width: itemWidth, height: itemHeight)
            minimumLineSpacing = 0
            minimumInteritemSpacing = 0
            scrollDirection = .vertical
        }
    }
}
