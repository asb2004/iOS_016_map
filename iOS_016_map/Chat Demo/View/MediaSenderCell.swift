//
//  MediaSenderCell.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 17/05/24.
//

import UIKit
import AVFoundation
import SDWebImage

class MediaSenderCell: UITableViewCell {

    @IBOutlet weak var playButton: UIImageView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var mediaImage: UIImageView!
    @IBOutlet weak var backView: UIView!
    
    var videoPlayButtonTapped: (() -> ())?
    
    var message: Message! {
        didSet {
            self.setMessageValues()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        backView.layer.cornerRadius = 5.0
        mediaImage.layer.cornerRadius = 5.0
        
        playButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(playButtonTapped)))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        mediaImage.image = nil
        mediaImage.backgroundColor = .clear
        playButton.isHidden = true
        timeLbl.text = nil
        
    }
    
    @objc func playButtonTapped() {
        videoPlayButtonTapped!()
    }
    
    func setMessageValues() {
        
        let url = URL(string: message.message)
        let fileExtension = url?.pathExtension
        
        if fileExtension!.lowercased() == "mp4" ||
            fileExtension!.lowercased() == "mov" ||
            fileExtension!.lowercased() == "m4v" {
            self.mediaImage.image = UIImage(systemName: "")
            self.mediaImage.backgroundColor = .black
            DispatchQueue.global().async {
                if let image = self.getThumbnailImage(forUrl: url!) {
                    DispatchQueue.main.async {
                        self.playButton.isHidden = false
                        self.mediaImage.image = image
                    }
                }
            }
        } else {
            self.playButton.isHidden = true
            self.mediaImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.mediaImage.sd_setImage(with: url!, completed: nil)
        }
        self.timeLbl.text = ChatViewController.getDateString(from: message.time)
    }
    
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true

        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }

        return nil
    }
    
}
