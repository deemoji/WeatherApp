import Foundation
import RxSwift
import MapKit
import RxCocoa

extension Reactive where Base: MKLocalSearchCompleter {
    
    public var delegate: DelegateProxy<MKLocalSearchCompleter, MKLocalSearchCompleterDelegate> {
        RxMKLocalSearchCompleterDelegateProxy.proxy(for: base)
    }
    public var didUpdateResults: Observable<[MKLocalSearchCompletion]> {
        RxMKLocalSearchCompleterDelegateProxy.proxy(for: base).didUpdateResultsSubject.asObservable()
    }
    public var didFailWithError: Observable<Error> {
        RxMKLocalSearchCompleterDelegateProxy.proxy(for: base).didFailWithErrorSubject.asObservable()
    }
    
}
