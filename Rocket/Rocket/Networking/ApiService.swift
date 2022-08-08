//
//  ApiService.swift
//  Rocket
//
//  Created by Adela Mišicáková on 22.07.2022.
//

import Foundation

//MARK: - URLError

enum URLError: Error {
    case failed
    // Failed to decode
    case failedToDecode
    // Bad request (400)
    case badRequest
    // Unauthorized (401)
    case unauthorized
    // Not found (404)
    case notFound
    // Conflict (409)
    case serverFailure
    // Unexpected nil
    case unexpectedNil
    // Unknown error
    case unknownError
}

//MARK: - ApiService

struct ApiService {
    
    private(set) var urlString: String
    
    //MARK: - Change base URL
    
    mutating func addToBaseString(query: String) {
        self.urlString += query
    }
    
    //MARK: - Get data from URL
    
    func getData<T: Decodable>() async throws -> T {
        
        if let url = URL(string: urlString) {
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // Check response
            try checkResponse(response: response)
            
            // Check decoded data
            return try parseJSON(type: T.self, data: data)
        } else {
            throw URLError.unexpectedNil
        }
    }
    
    //MARK: - Check response
    
    func checkResponse(response: URLResponse) throws {
        if let response = response as? HTTPURLResponse {
            switch response.statusCode {
            case 200...300:
                break
            case 400:
                throw URLError.badRequest
            case 401:
                throw URLError.unauthorized
            case 404:
                throw URLError.notFound
            case 409:
                throw URLError.serverFailure
            default:
                throw URLError.unknownError
            }
        }
    }
    
    //MARK: - Parse JSON
    
    func parseJSON<T: Decodable>(type: T.Type, data: Data) throws -> T {
        let decoder = JSONDecoder()
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw URLError.failedToDecode
        }
    }
}
