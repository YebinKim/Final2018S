//
//  LocalRecordTableViewController.swift
//  univerSwuSaga
//
//  Created by 김예빈 on 2018. 6. 17..
//  Copyright © 2018년 김예빈. All rights reserved.
//

import CoreData
import UIKit

class LocalRecordTableViewController: UITableViewController {
    
    var localRecords: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        // 삭제한 데이터 셀을 없애기 위해 다시 불러옴
        super.viewDidAppear(animated)
        
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
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLocalDetailView" {
            if let destination = segue.destination as? LocalRecordDetailsViewController {
                if let selectedIndex = self.tableView.indexPathsForSelectedRows?.first?.row {
                    destination.detailLocalScore = localRecords[selectedIndex]
                }
            }
        }
    }

    @IBAction func buttonBack(_ sender: UIBarButtonItem) {
//        if let player = appDelegate.clickEffectAudioPlayer {
//            player.play()
//        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
