import Foundation
import MapKit
import RxSwift
import RxCocoa

extension MKLocalSearchCompleter: HasDelegate {
    public typealias Delegate = MKLocalSearchCompleterDelegate
}

public class RxMKLocalSearchCompleterDelegateProxy
    : DelegateProxy<MKLocalSearchCompleter, MKLocalSearchCompleterDelegate>,
      DelegateProxyType, MKLocalSearchCompleterDelegate {
    
    public init(searchCompleter: MKLocalSearchCompleter) {
        super.init(parentObject: searchCompleter, delegateProxy: RxMKLocalSearchCompleterDelegateProxy.self)
    }
    
    internal lazy var didUpdateResultsSubject = PublishSubject<[MKLocalSearchCompletion]>()
    internal lazy var didFailWithErrorSubject = PublishSubject<Error>()
    
    public static func registerKnownImplementations() {
        self.register {RxMKLocalSearchCompleterDelegateProxy(searchCompleter: $0)}
    }
    
    public func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        _forwardToDelegate?.completerDidUpdateResults(completer)
        didUpdateResultsSubject.onNext(completer.results)
    }
    
    public func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        _forwardToDelegate?.completer(completer, didFailWithError: error)
        didFailWithErrorSubject.onNext(error)
    }
    deinit {
        self.didUpdateResultsSubject.on(.completed)
        self.didFailWithErrorSubject.on(.completed)
    }
}
