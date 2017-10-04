//
//  ServicesVC.swift
//  Salon-Admin
//
//  Created by Mostafa on 9/23/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit

class ServicesVC: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, GetSalonSubCategories {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let serviceService = ServiceService()
    
    @IBOutlet weak var viewAdd: UIView!
    var subcategories:[Subcategory] = [Subcategory]()
    var viewActivitySmall : SHActivityView?
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        serviceService.GetSalonSubCategoriesDelegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        addGesture()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
        showLoader()
        serviceService.GetSalonSubCategories(salonId: Helper.sharedInstance.UserDetails.id)
    }
    func GetSalonSubCategoriesSuccess(salonSubCategories: [Dictionary<String,AnyObject>]){
        viewActivitySmall?.dismissAndStopAnimation()
        subcategories = [Subcategory]()
        for subcat in salonSubCategories {
            let serializedSubcat = Subcategory(subcategory: subcat)
            subcategories.append(serializedSubcat)
        }
        collectionView.reloadData()
    }
    
    func GetSalonSubCategoriesFail(ErrorMessage:String){
        viewActivitySmall?.dismissAndStopAnimation()
        print(ErrorMessage)
        alert(message: ErrorMessage, buttonMessage: NSLocalizedString("OK", comment: ""))
    }
    
    func viewAddSubcategoryPage(_ sender:UITapGestureRecognizer){
        let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "AddSubcategoryVC") as? AddSubcategoryVC
        nextVC?.existingSubCategories = subcategories
        self.navigationController?.pushViewController(nextVC!, animated: true)

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subcategories.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "ServiceListVC") as? ServiceListVC
        nextVC?.subcategoryId = subcategories[indexPath.row].subcategoryId
        nextVC?.subcategoryName = subcategories[indexPath.row].subcategoryName
        self.navigationController?.pushViewController(nextVC!, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let subcategoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubcategoryCell", for: indexPath) as! SubcategoryCell
        subcategoryCell.lblCategoryName.text = subcategories[indexPath.row].categoryName
        subcategoryCell.lblSubcatName.text = subcategories[indexPath.row].subcategoryName
        subcategoryCell.lblServicesCount.text = subcategories[indexPath.row].serviceNumber
        subcategoryCell.btnMore.tag = indexPath.row
        subcategoryCell.btnMore.addTarget(self, action: #selector(ServicesVC.showSubcategoryOptions), for: .touchUpInside)
        return subcategoryCell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewSize = collectionView.frame.size.width
                return CGSize(width: collectionViewSize*0.47, height: collectionViewSize*0.47);
    }
    func showSubcategoryOptions(_ sender: subclassedUIButton){
        let alert =  UIAlertController(title:subcategories[sender.tag].subcategoryName
            , message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title:NSLocalizedString("Edit", comment: ""), style: .default, handler: { (action : UIAlertAction) in
            
            let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "ServiceListVC") as? ServiceListVC
            nextVC?.subcategoryId = self.subcategories[sender.tag].subcategoryId
            nextVC?.subcategoryName = self.subcategories[sender.tag].subcategoryName

            self.navigationController?.pushViewController(nextVC!, animated: true)
        }))
        alert.addAction(UIAlertAction(title:NSLocalizedString("Delete", comment: ""), style: .default, handler: { (action : UIAlertAction) in
            self.showLoader()
            self.serviceService.DeleteSubcategory(id: self.subcategories[sender.tag].id)
        }))
        alert.addAction(UIAlertAction(title:NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { (action : UIAlertAction) in
        }))
        self.present(alert, animated: true, completion: nil)
        
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
        let registerClick = UITapGestureRecognizer(target: self, action: #selector (self.viewAddSubcategoryPage(_:)))
        viewAdd.addGestureRecognizer(registerClick)
    }
}
