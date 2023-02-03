import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Text("Choose your action in the \n Upper Navigation Menu\n...")
                .multilineTextAlignment(.center)
                .navigationTitle("GI Tool App")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        NavigationLink(destination: EnemiesView(), label: {
                            Text("Enemies").foregroundColor(.blue)
                        })
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: CharactersView(), label: {
                            Text("Characters").foregroundColor(.blue)
                        })
                    }
                }
        }
    }
}


struct EnemiesView: View {
    @ObservedObject private var viewModel = EnemiesViewModel()
    @State private var searchText = ""
    @State private var showingSaveAlert = false
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText)
            List {
                ForEach(viewModel.enemies.filter {
                    self.searchText.isEmpty ? true : $0.lowercased().hasPrefix(self.searchText.lowercased())
                }, id: \.self) { enemy in
                    Text(enemy.capitalized.replacingOccurrences(of: "-", with: " "))
                }
            }
            .navigationTitle("Enemies")
            .toolbar {
                 ToolbarItem(placement: .navigationBarTrailing) {
                     Button(action: {
                         self.saveEnemiesToFile()
                     }) {
                         Text("Save")
                     }
                 }
             }
            .onAppear(perform: viewModel.fetchEnemies)
        }
        .alert(isPresented: $showingSaveAlert) {
            Alert(title: Text("Status"), message: Text("Saved Enemies to file enemies.txt!"), dismissButton: .default(Text("OK")))
        }
    }
    
    private func saveEnemiesToFile() {
        let enemies = viewModel.enemies.joined(separator: "\n")
        
        if let data = enemies.data(using: .utf8) {
            let fileName = "enemies.txt"
            let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
            
            do {
                try data.write(to: fileURL)
                self.showingSaveAlert = true
            } catch {
                print("Failed to save Enemies to file enemies.txt!")
            }
        }
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}

struct CharactersView: View {
    @ObservedObject private var viewModel = CharactersViewModel()
    @State private var searchText = ""
    @State private var showingSaveAlert = false
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText)
            List {
                ForEach(viewModel.characters.filter {
                    self.searchText.isEmpty ? true : $0.lowercased().hasPrefix(self.searchText.lowercased())
                }, id: \.self) { character in
                    Text(character.capitalized.replacingOccurrences(of: "-", with: " "))
                }
            }
            .navigationTitle("Characters")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.saveCharactersToFile()
                    }) {
                        Text("Save")
                    }
                }
            }
            .onAppear(perform: viewModel.fetchCharacters)
        }
        .alert(isPresented: $showingSaveAlert) {
            Alert(title: Text("Status"), message: Text("Saved Characters to file characters.txt!"), dismissButton: .default(Text("OK")))
        }
    }
    
    private func saveCharactersToFile() {
        let characters = viewModel.characters.joined(separator: "\n")
        
        if let data = characters.data(using: .utf8) {
            let fileName = "characters.txt"
            let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
            
            do {
                try data.write(to: fileURL)
                self.showingSaveAlert = true
            } catch {
                print("Failed to save Characters to  file characters.txt!")
            }
        }
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
        }
}


struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")

                TextField("Search", text: $text)
                    .foregroundColor(.primary)

                if !text.isEmpty {
                    Button(action: {
                        self.text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill").foregroundColor(.primary)
                    }
                }
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10.0)
        }
        .padding(.horizontal)
    }
}

class CharactersViewModel: ObservableObject {
    @Published var characters = [String]()
    
    func fetchCharacters() {
        guard let url = URL(string: "https://api.genshin.dev/characters") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            
            let characters = try! JSONDecoder().decode([String].self, from: data)
            
            DispatchQueue.main.async {
                self.characters = characters
            }
        }.resume()
    }
}

class EnemiesViewModel: ObservableObject {
    @Published var enemies = [String]()
    
    func fetchEnemies() {
        guard let url = URL(string: "https://api.genshin.dev/enemies") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            
            let enemies = try! JSONDecoder().decode([String].self, from: data)
            
            DispatchQueue.main.async {
                self.enemies = enemies
            }
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
