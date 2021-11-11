//
//  LocationTest.swift
//  PrivateLibrary
//
//  Created by 강희영 on 2021/11/08.
//

import SwiftUI
import Alamofire

class SearchJusoViewModel: ObservableObject {
    @Published var jusoList = [Juso]()
    @Published var searchLongitude = String()
    @Published var searchLatitude = String()
    
    init (jusoList: [Juso] = []) {
        self.jusoList = jusoList
    }
    func getData(dong: String)
    {
        self.jusoList = [Juso]()
        let url = "https://www.juso.go.kr/addrlink/addrLinkApi.do"
        let APIKEY = Bundle.main.object(forInfoDictionaryKey: "JUSO_API_KEY") as! String
        let body = ["confmKey": APIKEY, "currentPage": 1, "countPerPage": 20, "keyword": dong, "resultType" : "json"] as [String : Any]
        AF.request(url, method: .post, parameters: body, encoding: URLEncoding.httpBody).responseJSON() {[weak self] response in
            guard let self = self else { return }
            if let value = response.value {
                if let jusoResponse: JusoResponse = self.toJson(object: value) {
                    self.jusoList = jusoResponse.results.juso
                    print(self.jusoList)
                    //                    for juso in jusoResponse.results.juso {
                    //                        self.jusoList.append(Juso(roadAddr: juso.roadAddr, jibunAddr: juso.jibunAddr))
                    //                    }
                } else {
                    print("serialize error")
                }
            }
        }
    }
    
    func getXY(_ juso: String)
    {
        let url = "https://dapi.kakao.com/v2/local/search/address.json"
        let APIKEY = Bundle.main.object(forInfoDictionaryKey: "KM_REST_KEY") as! String
        let body = ["query": juso]
        let header : HTTPHeaders = ["Authorization": APIKEY]
        print(APIKEY)
        AF.request(url, method: .post, parameters: body, encoding: URLEncoding.httpBody, headers: header).responseJSON {
            response in
            switch response.result{
            case .success:
                guard let result = response.data else {return}
                do {
                    let decoder = JSONDecoder()
                    let json = try decoder.decode(LocationHead.self, from: result)
                    self.searchLongitude = json.documents[0].address.x!
                    self.searchLatitude = json.documents[0].address.y!
                } catch {
                    print("error!\(error)")
                }
                //                if let data = try! response.result.get() as? [String: Any] {
                ////                    print(data["address"])
                //                }
            case .failure(let error):
                print("Error: \(error)")
                return
            }
        }
    }
    
    private func toJson<T: Decodable>(object: Any) -> T? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: object) {
            let decoder = JSONDecoder()
            
            if let result = try? decoder.decode(T.self, from: jsonData) {
                return result
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
}
struct SearchBar: View {
    @Binding var dongName : String
    @Binding var searching : Bool
    @ObservedObject var searchViewModel : SearchJusoViewModel
    @State var alert = " "
    var body: some View {
        
        VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(Color.black)
                    .opacity(0.1)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("주소 검색", text: $dongName) {
                        startedEditing in
                        if startedEditing {
                            withAnimation {
                                searching = true
                            }
                        }
                    } onCommit: {
                        alert = " "
                        if dongName.count < 2{
                            alert = "두 글자 이상 입력해주세요."
                            return
                        }
                        withAnimation {
                            searching = false
                        }
                        searchViewModel.getData(dong: dongName)
                        print(getDistance(latitude1: "37.566381", longitude1: "126.977717", latitude2: "37.565577", longitude2: "126.978082"))
//                        print(getDistance(latitude1: "37.504030", longitude1: "127.024099", latitude2: "37.497175", longitude2: "127.027926"))
                    }
                    .disableAutocorrection(true)
                }
                .foregroundColor(.gray)
                .padding(.leading, 13)
            }
            .frame(height: 40)
            .cornerRadius(13)
            .padding()
            Text(alert)
                .foregroundColor(.red)
        }
    }
}

struct LocationRegistration: View {
    
    
    //    @StateObject var locationManager = LocationManager()
    
    @State var dongName = ""
    @State var searching = false
    @ObservedObject var searchJusoViewModel = SearchJusoViewModel()
    
    //    var userLatitude: String {
    //        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
    //    }
    //
    //    var userLongitude: String {
    //        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    //    }
    
    var body: some View {
        NavigationView{
            VStack {
                SearchBar(dongName: $dongName, searching: $searching, searchViewModel: searchJusoViewModel)
                HStack {
                    Text("latitude: \(searchJusoViewModel.searchLatitude)")
                    Text("longitude: \(searchJusoViewModel.searchLongitude)")
                }
                List{
                    ForEach(searchJusoViewModel.jusoList, id: \.id) { juso in
                        Text("\(juso.roadAddr)\n\(juso.jibunAddr)")
                            .font(.callout)
                            .frame(width: .infinity, alignment: .leading)
                            .onTapGesture {
                                dongName = juso.roadAddr
                                searchJusoViewModel.getXY(dongName)
                            }
                    }
                }
            }
            //            .onAppear(perform: {
            //                searchJusoViewModel.getData(dong: "사당")
            //            })
            .toolbar {
                if searching {
                    Button("Cancel") {
                        dongName = ""
                        withAnimation {
                            searching = false
                        }
                    }
                }
            }
        }
    }
}

struct LocationTest_Previews: PreviewProvider {
    static var previews: some View {
        LocationRegistration()
    }
}
