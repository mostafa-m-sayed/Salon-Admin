//
//  ImagesVC.swift
//  
//
//  Created by Mostafa on 9/23/17.
//
//

import UIKit

class ImagesVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
    }

    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 1
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let img:ImageCell = ImageCell()
        return img
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
        
    }
    

}
