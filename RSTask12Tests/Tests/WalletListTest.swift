//
//  WalletListTest.swift
//  RSTask12Tests
//
//  Created by Ivan Budovich on 10/8/21.
//

import XCTest
@testable import RSTask12
class WalletListTest: XCTestCase {
    var coordinator: WalletListMockCoordinator!
    var viewModel: WalletListViewModel!
    var service: CoreDataServiceStub!
    var delegate: WalletListDelegateMock!
    override func setUpWithError() throws {
        coordinator = WalletListMockCoordinator()
        service = CoreDataServiceStub()
        delegate = WalletListDelegateMock()
        viewModel = WalletListViewModel(service: service, coordinator: coordinator)
        viewModel.delegate = delegate
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        XCTAssertFalse(delegate.didUpdateCollectionView)
        XCTAssert(viewModel.wallets.isEmpty)
        viewModel.update()
        XCTAssertEqual(viewModel.wallets.count, 2)
        XCTAssert(delegate.didUpdateCollectionView)
        XCTAssert(delegate.isInfoLabelHidden)
        
        XCTAssertFalse(coordinator.didRequestColorTheme)
        _ = viewModel.backgroundImage
        XCTAssert(coordinator.didRequestColorTheme)
        
        XCTAssertFalse(coordinator.didGoToWallet)
        viewModel.walletSelected(at: 0)
        XCTAssert(coordinator.didGoToWallet)
        
        XCTAssertFalse(coordinator.didGoToNewWallet)
        viewModel.newWallet()
        XCTAssert(coordinator.didGoToNewWallet)
    }

}
