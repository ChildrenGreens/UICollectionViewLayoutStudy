//
//  CustomLayout.swift
//  UICollectionViewLayoutStudy
//
//  Created by caiqiujun on 16/3/8.
//  Copyright © 2016年 caiqiujun. All rights reserved.
//

import UIKit

protocol CustomLayoutDelegate:class{
    
    /**
     根据flowLayout获得cell的高度
     
     - parameter waterFallFlowLayout: WaterFallFlowLayout
     - parameter heigtForItemAtIndex: 第几个cell
     - parameter itemWidth:           cell的width
     
     - returns: cell的高度
     */
    func waterflowLayout(waterFallFlowLayout:CustomLayout,heigtForItemAtIndex:Int,itemWidth:CGFloat) -> CGFloat
    
}




class CustomLayout: UICollectionViewLayout {
    
    // 布局属性（懒加载）
    private lazy var attributes: [UICollectionViewLayoutAttributes] = {
       return [UICollectionViewLayoutAttributes]()
    }()
    
    weak var delegate:CustomLayoutDelegate?
    /// cell 间距
    private let cellMargin:CGFloat = 10
    /// 列数
    private let columnCount = 3
    /**  每列的行高  */
    private var heights:[CGFloat] = [0,0,0]
 
    /**
     *  1.首先，-(void)prepareLayout将被调用，默认下该方法什么没做，但是在自己的子类实现中，一般在该方法中设定一些必要的
     *  layout的结构和初始需要的参数等。
     */
    override func prepareLayout() {
        super.prepareLayout()
        // 清空数组
        attributes.removeAll()
        heights.removeAll()
        
        // 
        for _ in 0 ..< columnCount {
            let height:CGFloat = 0
            heights.append(height)
        }
        
        let count = collectionView!.numberOfItemsInSection(0)
        // 获取所有UICollectionViewLayoutAttributes信息
        for index in 0 ..< count {
            let indexPath = NSIndexPath(forItem: index, inSection: 0)
            let attribute = layoutAttributesForItemAtIndexPath(indexPath)!
            attributes.append(attribute)
        }
        
    }
    
    /**
     *  2.之后，-(CGSize) collectionViewContentSize将被调用，以确定collection应该占据的尺寸。注意这里的尺寸不是指可视
     *  部分的尺寸，而应该是所有内容所占的尺寸。collectionView的本质是一个scrollView，因此需要这个尺寸来配置滚动行为。
     */
    override func collectionViewContentSize() -> CGSize {
        let contentWidth = collectionView?.bounds.size.width
        
        
        return CGSize(width: contentWidth!, height: 1)
        
    }
    
    /**
     *  3.接下来，-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect被调用，这个没什么值得多说的。
     *  初始的layout的外观将由该方法返回的UICollectionViewLayoutAttributes来决定。
     */
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes
    }
    
    
    /*  
     *  layoutAttributesForItemAtIndexPath所有属性
     *
     *  public var frame: CGRect
     *  public var center: CGPoint
     *  public var size: CGSize
     *  public var transform3D: CATransform3D
     *  public var bounds: CGRect
     *  public var transform: CGAffineTransform
     *  public var alpha: CGFloat
     *  public var zIndex: Int
     *  public var hidden: Bool
     *  public var indexPath: NSIndexPath
     *
     *  返回对应于indexPath的位置的cell的布局属性
     */
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        
        var minHeight = heights[0]
        var minColumnIndex = 0
        
        // 取出最小的列高和对应的列数
        for index in 1 ..< columnCount {
            if heights[index] < minHeight {
                minHeight = heights[index]
                minColumnIndex = index
            }
        }
        
        let collectionViewW = collectionView!.frame.size.width
        
        let width = (collectionViewW - (CGFloat(columnCount) + 1) * cellMargin) / CGFloat(columnCount)
        let height = delegate!.waterflowLayout(self, heigtForItemAtIndex: indexPath.row, itemWidth: width)
        
        let x = (CGFloat(minColumnIndex) + 1) * cellMargin + CGFloat(minColumnIndex) * width
        let y = minHeight + cellMargin
        
        heights[minColumnIndex] = y +  CGFloat(height)
        
        attribute.frame = CGRect(x: x, y: y, width: width, height: CGFloat(height))
        
        return attribute
    }
    
    
    /*
     *  返回对应于indexPath的位置的追加视图的布局属性，如果没有追加视图可不重载
     */
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        return nil
    }
    
    
    /*
     *  返回对应于indexPath的位置的装饰视图的布局属性，如果没有装饰视图可不重载
     */
    override func layoutAttributesForDecorationViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        return nil
    }
    
    
    /*
     *  当边界发生改变时，是否应该刷新布局。如果YES则在边界变化（一般是scroll到其他地方）时，将重新计算需要的布局信息。
     */
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return false
    }
    
    

}
