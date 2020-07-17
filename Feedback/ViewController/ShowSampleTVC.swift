//
//  ShowSampleTVC.swift
//  Feedback
//
//  Created by Данила on 08.06.2020.
//  Copyright © 2020 Данила. All rights reserved.
//

import UIKit

class ShowSampleTVC: UITableViewController {

    var feedbacks:[Feedback] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedbacks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sample cell", for: indexPath) as! Cell

        cell.nameLabel.text = feedbacks[indexPath.row].name
        cell.surnameLabel.text = feedbacks[indexPath.row].surname
        cell.cityLabel.text = feedbacks[indexPath.row].city
        cell.commentLabel.text = feedbacks[indexPath.row].comment

        return cell
    }
    // Отменяем выделение строк
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "showDetailStatistic", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailStatistic" {
            let dvc = segue.destination as! NewFeedback
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            dvc.currentFeedback = feedbacks[indexPath.row]
        }
    }

}
