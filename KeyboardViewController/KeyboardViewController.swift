//
//  KeyboardViewController.swift
//  KeyboardViewController
//
//  Created by CSPC143 on 15/05/17.
//  Copyright © 2017 CSPC143. All rights reserved.
//

import UIKit
import MobileCoreServices

class KeyboardViewController: UIInputViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var heightConstraint:NSLayoutConstraint?
    var gifImagesDic = [String:UIImage]()
    var isFirstTime: Bool = true
    
    @IBOutlet var nextKeyboardButton: UIButton!
    var customInterface :UIView!
    var capsOn = false
    @IBOutlet var bottomCollectionView: UICollectionView!
    @IBOutlet var emojiCollectionView : UICollectionView!
    @IBOutlet weak var changebutton: UIButton!
    @IBOutlet weak var msglabel: UILabel!
    
    var timer = Timer()
    var bottomBarArray = Array<String>()
    var selectedEmojiArray = Array<String>()
    var allEmojiArray = Array<AnyObject>()
    var myDict: NSDictionary?
    var favoriteArray = Array<String>()
    
    var favSortedArray = Array<String>()
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
       
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2436:
                _ = self.view.heightAnchor.constraint(equalToConstant: 220).isActive = true
                break
            default: break
               // print("unknown")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isFirstTime {
            self.loadData()
            isFirstTime = false
        }
    }
    
    func loadData() {
        
       self.loadAnimatedImages()
        
       self.bottomBarArray = ["bottom_icon01_hover","bottom_icon02","bottom_icon03","bottom_icon04","bottom_icon05","bottom_icon06","bottom_icon07","bottom_icon08_hover"]
        
        let nib = UINib(nibName: "KeyboardView", bundle: nil)
        let objects = nib.instantiate(withOwner: self, options: nil)
        self.view = objects[0] as! UIView
        print(self.view.frame)
        self.inputView?.addSubview(self.view)
        
        self.getEmojifromplist()
        
        if self.isOpenAccessGranted() {
            self.selectedEmojiArray = self.myDict?["Panda"] as! Array<String>
        }
        else {
            
            if self.isKeyPresentInUserDefaults(key: "FavArray") {
                print(UserDefaults.standard.value(forKey: "FavArray") as! Array<String>)
                self.selectedEmojiArray = UserDefaults.standard.value(forKey: "FavArray") as! Array<String>
            }
            
        }
        
        self.selectedEmojiArray = self.myDict?["Panda"] as! Array<String>
        self.bottomCollectionView.delegate = self
        self.bottomCollectionView.dataSource = self
        self.emojiCollectionView.delegate = self
        self.emojiCollectionView.dataSource = self
        self.bottomCollectionView.register(UINib(nibName:"BottomCollectionViewCell", bundle :nil), forCellWithReuseIdentifier:"BottomCollectionViewCell")
        self.emojiCollectionView.register(UINib(nibName:"EmojiCollectionViewCell", bundle :nil), forCellWithReuseIdentifier: "EmojiCollectionViewCell")
        
        self.msglabel.isHidden = true
        self.msglabel.text = "Now, hold on the input and tap paste!"
        //        timer.invalidate()
        //        timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(timerAction), userInfo: nil, repeats: false)
        self.emojiCollectionView.reloadData()
    }
    
    func loadAnimatedImages() {
        self.loadGifImage(withName:"CatHeart.gif")
        self.loadGifImage(withName:"Dragonfly.gif")
        self.loadGifImage(withName:"Elephant.gif")
        self.loadGifImage(withName:"Gautama2.gif")
        self.loadGifImage(withName:"HamsaHand2.gif")
        self.loadGifImage(withName:"LotusFrog.gif")
        self.loadGifImage(withName:"MonkeyBuddha.gif")
        self.loadGifImage(withName:"PeacePup2.gif")
        self.loadGifImage(withName:"TreeofLife.gif")
        // self.loadGifImage(withName:"yingyang.gif")
    }
    
    func loadGifImage(withName:String) -> Void {
        DispatchQueue.global(qos: .default).async(execute: {() -> Void in
            let imgName = withName.replacingOccurrences(of: ".gif", with: "") as NSString
            let imageURL = Bundle.main.path(forResource: imgName as String, ofType: "gif")
            
            print(imageURL ?? ("null" + withName))
            
           // let data = NSData(contentsOf: NSURL(fileURLWithPath:imageURL!) as URL)
            //let FLAimage:FLAnimatedImage = FLAnimatedImage(animatedGIFData: data as? Data)
            let gif = UIImage(gifName: imgName as String, levelOfIntegrity:0.2)
            DispatchQueue.main.async(execute: {() -> Void in
                self.gifImagesDic[withName] = gif//FLAimage
            })
        })
    }
    
    // get emoji from plist
    func getEmojifromplist()  {
      
        if let path = Bundle.main.path(forResource: "EmojiPropertyList", ofType: "plist"){
            myDict = NSDictionary(contentsOfFile:path)
        }
        
    }
    
    // hide message label
    func timerAction()  {
        msglabel.isHidden = true
    }
    
    //check keyboard have full access
    func isOpenAccessGranted() -> Bool {
        
        if #available(iOSApplicationExtension 10.0, *) {
            UIPasteboard.general.string = "TEST"
            
            if UIPasteboard.general.hasStrings {
                // Enable string-related control...
                UIPasteboard.general.string = ""
                return  true
            }
            else
            {
                UIPasteboard.general.string = ""
                return  false
            }
        } else {
            // Fallback on earlier versions
            if UIPasteboard.general.isKind(of: UIPasteboard.self) {
                return true
            }else
            {
                return false
            }
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
     
//        let proxy = self.textDocumentProxy
//        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
//            textColor = UIColor.white
//        } else {
//            textColor = UIColor.black
//        }
        //  self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }
    
    
    
    
    // collectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section:Int)->Int {
        // if collection view is the bottom collection
        if collectionView.isEqual(bottomCollectionView){
            return bottomBarArray.count
        }
        else if collectionView.isEqual(emojiCollectionView)
        {
            return selectedEmojiArray.count
        }
        else
        {
            return 0
        }
        
    }
    
    // collection view method -> cell for row at index path
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell :EmojiCollectionViewCell!
        if collectionView.isEqual(bottomCollectionView) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"BottomCollectionViewCell", for: indexPath) as! BottomCollectionViewCell
            let name = bottomBarArray[indexPath.row]
           
            let image = UIImage(named: name)
            
            if image != nil {
                (cell as BottomCollectionViewCell).botomBarButton.setImage(image, for: .normal)
            }
           
            if indexPath.row == 0 || indexPath.row == bottomBarArray.count-1
            {
                (cell as BottomCollectionViewCell).contentView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 229/255, alpha: 1.0)
            }
           
            else {
                (cell as BottomCollectionViewCell).contentView.backgroundColor = UIColor.white
            }
            
            (cell as BottomCollectionViewCell).botomBarButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            (cell as BottomCollectionViewCell).botomBarButton.tag = indexPath.row
            
            return cell
        }
        else if collectionView.isEqual(emojiCollectionView){
            let cell : EmojiCollectionViewCell!
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCollectionViewCell", for: indexPath) as! EmojiCollectionViewCell
            cell.emojiImageView.stopAnimatingGif()
            let name = selectedEmojiArray[indexPath.row]
            if name.hasSuffix("gif")
            {
                if let gif = gifImagesDic[name] {
                    cell.emojiImageView.image = nil
                    let gifmanager = SwiftyGifManager(memoryLimit:50)
                    cell.emojiImageView.setGifImage(gif, manager: gifmanager)
                  //  cell.emojiImageView.animatedImage = gifImagesDic[name]
                    cell.emojiImageView.contentMode = .scaleAspectFill
                }
            }
            else {
                let emojiImage = UIImage(named: name)
            //  cell.emojiImageView.animatedImage = nil
                cell.emojiImageView.image = emojiImage
                cell.emojiImageView.contentMode = .scaleToFill
            }
            
            cell.emojiImageView.tag = indexPath.row
            let tap = UITapGestureRecognizer(target: self, action: #selector(tappedMe(_:)))
            cell.emojiImageView.addGestureRecognizer(tap)
            cell.emojiImageView.isUserInteractionEnabled = true
          
            return cell
        }
        else{
            cell = EmojiCollectionViewCell()
            return cell
        }
    }
    
    
    
    // collectionview frame reset during orientation
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView.isEqual(emojiCollectionView)
        {
            if(UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone){
                return CGSize(width: 45 , height: 45)
            }else{
                return CGSize(width: 65 , height: 65)
            }
            
            let totalPixel = 180 * UIScreen.main.bounds.size.width
            let pixelPerCell = totalPixel/CGFloat(selectedEmojiArray.count)
            var width = pixelPerCell.squareRoot()
            
            let tempCols = Int(UIScreen.main.bounds.size.width / width)
            let tempRows = (selectedEmojiArray.count ) / tempCols
            width = UIScreen.main.bounds.size.width / CGFloat(tempCols)
            var height = 180 / CGFloat(tempRows)
            
            if height < width {
                
                while ((CGFloat(tempRows) * height) > 180) {
                    height = height - 1
                }
                
                return CGSize(width: height, height: height)
            }
            else{
                while ((CGFloat(tempRows) * width) > 180) {
                    width = width - 1
                }
                
                return CGSize(width: width, height: width)
            }
        }
        else if collectionView.isEqual(bottomCollectionView)
        {
            return CGSize(width:(UIScreen.main.bounds.size.width)/8, height : 40)
        }
        
        return CGSize.zero
        
    }
    
    
  func  collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
   if collectionView.isEqual(emojiCollectionView)
   {
    let cell : EmojiCollectionViewCell!
     cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCollectionViewCell", for: indexPath)as! EmojiCollectionViewCell
    (cell as EmojiCollectionViewCell).emojiImageView.image = nil
    }
}
    // keyboard orientation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let screensize = UIScreen.main.bounds
        if  screensize.width > screensize.height {
            bottomCollectionView.reloadData()
            msglabel.frame = self.view.frame
            emojiCollectionView.reloadData()
        }
        else {
            bottomCollectionView.reloadData()
            msglabel.frame = self.view.frame
            emojiCollectionView.reloadData()
        }
        
    }
    
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    // BottomBar button clicked
    func buttonAction(sender:UIButton!)  {
      
        print(sender.tag)
        let btnsendtag: UIButton = sender
        
        bottomBarArray = ["bottom_icon01","bottom_icon02","bottom_icon03","bottom_icon04","bottom_icon05","bottom_icon06","bottom_icon07","bottom_icon08_hover"]
        
        if btnsendtag.tag < 7 {
            removeDefaultkeyboard()
        }
        
        if btnsendtag.tag == 0 {
            advanceToNextInputMode()
        }
        else if btnsendtag.tag == 1
        {
            bottomBarArray[btnsendtag.tag] = "bottom_icon02_hover"
            bottomCollectionView.reloadData()
            if isKeyPresentInUserDefaults(key: "FavArray"){
                
                print(UserDefaults.standard.value(forKey: "FavArray") ?? "null")
                
                selectedEmojiArray = UserDefaults.standard.value(forKey: "FavArray") as! Array<String>
                favoriteArray = UserDefaults.standard.value(forKey: "FavArray") as! Array<String>
            }
            else{
                selectedEmojiArray = myDict?["Favorite"] as! Array<String>
            }
           
            //selectedEmojiArray = myDict?["Favorite"] as! Array<String>
            emojiCollectionView.reloadData()
        }
        else if btnsendtag.tag == 2
        {
            selectedEmojiArray = myDict?["Panda"] as! Array<String>
            emojiCollectionView.reloadData()
            bottomBarArray[btnsendtag.tag] = "bottom_icon03_hover"
            bottomCollectionView.reloadData()
        }
        else if btnsendtag.tag == 3
        {
            selectedEmojiArray = myDict?["Text"] as! Array<String>
            emojiCollectionView.reloadData()
            bottomBarArray[btnsendtag.tag] = "bottom_icon04_hover"
            bottomCollectionView.reloadData()
            
        }
        else if btnsendtag.tag == 4
        {
            selectedEmojiArray = myDict?["Animated"] as! Array<String>
            emojiCollectionView.reloadData()
            bottomBarArray[btnsendtag.tag] = "bottom_icon05_hover"
            bottomCollectionView.reloadData()
        }
        else if btnsendtag.tag == 5
        {
            selectedEmojiArray = myDict?["Static"] as! Array<String>
            emojiCollectionView.reloadData()
            bottomBarArray[btnsendtag.tag] = "bottom_icon06_hover"
            bottomCollectionView.reloadData()
        }
        else if btnsendtag.tag == 6
        {
            bottomBarArray[btnsendtag.tag] = "bottom_icon07_hover"
            bottomCollectionView.reloadData()
            initDefaultKeyboard()
        }
        else if btnsendtag.tag == 7
        {
             bottomBarArray[btnsendtag.tag] = "bottom_icon08_hover"
            (textDocumentProxy as UIKeyInput).deleteBackward()
        }
    }
    
    // emoji tapped
    func tappedMe(_ sender: UITapGestureRecognizer)
    {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: false)
        msglabel.isHidden = false
        let imgView = sender.view as! UIImageView
        let imageTag = imgView.tag
        var imgName = selectedEmojiArray[imageTag] as NSString
        addEmojiToFavorite(emojiName: imgName as String  )
        
        if imgName.hasSuffix("png")
        {

            let emojiImage = UIImage(named: imgName as String)
          //  emojiImage =   ResizeImage(image:(UIImage(named:imgName as String))!, targetSize: CGSize(width: 60, height: 60))
            let data = UIImagePNGRepresentation(emojiImage!)

            UIPasteboard.general.setData(data! as Data, forPasteboardType: "public.png")
        }
        else
        {
            imgName = imgName.replacingOccurrences(of: ".gif", with: "") as NSString
            let imageURL = Bundle.main.path(forResource: imgName as String, ofType: "gif")
            let data = NSData(contentsOf: NSURL(fileURLWithPath:imageURL!) as URL)
            UIPasteboard.general.setData(data! as Data, forPasteboardType: kUTTypeGIF as String)
        }
    }
    
    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width : size.width * heightRatio, height:size.height * heightRatio)
            
        } else {
            newSize = CGSize(width:size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        // let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        let rect = CGRect(x: 5, y: 5, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    func addEmojiToFavorite(emojiName: String)
    {
        favoriteArray.append(emojiName)
        print(favoriteArray)
        var counts:[String:Int] = [:]
     
        for item in favoriteArray {
            counts[item] = (counts[item] ?? 0) + 1
        }
        
        let sortedFriends1 = counts.sorted(by: { $0.value > $1.value })
      //  print(sortedFriends1)
     //   print(sortedFriends1.count)
        var favSortedArray = Array<String>()
        
        for friendEntry in sortedFriends1 {
            //  print("Name: \(friendEntry.key)")
            favSortedArray.append(friendEntry.key)
        }
      
        print(favSortedArray);
        if favSortedArray.count > 18 {
            var tempArray = Array<String>()
            tempArray = Array(favSortedArray.prefix(upTo: 18))
            UserDefaults.standard.set(tempArray, forKey: "FavArray")
        }
        else {
            UserDefaults.standard.set(favSortedArray, forKey: "FavArray")
        }
    }
    
    // init the default keyboard
    
    func initDefaultKeyboard()
    {
        let defaultNib = UINib(nibName:"DefaultKeyboard1",bundle: nil)
        let defaultKeyboardView = defaultNib.instantiate(withOwner: self, options: nil)[0] as! UIView
        defaultKeyboardView.translatesAutoresizingMaskIntoConstraints = false
        defaultKeyboardView.tag = 420
        view.addSubview(defaultKeyboardView)
        
        // create the constraints
        
        // top constraints
        
        let topConstraint : NSLayoutConstraint = NSLayoutConstraint(item: defaultKeyboardView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: emojiCollectionView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        view.addConstraint(topConstraint)
        
        // bottom constraints
        
        let bottomConstraint: NSLayoutConstraint = NSLayoutConstraint(item: defaultKeyboardView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: emojiCollectionView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint)
        
        // leading  constraints
        
        let leadingConstraint : NSLayoutConstraint = NSLayoutConstraint(item: defaultKeyboardView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: emojiCollectionView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        view.addConstraint(leadingConstraint)
        
        let trailingConstraint : NSLayoutConstraint = NSLayoutConstraint(item: defaultKeyboardView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: emojiCollectionView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        view.addConstraint(trailingConstraint)
        
        //copy the background color
        view.backgroundColor = defaultKeyboardView.backgroundColor
    }
    
    
    // add letter
    @IBAction func addLetter(_ sender: UIButton)
    {
        self.textDocumentProxy.insertText((sender.titleLabel?.text)!)
    }
    
    // add space
    @IBAction func addSpace(_ sender: UIButton)
    {
        self.textDocumentProxy.insertText(" ")
        
    }
    
    // delete letters
    @IBAction func deleteLetter(_ sender: UIButton)
    {
        self.textDocumentProxy.deleteBackward()
    }
    
    // toggle caps
    @IBAction func toggleCaps(_ sender: UIButton)
    {
        capsOn = !capsOn
        for v:UIView in self.view.subviews{
            for v2:UIView in v.subviews{
                for v3:UIView in v2.subviews{
                    for v4 : UIView in v3 .subviews{
                        if v4 is UIButton && v4.tag < 10{
                            let word = ((capsOn) ? (v4 as! UIButton).currentTitle?.uppercased(): (v4 as! UIButton).currentTitle?.lowercased())
                            (v4 as! UIButton).setTitle(word, for:UIControlState())
                            (v4 as! UIButton).setTitle(word, for: .highlighted)
                            (v4 as! UIButton).setTitle(word, for: .selected)
                        }
                    }
                }
            }
        }
    }
    
    // return action
    @IBAction func returnAction(_ sender: UIButton)
    {
        dismissKeyboard()
    }
    
    // changebtnclick
    @IBAction func changeBtnClick(_ sender: UIButton)
    {
        let view = self.view.viewWithTag(420)
        view?.removeFromSuperview()
    }
    
    // remove default keyboard
    func removeDefaultkeyboard(){
        let view = self.view.viewWithTag(420)
        view?.removeFromSuperview()
       
    }
}
