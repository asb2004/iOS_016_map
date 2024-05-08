//
//  ProductDetailsViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 11/04/24.
//

import UIKit

class ProductDetailsViewController: UIViewController {

    @IBOutlet weak var RateButton: UIButton!
    @IBOutlet weak var addToBagButton: UIButton!
    @IBOutlet weak var imageSliderHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonShadowView: UIView!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var productDetailsView: UIView!
    @IBOutlet weak var ratingShadowView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var viewMoreButtonView: UIView!
    @IBOutlet weak var strikeThroughLablePrice: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var backButtonImage: UIImageView!
    @IBOutlet weak var shareButtonImage: UIImageView!
    @IBOutlet weak var imageSliderView: UICollectionView!
    @IBOutlet weak var sizeButtonStack: UIStackView!
    @IBOutlet weak var colorsStack: UIStackView!
    
    var currentIndex = 0
    var timer: Timer!
    
    var imageSet = [
        UIImage(named: "shop_1")!,
        UIImage(named: "shop_2")!,
        UIImage(named: "shop_3")!,
        UIImage(named: "shop_4")!,
        UIImage(named: "shop_5")!
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageSliderView.collectionViewLayout = ImgageSliderCustomFlow()
        
        strikeThroughLablePrice.attributedText = strikeThroughLablePrice.text?.strikeThrough()
        
        setUpControls()
        sizeButtonSetUp()
        colorsButtonSetUp()
        
        pageControl.numberOfPages = imageSet.count
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(showNextSlid), userInfo: nil, repeats: true)
    }
    
    func setUpControls() {
        
        backButtonImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backButtonTapped)))
        
        shareButtonImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shareButtonTapped)))
        
        imageSliderHeight.constant = UIScreen.main.bounds.height * 0.4
        
        viewMoreButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewMoreButtonTapped)))
        
        productDetailsView.layer.cornerRadius = 20.0
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowColor = UIColor(named: "tabbar_lightbtn")?.cgColor
        shadowView.layer.shadowOffset = CGSize.zero
        shadowView.layer.shadowRadius = 10
        shadowView.layer.shadowOpacity = 0.2
        
        ratingView.layer.cornerRadius = 20.0
        ratingShadowView.layer.masksToBounds = false
        ratingShadowView.layer.shadowColor = UIColor(named: "tabbar_lightbtn")?.cgColor
        ratingShadowView.layer.shadowOffset = CGSize.zero
        ratingShadowView.layer.shadowRadius = 10
        ratingShadowView.layer.shadowOpacity = 0.2
        
        
        buttonShadowView.layer.masksToBounds = false
        buttonShadowView.layer.shadowColor = UIColor(named: "tabbar_lightbtn")?.cgColor
        buttonShadowView.layer.shadowOffset = CGSize.zero
        buttonShadowView.layer.shadowRadius = 10
        buttonShadowView.layer.shadowOpacity = 0.2
        addToBagButton.layer.cornerRadius = 20.0
        
        RateButton.layer.borderWidth = 2.0
        RateButton.layer.borderColor = UIColor(named: "tabbar_lightbtn")?.cgColor
        RateButton.layer.cornerRadius = 10.0
    }
    
    @objc func showNextSlid() {
        if currentIndex < imageSet.count - 1 {
            currentIndex += 1
        } else {
            currentIndex = 0
        }
        
        imageSliderView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .right, animated: true)
        pageControl.currentPage = currentIndex
    }
    
    @objc func shareButtonTapped() {
        
        let activityVC = UIActivityViewController(activityItems: ["hello"], applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func colorsButtonSetUp() {
        for img in colorsStack.arrangedSubviews {
            let image = img as! UIImageView
            image.layer.borderColor = UIColor(named: "tabbar_lightbtn")?.cgColor
            image.layer.cornerRadius = image.bounds.height / 2
            image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(colorButtonTapped(_:))))
        }
    }
    
    @objc func colorButtonTapped(_ sender: UITapGestureRecognizer) {
        
        guard let imageView = sender.view as? UIImageView else { return }
        
        for img in colorsStack.arrangedSubviews {
            let image = img as! UIImageView
            image.layer.borderWidth = 0.0
        }
        imageView.layer.borderWidth = 1.0
    }
    
    func sizeButtonSetUp() {
        for button in sizeButtonStack.arrangedSubviews {
            let btn = button as! UIButton
            btn.layer.cornerRadius = 5.0
        }
    }
    
    @IBAction func sizeButtons(_ sender: UIButton) {
        for button in sizeButtonStack.arrangedSubviews {
            let btn = button as! UIButton
            
            btn.backgroundColor = .white
            btn.configuration?.baseForegroundColor = .black
        }
        
        sender.backgroundColor = UIColor(named: "tabbar_lightbtn")
        sender.configuration?.baseForegroundColor = .white
    }
    
    @objc func viewMoreButtonTapped() {
        let vc = uiDemoStoryboard.instantiateViewController(withIdentifier: "ProductDetailsBottomSheetViewController") as! ProductDetailsBottomSheetViewController
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 30.0
            sheet.prefersGrabberVisible = true
        }

        present(vc, animated: true, completion: nil)
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension ProductDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageSet.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageSliderView.dequeueReusableCell(withReuseIdentifier: "ProductImageSliderCell", for: indexPath) as! ProductImageSliderCell
        cell.productImage.image = imageSet[indexPath.row]
        return cell
    }
}

class ProductImageSliderCell: UICollectionViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
        return attributeString
    }
}
