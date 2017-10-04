//
//  MyProfileVC.swift
//  Salon-Admin
//
//  Created by Mostafa on 9/22/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit
import GoogleMaps
import Cosmos
import DatePickerDialog

class MyProfileVC: UIViewController,GetInfoUser,UpdateProfileUser,GMSMapViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CodeDropDownDelegate {
    
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtWorkFrom: UITextField!
    @IBOutlet weak var txtWorkTo: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var viewMapControl: GMSMapView!
    @IBOutlet weak var viewRating: CosmosView!
    @IBOutlet weak var btnBarEdit: UIBarButtonItem!
    @IBOutlet weak var txtSeparator: UITextField!
    @IBOutlet weak var btnWorkingFrom: UIButton!
    @IBOutlet weak var btnWorkingTo: UIButton!
    @IBOutlet weak var viewCode: CodeDropDown!
    
    var selectCountry : Country!
    var location : CLLocationCoordinate2D!
    let imagePicker = UIImagePickerController()
    var userData:UserProfile!
    var accountService: AccountService = AccountService()
    var viewActivitySmall : SHActivityView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewCode.delegate = self
        enableDisableFields(status: "disable")
        accountService.GetInfoUserDelegate = self
        accountService.UpdateProfileUserDelegate = self
        showLoader()
        initMap()
        addGesture()
        imagePicker.delegate = self
        viewMapControl.delegate = self
        //locationManager.delegate = self
        accountService.GetInfoUser(id: Helper.sharedInstance.UserDetails.id)
        
    }
    @IBAction func showTimePicker(_ sender: UIButton) {
        DatePickerDialog().show("DatePicker",doneButtonTitle: "Done",cancelButtonTitle: "Cancel",datePickerMode: .time){
            (date) -> Void in
            if let selectedDate = date{
                let time = Helper.sharedInstance.getTimeFromDate(date: selectedDate)
                if sender.tag == 0{
                    self.txtWorkFrom.text = Helper.sharedInstance.convertTimeFormat(time24: time)
                }else{
                    self.txtWorkTo.text = Helper.sharedInstance.convertTimeFormat(time24: time)
                }
            }
        }
    }
    @IBAction func btnLogout_Click(_ sender: Any) {
        
        Helper.sharedInstance.clearUserData()
        let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC
        self.navigationController?.pushViewController(nextVC!, animated: true)
        
    }
    @IBAction func btnEdit_Click(_ sender: Any) {
        if btnBarEdit.title == NSLocalizedString("Edit", comment: ""){
            btnBarEdit.title = NSLocalizedString("Save", comment: "")
            enableDisableFields(status: "enable")
        }else{
            btnBarEdit.title = NSLocalizedString("Edit", comment: "")
            enableDisableFields(status: "disable")
            showLoader()
            
            accountService.UpdateProfileUser(id: userData.id, name: txtName.text!, email: txtEmail.text!, password: userData.password, mobile: txtMobile.text!, countryId: selectCountry.id, workFrom: txtWorkFrom.text!, workTo: txtWorkTo.text!, image: userData.img, lat: "\(location.latitude)", lng: "\(location.longitude)")
        }
    }

    func codeDropDown(_ codeDropDown: CodeDropDown, didSelectItem country: Country) {
        selectCountry = country
    }
    func updateLocation(cordinates:CLLocationCoordinate2D) {
        location = cordinates
        viewMapControl.clear()
        addMarker(cordinates: location)
        let camera = GMSCameraPosition.camera(withLatitude: cordinates.latitude, longitude: cordinates.longitude, zoom: 6.0)
        viewMapControl.camera = camera

        
    }
    func UpdateProfileUserSuccess(salonData: Dictionary<String,AnyObject>){
        viewActivitySmall?.dismissAndStopAnimation()
        print(salonData)
    }
    func UpdateProfileUserFail(ErrorMessage:String){
        viewActivitySmall?.dismissAndStopAnimation()
        print(ErrorMessage)
        alert(message: ErrorMessage, buttonMessage: NSLocalizedString("OK", comment: ""))
    }
    func GetInfoUserSuccess(salonData: Dictionary<String,AnyObject>){
        viewActivitySmall?.dismissAndStopAnimation()
        userData = UserProfile(salonData: salonData)
        
        txtName.text = userData.name
        txtWorkFrom.text = userData.work_from
        txtWorkTo.text = userData.work_to
        txtEmail.text = userData.email
        txtMobile.text = userData.mobile
        viewRating.rating = Double(userData.rate)!
        let country = viewCode.GetCountryById(id: userData.countryId)
        selectCountry = country
        viewCode.setSelectedItem(country: selectCountry)
        imgProfilePic.downloadedFrom(link:userData.imgURL)
        imgProfilePic.contentMode = .scaleToFill
        location=CLLocationCoordinate2D(latitude: Double(userData.lat)!, longitude: Double(userData.lng)!)
        addMarker(cordinates: location)
        let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 6.0)
        viewMapControl.camera = camera
        getAddressFromLatLon(lat:userData.lat,lon:userData.lng)
        
        print(salonData)
    }
    func GetInfoUserFail(ErrorMessage:String){
        viewActivitySmall?.dismissAndStopAnimation()
        alert(message: ErrorMessage, buttonMessage: NSLocalizedString("OK", comment: ""))
        print(ErrorMessage)
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "UpdateLocationVC") as? UpdateLocationVC
        nextVC?.parentVC = self
        self.navigationController?.pushViewController(nextVC!, animated: true)

    }
    func loadImage(_ sender:UITapGestureRecognizer){
        let alert =  UIAlertController(title: NSLocalizedString("Choose Image Loc", comment: ""), message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Phone", comment: ""), style: .default, handler: { (action : UIAlertAction) in
            
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true , completion: nil)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: .default, handler: { (action : UIAlertAction) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true , completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let resizedImage = resizeImage(image: pickedImage, newWidth: 200)
            imgProfilePic.contentMode = .scaleAspectFill
            
            imgProfilePic.image = resizedImage
            let imageData = UIImagePNGRepresentation(resizedImage)!
            let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            userData.addProfilePic(imageData: strBase64)
            //print(strBase64)
        }
        
        dismiss(animated: true, completion: nil)
    }
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        let newSize:CGSize = CGSize(width: newWidth, height: newHeight)
        UIGraphicsBeginImageContext(newSize)
        let newRect:CGRect = CGRect(x: 0, y: 0, width: newWidth, height: newHeight)
        image.draw(in: newRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    func initMap(){
        let camera = GMSCameraPosition.camera(withLatitude: 30.031957899999998, longitude: 31.408473099999995, zoom: 6.0)
        viewMapControl.camera = camera
    }
    func addMarker(cordinates:CLLocationCoordinate2D)  {
        let marker = GMSMarker()
        marker.position = cordinates
        marker.title = "Position"
        marker.snippet = "My Position"
        marker.map = viewMapControl
    }
    func enableDisableFields(status:String) {
        if(status=="enable"){
            txtName.isEnabled=true
            txtWorkFrom.isEnabled=true
            txtWorkTo.isEnabled=true
            txtEmail.isEnabled=true
            viewCode.isUserInteractionEnabled=true
            txtMobile.isEnabled=true
            imgProfilePic.isUserInteractionEnabled=true
            btnWorkingFrom.isEnabled = true
            btnWorkingTo.isEnabled = true
            txtName.borderStyle = .roundedRect
            txtWorkFrom.borderStyle = .roundedRect
            txtWorkTo.borderStyle = .roundedRect
            txtEmail.borderStyle = .roundedRect
            txtMobile.borderStyle = .roundedRect
            viewMapControl.isUserInteractionEnabled = true
        }
        else{
            txtName.isEnabled=false
            txtWorkFrom.isEnabled=false
            txtWorkTo.isEnabled=false
            txtEmail.isEnabled=false
            viewCode.isUserInteractionEnabled=false
            txtMobile.isEnabled=false
            imgProfilePic.isUserInteractionEnabled=false
            btnWorkingFrom.isEnabled = false
            btnWorkingTo.isEnabled = false
            
            txtName.borderStyle = .none
            txtWorkFrom.borderStyle = .none
            txtWorkTo.borderStyle = .none
            txtEmail.borderStyle = .none
            txtMobile.borderStyle = .none
            txtSeparator.borderStyle = .none
            viewMapControl.isUserInteractionEnabled = false
        }
    }
    func showLoader(){
        viewActivitySmall = SHActivityView.init()
        viewActivitySmall?.spinnerSize = .kSHSpinnerSizeSmall
        viewActivitySmall?.spinnerColor = UIColor(rgb: 0x522D6A)
        self.view.addSubview(viewActivitySmall!)
        viewActivitySmall?.showAndStartAnimate()
        viewActivitySmall?.center = CGPoint(x: (self.view?.frame.size.width)!/2, y: (self.view?.frame.size.height)!/2)
    }
    func addGesture(){
        let registerClick = UITapGestureRecognizer(target: self, action: #selector (self.loadImage(_:)))
        imgProfilePic.addGestureRecognizer(registerClick)
    }
    func getAddressFromLatLon(lat:String,lon:String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let ceo: CLGeocoder = CLGeocoder()
        if let latitude = Double(lat), let longitude = Double(lon){
            center.latitude = latitude
            center.longitude = longitude
        }else{
            return
        }
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        var addressString : String = ""
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    
                    //if pm.subLocality != nil {
                      //  addressString = addressString + pm.subLocality! + ", "
                   // }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    print(addressString)
                    self.lblAddress.text = addressString
                }
        })
    }
    func initNavigationBar(){
        self.navigationItem.title = NSLocalizedString("My Profile", comment: "")
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb:0xf5c1f0)
        self.navigationController?.navigationBar.tintColor =  UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
}
