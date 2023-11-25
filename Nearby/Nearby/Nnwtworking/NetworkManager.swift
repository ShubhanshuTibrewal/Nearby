//
//  NetworkManager.swift
//  Nearby
//
//  Created by Shubhanshu Tibrewal on 25/11/23.
//

import Foundation

class NetworkManager {

    /// These are the errors this class might return
    enum ManagerErrors: Error {
        case invalidResponse
        case invalidStatusCode(Int)
    }

    /// The request method you like to use
    enum HttpMethod: String {
        case get
        case post

        var method: String { rawValue.uppercased() }
    }

    /// Request data from an endpoint
    /// - Parameters:
    ///   - url: the URL
    ///   - httpMethod: The HTTP Method to use, either get or post in this case
    ///   - completion: The completion closure, returning a Result of either the generic type or an error
    func request<T: Decodable>(fromURL url: URL, httpMethod: HttpMethod = .get, completion: @escaping (Result<T, Error>) -> Void) {

        let completionOnMain: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.method

        let urlSession = URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                completionOnMain(.failure(error))
                return
            }

            guard let urlResponse = response as? HTTPURLResponse else { return completionOnMain(.failure(ManagerErrors.invalidResponse)) }
            if !(200..<300).contains(urlResponse.statusCode) {
                return completionOnMain(.failure(ManagerErrors.invalidStatusCode(urlResponse.statusCode)))
            }

            guard let data = data else { return }
            do {
                let users = try JSONDecoder().decode(T.self, from: data)
                completionOnMain(.success(users))
            } catch {
                debugPrint("Could not translate the data to the requested type. Reason: \(error.localizedDescription)")
                completionOnMain(.failure(error))
            }
        }

        // Start the request
        urlSession.resume()
    }
}

