//
//  PersonController.swift
//  Pair2
//
//  Created by Bryson Jones on 7/26/21.
//

import Foundation

class PersonController {
    
    //MARK: - Properties
    static let shared = PersonController()
    var people: [Person] = []
    
    //MARK: - CRUD
    func createPersonWith(name: String) {
        let newPerson = Person(name: name)
        people.append(newPerson)
        saveToPersistentStore()
    }
    
    func deletePerson(person: Person) {
        guard let index = people.firstIndex(of: person) else {return}
        people.remove(at: index)
        saveToPersistentStore()
    }
    
    //MARK: - Persistence
    func createPersistentStore() -> URL {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileURL = url[0].appendingPathComponent("Person.json")
        return fileURL
    }
    
    func saveToPersistentStore() {
        do {
            let data = try JSONEncoder().encode(people)
            try data.write(to: createPersistentStore())
        } catch {
            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
        }
    }
    
    func loadFromPersistentStore() {
        do {
            let data = try Data(contentsOf: createPersistentStore())
            people = try JSONDecoder().decode([Person].self, from: data)
        } catch {
            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
        }
    }
    
}//End class
