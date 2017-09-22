//
//  RegisterLocationVC.swift
//  Salon-Admin
//
//  Created by Mostafa on 9/19/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlacePicker

class RegisterLocationVC: UIViewController, CLLocationManagerDelegate,GMSAutocompleteResultsViewControllerDelegate,GMSMapViewDelegate,CompleteRegisterUser {
    
    @IBOutlet weak var viewMapControl: GMSMapView!
    var userID:String!
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    var locationManager = CLLocationManager()
    var currentLocation : CLLocation!
    var pinLocation:CLLocationCoordinate2D!
    var didFindMyLocation = false
    
    var accountService: AccountService = AccountService()
    var viewActivitySmall : SHActivityView?
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationBar()
        initMap()
        viewMapControl.delegate = self
        accountService.CompleteRegisterUserDelegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        ////////////////// search box
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
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
        //////////////////////////
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationAuthStatus()
    }
    func CompleteRegisterUserSuccess(salonData: Dictionary<String,AnyObject>){
        viewActivitySmall?.dismissAndStopAnimation()
        
        let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "MainPageVC") as? MainPageVC
        self.navigationController?.pushViewController(nextVC!, animated: true)

    }
    func CompleteRegisterUserFail(ErrorMessage:String){
        viewActivitySmall?.dismissAndStopAnimation()
        alert(message: ErrorMessage, buttonMessage: "OK")
        print(ErrorMessage)
    }
    
    
    
 
    
    @IBAction func btnContinue_Click(_ sender: Any) {
        if pinLocation==nil{
            alert(message: "Select Your Location", buttonMessage: "OK")
            return
        }
        if userID==nil||userID==""{
            alert(message: "Failed!", buttonMessage: "OK")
            return
        }
        showLoader()
        accountService.CompleteRegisterUser(id: userID, lat: pinLocation.latitude, lng: pinLocation.longitude)
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            currentLocation = locationManager.location
            let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 17.0)
            self.viewMapControl?.animate(to: camera)
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
    func initNavigationBar(){
        self.navigationItem.title = "Locate Yourself"
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb:0xF5CFF3)
        self.navigationController?.navigationBar.tintColor =  UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    func initMap(){
        let camera = GMSCameraPosition.camera(withLatitude: 30.031957899999998, longitude: 31.408473099999995, zoom: 6.0)
        viewMapControl.camera = camera

    }
    func showLoader(){
        viewActivitySmall = SHActivityView.init()
        viewActivitySmall?.spinnerSize = .kSHSpinnerSizeSmall
        viewActivitySmall?.spinnerColor = UIColor(rgb: 0x522D6A)
        self.view.addSubview(viewActivitySmall!)
        viewActivitySmall?.showAndStartAnimate()
        viewActivitySmall?.center = CGPoint(x: (self.view?.frame.size.width)!/2, y: (self.view?.frame.size.height)!/2)
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
}
