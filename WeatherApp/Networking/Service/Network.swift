import RxSwift

final class Network<EndPoint> where EndPoint: EndPointType {
    
    private lazy var urlSession = URLSession.shared
    
    func executeQuery(endPoint: EndPoint) -> Single<Data> {
        return Single.create { [weak self] single in
            guard let self = self else { return Disposables.create() }
            do {
                let request = try self.buildRequest(from: endPoint)
                let task = self.urlSession.dataTask(with: request) { data, responce, error in
                    if let _ = error {
                        single(.failure(ResponceError.connectionError))
                        return
                    }
                    if let responce = responce as? HTTPURLResponse {
                        let statusCode = responce.statusCode
                        if (200...299).contains(statusCode) {
                            single(.success(data ?? Data()))
                        } else {
                            single(.failure(ResponceError.badStatusCode(statusCode)))
                        }
                    }
                }
                task.resume()
                return Disposables.create() {
                    task.cancel()
                }
            } catch {
                single(.failure(ResponceError.buildRequestError))
                return Disposables.create()
            }
        }
    }
    
    private func buildRequest(from endPoint: EndPointType) throws -> URLRequest {
        var request = URLRequest(url: endPoint.baseURL.appendingPathComponent(endPoint.path), cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 10.0)
        request.httpMethod = endPoint.httpMethod.rawValue
        do {
            switch endPoint.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestWithParameters(let bodyParameters, let urlParameters):
                try self.configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)
            case .requestWithParametersAndHeaders(let bodyParameters, let urlParameters,  let headers):
                self.addHeaders(headers, &request)
                try self.configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)
            }
        }
        catch {
            throw error
        }
        
        return request
    }
    private func configureParameters(bodyParameters: Parameters?, urlParameters: Parameters?, request: inout URLRequest) throws {
        do {
            if let bodyParameters = bodyParameters {
                try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
            }
            if let urlParameters = urlParameters {
                try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
            }
        } catch {
            throw error
        }
    }
    private func addHeaders(_ headers: HTTPHeaders?, _ request: inout URLRequest) {
        guard let headers = headers else { return }
        for (key,value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }

}
