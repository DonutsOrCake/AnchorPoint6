//
//  PeopleListTableViewController.swift
//  Pair2
//
//  Created by Bryson Jones on 7/26/21.
//

import UIKit

class PeopleListTableViewController: UITableViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var shuffleBarButton: UIBarButtonItem!
    
    //MARK: - Properties
    var isRandom: Bool = false {
        didSet {
            tableView.reloadData()
        }
    }
    
    var pairs: [[Person]] = []

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        PersonController.shared.loadFromPersistentStore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        random()
        tableView.reloadData()
    }
    
    //MARK: - Actions
    @IBAction func shuffleBarButtonTapped(_ sender: Any) {
        isRandom = true
        random()
        tableView.reloadData()
    }
    
    @IBAction func addPersonBarButtonTapped(_ sender: Any) {
        presentAddPersonAlert()
    }
    
    //MARK: - Methods
    func random() {
        var random2DArray: [[Person]] = []
        var newArray: [Person] = []
        
        for person in PersonController.shared.people.shuffled() {
            if newArray.count < 2 {
                newArray.append(person)
            } else if newArray.count == 2 {
                random2DArray.append(newArray)
                newArray = []
                newArray.append(person)
            }
        }
        if newArray.count > 0 {
            random2DArray.append(newArray)
        }
        pairs = random2DArray
    }
    
    func presentAddPersonAlert() {
        let alertController = UIAlertController(title: "Add Person", message: "Who?", preferredStyle: .alert)
        
        alertController.addTextField { (textfield) in
            textfield.placeholder = "Enter their name..."
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let name = alertController.textFields?.first?.text, !name.isEmpty else {return}
            PersonController.shared.createPersonWith(name: name)
            self.random()
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return pairs.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isRandom == true {
            return "Group \(section + 1)"
        } else {
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pairs[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath)

        let person = pairs[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = person.name

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let personToDelete = pairs[indexPath.section][indexPath.row]
            
            PersonController.shared.deletePerson(person: personToDelete)
            
            random()
            tableView.reloadData()
        }
    }
}//End class
