//
//  RankingTableViewController.swift
//  univerSwuSaga
//
//  Created by 김예빈 on 2018. 5. 27..
//  Copyright © 2018년 김예빈. All rights reserved.
//

import UIKit
import Firebase

class RankingTableViewController: UITableViewController {
    
    var scoreRankingFetchedArray: [UserInfo] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeTableView()
        
        registerCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "color_back")
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
        
        //        userRankingFetchedArray = [] // 배열을 초기화하고 서버에서 자료를 다시 가져옴
        self.userRankingDownloadDataFromServer()
    }
    
    private func initializeTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func registerCell() {
        let rankingViewCellNib = UINib(nibName: String(describing: RankingViewCell.self), bundle: nil)
        self.tableView.register(rankingViewCellNib, forCellReuseIdentifier: RankingViewCell.identifier)
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
            self.tableView.reloadData()
        })
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoreRankingFetchedArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RankingViewCell.identifier) as? RankingViewCell else {
            print("Error: RackingViewCell configure error")
            return UITableViewCell()
        }
        cell.profileImageView.image = scoreRankingFetchedArray[indexPath.row].profileImage
        cell.nameLabel.text = scoreRankingFetchedArray[indexPath.row].name
        cell.scoreLabel.text = String(scoreRankingFetchedArray[indexPath.row].maxScore)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        //        if segue.identifier == "toRankingDetailView" {
        //            if let destination = segue.destination as? RankingDetailsViewController {
        //                if let selectedIndex = self.tableView.indexPathsForSelectedRows?.first?.row {
        //                    //                    let data = userRankingFetchedArray[selectedIndex]
        //                    //                    destination.selectedData = data
        //                }
        //            }
        //        }
    }
    
    @IBAction func buttonBack(_ sender: UIBarButtonItem) {
        SoundManager.clickEffect()
        
        self.navigationController?.popViewController(animated: true)
    }
}

extension RankingTableViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {

        guard let navBar = navigationController?.navigationBar else {
            return
        }

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
