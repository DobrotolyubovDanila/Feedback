//
//  ViewController.swift
//  Feedback
//
//  Created by Данила on 08.06.2020.
//  Copyright © 2020 Данила. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var feedbacks:[Feedback] = []
    var filteredArrays:[[Feedback]] = [] // Массив для хранения отсортированных данных по убыванию количества членов в массивах.
    
    let regionNames = ["Краснодарский край", "Ростовская область", "Ставропольский край"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // Сортировка
        let fk = feedbacks.filter { (fk) -> Bool in
            return fk.region == "Краснодарский край"
        }
        filteredArrays.append(fk)
        
        let fr = feedbacks.filter { (fr) -> Bool in
            return fr.region == "Ростовская область"
        }
        filteredArrays.append(fr)
        
        let fs = feedbacks.filter { (fs) -> Bool in
            return fs.region == "Ставропольский край"
        }
        filteredArrays.append(fs)
        
        filteredArrays = filteredArrays.sorted { (a, b) -> Bool in
            return a.count > b.count
        }
        
        tableView.tableFooterView = UIView()
        
        tableView.reloadData()
    }
    
}



// Работа с TableView
extension StatisticsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredArrays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "statistics cell", for: indexPath) as! StatisticsCell
        
        cell.regionLabel.text = filteredArrays[indexPath.row][0].region
        cell.counterLabel.text = "\(filteredArrays[indexPath.row].count)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    // Передача данных.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        
        let dvc = segue.destination as! ShowSampleTVC
        
        dvc.feedbacks = filteredArrays[indexPath.row]
    }
    
}
