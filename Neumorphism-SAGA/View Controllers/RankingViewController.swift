//
//  RankingViewController.swift
//  PlanetSAGA
//
//  Created by Yebin Kim on 2020/06/10.
//  Copyright © 2020 김예빈. All rights reserved.
//

import UIKit
import Firebase

class RankingViewController: UIViewController {
    
    static let identifier: String = "rankingViewController"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var userInfoArray: [UserInfo] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        
        initializeCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "color_back")
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        allRankingDownloadFromServer()
    }
    
    func allRankingDownloadFromServer() -> Void {
        userInfoArray = []
        
        PSDatabase.userInfoRef.queryOrdered(byChild: "maxScore").observe(.value, with: { snapshot in
            var userInfoes: [UserInfo] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let userInfo = UserInfo(snapshot: snapshot) {
                    userInfoes.append(userInfo)
                }
            }
            
            self.userInfoArray = userInfoes.reversed()
            self.collectionView.reloadData()
        })
    }
    
    private func registerCell() {
        let cellNib = UINib(nibName: String(describing: RankingCollectionViewCell.self), bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: RankingCollectionViewCell.identifier)
    }
    
    private func initializeCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    @IBAction func buttonBackTapped(_ sender: UIBarButtonItem) {
        SoundManager.shared.playClickEffect()
        
        self.navigationController?.popViewController(animated: true)
    }
}

extension RankingViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: UICollectionViewDataSource & UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userInfoArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RankingCollectionViewCell.identifier, for: indexPath) as? RankingCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let userInfo = userInfoArray[indexPath.row]
        
        cell.profileImageView.image = ImageManager.createDefaultProfileImage(bgColor: UIColor(named: "color_main"))
        cell.scoreLabel.text = "\(userInfo.maxScore)"
        cell.nameLabel.text = userInfo.name
        
        let storageRef = PSDatabase.storageRef.child(userInfo.key)
        storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error, data == nil {
                print("Update User Error: \(error.localizedDescription)")
            } else {
                cell.profileImageView.image = UIImage(data: data!)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let imageSize: CGFloat = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: imageSize, height: imageSize)
    }

}

extension RankingViewController: RankingLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        let profileImage = userInfoArray[indexPath.item].profileImage ?? ImageManager.createDefaultProfileImage(bgColor: UIColor(named: "color_main"))
        return profileImage.size.height
    }
    
}

extension RankingViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
