//
//  DropdownMenu.swift
//  GI-Tool-App
//
//  Created by Patrik Lehner on 31.01.2023.
//

import SwiftUI

struct TestView: View {
    @State var results = [Character]()

    var body: some View {
        List(results.indices, id: \.self) { index in
            Text(self.results[index].name)
        }.onAppear(perform: loadData)
    }

    func loadData() {
        let characterEndpoint = "https://api.genshin.dev/characters/zhongli/"

        
        let url = URL(string: characterEndpoint)!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("Error: \(error!.localizedDescription)")
                return
            }
            
            do {
                let character = try JSONDecoder().decode(Character.self, from: data)
                
                print("Name: \(character.name)")
                print("Rarity: \(character.rarity)")
                print("Weapon: \(character.weapon)")
                print("Nation: \(character.nation)")
            } catch let error {
                print("Error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
