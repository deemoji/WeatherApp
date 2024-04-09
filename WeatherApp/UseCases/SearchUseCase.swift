import Foundation
import RxSwift
import MapKit

protocol SearchUseCase {
    func search(with query: String) -> Observable<[String]>
}
final class MKSearchUseCase: SearchUseCase {
    
    private let completer = MKLocalSearchCompleter()
    
    init() {
        completer.resultTypes = .address
    }
    
    func search(with query: String) -> Observable<[String]> {
        completer.queryFragment = query
        return completer.rx.didUpdateResults
            .map { results in
            results.map {
                $0.title
            }
        }
    }
    
}
