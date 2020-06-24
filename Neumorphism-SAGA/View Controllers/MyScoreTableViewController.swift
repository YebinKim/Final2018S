//
//  LocalRecordTableViewController.swift
//  univerSwuSaga
//
//  Created by 김예빈 on 2018. 6. 17..
//  Copyright © 2018년 김예빈. All rights reserved.
//

import UIKit
import Firebase

class MyScoreTableViewController: UITableViewController {
    
    static let identifier: String = "myScoreTableViewController"
    
    private var scoreArray: [Score] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "color_back")
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        allScoreDownloadFromServer()
    }
    
    private func initializeTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func allScoreDownloadFromServer() -> Void {
        scoreArray = []
        
        PSDatabase.scoreRef.queryOrdered(byChild: "scoreDate").observe(.value, with: { snapshot in
            var scores: [Score] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let score = Score(snapshot: snapshot) {
                    scores.append(score)
                }
            }
            
            self.scoreArray = scores.reversed()
            self.tableView.reloadData()
        })
    }
    
    // MARK: - UITableViewDataSource & UITableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoreArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scoreCell", for: indexPath)

        let score = scoreArray[indexPath.row]
        
        cell.backgroundColor = .clear
        cell.textLabel?.text = "\(score.score)"
        
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let scoreDate = Double(score.scoreDate) {
            let date = NSDate(timeIntervalSince1970: scoreDate)
            cell.detailTextLabel?.text = formatter.string(from: date as Date)
        } else {
            cell.detailTextLabel?.text = ""
        }
        
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLocalDetailView" {
//            if let destination = segue.destination as? MyScoreDetailsViewController {
//                if let selectedIndex = self.tableView.indexPathsForSelectedRows?.first?.row {
//                    destination.detailLocalScore = localRecords[selectedIndex]
//                }
//            }
        }
    }

    @IBAction func buttonBack(_ sender: UIBarButtonItem) {
        SoundManager.shared.playClickEffect()
        
        self.navigationController?.popViewController(animated: true)
    }
}

extension MyScoreTableViewController {
    
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
