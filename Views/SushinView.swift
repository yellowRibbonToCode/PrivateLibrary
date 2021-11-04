//
//  SushinView.swift
//  PrivateLibrary
//
//  Created by SSB on 2021/11/03.
//

import SwiftUI

struct SushinView: View {
    var sushinViewModel: SushinViewModel
    @State var showContent: Bool = false
    @State var viewState = CGSize.zero
    @State var showAlert = false
    
    var body: some View {
        ZStack(alignment: .center) {
            backView.opacity(showContent ? 1 : 0)
            frontView.opacity(showContent ? 0 : 1)
        }
        .frame(width: 250, height: 400)
        .background(Color.orange)
        .cornerRadius(20)
        .shadow(color: Color(.blue).opacity(0.3), radius: 5, x: 10, y: 10)
        .rotation3DEffect(.degrees(showContent ? 180.0 : 0.0), axis: (x: 0, y: -1, z: 0))
        .offset(x: viewState.width, y: viewState.height)
        .animation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0))
        .onTapGesture {
            withAnimation {
                showContent.toggle()
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    viewState = value.translation
                }
                .onEnded { value in
                    if value.location.y < value.startLocation.y - 40.0 {
                        showAlert.toggle()
                    }
                    viewState = .zero
                }
        )
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Remove Card"),
                message: Text("Are you sure you want to remove this card?"),
                primaryButton: .destructive(Text("Remove")) {
                    sushinViewModel.remove()
                },
                secondaryButton: .cancel())
        }
    }
    
    var frontView: some View {
        VStack(alignment: .center) {
            Spacer()
            Text(sushinViewModel.sushin.bookname)
                .foregroundColor(.white)
                .font(.system(size: 20))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(20.0)
            Spacer()
            HStack {
                HStack(alignment: .top, spacing: 10) {
                    Circle()
                        .fill(sushinViewModel.sushin.exchange ? Color.green : Color.red)
                        .frame(width:20, height:20, alignment: .center)
                    Text("Exchange")
                        .fontWeight(.bold)
                }
                HStack(alignment: .top, spacing: 10) {
                    Circle()
                        .fill(sushinViewModel.sushin.sell ? Color.green : Color.red)
                        .frame(width:20, height:20, alignment: .center)
                    Text("Sell")
                        .fontWeight(.bold)
                }
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            .foregroundColor(.white)
        }
    }

    var backView: some View {
        VStack {
            // 1
            Spacer()
            VStack {
                Text(sushinViewModel.sushin.bookname)
                Text(sushinViewModel.sushin.author)
                Text(sushinViewModel.sushin.title)
                Text(sushinViewModel.sushin.content)
            }
            .foregroundColor(.white)
            .font(.body)
            .padding(20.0)
            .multilineTextAlignment(.center)
            .animation(.easeInOut)
            Spacer()
            // 2
            HStack(spacing: 40) {
                Button(action: {
                    sushinViewModel.sushin.exchange = sushinViewModel.sushin.exchange ? false : true
                    exchangeState()
                }) {
                    Image(systemName: "rectangle.2.swap")
                        .padding()
                        .background(sushinViewModel.sushin.exchange ? Color.green : Color.red)
                        .font(.title)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                Button(action: {
                    sushinViewModel.sushin.sell = sushinViewModel.sushin.sell ? false : true
                    sellState()
                }) {
                    Image(systemName: "dollarsign.circle")
                        .padding()
                        .background(sushinViewModel.sushin.sell ? Color.green : Color.red)
                        .font(.title)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
            }
            .padding()
        }
        .rotation3DEffect(.degrees(180), axis: (x: 0.0, y: 1.0, z: 0.0))
    }
    
    // 1
    private func sellState() {
        let updatedSushin = sushinViewModel.sushin
//        updatedSushin.sell = false
        update(sushin: updatedSushin)
    }
    
    // 2
    private func exchangeState() {
        let updatedSushin = sushinViewModel.sushin
//        updatedSushin.exchange = true
        update(sushin: updatedSushin)
    }
    
    // 3
    func update(sushin: Sushin) {
        sushinViewModel.update(sushin: sushin)
        showContent.toggle()
    }
}

struct SushinView_Previews: PreviewProvider {
    static var previews: some View {
        let sushin = testData[0]
        return SushinView(sushinViewModel: SushinViewModel(sushin: sushin))
    }
}
