//
//  CollectionController.swift
//  RSTask12
//
//  Created by Ivan Budovich on 9/27/21.
//

import UIKit

class CollectionController<ViewModel: CollectionControllerViewModelling, Cell: InstantiatableCell>: UIViewController, UICollectionViewDelegate {

    var viewModel: ViewModel!
    
    lazy private var glassBar: GlassBar = {
        let glassBar = GlassBar()
        glassBar.translatesAutoresizingMaskIntoConstraints = false
        glassBar.title = viewModel.barTitle
        glassBar.leadingImage = .circleBack
        glassBar.trailingImage = nil
        glassBar.leadingHandler = viewModel.goBack
        return glassBar
    }()
    
    lazy private var collectionView: UICollectionView = {
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewLayout(height: Cell.height))
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = viewModel
        collectionView.register(Cell.nib, forCellWithReuseIdentifier: Cell.reuseIdentifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let glassBar = self.glassBar
        let collectionView = self.collectionView
        
        view.addSubview(glassBar)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            glassBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 20.0),
            glassBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            glassBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.topAnchor.constraint(equalTo: glassBar.bottomAnchor, constant: 24),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
        
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.itemSelected(at: indexPath.item)
    }
}


protocol CollectionControllerViewModelling: UICollectionViewDataSource {
    func itemSelected(at index: Int)
    func goBack()
    var barTitle: String { get }
}

protocol InstantiatableCell {
    static var nib: UINib { get }
    static var height: CGFloat { get }
    static var reuseIdentifier: String { get }
}
