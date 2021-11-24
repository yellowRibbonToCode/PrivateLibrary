//
//  LocationTest.swift
//  PrivateLibrary
//
//  Created by 강희영 on 2021/11/08.
//

import SwiftUI
import Alamofire
import FirebaseAuth
import FirebaseFirestore

class SearchJusoViewModel: ObservableObject {
    @Published var jusoList = [Juso]()
    @Published var searchLongitude = String()
    @Published var searchLatitude = String()
    @Published var jusodata = Juso()
    
    init (jusoList: [Juso] = []) {
        self.jusoList = jusoList
    }
    func getData(dong: String)
    {
        self.jusoList = [Juso]()
        let url = "https://www.juso.go.kr/addrlink/addrLinkApi.do"
        let APIKEY = Bundle.main.object(forInfoDictionaryKey: "JUSOAPIKEY") as! String
        let body = ["confmKey": APIKEY, "currentPage": 1, "countPerPage": 20, "keyword": dong, "resultType" : "json"] as [String : Any]
        AF.request(url, method: .post, parameters: body, encoding: URLEncoding.httpBody).responseJSON() {[weak self] response in
            guard let self = self else { return }
            if let value = response.value {
                if let jusoResponse: JusoResponse = self.toJson(object: value) {
                    guard let _ = jusoResponse.results.juso else { return }
                    
                    self.jusoList = jusoResponse.results.juso
//                    print(self.jusoList)
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
        let APIKEY = Bundle.main.object(forInfoDictionaryKey: "KMRESTKEY") as! String
        let body = ["query": juso]
        let header : HTTPHeaders = ["Authorization": APIKEY]
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
struct JusoSearchBar: View {
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
                        //                        print(getDistance(latitude1: "37.566381", longitude1: "126.977717", latitude2: "37.565577", longitude2: "126.978082"))
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
    @Environment(\.presentationMode) var presentationMode
    @State var roadAddr = ""
    @State var searching = false
    @State var select = false
    @ObservedObject var searchJusoViewModel = SearchJusoViewModel()
    @Binding var profile: Profile
    
    let userid = Auth.auth().currentUser!.uid
    //    @Binding var showingJuso : Bool
    
    //    var userLatitude: String {
    //        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
    //    }
    //
    //    var userLongitude: String {
    //        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    //    }
    
    private func saveJuso() {
        // 1.게시글 중에 이전 유저네임이랑 같은글 전부 수정 or 그냥 un
        //        Firestore.firestore().collection("libData").whereField("userid", isEqualTo: userid).getDocuments() { infos, err in
        //            if let err = err {
        //                print("Error getting documents: \(err)")
        //            } else {
        //                guard let infos = infos?.documents else {
        //                    print("books is nil")
        //                    return
        //                }
        //                for info in infos {
        //                    info.reference.setData(["username": changedName], merge: true)
        //                }
        //            }
        //        }
        // 2.db의 users의 uid같은거에서 유저네임 수정.
        db.collection("users").document("\(userid)").setData([
            "roadAddr" : searchJusoViewModel.jusodata.roadAddr ?? "",
            "sggNm" : searchJusoViewModel.jusodata.sggNm ?? "",
            "emdNm" : searchJusoViewModel.jusodata.emdNm ?? "",
            "latitude" : searchJusoViewModel.searchLatitude,
            "longitude" : searchJusoViewModel.searchLongitude]
                                                             , merge: true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    var body: some View {
        //        NavigationView{
        VStack {
            JusoSearchBar(dongName: $roadAddr, searching: $searching, searchViewModel: searchJusoViewModel)
                .onTapGesture {
                    select = false
                }
            //                HStack {
            //                    Text("latitude: \(searchJusoViewModel.searchLatitude)")
            //                    Text("longitude: \(searchJusoViewModel.searchLongitude)")
            //                }
            List{
                ForEach(searchJusoViewModel.jusoList, id: \.id) { juso in
                    Text("\(juso.roadAddr)\n\(juso.jibunAddr)")
                        .font(.callout)
                        .onTapGesture {
                            roadAddr = juso.roadAddr
                            searchJusoViewModel.jusodata = juso
                            searchJusoViewModel.getXY(roadAddr)
                            select = true
                        }
                }
            }
        }
        .alert(isPresented: $select) {
            Alert(title: Text("주소"), message: Text(roadAddr), primaryButton:  .default(Text("저장"), action:{
                saveJuso()
                profile.sggNm = searchJusoViewModel.jusodata.sggNm
                profile.emdNm = searchJusoViewModel.jusodata.emdNm
                
                self.presentationMode.wrappedValue.dismiss()
            }), secondaryButton: .cancel(Text("취소")))
        }
    }
}
////
//struct LocationTest_Previews: PreviewProvider {
//    static var previews: some View {
//        LocationRegistration()
//    }
//}
