//
//  LocalRecordTableViewController.swift
//  univerSwuSaga
//
//  Created by 김예빈 on 2018. 6. 17..
//  Copyright © 2018년 김예빈. All rights reserved.
//

import CoreData
import UIKit

class MyScoreTableViewController: UITableViewController {
    
    static let identifier: String = "myScoreTableViewController"
    
    var localRecords: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeTableView()
        
//        let context = self.getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LocalRecord")
        
        let sortDescriptor = NSSortDescriptor (key: "playdate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
//        do {
//            localRecords = try context.fetch(fetchRequest)
//        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//        }
        
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "color_back")
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
//        let context = self.getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LocalRecord")
        
        let sortDescriptor = NSSortDescriptor (key: "playdate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
//        do {
//            localRecords = try context.fetch(fetchRequest)
//        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//        }
        
        self.tableView.reloadData()
    }
    
    private func initializeTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return localRecords.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Local Record Cell", for: indexPath)

        let localRecord = localRecords[indexPath.row]
        
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        cell.textLabel?.text = localRecord.value(forKey: "localscore") as? String
        cell.detailTextLabel?.text = formatter.string(for: localRecord.value(forKey: "playdate") as? Date)

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Core Data 내의 해당 자료 삭제
//            let context = getContext()
//            context.delete(localRecords[indexPath.row])
            
//            do {
//                try context.save()
//                print("deleted!")
//            } catch let error as NSError {
//                print("Could not delete \(error), \(error.userInfo)")
//            }
            
            // 배열에서 해당 자료 삭제
            localRecords.remove(at: indexPath.row)
            // 테이블뷰 Cell 삭제
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLocalDetailView" {
            if let destination = segue.destination as? MyScoreDetailsViewController {
                if let selectedIndex = self.tableView.indexPathsForSelectedRows?.first?.row {
                    destination.detailLocalScore = localRecords[selectedIndex]
                }
            }
        }
    }

    @IBAction func buttonBack(_ sender: UIBarButtonItem) {
        SoundManager.clickEffect()
        
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
