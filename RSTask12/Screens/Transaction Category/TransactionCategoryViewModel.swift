//
//  TransactionCategoryViewModel.swift
//  RSTask12
//
//  Created by Admin on 02.10.2021.
//

import UIKit

final class TransactionCategoryViewModel: NSObject, CollectionControllerViewModelling {
    private let categories: [TransactionInfo.Category] = TransactionInfo.Category.allCases
    private let coordinator: CollectionCoordinator
    private let callback: (TransactionInfo.Category) -> Void
    private var selectedCategoryIndex: Int
    
    func itemSelected(at index: Int) {
        selectedCategoryIndex = index
    }
    
    func goBack() {
        callback(categories[selectedCategoryIndex])
        coordinator.goBack()
    }
    
    var barTitle: String {
        "Transaction category"
    }
    
    var backgroundImage: UIImage {
        coordinator.colorTheme.image
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as? CategoryCell else { return UICollectionViewCell() }
        let category = categories[indexPath.item]
        cell.configure(with: category)
        if indexPath.item == selectedCategoryIndex {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        }
        return cell
    }
    
    init(coordinator: CollectionCoordinator, category: TransactionInfo.Category, callback: @escaping (TransactionInfo.Category) -> Void) {
        self.coordinator = coordinator
        self.callback = callback
        selectedCategoryIndex = categories.firstIndex(of: category) ?? 0
    }
    
}
