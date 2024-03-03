import Foundation
import RxSwift
import RxCocoa

extension ObservableType {
    public func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
    
    public func asDriverOnErrorJustComplete() -> Driver<Element> {
        asDriver { error in
            Driver.empty()
        }
    }
    public func unwrap<T>() -> Observable<T> where Element == T? {
        return self.compactMap { $0 }
    }

}

