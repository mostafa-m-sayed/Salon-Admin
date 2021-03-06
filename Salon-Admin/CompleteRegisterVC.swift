//
//  CompleteRegisterVC.swift
//  Salon-Admin
//
//  Created by Mostafa on 9/18/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import DatePickerDialog

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
   
    @IBAction func showTimePicker(_ sender: UIButton) {
        DatePickerDialog().show("DatePicker",doneButtonTitle: "Done",cancelButtonTitle: "Cancel",datePickerMode: .time){
            (date) -> Void in
            if let selectedDate = date{
                let time = Helper.sharedInstance.getTimeFromDate(date: selectedDate)
                if sender.tag == 0{
                    self.txtFrom.text = Helper.sharedInstance.convertTimeFormat(time24: time)
                }else{
                    self.txtTo.text = Helper.sharedInstance.convertTimeFormat(time24: time)
                }
            }
        }
    }
       func RegisterUserSuccess(salonId: String){
        viewActivitySmall?.dismissAndStopAnimation()
        alert(message:NSLocalizedString("Waiting confirmation", comment: ""), buttonMessage: NSLocalizedString("OK", comment: ""))
        print(salonId)
        firstTime=false
        userDetails.addUserID(userID: salonId)
    }
    func RegisterUserFail(ErrorMessage:String){
        viewActivitySmall?.dismissAndStopAnimation()
        alert(message: ErrorMessage, buttonMessage: NSLocalizedString("OK", comment: ""))
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
        alert(message: ErrorMessage, buttonMessage: NSLocalizedString("OK", comment: ""))
    }
    
    func loadImage(_ sender:UITapGestureRecognizer){
        let alert =  UIAlertController(title:NSLocalizedString("Choose Image Loc", comment: ""), message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:NSLocalizedString("Phone", comment: ""), style: .default, handler: { (action : UIAlertAction) in
            
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true , completion: nil)
        }))
        alert.addAction(UIAlertAction(title:NSLocalizedString("Camera", comment: ""), style: .default, handler: { (action : UIAlertAction) in
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
            alert(message:NSLocalizedString("Null Working Hours", comment: ""), buttonMessage: NSLocalizedString("OK", comment: ""))
            return
        }
        if txtTo.text == ""{
            alert(message: NSLocalizedString("Null Working Hours",comment:""), buttonMessage: NSLocalizedString("OK", comment: ""))
            return
        }
        if uploadedImage==nil{
            alert(message: NSLocalizedString("Null Image", comment: ""), buttonMessage: NSLocalizedString("OK", comment: ""))
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
        self.navigationItem.title = NSLocalizedString("Complete Register", comment: "")
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
    
    func initTextFields(){
        let floatingTextColor = UIColor.gray
        
        txtFrom.placeholder = NSLocalizedString("From", comment: "")
        txtFrom.selectedTitleColor = floatingTextColor
        //txtFrom.title = "Enter Date From"  Uncomment to change title
        
        txtTo.placeholder = NSLocalizedString("To", comment: "")
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
