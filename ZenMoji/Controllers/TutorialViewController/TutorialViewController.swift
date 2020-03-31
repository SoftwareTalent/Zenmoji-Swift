//
//  TutorialViewController.swift
//  ZenEmoji
//
//  Created by Mobile on 23/06/17.
//  Copyright © 2017 CSPC143. All rights reserved.
//

import UIKit

class TutorialViewController: AbstractControl,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var pageContol: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var imageArray = Array<Any>()
    
     //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageArray = [#imageLiteral(resourceName: "1"),#imageLiteral(resourceName: "2"),#imageLiteral(resourceName: "3"),#imageLiteral(resourceName: "4"),#imageLiteral(resourceName: "5"),#imageLiteral(resourceName: "6"),#imageLiteral(resourceName: "7"),#imageLiteral(resourceName: "8"),#imageLiteral(resourceName: "9")]
        print(imageArray)
        self.pageContol.numberOfPages = imageArray.count
        self.pageContol.currentPage = 0
        self.pageContol.tintColor = UIColor.red
        self.pageContol.pageIndicatorTintColor = UIColor.black
        self.pageContol.currentPageIndicatorTintColor = UIColor.green
    }

    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        let currentIndex = collectionView.contentOffset.x / UIScreen.main.bounds.size.width
        
        collectionView.isHidden = true
        
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: nil, completion: {
            _ in
            self.collectionView.contentOffset = CGPoint(x: currentIndex * UIScreen.main.bounds.size.width, y: 0)
            self.collectionView.isHidden = false
        })
    }
    
    
    //MARK:- viewWillLayoutSubviews
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        
        flowLayout.itemSize = CGSize(width: view.frame.width, height: collectionView.frame.size.height)
        
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        collectionView.setCollectionViewLayout(flowLayout, animated: false)
        flowLayout.invalidateLayout()
    }
    
    
    
    // MARK:- BUTTON ACTIONS

    @IBAction func skipButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: false)
    }
    
    @IBAction func learnMoreButton(_ sender: Any) {
    }
    
    
    //MARK:- COLLECTION VIEW 
    
    /*
     DATASOURCE AND DELEGATE METHODS
     */
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TutorialCollectionViewCell", for: indexPath) as! TutorialCollectionViewCell
        cell.tutorialScreens.image = imageArray[indexPath.row] as? UIImage
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageContol.currentPage = indexPath.row
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = self.collectionView.frame.size.width
        self.pageContol.currentPage = Int(self.collectionView.contentOffset.x / pageWidth)
    }
    //MARK:- ________
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
