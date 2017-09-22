//
//  CompleteRegisterVC.swift
//  Salon-Admin
//
//  Created by Mostafa on 9/18/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class CompleteRegisterVC: UIViewController,UIImagePickerControllerDelegate  , UINavigationControllerDelegate ,RegisterUser,LoginUser {
    
    @IBOutlet weak var txtFrom: SkyFloatingLabelTextField!
    @IBOutlet weak var txtTo: SkyFloatingLabelTextField!
    
    @IBOutlet weak var imageContainer: UIImageView!
    @IBOutlet weak var imageProfilePic: UIImageView!
    var firstTime=true
    var userDetails : UserProfile!
    var accountService: AccountService = AccountService()
    var viewActivitySmall : SHActivityView?
    let imagePicker = UIImagePickerController()
    var uploadedImage:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTextFields()
        initNavigationBar()
        imageContainer.isUserInteractionEnabled = true;
        addGesture()
        accountService.RegisterUserDelegate = self
        accountService.LoginUserDelegate = self
        imagePicker.delegate = self
        
    }
    func RegisterUserSuccess(salonId: String){
        viewActivitySmall?.dismissAndStopAnimation()
        alert(message: "Waiting for confirmation", buttonMessage: "OK")
        print(salonId)
        firstTime=false
        userDetails.addUserID(userID: salonId)
    }
    func RegisterUserFail(ErrorMessage:String){
        viewActivitySmall?.dismissAndStopAnimation()
        alert(message: ErrorMessage, buttonMessage: "OK")
        print(ErrorMessage)
    }
    func LoginUserSuccess(salonData: Dictionary<String,AnyObject>){
        viewActivitySmall?.dismissAndStopAnimation()
        print(salonData)
        let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "RegisterLocationVC") as? RegisterLocationVC
        nextVC?.userID = userDetails.id
        self.navigationController?.pushViewController(nextVC!, animated: true)
    }
    func LoginUserFail(ErrorMessage:String){
        viewActivitySmall?.dismissAndStopAnimation()
        print(ErrorMessage)
        alert(message: ErrorMessage, buttonMessage: "OK")
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
            imageContainer.contentMode = .scaleAspectFill
            
            imageContainer.image = resizedImage
            imageProfilePic.isHidden=true
            let imageData = UIImagePNGRepresentation(resizedImage)!
            let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            uploadedImage = strBase64
            userDetails.addProfilePic(imageData: uploadedImage)
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
    
    @IBAction func btnContinue_Click(_ sender: Any) {
        if txtFrom.text == ""{
            alert(message: "Working Hours is empty", buttonMessage: "OK")
            return
        }
        if txtTo.text == ""{
            alert(message: "Working Hours is empty", buttonMessage: "OK")
            return
        }
        if uploadedImage==nil{
            alert(message: "Select an image", buttonMessage: "OK")
            return
        }
        if firstTime{
        userDetails.addWorkingHours(from: txtFrom.text!, to: txtTo.text!)
        showLoader()
        accountService.RegisterUser(name: userDetails.name, email: userDetails.email, password: userDetails.password, mobile: userDetails.mobile, countryId: 2, workFrom: userDetails.work_from, workTo: userDetails.work_to, image: userDetails.img)
        }else{
            showLoader()
            accountService.LoginUser(email: userDetails.email, password: userDetails.password)
        }
    }
    
    @IBAction func btnBack_Click(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func initNavigationBar(){
        self.navigationItem.title = "Complete Register"
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb:0xF5CFF3)
        self.navigationController?.navigationBar.tintColor =  UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    
    func initTextFields(){
        let floatingTextColor = UIColor.gray
        
        txtFrom.placeholder = "From"
        txtFrom.selectedTitleColor = floatingTextColor
        //txtFrom.title = "Enter Date From"  Uncomment to change title
        
        txtTo.placeholder = "To"
        txtTo.selectedTitleColor = floatingTextColor
        //txtTo.title = "Enter Date To"  Uncomment to change title
    }
    
    func addGesture(){
        let registerClick = UITapGestureRecognizer(target: self, action: #selector (self.loadImage(_:)))
        imageContainer.addGestureRecognizer(registerClick)
    }
    
    func showLoader(){
        viewActivitySmall = SHActivityView.init()
        viewActivitySmall?.spinnerSize = .kSHSpinnerSizeSmall
        viewActivitySmall?.spinnerColor = UIColor(rgb: 0x522D6A)
        self.view.addSubview(viewActivitySmall!)
        viewActivitySmall?.showAndStartAnimate()
        viewActivitySmall?.center = CGPoint(x: (self.view?.frame.size.width)!/2, y: (self.view?.frame.size.height)!/2)
    }
    
}
