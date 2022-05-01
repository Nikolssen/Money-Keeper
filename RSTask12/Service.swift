//
//  Service.swift
//  RSTask12
//
//  Created by Ivan Budovich on 5/1/22.
//

import Foundation

class Service {
    let coreDataService: CoreDataServiceType = CoreDataService(containerName: "RSTask12")
    let firebaseService: FirebaseService = FirebaseService()
}
