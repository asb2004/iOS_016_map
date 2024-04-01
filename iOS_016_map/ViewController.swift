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

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var drawerView: UIView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var isDrawerShowing = false
    var drawerMenuList = ["SMS, Mail, Call", "Share", "Animation", "Custom Drawer", "Audio Player", "Video Player"]

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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        
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
        
        // Do any additional setup after loading the view.
        title = "Google Map"
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        //locationManager.startUpdatingLocation()
        
        
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
    
    @IBAction func signOutButtonTapped(_ sender: UIButton) {
        GIDSignIn.sharedInstance.signOut()
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
    
    func drawPath(from polyStr: String){
        
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 5.0
        polyline.map = mapView


        let cameraUpdate = GMSCameraUpdate.fit(GMSCoordinateBounds(coordinate: CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongitude), coordinate: CLLocationCoordinate2D(latitude: destinationLatitude, longitude: destinationLongitude)))
        mapView.moveCamera(cameraUpdate)
        let currentZoom = mapView.camera.zoom
        mapView.animate(toZoom: currentZoom - 1.4)
    }
    
    func getRoutes() {
        let origin = "\(sourceLatitude),\(sourecLongitude)"
        let destination = "\(destinationLatitude),\(destinationLongitude)"
        
//        let session = URLSession.shared
//
//            let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&sensor=false&mode=driving&key=AIzaSyDuCz_PnycWVP2kZMgMwB5SSSc77iABQOM")!
//
//            let task = session.dataTask(with: url, completionHandler: {
//                (data, response, error) in
//
//                guard error == nil else {
//                    print(error!.localizedDescription)
//                    return
//                }
//
//                guard let jsonResult = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] else {
//
//                    print("error in JSONSerialization")
//                    return
//
//                }
//
//
//
//                guard let routes = jsonResult["routes"] as? [Any] else {
//                    return
//                }
//
//                print(routes)
//
//                guard let route = routes[0] as? [String: Any] else {
//                    return
//                }
//
//                guard let legs = route["legs"] as? [Any] else {
//                    return
//                }
//
//                guard let leg = legs[0] as? [String: Any] else {
//                    return
//                }
//
//                guard let steps = leg["steps"] as? [Any] else {
//                    return
//                }
//                  for item in steps {
//
//                    guard let step = item as? [String: Any] else {
//                        return
//                    }
//
//                    guard let polyline = step["polyline"] as? [String: Any] else {
//                        return
//                    }
//
//                    guard let polyLineString = polyline["points"] as? String else {
//                        return
//                    }
//
//                    //Call this method to draw path on map
//                    DispatchQueue.main.async {
//                        self.drawPath(from: polyLineString)
//                    }
//
//                }
//            })
//            task.resume()
        
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyDuCz_PnycWVP2kZMgMwB5SSSc77iABQOM"

        let url = URL(string: urlString)

        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in

            if(error != nil){
                print("error")
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    let routes = json["routes"] as! NSArray

                    DispatchQueue.main.async{
                        self.mapView.clear()
                        self.setMarkers()
                        for route in routes
                        {
                            let routeOverviewPolyline:NSDictionary = (route as! NSDictionary).value(forKey: "overview_polyline") as! NSDictionary
                            let points = routeOverviewPolyline.object(forKey: "points")
                            let path = GMSPath.init(fromEncodedPath: points! as! String)
                            let polyline = GMSPolyline.init(path: path)
                            polyline.strokeWidth = 3

                            let bounds = GMSCoordinateBounds(path: path!)
                            self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 30.0))

                            polyline.map = self.mapView

                        }
                    }
                }catch let error as NSError{
                    print("error:\(error)")
                }
            }
        }).resume()
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
        
        let camera = GMSCameraPosition.camera(withLatitude: currentLatitude, longitude: currentLongitude, zoom: 14.0)
        mapView.animate(to: camera)
        
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
        if indexPath.row == 0 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "SMSViewController") as! SMSViewController
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 1 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "ShareDataViewController") as! ShareDataViewController
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 2 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "AnimationViewController") as! AnimationViewController
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 3 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "CustomViewController") as! CustomViewController
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 4 {
            let vc = audioPlayerStoryboard.instantiateViewController(withIdentifier: "AudioListViewController") as! AudioListViewController
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 5 {
            let vc = audioPlayerStoryboard.instantiateViewController(withIdentifier: "VideoListViewController") as! VideoListViewController
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

