//
//  Spot.swift
//  Snacktacular
//
//  Created by Carol Yu on 4/4/22.
//

import Foundation
import Firebase
class Spot {
    var name: String
    var address: String
    var averageRating: Double
    var numberOfReviews: Int
    var postingUserID: String
    var documentID: String
    
    var dictonary: [String: Any] {
        return ["name": name, "address": address, "averageRating": averageRating, "numberOfReviews": numberOfReviews, "postingUserID": postingUserID]
    }
    
    init(name: String, address: String, averageRating: Double, numberOfReviews: Int, postingUserID: String, documentID: String) {
        self.name = name
        self.address = address
        self.averageRating = averageRating
        self.numberOfReviews = numberOfReviews
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    convenience init() {
        self.init(name: "", address: "", averageRating: 0.0, numberOfReviews: 0, postingUserID: "", documentID: "")
    }
    convenience init(dictionary: [String: Any]) {
        let name = dictionary["name"] as! String? ?? ""
        let address = dictionary["address"] as! String? ?? ""
        let averageRating = dictionary["averageRating"] as! Double? ?? 0.0
        let numberOfReviews = dictionary["numberOfReviews"] as! Int? ?? 0
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        
        self.init(name: name, address: address, averageRating: averageRating, numberOfReviews: numberOfReviews, postingUserID: postingUserID, documentID: "")
    }
    
    func saveData(completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        // Grab the user ID
        guard let postingUserID = Auth.auth().currentUser?.uid else {
        print("Error: could not save data beucase we don't have a valid postingUserID")
            return completion(false)
        }
        self.postingUserID = postingUserID
        // create the dictionary representing data we want to save
        let dataToSave:[String: Any] = self.dictonary
        // if we HAVE saved a record, we'll have an ID, otherwise .addDocument will create one
        if self.documentID == "" { // Create a new document via .addDocument
            var ref: DocumentReference? = nil //Firestore will create new ID for us
            ref = db.collection("spots").addDocument(data: dataToSave){ (error) in
                guard error == nil else {
                    print("Error adding document \(error!.localizedDescription)")
                    return completion(false)
                    
                }
                self.documentID = ref!.documentID
                print("💨 Added document: \(self.documentID)") // it worked!
                completion(true)
            }
        } else { // else save to the existing documentID w/ .setData
            let ref = db.collection("spots").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                guard error == nil else {
                    print("😡 Error: updating document \(error!.localizedDescription)")
                    return completion(false)
                }
                print("💨 updated document: \(self.documentID)") // it worked!
                completion(true)
            }
        }
    }
}


