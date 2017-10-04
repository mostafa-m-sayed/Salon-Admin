//
//  CodeDropDown.swift
//  CountryPhoneCodePicker
//
//  Created by Ragaie alfy on 9/24/17.
//  Copyright © 2017 Ragaie alfy. All rights reserved.
//

import UIKit
import Alamofire


extension UIResponder {
    func owningViewController() -> UIViewController? {
        var nextResponser = self
        while let next = nextResponser.next {
            nextResponser = next
            if let vc = nextResponser as? UIViewController {
                return vc
            }
        }
        return nil
    }
}
func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
    URLSession.shared.dataTask(with: url) { data, response, error in
        completion(data, response, error)
        }.resume()
}


protocol CodeDropDownDelegate {
    
    func codeDropDown(_ codeDropDown: CodeDropDown, didSelectItem country: Country)
}

@objc
@IBDesignable class CodeDropDown: UIView ,UITableViewDelegate,UITableViewDataSource,GetCountries{
    
    @IBOutlet weak var flageButton: UIButton!
    
    @IBOutlet weak var actionButton: UIButton!
    
    
    @IBOutlet weak var codeLabel: UILabel!
    
    public var delegate : CodeDropDownDelegate!
    
    private  var tableData : UITableView!
    private  var filterTable : UITableView!
    private  var showDrop : Bool! = false
    private var containerView : UIView!
    private var countries: [Country] = []
    var countryService = CountryService()
    var allCountries : [Country]! = []
    //    private var searchChar : [String] = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    private  var tapGesture :UITapGestureRecognizer! // =
    
    public var resIdentifier : String!
    
    
    @IBInspectable public  var restIdentifier: String? {
        didSet {
            resIdentifier = restIdentifier
        }
    }
    
    func GetCountriesSuccess(countries: [Dictionary<String,AnyObject>]){
        var serializedCountries = [Country]()
        for country in countries {
            serializedCountries.append(Country(country: country ))
        }
        allCountries = serializedCountries
        self.countries = allCountries
        getDataFromUrl(url: URL(string: self.countries[0].img)!) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                self.flageButton.setImage( UIImage(data: data),for:.normal)
            }
        }
        codeLabel.text = self.countries[0].dial_code
        
        self.delegate.codeDropDown(self, didSelectItem: self.countries[0])
    }
    func GetCountriesFail(ErrorMessage:String){
        print(ErrorMessage)
    }
    
    @IBInspectable public  var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            clipsToBounds = true
            
        }
    }
    
    
    @IBInspectable public var borderWidth: CGFloat = 1.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var borderColor: UIColor = UIColor.blue {
        didSet {
            
            layer.borderColor = borderColor.cgColor
        }
    }
    
    
    //MARK: Initializers
    override public init(frame : CGRect) {
        super.init(frame : frame)
        initSubviews()
    }
    
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
        initActionAndDelegete()
        
    }
    
    public func initSubviews() {
        
        let bundle = Bundle(for: type(of: self))
        
        
        let nib = UINib(nibName: "CodeDropDown", bundle: bundle)
        
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        // to make view fit view in design you welcome.
        view.frame = self.bounds
        
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        // nib.contentView.frame = bounds
        codeLabel.adjustsFontSizeToFitWidth = true
        addSubview(view)
        
        codeLabel.adjustsFontSizeToFitWidth = true
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(CodeDropDown.tapBlurButton(_:)))
        
        // custom initialization logic
        
    }
    
    // add action of dropDown
    func initActionAndDelegete()  {
        
        countryService.GetCountriesDelegate = self
        actionButton.addTarget(self, action: #selector(CodeDropDown.showCountryCodes(_:)), for: .touchUpInside)
        countryService.GetCountries()
        //load all countries from json file
        //allCountries =   self.getAllCountries()
        
        //countries =  allCountries
    }
    
    
    
    func showCountryCodes(_ sender : UIButton){
        
        if showDrop == true {
            
            containerView.removeFromSuperview()
            showDrop = false
        }
        else{
            if containerView == nil {
                
                var minX:CGFloat!
                var minY:CGFloat!
                var width:CGFloat!
                
                let mainView = self.owningViewController()?.view.viewWithTag(-5)
                minX = mainView?.frame.minX
                minY = mainView?.frame.minY
                let subView = mainView?.viewWithTag(-4)
                minX = minX + (subView?.frame.minX)!//phone container
                minY = minY + (subView?.frame.minY)!//phone container
                width = subView?.frame.width
                containerView  = UIView(frame: CGRect.init(x: minX - 10 , y: minY - 5, width: width + 30  , height: UIScreen.main.bounds.height / 2))
                
                
                tableData  = UITableView.init(frame: CGRect.init(x: 0   , y: 0 , width: width - 0  , height: UIScreen.main.bounds.height / 2))
                tableData.register(UINib(nibName: "CodeTableCell", bundle: nil), forCellReuseIdentifier: "cellID")
                
                
                tableData.layer.zPosition = 1
                tableData.layer.cornerRadius = 3
                tableData.separatorStyle = .none
                tableData.dataSource = self
                tableData.delegate = self
                
                tableData.showsVerticalScrollIndicator = false
                
                tableData.layer.borderColor = UIColor.white.cgColor
                tableData.layer.borderWidth = 0.5
                
                
                //////// create shadow for tableView
                let rectTemp = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height)
                
                containerView.layer.shadowColor = UIColor.darkGray.cgColor
                containerView.layer.shadowOpacity = 0.5
                containerView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0) //CGSize.zero
                containerView.layer.shadowRadius = 9
                
                containerView.layer.shadowPath = UIBezierPath(rect: rectTemp).cgPath
                containerView.layer.shouldRasterize = false
                
                containerView.clipsToBounds = false
                
                
                
            }
            
            // tableData.backgroundView?.addSubview(filterTable)
            containerView.addSubview(tableData)
            //containerView.addSubview(filterTable)
            if let vw = self.owningViewController()?.view.subviews[0] as? UIScrollView{
                vw.addSubview(containerView)
            }else{
                self.owningViewController()?.view.addSubview(containerView)
            }
            showDrop = true
        }
        
    }
    
    
    
    
    //// table view data source
    
    
    
    
    public func  tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        if tableView.tag == 0 {
            //flageButton.setImage(UIImage.init(named: countries[indexPath.row].code), for: .normal)
            getDataFromUrl(url: URL(string: countries[indexPath.row].img)!) { data, response, error in
                guard let data = data, error == nil else { return }
                print(response?.suggestedFilename ?? URL(string: self.countries[indexPath.row].img)!.lastPathComponent)
                print("Download Finished")
                DispatchQueue.main.async() {
                    self.flageButton.setImage( UIImage(data: data),for:.normal)
                }
            }
            codeLabel.text = countries[indexPath.row].dial_code
            
            if delegate != nil {
                
                self.delegate.codeDropDown(self, didSelectItem: countries[indexPath.row])
                
            }
            
            
            containerView.removeFromSuperview()
            showDrop = false
        }
        //        else{
        //
        //            filterContentForSearchText(searchText: searchChar[indexPath.row])
        //
        //        }
        
    }
    func setSelectedItem(country:Country) {
        codeLabel.text = country.dial_code
        getDataFromUrl(url: URL(string: country.img)!) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                self.flageButton.setImage( UIImage(data: data),for:.normal)
            }
        }
        self.delegate.codeDropDown(self, didSelectItem: country)
    }
    
    
    
    public func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if tableView.tag == 0 {
            
            return countries.count
            
        }
        return 0
        //        else{
        //
        //            return searchChar.count
        //        }
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableView.tag == 0 {
            
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! CodeTableCell
            
            cell.codeLabel.text = countries[indexPath.row].dial_code
            //downloadedFrom(link:salonImages[indexPath.row].img)
            //= UIImage.init(named: countries[indexPath.row].code)
            //cell.flageImage.image.downloadedFrom(link:countries[indexPath.row].img)
            getDataFromUrl(url: URL(string: countries[indexPath.row].img)!) { data, response, error in
                guard let data = data, error == nil else { return }
                print(response?.suggestedFilename ?? URL(string: self.countries[indexPath.row].img)!.lastPathComponent)
                print("Download Finished")
                DispatchQueue.main.async() {
                    cell.flageImage.image = UIImage(data: data)
                }
            }
            cell.codeLabel.adjustsFontSizeToFitWidth = true
            return cell
            
            
        }
        else{
            
            let cell : UITableViewCell! = UITableViewCell.init(frame: CGRect.init(x: 0, y: 0, width: 10, height: 15 ))
            
            // cell.textLabel?.text = searchChar[indexPath.row]
            
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 12)
            
            return cell
            
            
        }
    }
    
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        
        if tableView.tag == 0 {
            return 35
        }
        else{
            return 18
            
        }
        
        
    }
    
    
    func tapBlurButton(_ sender: UITapGestureRecognizer) {
        print("Please Help!")
        
        
        
        if showDrop == true {
            
            
            containerView.removeFromSuperview()
            showDrop = false
            
        }
    }
    
    func GetCountryById(id:String) -> Country{
        if allCountries != nil {
            for cntry in allCountries {
                if cntry.id == id{
                    return cntry
                }
            }
        }
        return Country()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    private func getAllCountries()-> [Country]  {
        var countries: [Country] = []
        
        do {
            if let file = Bundle.main.url(forResource: "countryCodes", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let array = json as? Array<[String: String]> {
                    for object in array {
                        guard let code = object["code"],
                            let phoneExtension = object["dial_code"],
                            let formatPattern = object["format"],
                            let name = object["name"] else {
                                fatalError("Must be valid json.")
                        }
                        
                        countries.append(Country(countryCode: code,
                                                 phoneExtension: phoneExtension,
                                                 formatPattern: formatPattern,name : name))
                    }
                }
            } else {
                print("countryCodePicker can't find a bundle for the countries")
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return countries
    }
    
    
    
    //    func filterContentForSearchText(searchText: String) {
    //        countries = []
    //
    //        let   filterdTerms = allCountries.filter { term in
    //
    //            return   term.name.lowercased().characters.first   == searchText.lowercased().characters.first
    //
    //        }
    //
    //
    //        //        for item in allCountries {
    //        //
    //        //
    //        //            if String.init( (item.name.lowercased())[0] )  == searchText.lowercased(){
    //        //
    //        //
    //        //
    //        //            }
    //        //        }
    //        //
    //        countries = filterdTerms
    //        tableData.reloadData()
    //
    //
    //    }
    
    
    
    
    
}





