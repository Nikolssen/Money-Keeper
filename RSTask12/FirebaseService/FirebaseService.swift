//
//  FirebaseService.swift
//  RSTask12
//
//  Created by Ivan Budovich on 5/1/22.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import RxSwift

class FirebaseService {
    
    func signIn(email: String, password: String) -> Single<AuthDataResult> {
        return Single<AuthDataResult>.create{
            single in
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let error = error {
                    single(.failure(error))
                }
                else {
                    single(.success(result!))
                }
            }
            return Disposables.create()
        }
        
    }
    
    func createUser(email: String, password: String) -> Single<AuthDataResult>{
        return Single<AuthDataResult>.create{
            single in
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    single(.failure(error))
                }
                else {
                    if let result = result {
//                        let firestore = Firestore.firestore()
//                        firestore.collection("users").addDocument(data: ["uid": result.user.uid])
                        single(.success(result))
                    }
                    else {
                        single(.failure(NSError(domain: "Unknown Error", code: 20021)))
                    }

                }
            }
            return Disposables.create()
        }
        
    }
    
    func logout() -> Single<Void> {
        do {
            try Auth.auth().signOut()
            return Single.just(Void())
        } catch  {
            return Single.error(NSError(domain: "Unsuccessful Logout", code: 20020, userInfo: nil))
        }
    }
}
