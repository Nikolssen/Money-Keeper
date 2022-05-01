//
//  AuthViewModel.swift
//  RSTask12
//
//  Created by Ivan Budovich on 5/1/22.
//

import Foundation
import RxRelay
import RxSwift
import FirebaseAuth
import Firebase

protocol RegistrationViewModelType {
    
    var coordinator: RegistrationViewModelCoordinator {get}
    var service: Service {get}
    
    ///Input: Values
    var emailAddress: PublishRelay<String> {get}
    var password: PublishRelay<String> {get}
    var repeatPassword: PublishRelay<String> {get}
    ///Input: Actions
    var register: PublishRelay<Void> {get}
    
    ///Output
    var emailCheckMessage: PublishRelay<String> {get}
    var passwordCheckMessage: PublishRelay<String> {get}
    var repeatPasswordCheckMessage: PublishRelay<String> {get}
    var isRegistrationEnabled: BehaviorRelay<Bool> {get}
    var activityIndicator: BehaviorRelay<Bool> {get}
}

protocol RegistrationViewModelCoordinator: ErrorHandler {
    func registered()
}


class RegistrationViewModel: RegistrationViewModelType {
    
    var coordinator: RegistrationViewModelCoordinator
    let service: Service
    
    let emailAddress: PublishRelay<String> = .init()
    let password: PublishRelay<String> = .init()
    let repeatPassword: PublishRelay<String> = .init()
    
    
    let register: PublishRelay<Void> = .init()
    let showLicenseAgreement: PublishRelay<Void> = .init()
    
    
    let emailCheckMessage: PublishRelay<String> = .init()
    let passwordCheckMessage: PublishRelay<String> = .init()
    let repeatPasswordCheckMessage: PublishRelay<String> = .init()
    let isRegistrationEnabled: BehaviorRelay<Bool> = .init(value: false)
    let activityIndicator: BehaviorRelay<Bool> = .init(value: false)
    let disposeBag = DisposeBag()
    
    init(coordinator: RegistrationViewModelCoordinator, service: Service){
        self.coordinator = coordinator
        self.service = service
        
        let emailAddressObservable = emailAddress
            .debounce(.milliseconds(400), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .observe(on: SerialDispatchQueueScheduler(qos: .userInitiated))
            .map{ ($0, $0.isValidEmail) }
            .share(replay: 1, scope: .whileConnected)
        
        
        
        let passwordObservable = password
            .debounce(.milliseconds(400), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .observe(on: SerialDispatchQueueScheduler(qos: .userInitiated))
            .map({($0, $0.isValidPassword)})
            .share(replay: 1, scope: .whileConnected)
        
        
        passwordObservable
            .map({ (_, result) in
                    switch result {
                    case .empty, .valid:
                        return ""
                    case .short:
                        return "Password must have at least 6 characters"
                    case .invalid:
                        return "Password must contain only latin letters and numbers"
                    }})
            .bind(to: passwordCheckMessage)
            .disposed(by: disposeBag)
        
        
        
        let repeatPasswordObservable = repeatPassword
            .debounce(.milliseconds(400), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .observe(on: SerialDispatchQueueScheduler(qos: .userInitiated))
        
        let repeatPasswordResultObservable = Observable
            .combineLatest(repeatPasswordObservable, passwordObservable.map({(password, _) in password}))
            .map({ (repeatPassword, password) in
                    repeatPassword.arePasswordsEqual(password: password)}).share()
        
        repeatPasswordResultObservable
            .map({
                    switch $0{
                    case .empty, .valid:
                        return ""
                    case .invalid, .short:
                        return "Passwords are not equal"
                    }})
            .bind(to: repeatPasswordCheckMessage)
            .disposed(by: disposeBag)
        
        emailAddressObservable
            .map({ (_, result) in
                    switch result {
                    case .empty, .valid:
                        return ""
                    case .invalid:
                        return "The input does not respond to email address"
                    }})
            .bind(to: emailCheckMessage)
            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(emailAddressObservable.map({$0.1}), passwordObservable.map({$0.1}), repeatPasswordResultObservable)
            .map({$0.0 == .valid && $0.1 == .valid && $0.2 == .valid})
            .bind(to: isRegistrationEnabled)
            .disposed(by: disposeBag)
        
        
        register
            .withLatestFrom(Observable.combineLatest(emailAddressObservable.map({$0.0}), passwordObservable.map({$0.0}))) { $1 }
            .do(onNext: {[activityIndicator] _ in activityIndicator.accept(true)})
            .flatMapLatest({ [service] (email, password) in
                service.authApi.createUser(email: email, password: password)
            })
            .observe(on: MainScheduler.instance)
            .do(onError: {[activityIndicator] error in
                
                activityIndicator.accept(false)
                coordinator.handle(error: error)
            })
            .retry()
            .observe(on: SerialDispatchQueueScheduler.init(qos: .userInitiated))
            .flatMap({[service] data in
                service.userService.createUser(uid: data.user.uid)
            })
            .observe(on: MainScheduler.instance)
            .do(onNext: {[activityIndicator] _ in activityIndicator.accept(false)}, onError: {[activityIndicator] error in
            activityIndicator.accept(false)
            coordinator.handle(error: error)
            })
            .observe(on: SerialDispatchQueueScheduler(qos: .userInitiated))
            .retry()
            .do(onNext: {[service] uid in
                service.userService.uid.accept(uid)
            })
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {[coordinator] uid in
                coordinator.registered()
            })
            .disposed(by: disposeBag)
        
        
    }
}
