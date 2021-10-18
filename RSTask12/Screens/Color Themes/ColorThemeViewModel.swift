//
//  ColorThemeViewModel.swift
//  RSTask12
//
//  Created by Ivan Budovich on 9/30/21.
//

import Foundation
import UIKit

protocol ColorThemeViewModelDelegate: AnyObject {
    func setBackgroundImage(image: UIImage)
    
}

class ColorThemeViewModel: NSObject, CollectionControllerViewModelling {
    var backgroundImage: UIImage {
        
        coordinator.colorTheme.image
    }
    
    private let coordinator: CollectionCoordinator
    private let colors = ColorTheme.allCases
    private var selectedThemeIndex: Int
    weak var delegate: ColorThemeViewModelDelegate?
    private var callback: (ColorTheme) -> Void
    func itemSelected(at index: Int) {
        delegate?.setBackgroundImage(image: colors[index].image)
        selectedThemeIndex = index
    }
    
    func goBack() {
        callback(colors[selectedThemeIndex])
        coordinator.goBack()
    }
    
    var barTitle: String {
        "Color themes"
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.reuseIdentifier, for: indexPath) as? ColorCell else { return UICollectionViewCell() }
        let theme = colors[indexPath.item]
        cell.configure(with: theme)
        if indexPath.item == selectedThemeIndex {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        }
        return cell
    }
    
    init(coordinator: CollectionCoordinator, callback: @escaping (ColorTheme) -> Void) {
        self.coordinator = coordinator
        self.callback = callback
        selectedThemeIndex = colors.firstIndex(of: coordinator.colorTheme) ?? 0
    }
    
}
