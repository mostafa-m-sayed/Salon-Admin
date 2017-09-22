//
//  MyProfileVC.swift
//  Salon-Admin
//
//  Created by Mostafa on 9/22/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit
import GoogleMaps
class MyProfileVC: UIViewController,GetInfoUser,UpdateProfileUser,GMSMapViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtWorkFrom: UITextField!
    @IBOutlet weak var txtWorkTo: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtCountryCode: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var viewMapControl: GMSMapView!
    
    var location : CLLocationCoordinate2D!
    let imagePicker = UIImagePickerController()
    var userData:UserProfile!
    var accountService: AccountService = AccountService()
    var viewActivitySmall : SHActivityView?

    override func viewDidLoad() {
        super.viewDidLoad()
        accountService.GetInfoUserDelegate = self
        showLoader()
        initMap()
        self.view.isUserInteractionEnabled=false
        accountService.GetInfoUser(id: Helper.sharedInstance.UserDetails.id)
    }
    func UpdateProfileUserSuccess(salonData: Dictionary<String,AnyObject>){}
    func UpdateProfileUserFail(ErrorMessage:String){}
    func GetInfoUserSuccess(salonData: Dictionary<String,AnyObject>){
        viewActivitySmall?.dismissAndStopAnimation()
        let userData = UserProfile(salonData: salonData)
        
        txtName.text = userData.name
        txtWorkFrom.text = userData.work_from
        txtWorkTo.text = userData.work_to
        txtEmail.text = userData.email
        txtMobile.text = userData.mobile
        imgProfilePic.downloadedFrom(link:userData.imgURL)
        imgProfilePic.contentMode = .scaleToFill
        location=CLLocationCoordinate2D(latitude: Double(userData.lat)!, longitude: Double(userData.lng)!)
        addMarker(cordinates: location)
        print(salonData)
    }
    func GetInfoUserFail(ErrorMessage:String){
        viewActivitySmall?.dismissAndStopAnimation()
        print(ErrorMessage)
    }
    func loadImage(_ sender:UITapGestureRecognizer){
        let alert =  UIAlertController(title: "Choose Image From", message: "", preferredStyle: .alert)
        
        
        alert.addAction(UIAlertAction(title: "Phone", style: .default, handler: { (action : UIAlertAction) in
            
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true , completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action : UIAlertAction) in
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
            userDetails.addProfilePic(imageData: strBase64)
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
}
