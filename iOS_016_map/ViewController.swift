//
//  ViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 12/03/24.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GoogleSignIn
import FacebookCore
import FBSDKLoginKit
import FirebaseAuth
import FirebaseFirestore
import StripeCore

class ViewController: UIViewController {
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var drawerView: UIView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var isDrawerShowing = false
    var drawerMenuList = ["Changes", "Custom Drawer", "SMS, Mail, Call", "Animation", "Share", "Audio Player", "Video Player", "Device Resolution", "Auto Resizing", "UI Design", "Localization", "Action Sheet", "Popover View", "Orientation",  "Pull To Refresh", "Week 8", "Week 9", "Week 10", "Week 11", "Chat Demo"]

    @IBOutlet weak var currentLocation: UIImageView!
    @IBOutlet weak var searchRouteButton: UIImageView!
    @IBOutlet weak var tfSearchDestination: UITextField!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var displayMap: UIView!
    var locationManager: CLLocationManager!
    var marker: GMSMarker!
    var mapView: GMSMapView!

    var currentLatitude = 21.2305298
    var currentLongitude = 72.86389
    
    var destinationLatitude = 0.0
    var destinationLongitude = 0.0
    
    var sourceLatitude = 0.0
    var sourecLongitude = 0.0
    
    var isSourceTapped = false
    var isDestinationTapped = false
    
    var db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        
        if let value = UserDefaults.standard.string(forKey: "loginFrom") {
            if value == "google" {
                getDataFromGoogle()
            } else if value == "facebook" {
                getUserDataFromFaceBook()
            } else {
                getDataFromFirebase()
            }
        }
        
        
        // Do any additional setup after loading the view.
        title = "Google Map"
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        let camera = GMSCameraPosition.camera(withLatitude: 21.2305298, longitude: 72.86389, zoom: 15.0)
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        mapView.frame = displayMap.bounds
        self.displayMap.addSubview(mapView)
        
        mapView.isMyLocationEnabled = true
        
        marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongitude)
        marker.title = "Utran"
        marker.snippet = "Surat"
        marker.map = mapView
        marker.isDraggable = true
        
        mapView.delegate = self
        
        searchRouteButton.layer.cornerRadius = 30.0
        searchRouteButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(searchRouteTapped)))
        
        currentLocation.layer.cornerRadius = 30.0
        currentLocation.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(currentLocationTappped)))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func getDataFromGoogle() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil {
                return
            }
            
            guard let currentUser = user else { return }
            self.lblName.text = currentUser.profile?.name
            self.lblEmail.text = currentUser.profile?.email
            
            DispatchQueue.main.async {
                if let data = try? Data(contentsOf: (currentUser.profile?.imageURL(withDimension: 320))!) {
                    self.profileImage.image = UIImage(data: data)
                }
            }
        }
    }
    
    func getUserDataFromFaceBook() {
        GraphRequest(graphPath: "me", parameters: ["fields": "id, name, email, picture.width(480).height(480)"]).start { (connection, result, error) in
              if let error = error {
                  // Handle API request error here
                  print("Error: \(error.localizedDescription)")
              } else if let userData = result as? [String: Any] {
                  // Access the user data here
                  let _ = userData["id"] as? String
                  let name = userData["name"] as? String
                  let email = userData["email"] as? String
                  
                  self.lblName.text = name
                  self.lblEmail.text = email
                  
                  if let imageURL = ((userData["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                      let url = URL(string: imageURL)
                      let data = try? Data(contentsOf: url!)
                      self.profileImage.image = UIImage(data: data!)
                  }
              }
          }
    }
    
    func getDataFromFirebase() {
        if let userID = Auth.auth().currentUser?.uid {
            do {
                db.collection("users").document(userID).getDocument { docSnepshot, err in
                    if let err = err {
                        print(err.localizedDescription)
                        return
                    }
                    if let docSnepshot = docSnepshot {
                        
                        self.db.collection("users").document(userID).updateData(["isOnline": true])
                        
                        self.lblName.text = docSnepshot.data()!["name"] as? String
                        self.lblEmail.text = docSnepshot.data()!["email"] as? String
                    }
                }
            }
        }
    }
    
    @IBAction func signOutButtonTapped(_ sender: UIButton) {
        if let value = UserDefaults.standard.string(forKey: "loginFrom") {
            if value == "google" {
                GIDSignIn.sharedInstance.signOut()
            } else if value == "facebook" {
                LoginManager().logOut()
            } else {
                do {
                    let userID = Auth.auth().currentUser?.uid
                    try Auth.auth().signOut()
                    self.db.collection("users").document(userID!).updateData(["isOnline": false])
                    print("sign out")
                } catch {
                    print("sign in")
                }
            }
        }
        UserDefaults.standard.set("signout", forKey: "loginFrom")
        Switcher.updateRootVC(status: false)
    }

    @IBAction func drawerButtonTapped(_ sender: Any) {
        if isDrawerShowing {
            drawerView.isHidden = true
            isDrawerShowing = false
        } else {
            //drawerAnimation()
            drawerView.isHidden = false
            isDrawerShowing = true
            //drawerAnimation()
        }
    }
    
    func drawerAnimation() {
        self.drawerView.frame.size.width = 0
//        self.drawerView.translatesAutoresizingMaskIntoConstraints = false
//        self.drawerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: -300).isActive = true
        
        UIView.animate(withDuration: 1) {
            self.drawerView.frame.size.width = 300
            //self.drawerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 300).isActive = true
        }
    }
    
    @IBAction func autoCompleteTapped(_ sender: Any) {
        self.drawerView.isHidden = true
        isDrawerShowing = false
        isSourceTapped = true
        isDestinationTapped = false
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        present(autoCompleteController, animated: true, completion: nil)
    }
    
    @IBAction func autoCompleteDestinationTapped(_ sender: Any) {
        self.drawerView.isHidden = true
        isDrawerShowing = false
        isSourceTapped = false
        isDestinationTapped = true
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        present(autoCompleteController, animated: true, completion: nil)
    }
    
    
    func getAddress(coordinate: CLLocationCoordinate2D, complitionHandler: @escaping ([String]) -> Void) {
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let address = response?.firstResult(), let lines = address.lines else { return }
            complitionHandler(lines)
            
        }
    }
    
    @objc func searchRouteTapped() {
        getRoutes()
        self.drawerView.isHidden = true
        isDrawerShowing = false
    }
    
    @objc func currentLocationTappped() {
        self.drawerView.isHidden = true
        isDrawerShowing = false
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        switch CLLocationManager.authorizationStatus() {
        case .restricted, .denied:
            let alertController = UIAlertController (title: "Turn on location services from settings for current location", message: nil, preferredStyle: .alert)

            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }

                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
            alertController.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(cancelAction)

            present(alertController, animated: true, completion: nil)
        case .authorizedAlways, .authorizedWhenInUse :
            let camera = GMSCameraPosition.camera(withLatitude: currentLatitude, longitude: currentLongitude, zoom: 14.0)
            mapView.animate(to: camera)
        default:
            print("default")
        }
    }
    
    func setMarkers() {
        let sourceMarker = GMSMarker()
        sourceMarker.position = CLLocationCoordinate2D(latitude: sourceLatitude, longitude: sourecLongitude)
        sourceMarker.map = mapView
        sourceMarker.icon = GMSMarker.markerImage(with: UIColor.blue)
        getAddress(coordinate: CLLocationCoordinate2D(latitude: sourceLatitude, longitude: sourecLongitude)) { res in
            let line = res.joined(separator: "\n")
            sourceMarker.title = line
        }
        
        let desMarker = GMSMarker()
        desMarker.position = CLLocationCoordinate2D(latitude: destinationLatitude, longitude: destinationLongitude)
        desMarker.map = mapView
        getAddress(coordinate: CLLocationCoordinate2D(latitude: destinationLatitude, longitude: destinationLongitude)) { res in
            let line = res.joined(separator: "\n")
            desMarker.title = line
        }
    }
    
//    func drawPath(from polyStr: String){
//
//        let path = GMSPath(fromEncodedPath: polyStr)
//        let polyline = GMSPolyline(path: path)
//        polyline.strokeWidth = 5.0
//        polyline.map = mapView
//
//
//        let cameraUpdate = GMSCameraUpdate.fit(GMSCoordinateBounds(coordinate: CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongitude), coordinate: CLLocationCoordinate2D(latitude: destinationLatitude, longitude: destinationLongitude)))
//        mapView.moveCamera(cameraUpdate)
//        let currentZoom = mapView.camera.zoom
//        mapView.animate(toZoom: currentZoom - 1.4)
//    }
    
//    func getRoutes() {
//        let origin = "\(sourceLatitude),\(sourecLongitude)"
//        let destination = "\(destinationLatitude),\(destinationLongitude)"
//
//        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyDuCz_PnycWVP2kZMgMwB5SSSc77iABQOM"
//
//        let url = URL(string: urlString)
//
//        URLSession.shared.dataTask(with: url!, completionHandler: {
//            (data, response, error) in
//
//            if(error != nil){
//                print("error")
//            }else{
//                do{
//                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
//                    let routes = json["routes"] as! NSArray
//
//                    DispatchQueue.main.async{
//                        self.mapView.clear()
//                        self.setMarkers()
//                        for route in routes
//                        {
//                            let routeOverviewPolyline:NSDictionary = (route as! NSDictionary).value(forKey: "overview_polyline") as! NSDictionary
//                            let points = routeOverviewPolyline.object(forKey: "points")
//                            let path = GMSPath.init(fromEncodedPath: points! as! String)
//                            let polyline = GMSPolyline.init(path: path)
//                            polyline.strokeWidth = 3
//
//                            let bounds = GMSCoordinateBounds(path: path!)
//                            self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 30.0))
//
//                            polyline.map = self.mapView
//
//                        }
//                    }
//                }catch let error as NSError{
//                    print("error:\(error)")
//                }
//            }
//        }).resume()
//    }

    func getRoutes() {
        let origin = "\(sourceLatitude),\(sourecLongitude)"
        let destination = "\(destinationLatitude),\(destinationLongitude)"
        
        guard let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyDuCz_PnycWVP2kZMgMwB5SSSc77iABQOM".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching routes: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data returned")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject],
                   let routes = json["routes"] as? [[String: AnyObject]] {
                    
                    DispatchQueue.main.async {
                        self.mapView.clear()
                        self.setMarkers()
                        
                        for route in routes {
                            guard let legs = route["legs"] as? [[String: AnyObject]] else { continue }
                            for leg in legs {
                                guard let steps = leg["steps"] as? [[String: AnyObject]] else { continue }
                                for step in steps {
                                    guard let polyline = step["polyline"] as? [String: AnyObject],
                                          let points = polyline["points"] as? String,
                                          let path = GMSPath(fromEncodedPath: points) else { continue }
                                    
                                    let polylines = GMSPolyline(path: path)
                                    polylines.strokeWidth = 3
                                    polylines.strokeColor = .blue
                                    polylines.map = self.mapView
                                }
                            }
                        }
                        
                        // Adjust the camera to fit all the polylines
                        if let firstRoute = routes.first,
                           let overviewPolyline = firstRoute["overview_polyline"] as? [String: AnyObject],
                           let overviewPoints = overviewPolyline["points"] as? String,
                           let overviewPath = GMSPath(fromEncodedPath: overviewPoints) {
                            let bounds = GMSCoordinateBounds(path: overviewPath)
                            self.mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 30.0))
                        }
                    }
                } else {
                    print("Invalid JSON format")
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }.resume()
    }
}

extension ViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        
    }
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.drawerView.isHidden = true
        isDrawerShowing = false
        getAddress(coordinate: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)) { res in
            self.marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let line = res.joined(separator: "\n")
            self.marker.title = line
            
            self.destinationLatitude = self.marker.position.latitude
            self.destinationLongitude = self.marker.position.longitude
            
            self.getRoutes()
            
        }
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
            
        case .restricted, .denied:
            print("permisson denied")
            mapView.clear()
            
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        default:
            print("default")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        
        currentLatitude = location.coordinate.latitude
        currentLongitude = location.coordinate.longitude
        
//        let camera = GMSCameraPosition.camera(withLatitude: currentLatitude, longitude: currentLongitude, zoom: 14.0)
//        mapView.animate(to: camera)
        
        //locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension ViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.mapView.clear()
        self.marker = GMSMarker()
        self.marker.map = mapView
        self.marker.position = place.coordinate
        self.mapView.camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 14.0)
        marker.title = place.name
        
        
        if isSourceTapped {
            sourceLatitude = place.coordinate.latitude
            sourecLongitude = place.coordinate.longitude
            tfSearch.text = place.formattedAddress
        } else {
            destinationLatitude = place.coordinate.latitude
            destinationLongitude = place.coordinate.longitude
            tfSearchDestination.text = place.name
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

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drawerMenuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = drawerMenuList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        drawerView.isHidden = true
        isDrawerShowing = false
        
        if indexPath.row == 2 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "SMSViewController") as! SMSViewController
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 4 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "ShareDataViewController") as! ShareDataViewController
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 3 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "AnimationViewController") as! AnimationViewController
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 1 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "CustomViewController") as! CustomViewController
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 5 {
            let vc = audioPlayerStoryboard.instantiateViewController(withIdentifier: "AudioListViewController") as! AudioListViewController
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 6 {
            let vc = audioPlayerStoryboard.instantiateViewController(withIdentifier: "VideoListViewController") as! VideoListViewController
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 7 {
            let vc = audioPlayerStoryboard.instantiateViewController(withIdentifier: "DeviceResolutionViewController") as! DeviceResolutionViewController
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 8 {
            let vc = audioPlayerStoryboard.instantiateViewController(withIdentifier: "AutoResizingViewController") as! AutoResizingViewController
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 10 {
            let vc = audioPlayerStoryboard.instantiateViewController(withIdentifier: "LanguageViewController") as! LanguageViewController
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 11 {
            let vc = audioPlayerStoryboard.instantiateViewController(withIdentifier: "ActionSheetViewController") as! ActionSheetViewController
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 12 {
            let vc = audioPlayerStoryboard.instantiateViewController(withIdentifier: "PopoverViewController") as! PopoverViewController
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 14 {
            let vc = audioPlayerStoryboard.instantiateViewController(withIdentifier: "PullToRefreshViewController") as! PullToRefreshViewController
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 9 {
            let vc = uiDemoStoryboard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
            let uiDesignVC = uiDemoStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            uiDesignVC.latitude = self.currentLatitude
            uiDesignVC.longitude = self.currentLongitude
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 13 {
            let vc = audioPlayerStoryboard.instantiateViewController(withIdentifier: "OrientationViewController") as! OrientationViewController
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 15 {
            let vc = week8Stroyboard.instantiateViewController(withIdentifier: "PaymentListViewController") as! PaymentListViewController
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 16 {
            let vc = week9Stroyboard.instantiateViewController(withIdentifier: "Week9TopicListViewController") as! Week9TopicListViewController
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 17 {
            let vc = week10Storyboard.instantiateViewController(withIdentifier: "Week10TopicListController") as! Week10TopicListController
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 0 {
            let vc = changesStoryboard.instantiateViewController(withIdentifier: "ChangesListViewController") as! ChangesListViewController
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 18 {
            let vc = week11Storyboard.instantiateViewController(withIdentifier: "Week11TopicListViewController") as! Week11TopicListViewController
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 19 {
            let vc = chatDemoStoryboard.instantiateViewController(withIdentifier: "UserChatListViewController") as! UserChatListViewController
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

