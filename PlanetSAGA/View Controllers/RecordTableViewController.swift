//
//  RecordTableViewController.swift
//  univerSwuSaga
//
//  Created by 김예빈 on 2018. 5. 29..
//  Copyright © 2018년 김예빈. All rights reserved.
//

import UIKit

class RecordTableViewController: UITableViewController {
    
    var urlString: String = ""
    var alignFlag: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.userScoreDownloadDataFromServer()
    }
    
    @IBAction func alignButton(_ sender: UIBarButtonItem) {
        SoundManager.clickEffect()
        
        alignFlag = !alignFlag
        viewWillAppear(true)
    }
    
    func userScoreDownloadDataFromServer() -> Void {
        if alignFlag {
            urlString = "http://condi.swu.ac.kr/student/W02iphone/USS_scoreDateTable.php"
        } else {
            urlString = "http://condi.swu.ac.kr/student/W02iphone/USS_scoreScoreTable.php"
        }
        
        guard let requestURL = URL(string: urlString) else { return }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
//        let restString: String = "id=" + appDelegate.ID!
//        request.httpBody = restString.data(using: .utf8)
//
//        let session = URLSession.shared
//        let task = session.dataTask(with: request) { (responseData, response, responseError) in
//            guard responseError == nil else { print("Error: calling POST"); return; }
//            guard let receivedData = responseData else { print("Error: not receiving Data"); return; }
//            let response = response as! HTTPURLResponse
//
//            if !(200...299 ~= response.statusCode) { print("HTTP response Error!"); return }
//            do {
//                if let jsonData = try JSONSerialization.jsonObject(with: receivedData, options:.allowFragments) as? [[String: Any]] {
//                    for i in 0...jsonData.count-1 {
//                        let newData: UserScore = UserScore()
//                        var jsonElement = jsonData[i]
//                        newData.scoreNo = jsonElement["ScoreNo"] as! String
//                        newData.id = jsonElement["ID"] as! String
//                        newData.score = jsonElement["Score"] as! String
//                        newData.scoreDate = jsonElement["ScoreDate"] as! String
//                        newData.scoreMemo = jsonElement["ScoreMemo"] as! String
//                        self.userScoreFetchedArray.append(newData)
//                    }
//                    DispatchQueue.main.async { self.tableView.reloadData() }
//                }
//            } catch {
//                print("Error:")
//            }
//        }
//        task.resume()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Record Cell", for: indexPath)
        
//        let item = userScoreFetchedArray[indexPath.row]
//        cell.textLabel?.text = item.score
//        cell.detailTextLabel?.text = item.scoreDate // ----> Right Detail 설정 return cell
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "toRecordDetailView" {
            if let destination = segue.destination as? RecordDetailsViewController {
                if let selectedIndex = self.tableView.indexPathsForSelectedRows?.first?.row {
//                    let data = userScoreFetchedArray[selectedIndex]
//                    destination.selectedData = data
                }
            }
        }
    }

    @IBAction func buttonBack(_ sender: UIBarButtonItem) {
        SoundManager.clickEffect()
        
        self.dismiss(animated: true, completion: nil)
    }
}
