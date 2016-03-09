//
//  ViewController.swift
//  UICollectionViewLayoutStudy
//
//  Created by caiqiujun on 16/3/8.
//  Copyright © 2016年 caiqiujun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var collectionView:UICollectionView = {
        let layout = CustomLayout()
        
        layout.delegate = self
        let collectionView = UICollectionView(frame: UIScreen.mainScreen().bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.showsVerticalScrollIndicator = false
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: String(UICollectionViewCell))
        return collectionView
    }()
    
    private lazy var items:[Square] = {
        return Square.squares()
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(collectionView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(UICollectionViewCell), forIndexPath: indexPath)
        cell.backgroundColor = UIColor.purpleColor()
        return cell
    }
}


extension ViewController: CustomLayoutDelegate {
    func waterflowLayout(waterFallFlowLayout: CustomLayout, heigtForItemAtIndex: Int, itemWidth: CGFloat) -> CGFloat {
        let item = items[heigtForItemAtIndex]
        let height = itemWidth * item.h / item.w
        
        return height
    }
}
