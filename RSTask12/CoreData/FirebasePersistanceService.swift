//
//  FirebasePersistanceService.swift
//  RSTask12
//
//  Created by Ivan Budovich on 5/2/22.
//


import Foundation
import FirebaseAuth
import Firebase
import FirebaseFirestore

final class FirebasePersistanceService {
    weak var coredataService: CoreDataService!
    
    func fetch(completion: @escaping ()->()) {
        let db = Firestore.firestore()
        guard let user = Firebase.Auth.auth().currentUser?.uid else {
            completion()
            return }
        db.collection("wallet").whereField("user", isEqualTo: user).getDocuments { [coredataService] snapshot, error  in
            guard let snapshot = snapshot else {
                completion()
                return
            }
                let wallets = snapshot.documents.compactMap {
                    value -> WalletInfo? in
                    let data = value.data()
                    guard let theme = data["theme"]  as? Int32,
                          let code = data["code"] as? String,
                          let title = data["title"] as? String
                    else { return nil }
                    return WalletInfo(theme: .init(rawValue: theme)!, currencyCode: code, title: title)
                }
                guard let service = coredataService else {
                    completion()
                    return }
                wallets.forEach {
                    service.addNewWallet(walletInfo: $0, withUpdate: false)
                }
                let newWallets = service.fetchWallets()
                db.collection("transaction").whereField("user", isEqualTo: user).getDocuments { snapshot, error in
                    guard let snapshot = snapshot else {
                        completion()
                        return }
                    let transactions = snapshot.documents.compactMap {
                        value -> TransactionInfo? in
                        let data = value.data()
                        guard let title = data["title"] as? String,
                              let date = (data["date"] as? Timestamp)?.dateValue(),
                              let isOutcome = data["isOutcome"] as? Bool,
                              let change = data["change"] as? Decimal,
                              let walletId = data["wallet"] as? String,
                              let categoryInt = data["category"] as? Int32,
                              let category = TransactionInfo.Category.init(rawValue: categoryInt) else { return nil }
                        let note = data["note"] as? String
                        return TransactionInfo(title: title, date: date, isOutcome: isOutcome, change: change, category: category, note: note, walletId: walletId)
                        
                    }
                    transactions.forEach { value in
                        service.addTransaction(transactionInfo: value, in: newWallets.first {
                            $0.title == value.walletId
                        }!, withUpdate: false)
                    }
                    completion()
                }
        }
    }
    
    init(service: CoreDataService) {
        self.coredataService = service
    }
    
    func addWallet(walletInfo: WalletInfo) {
        let db = Firestore.firestore()
        db.collection("wallet").addDocument(data: ["user": Firebase.Auth.auth().currentUser?.uid ?? "",
            "code": walletInfo.currencyCode,
            "theme": walletInfo.theme.rawValue,
            "title": walletInfo.title
        ])
    }
    
    func addTransaction(transaction: TransactionInfo) {
        let db = Firestore.firestore()
        let user = Firebase.Auth.auth().currentUser?.uid ?? ""
        db.collection("transaction").addDocument(data: ["user": user,
                        "title": transaction.title,
                        "date": transaction.date,
                        "isOutcome": transaction.isOutcome,
                        "change": transaction.change,
                        "wallet": transaction.walletId,
                        "category": transaction.category.rawValue,
                        "note": transaction.note ?? ""
        ])
    }
    
    func deleteWallet(walletInfo: WalletInfo) {
        let db = Firestore.firestore()
        let user = Firebase.Auth.auth().currentUser?.uid ?? ""
        db.collection("wallet").whereField("user", isEqualTo: user).whereField("title", isEqualTo: walletInfo.title).getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            if let id = snapshot.documents.first?.reference.path {
                db.document(id).delete()
            }
        }
        db.collection("transaction").whereField("user", isEqualTo: user).whereField("wallet", isEqualTo: walletInfo.title).getDocuments { snapshot, err in
            if let snapshot = snapshot {
                snapshot.documents.forEach {
                    db.document($0.reference.path).delete()
                }
            }
        }
        
    }
    
    func deleteTransaction(transaction: TransactionInfo) {
        let db = Firestore.firestore()
        let user = Firebase.Auth.auth().currentUser?.uid ?? ""

        db.collection("transaction").whereField("user", isEqualTo: user).whereField("wallet", isEqualTo: transaction.walletId).whereField("title", isEqualTo: transaction.title).getDocuments { snapshot, err in
            if let snapshot = snapshot {
                snapshot.documents.forEach {
                    db.document($0.reference.path).delete()
                }
            }
        }
    }
    
    func updateTransaction(transaction: TransactionInfo) {
        let db = Firestore.firestore()
        let user = Firebase.Auth.auth().currentUser?.uid ?? ""

        db.collection("transaction").whereField("user", isEqualTo: user).whereField("wallet", isEqualTo: transaction.walletId).whereField("title", isEqualTo: transaction.title).getDocuments { snapshot, err in
            if let snapshot = snapshot {
                snapshot.documents.forEach {
                    db.document($0.reference.path).updateData(["user": user,
                                                           "title": transaction.title,
                                                           "date": transaction.date,
                                                           "isOutcome": transaction.isOutcome,
                                                           "change": transaction.change,
                                                           "wallet": transaction.walletId,
                                                           "category": transaction.category.rawValue,
                                                           "note": (transaction.note ?? "")])
                }
            }
        }
    }
    
    func updateWallet(walletInfo: WalletInfo) {
        let db = Firestore.firestore()
        let user = Firebase.Auth.auth().currentUser?.uid ?? ""
        db.collection("wallet").whereField("user", isEqualTo: user).whereField("title", isEqualTo: walletInfo.title).getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            if let id = snapshot.documents.first?.reference.path {
                db.document(id).updateData(["user": user,
                                            "code": walletInfo.currencyCode,
                                            "theme": walletInfo.theme.rawValue,
                                            "title": walletInfo.title
                                        ])
            }
        }
    }
    
}
