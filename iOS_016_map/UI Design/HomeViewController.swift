//
//  HomeViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 09/04/24.
//

import UIKit
import GooglePlaces
import GoogleMaps
import MapKit
import iOSDropDown

let uiDemoStoryboard = UIStoryboard(name: "UIDemo", bundle: nil)

class HomeViewController: UIViewController {

    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionVIew: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var pricesText: DropDown!
    @IBOutlet weak var SortByText: DropDown!
    @IBOutlet weak var topRatedButton: UIButton!
    @IBOutlet weak var distanceButton: UIButton!
    
    var longitude = 0.0
    var latitude = 0.0
    
    var imageSet: [UIImage]!
    var currentIndex = 0
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SortByText.layer.cornerRadius = 10.0
        pricesText.layer.cornerRadius = 10.0
        topRatedButton.layer.cornerRadius = 10.0
        distanceButton.layer.cornerRadius = 10.0
        
        initialSetup()
        
        imageSet = [
            UIImage(named: "shop_1")!,
            UIImage(named: "shop_2")!,
            UIImage(named: "shop_3")!,
            UIImage(named: "shop_4")!,
            UIImage(named: "shop_5")!
        ]
        
        locationView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(locationViewTapped)))
        
        let vc = ViewController()
        latitude = vc.currentLatitude
        longitude = vc.currentLongitude
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        location.fetchCityAndCountry { city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            self.locationLabel.text = city + ", " + country
        }
        
        collectionVIew.layer.cornerRadius = 10.0
        collectionVIew.collectionViewLayout = ImgageSliderCustomFlow()
        
        pageControl.numberOfPages = imageSet.count
        
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(showNextSlid), userInfo: nil, repeats: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func initialSetup() {

        // basic setup
        view.backgroundColor = .white

        // Create a new gradient layer
        let gradientLayer = CAGradientLayer()
        // Set the colors and locations for the gradient layer
        gradientLayer.colors = [UIColor.white.cgColor, UIColor(named: "tabbar_btnback")!.cgColor]
        gradientLayer.locations = [0.0, 1.0]

        // Set the start and end points for the gradient layer
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)

        // Set the frame to the layer
        gradientLayer.frame = view.frame

        // Add the gradient layer as a sublayer to the background view
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
     
    @objc func showNextSlid() {
        if currentIndex < imageSet.count - 1 {
            currentIndex += 1
        } else {
            currentIndex = 0
        }
        
        collectionVIew.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .right, animated: true)
        pageControl.currentPage = currentIndex
    }
    
    @objc func locationViewTapped() {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        present(autoCompleteController, animated: true, completion: nil)
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageSet.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageSliderCell", for: indexPath) as! IamgeSliderCell
        cell.imageView.image = imageSet[indexPath.row]
        return cell
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageSet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeProductCell") as! HomeProductViewCell
        cell.shopImage.image = imageSet[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = uiDemoStoryboard.instantiateViewController(withIdentifier: "ProductListNav") as! UINavigationController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
}

extension HomeViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {

        latitude = place.coordinate.latitude
        longitude = place.coordinate.longitude
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        location.fetchCityAndCountry { city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            self.locationLabel.text = city + ", " + country
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print(error)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
}

class ImgageSliderCustomFlow: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        if let collectionView = collectionView {
            let itemWidth = collectionView.bounds.width
            let itemHeight = collectionView.bounds.height
            
            itemSize = CGSize(width: itemWidth, height: itemHeight)
            minimumLineSpacing = 0
            minimumInteritemSpacing = 0
            scrollDirection = .horizontal
        }
    }
}

