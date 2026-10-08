//
//  ContentView.swift
//  movietime
//
//  Created by Sandesh Naik on 15/08/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MoviesScreen()
                .tabItem {
                    Text("Home")
                }
            
            Color.red
                .edgesIgnoringSafeArea(.all)
                .tabItem {
                    Text("Search")
                }
        }
       
    }
}

#Preview {
    ContentView()
}
