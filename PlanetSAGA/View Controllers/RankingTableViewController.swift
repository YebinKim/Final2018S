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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        //        userRankingFetchedArray = [] // 배열을 초기화하고 서버에서 자료를 다시 가져옴
        self.userRankingDownloadDataFromServer()
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //        return userRankingFetchedArray.count
        return scoreRankingFetchedArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Ranking Cell", for: indexPath)
        
        let item = scoreRankingFetchedArray[indexPath.row]
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = String(item.maxScore ?? 0) // ----> Right Detail 설정 return cell
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "toRankingDetailView" {
            if let destination = segue.destination as? RankingDetailsViewController {
                if let selectedIndex = self.tableView.indexPathsForSelectedRows?.first?.row {
                    //                    let data = userRankingFetchedArray[selectedIndex]
                    //                    destination.selectedData = data
                }
            }
        }
    }
    
    @IBAction func buttonBack(_ sender: UIBarButtonItem) {
        SoundManager.clickEffect()
        
        self.navigationController?.popViewController(animated: true)
    }
}
