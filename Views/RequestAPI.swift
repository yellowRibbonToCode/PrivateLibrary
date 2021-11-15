//
//  RequestAPI.swift
//  PrivateLibrary
//
//  Created by 강희영 on 2021/11/08.
//

import Foundation


struct Response: Codable {
    let totalCount : String
    let currentPage : String
    let countPerPage : String
    let errorCode : String
    let errorMessage: String
    let roadAddr : String
//    let result: String
//    let message: String
}

/* Body가 없는 요청 */
func requestGet(url: String, completionHandler: @escaping (Bool, Any) -> Void) {
    guard let url = URL(string: url) else {
        print("Error: cannot create URL")
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"

    URLSession.shared.dataTask(with: request) { data, response, error in
        guard error == nil else {
            print("Error: error calling GET")
            print(error!)
            return
        }
        guard let data = data else {
            print("Error: Did not receive data")
            return
        }
        guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
            print("Error: HTTP request failed")
            return
        }
        guard let output = try? JSONDecoder().decode(Response.self, from: data) else {
            print("Error: JSON Data Parsing failed")
            return
        }
        
        completionHandler(true, output.roadAddr)
    }.resume()
}

/* Body가 있는 요청 */
func requestPost(url: String, method: String, param: [String: Any], completionHandler: @escaping (Bool, Any) -> Void) {
    let sendData = try! JSONSerialization.data(withJSONObject: param, options: [])
    
    guard let url = URL(string: url) else {
        print("Error: cannot create URL")
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = method
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = sendData
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard error == nil else {
            print("Error: error calling GET")
            print(error!)
            return
        }
        guard let data = data else {
            print("Error: Did not receive data")
            return
        }
        guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
            print("Error: HTTP request failed")
            return
        }
        guard let output = try? JSONDecoder().decode(Response.self, from: data) else {
            print("Error: JSON Data Parsing failed")
            return
        }
        
        completionHandler(true, output.roadAddr)
    }.resume()
}

/* 메소드별 동작 분리 */
func request(_ url: String, _ method: String, _ param: [String: Any]? = nil, completionHandler: @escaping (Bool, Any) -> Void) {
    if method == "GET" {
        requestGet(url: url) { (success, data) in
            completionHandler(success, data)
        }
    }
    else {
        requestPost(url: url, method: method, param: param!) { (success, data) in
            completionHandler(success, data)
        }
    }
}


//struct Results: Decodable {
//    let articles: [Article]
//}
//
//struct Article: Decodable, Hashable{
//    let title: String
//    let url: String
//    let urlToImage: String?
//}
//
//class RequestAPI: ObservableObject {
//    static let shared = RequestAPI()
//    private init() { }
//    @Published var posts = [Article]()
//
//    private let apiKey = Bundle.main.object(forInfoDictionaryKey: "JUSO_API_KEY") as? String
//
//    func fetchData(){
//
//        guard let apiKey = apiKey else { return }
//
//        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?country=kr&apiKey=\(apiKey)") else{
//            return
//        }
//
//        let session = URLSession(configuration: .default)
//
//        let task = session.dataTask(with: url) { data, response, error in
//            if let error = error{
//                print(error.localizedDescription)
//                return
//            }
//            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
//                self.posts = []
//                return
//            }
//            guard let data = data else{
//                return
//            }
//            do{
//                let apiResponse = try JSONDecoder().decode(Results.self, from: data)
//                DispatchQueue.main.async {
//                    self.posts = apiResponse.articles
//                }
//            }catch(let err){
//                print(err.localizedDescription)
//            }
//        }
//        task.resume()
//    }
//}
