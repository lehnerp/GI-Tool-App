//
//  ContentView.swift
//  GI-Tool-App
//
//  Created by Patrik Lehner on 31.01.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Text("To-Do")
                .navigationTitle("GI Tool App")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button("Bosses") {}
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Characters") {}
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
