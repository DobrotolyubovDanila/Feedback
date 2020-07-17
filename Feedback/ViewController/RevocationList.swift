//
//  List.swift
//  Feedback
//
//  Created by Данила on 07.06.2020.
//  Copyright © 2020 Данила. All rights reserved.
//

import UIKit
import CoreData

class RevocationList: UITableViewController {
    
    var context: NSManagedObjectContext!
    
    var feedbacks:[Feedback] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Получаем данные для последующей вставки в TableView
        getData()
    }
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Cell
        
        cell.cityLabel.text = feedbacks[indexPath.row].city
        cell.nameLabel.text = feedbacks[indexPath.row].name
        cell.surnameLabel.text = feedbacks[indexPath.row].surname
        cell.commentLabel.text = feedbacks[indexPath.row].comment
        
        return cell
    }
    // Отменяем выделение ранее выбранной ячейки
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    // Получение данных из памяти
    private func getData() {
        let fetchRequest:NSFetchRequest<Feedback> = Feedback.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            feedbacks = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    // Добавление жеста удаления строки
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard  editingStyle == .delete else { return }

        let feedback = feedbacks[indexPath.row]
        feedbacks.remove(at: indexPath.row)
        context.delete(feedback)
        
        do {
            try context.save()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    // MARK: Navigation
    @IBAction func unwindSegue(_ sender: UIStoryboardSegue) {
        guard let newFeedbackVC = sender.source as? NewFeedback else {return}
        newFeedbackVC.saveFeedback()
        
        // Обновление TableView, чтобы показать внесенные изменения
        getData()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let fb = feedbacks[indexPath.row]
            let newFeedbackVC = segue.destination as! NewFeedback
            newFeedbackVC.currentFeedback = fb
        }
        if segue.identifier == "show Statistics" {
            let svc = segue.destination as! StatisticsViewController
            svc.feedbacks = feedbacks
        }
    }
}
