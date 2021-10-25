//
//  scrollView.swift
//  PrivateLibrary
//
//  Created by 강희영 on 2021/10/25.
//

import SwiftUI

struct scrollView : View {
        let colors: [Color] = [.red, .green, .blue]

        var body: some View {
            ScrollView {
                ScrollViewReader { value in
                    Button("Jump to #8") {
                        value.scrollTo(8)
                    }
                    .padding()

                    ForEach(0..<100) { i in
                        Text("Example \(i)")
                            .font(.title)
                            .frame(width: 200, height: 200)
                            .background(colors[i % colors.count])
                            .id(i)
                    }
                }
            }
            .frame(height: 350)
        }
    }
struct scrollView_Previews: PreviewProvider {
    static var previews: some View {
        scrollView()
    }
}
