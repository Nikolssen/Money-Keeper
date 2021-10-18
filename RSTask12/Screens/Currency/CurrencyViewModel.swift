//
//  CurrencyViewModel.swift
//  RSTask12
//
//  Created by Ivan Budovich on 9/30/21.
//

import Foundation
import UIKit

final class CurrencyViewModel: NSObject, CollectionControllerViewModelling {
    private let currencies: [String] = Currency.currencies
    private let coordinator: CollectionCoordinator
    private let callback: (String) -> Void
    private var selectedCurrencyIndex: Int
    func itemSelected(at index: Int) {
        selectedCurrencyIndex = index
    }
    
    func goBack() {
        callback(currencies[selectedCurrencyIndex])
        coordinator.goBack()
    }
    
    var barTitle: String {
        "Wallet currency"
    }
    
    var backgroundImage: UIImage {
        coordinator.colorTheme.image
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        currencies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrencyCell.reuseIdentifier, for: indexPath) as? CurrencyCell else { return UICollectionViewCell() }
        let currencyCode = currencies[indexPath.item]
        cell.configure(with: CurrencyCellViewModel(currencyCode: currencyCode, currencyName: Currency.name(for: currencyCode)))
        if indexPath.item == selectedCurrencyIndex {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        }
        return cell
    }
    
    init(coordinator: CollectionCoordinator, currencyCode: String, callback: @escaping (String) -> Void) {
        self.coordinator = coordinator
        selectedCurrencyIndex = currencies.firstIndex(of: currencyCode) ?? 0
        self.callback = callback
    }
    
}
