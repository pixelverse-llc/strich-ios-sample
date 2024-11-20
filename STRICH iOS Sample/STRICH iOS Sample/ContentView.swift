//
//  ContentView.swift
//  STRICH iOS Sample
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            WebView(url: URL(string: "https://demo.strich.io")!)
                .edgesIgnoringSafeArea(.all)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
