//
//  UpdateLocationVC.swift
//  Salon-Admin
//
//  Created by Mostafa on 10/4/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlacePicker

class UpdateLocationVC: UIViewController,CLLocationManagerDelegate,GMSAutocompleteResultsViewControllerDelegate,GMSMapViewDelegate {

    @IBOutlet weak var viewMapControl: GMSMapView!
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    var locationManager = CLLocationManager()
    var currentLocation : CLLocation!
    var pinLocation:CLLocationCoordinate2D!

    weak var parentVC:MyProfileVC?
    override func viewDidLoad() {
        super.viewDidLoad()

        initNavigationBar()
        initMap()
        viewMapControl.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        ////////////////// search box
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        searchController?.title = NSLocalizedString("Search", comment: "")
        searchController?.searchBar.text = NSLocalizedString("Search", comment: "")
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        let screenWidth = UIScreen.main.bounds.width
        
        let subView = UIView(frame: CGRect(x: 10, y: 80, width: screenWidth-20, height: 45.0))
        
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationAuthStatus()
    }
    @IBAction func btnContinue_Click(_ sender: Any) {
        if pinLocation==nil{
            alert(message:NSLocalizedString("Select Location", comment: ""), buttonMessage: NSLocalizedString("OK", comment: ""))
            return
        }
        parentVC?.updateLocation(cordinates: pinLocation)
        _ = navigationController?.popViewController(animated: true)
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            currentLocation = locationManager.location
            let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 17.0)
            self.viewMapControl?.animate(to: camera)
            //addMarker(cordinates: currentLocation.coordinate)
            print("Loc::")
            print(currentLocation.coordinate.latitude,currentLocation.coordinate.longitude)
        }
        else{
            locationManager.requestWhenInUseAuthorization()
            locationAuthStatus()
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
        clearMarkers()
        addMarker(cordinates: coordinate)
    }
    
    
    
    
    
    //MARK: Search Functions
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress ?? "err")")
        print("Cordinates: \(place.coordinate)")
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 15)
        viewMapControl.camera = camera
        
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    //MARK: Helpers
    
    func initMap(){
        let camera = GMSCameraPosition.camera(withLatitude: 30.031957899999998, longitude: 31.408473099999995, zoom: 6.0)
        viewMapControl.camera = camera
        
    }
        @IBAction func btnGetLocation_Click(_ sender: Any) {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            currentLocation = locationManager.location
            let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 17.0)
            self.viewMapControl?.animate(to: camera)
            // addMarker(cordinates: currentLocation.coordinate)
            print("Loc::")
            print(currentLocation.coordinate.latitude,currentLocation.coordinate.longitude)
        }
        else{
            locationManager.requestWhenInUseAuthorization()
            locationAuthStatus()
        }
    }
    func addMarker(cordinates:CLLocationCoordinate2D)  {
        let marker = GMSMarker()
        marker.position = cordinates
        marker.title = "Position"
        marker.snippet = "My Position"
        marker.map = viewMapControl
        pinLocation = cordinates
    }
    func clearMarkers() {
        viewMapControl.clear()
    }
    func initNavigationBar(){
        
        self.navigationItem.title = NSLocalizedString("Locate Yourself", comment: "")
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb:0xf5c1f0)
        self.navigationController?.navigationBar.tintColor =  UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        if Helper.sharedInstance.getAppLanguage() == "ar"{
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            if navigationItem.leftBarButtonItem != nil{
                navigationItem.rightBarButtonItem = navigationItem.leftBarButtonItem
                navigationItem.leftBarButtonItem = nil
                navigationItem.setHidesBackButton(true, animated: false)
            }
        }
    }
}
