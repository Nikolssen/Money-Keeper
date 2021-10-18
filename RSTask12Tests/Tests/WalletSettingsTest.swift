//
//  WalletSettingsTest.swift
//  RSTask12Tests
//
//  Created by Ivan Budovich on 10/8/21.
//

import XCTest
@testable import RSTask12

class WalletSettingsTest: XCTestCase {

    var coordinator: WalletSettingsMockCoordinator!
    var viewModel: SettingsViewModelling!
    var service: CoreDataServiceType!
    var delegate: WalletSettingsDelegateMock!
    
    override func setUpWithError() throws {
        coordinator = WalletSettingsMockCoordinator()
        service = CoreDataServiceStub()
        delegate = WalletSettingsDelegateMock()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNewWallet() {
        XCTAssertFalse(coordinator.didRequestColorTheme)
        viewModel = NewWalletViewModel(coordinator: coordinator, service: service)
        XCTAssertTrue(coordinator.didRequestColorTheme)
        
        XCTAssert(viewModel.currentTitle.isEmpty)
        viewModel.currentTitle = "My title"
        XCTAssertEqual(viewModel.currentTitle, "My title")
        
        //Adding
        XCTAssertEqual(service.fetchWallets().count, 2)
        viewModel.delegate = delegate
        viewModel.glassBarLeadingAction?()
        XCTAssertEqual(service.fetchWallets().count, 2)
        XCTAssert(coordinator.didGoBack)
        coordinator.didGoBack = false
        delegate.shouldSelectLeadingAction = true
        viewModel.glassBarLeadingAction?()
        XCTAssertEqual(service.fetchWallets().count, 3)
        XCTAssert(coordinator.didGoBack)
        
        
        XCTAssertFalse(coordinator.didShowColorTheme)
        viewModel.showColors()
        XCTAssert(coordinator.didShowColorTheme)
        
        
        
        XCTAssertFalse(coordinator.didShowCurrencies)
        viewModel.showCurrencies()
        XCTAssert(coordinator.didShowCurrencies)
        
        

        
        XCTAssertEqual(viewModel.glassBarTitle, "Add new wallet")
        
        
    }

}
