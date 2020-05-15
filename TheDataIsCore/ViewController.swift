//
//  ViewController.swift
//  TheDataIsCore
//
//  Created by Mike Kavouras on 5/15/20.
//  Copyright © 2020 Mike Kavouras. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
    
    var people: [Person] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPerson))
        
        let fetchResult = Person.all()
        switch fetchResult {
        case .success(let people):
            self.people = people
        case .failure(let error):
            print(error)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = people[indexPath.row].name
        return cell
    }

    @objc private func addPerson() {
        let alert = UIAlertController(title: "New person", message: "Add a new name", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
                                        
            guard let textField = alert.textFields?.first,
                let name = textField.text else {
                    return
            }
          
            let result = Person.save(name: name)
            switch result {
            case .success(let person):
                self.people.append(person)
            case .failure(let error):
                print(error)
            }
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}

