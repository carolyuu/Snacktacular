//
//  Spots.swift
//  Snacktacular
//
//  Created by Carol Yu on 4/4/22.
//

import Foundation
import Firebase
import FirebaseFirestore

class Spots {
    var spotArray: [Spot] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ()) {
        db.collection("spots").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("Error: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.spotArray = [] //clean out existing spot Array since new data will load
            // there are querySnapshot!.documents.count documents in the snapshot
            for document in querySnapshot! .documents { // you'll have to make sure you have a dictonary initalizer in singular class 
                let spot = Spot(dictionary: document.data())
                spot.documentID = document.documentID
                self.spotArray.append(spot)
            }
            completed()
        }
    }
}
