//
//  ImagesVC.swift
//  
//
//  Created by Mostafa on 9/23/17.
//
//

import UIKit

class ImagesVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate, UINavigationControllerDelegate, AddImage, DeleteImage,GetInfoUser {

    @IBOutlet weak var viewAdd: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var salonImages:[Image] = [Image]()
    
    let imagePicker = UIImagePickerController()
    
    var accountService: AccountService = AccountService()
    var imageService: ImageService = ImageService()
    var viewActivitySmall : SHActivityView?
    var imageToDelete = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        addGesture()
        imagePicker.delegate=self
        collectionView.delegate = self
        collectionView.dataSource = self
        imageService.AddImageDelegate = self
        imageService.DeleteImageDelegate = self
        accountService.GetInfoUserDelegate=self
        showLoader()
        accountService.GetInfoUser(id: Helper.sharedInstance.UserDetails.id)
        collectionView.reloadData()
    }

    func GetInfoUserSuccess(salonData: Dictionary<String,AnyObject>){
        viewActivitySmall?.dismissAndStopAnimation()
        let userData = UserProfile(salonData: salonData)
        salonImages = userData.images
        collectionView.reloadData()
        print(salonData)
    }
    func GetInfoUserFail(ErrorMessage:String){
        viewActivitySmall?.dismissAndStopAnimation()
        print(ErrorMessage)
        alert(message: ErrorMessage, buttonMessage: NSLocalizedString("OK", comment: ""))
    }

    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return salonImages.count
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let imgCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        imgCell.imgContent.downloadedFrom(link:salonImages[indexPath.row].img)
        imgCell.imgContent.contentMode = .scaleToFill
        return imgCell
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewSize = collectionView.frame.size.width
        return CGSize(width: collectionViewSize*0.47, height: collectionViewSize*0.47);
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alert =  UIAlertController(title:NSLocalizedString("Delete Image?", comment: ""), message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:NSLocalizedString("Yes", comment: ""), style: .default, handler: { (action : UIAlertAction) in
            self.imageToDelete = indexPath.row
            self.showLoader()
            self.imageService.DeleteImage(imageId: self.salonImages[indexPath.row].id)
        }))
        alert.addAction(UIAlertAction(title:NSLocalizedString("No", comment: ""), style: .default,handler: { (action : UIAlertAction) in
        
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func AddImageSuccess(Message: String){
        viewActivitySmall?.dismissAndStopAnimation()
        accountService.GetInfoUser(id: Helper.sharedInstance.UserDetails.id)
        print(Message)
    }
    func AddImageFail(ErrorMessage:String){
        viewActivitySmall?.dismissAndStopAnimation()
        alert(message: ErrorMessage, buttonMessage:NSLocalizedString("OK", comment: ""))
        print(ErrorMessage)
    }
    
    func DeleteImageSuccess(Message: String){
        viewActivitySmall?.dismissAndStopAnimation()
        if imageToDelete != 0{
            salonImages.remove(at: imageToDelete)
        }
        collectionView.reloadData()
        print(Message)
    }
    func DeleteImageFail(ErrorMessage:String){
        viewActivitySmall?.dismissAndStopAnimation()
        alert(message: ErrorMessage, buttonMessage:NSLocalizedString("OK", comment: ""))
        print(ErrorMessage)
    }

    
    func showUploadDialogue(_ sender:UITapGestureRecognizer){
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
            let imageData = UIImagePNGRepresentation(resizedImage)!
            let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            if Helper.sharedInstance.UserDetails==nil{
                if Helper.sharedInstance.UserDetails.id == ""{
                    return
                }
            }
            showLoader()
            imageService.AddImage(salonId: Helper.sharedInstance.UserDetails.id, image: strBase64)
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
    
    func addGesture(){
        let registerClick = UITapGestureRecognizer(target: self, action: #selector (self.showUploadDialogue(_:)))
        viewAdd.addGestureRecognizer(registerClick)
        
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
