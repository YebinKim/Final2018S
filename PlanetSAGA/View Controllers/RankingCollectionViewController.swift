//
//  RankingCollectionViewController.swift
//  PlanetSAGA
//
//  Created by Yebin Kim on 2020/06/10.
//  Copyright © 2020 김예빈. All rights reserved.
//

import UIKit
import Firebase

class RankingCollectionViewController: UICollectionViewController {
    
    private var scoreRankingFetchedArray: [UserInfo] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "color_back")
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        //        userRankingFetchedArray = [] // 배열을 초기화하고 서버에서 자료를 다시 가져옴
        userRankingDownloadDataFromServer()
    }
    
    func userRankingDownloadDataFromServer() -> Void {
        PSDatabase.userInfoRef.queryOrdered(byChild: "maxScore").observe(.value, with: { snapshot in
            var newItems: [UserInfo] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let score = UserInfo(snapshot: snapshot) {
                    newItems.append(score)
                }
            }
            
            self.scoreRankingFetchedArray = newItems
            self.collectionView.reloadData()
        })
    }
    
    private func initializeCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RankingCollectionViewCell.identifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }
    
    @IBAction func buttonBackTapped(_ sender: UIBarButtonItem) {
        SoundManager.clickEffect()
        
        self.navigationController?.popViewController(animated: true)
    }

}

extension RankingCollectionViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let navBar = navigationController?.navigationBar else { return }

        if scrollView.contentOffset.y > navBar.frame.height {
            addShadow(navBar)
        } else {
            deleteShadow(navBar)
        }
    }

    func addShadow(_ view: UIView) {
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        view.layer.masksToBounds = false
        view.layer.shadowRadius = 5.0
        view.layer.shadowOpacity = 0.3
    }

    func deleteShadow(_ view: UIView) {
        view.layer.shadowOffset = CGSize(width: 0, height: 0.0)
        view.layer.shadowRadius = 0
        view.layer.shadowOpacity = 0
    }
    
}
