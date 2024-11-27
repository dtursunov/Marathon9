//
//  ViewController.swift
//  Marathon9
//
//  Created by Diyor Tursunov on 27/11/24.
//

import UIKit

class ViewController: UIViewController {
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())

    override func viewDidLoad() {
        super.viewDidLoad()
         
        let layout = YourCollectionLayoutSubclass()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.decelerationRate = .fast
        collectionView.isPagingEnabled = false        
        collectionView.dataSource = self
        collectionView.delegate = self
        title = "Collection"
        navigationController?.navigationBar.prefersLargeTitles = true
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(collectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .systemGray
        cell.layer.cornerRadius = 16
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let screen = UIScreen.main.bounds
        return .init(width: screen.width * 0.6, height: screen.height * 0.5)
    }
}


class YourCollectionLayoutSubclass: UICollectionViewFlowLayout {
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
           var point = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
           guard let collectionView = collectionView else {
               return point
           }
        
           let cells = collectionView.visibleCells
           let centerPoint = collectionView.center
           var cellFrame: CGRect = CGRect.zero
           for cell in cells {
               cellFrame = collectionView.convert(cell.frame, to: collectionView.superview)
               var newCenterPoint: CGPoint = centerPoint
               if velocity.x > 0 {
                   newCenterPoint = CGPoint(x: centerPoint.x * 1.5, y: centerPoint.y)
               } else if velocity.x < 0 {
                   newCenterPoint = CGPoint(x: centerPoint.x * 0.5, y: centerPoint.y)
               }
               guard cellFrame.contains(newCenterPoint) else {
                   continue
               }
               let x = collectionView.frame.width * 0.5 - cell.frame.width * 0.5
               point.x = cell.frame.origin.x - x + 80
               print(point.x)
               break
           }
           return point
       }
}
