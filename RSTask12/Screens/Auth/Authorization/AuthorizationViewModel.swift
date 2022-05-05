//
//  AuthorizationViewModel.swift
//  RSTask12
//
//  Created by Ivan Budovich on 5/2/22.
//

import Foundation
import Firebase
import FirebaseAuth
import RxRelay
import RxSwift

protocol AuthorizationViewModelType {
    
    var coordinator: AuthorizationViewModelCoordinator {get}
    var service: Service {get}
    
    ///Input: Values
    var emailAddress: PublishRelay<String> {get}
    var password: PublishRelay<String> {get}
    
    ///Input: Action
    var login: PublishRelay<Void> {get}
    var registration: PublishRelay<Void> {get}
    
    ///Output
    var emailCheckMessage: PublishRelay<String> {get}
    var passwordCheckMessage: PublishRelay<String> {get}
    var isLoginEnabled: BehaviorRelay<Bool> {get}
    var activityIndicator: BehaviorRelay<Bool> {get}
    
    
    
}


protocol AuthorizationViewModelCoordinator {
    func goToRegistration()
    func loggedIn()
    func handle(error: Error)
}


class AuthorizationViewModel: AuthorizationViewModelType {
    
    
    
    var coordinator: AuthorizationViewModelCoordinator
    let service: Service
    
    let emailAddress: PublishRelay<String> = .init()
    let password: PublishRelay<String> = .init()
    
    
    let googleAuthorization: PublishRelay<Void> = .init()
    let login: PublishRelay<Void> = .init()
    let registration: PublishRelay<Void> = .init()
    
    
    let emailCheckMessage: PublishRelay<String> = .init()
    let passwordCheckMessage: PublishRelay<String> = .init()
    let isLoginEnabled: BehaviorRelay<Bool> = .init(value: false)
    let activityIndicator: BehaviorRelay<Bool> = .init(value: false)
    
    let disposeBag = DisposeBag()
    
    init(coordinator: AuthorizationViewModelCoordinator, service: Service){
        self.coordinator = coordinator
        self.service = service
        
        
        let mailObservable = emailAddress
            .debounce(.milliseconds(400), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .observe(on: SerialDispatchQueueScheduler(qos: .userInitiated))
            .map({($0, $0.isValidEmail)})
            .share(replay: 1, scope: .whileConnected)
        
        let passwordObservable = password
            .debounce(.milliseconds(400), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .observe(on: SerialDispatchQueueScheduler(qos: .userInitiated))
            .map({($0, $0.isValidPassword)})
            .share(replay: 1, scope: .whileConnected)
        
        mailObservable
            .map({ (email, emailCheckResult) in
                    switch emailCheckResult {
                    case .empty, .valid:
                        return ""
                    case .invalid:
                        return "The input does not respond to email address"
                    }})
            .bind(to: emailCheckMessage)
            .disposed(by: disposeBag)
        
        passwordObservable
            .map({(password, passwordCheckResult) in
                    switch passwordCheckResult {
                    case .empty, .valid:
                        return ""
                    case .short:
                        return "Password must have at least 6 characters"
                    case .invalid:
                        return "Password must contain only latin letters and numbers"
                    }})
            .bind(to: passwordCheckMessage)
            .disposed(by: disposeBag)
        
        
        
        login
            .withLatestFrom(Observable.combineLatest(mailObservable, passwordObservable))
            .map({($0.0, $1.0)})
            .do(onNext: {[activityIndicator] _ in activityIndicator.accept(true)})
            .flatMapLatest( {[service] (email, password)  in
                service.firebaseService.signIn(email: email, password: password)
            })
            .observe(on: MainScheduler.instance)
            .do(onNext: {[activityIndicator] _ in activityIndicator.accept(false)}, onError: {[activityIndicator, coordinator] error in
                activityIndicator.accept(false)
                coordinator.handle(error: error)

            })
            .retry()
            .subscribe(onNext: {[service, coordinator] data in
                service.coreDataService.clearAll(completion: {
                    coordinator.loggedIn()
                })
                })
            .disposed(by: disposeBag)
        
        registration
            .bind(onNext: coordinator.goToRegistration)
            .disposed(by: disposeBag)
        
        
        Observable.combineLatest(mailObservable, passwordObservable)
            .map({(emailAddress, password) in
                emailAddress.1  == .valid && password.1 == .valid
            })
            .bind(to: isLoginEnabled)
            .disposed(by: disposeBag)

    }
    
    
}
