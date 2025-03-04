import SwiftUI

// Structs to match the JSON structure
struct BasketballGame: Codable {
    let id: Int
    let date: String
    let team: String
    let opponent: String
    let isHomeGame: Bool
    let score: GameScore
}

struct GameScore: Codable {
    let unc: Int
    let opponent: Int
}

struct ContentView: View {
    @State private var games = [BasketballGame]()
    
    var body: some View {
        NavigationView {
            List(games, id: \.id) { game in
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(game.team) vs. \(game.opponent)")
                            .font(.headline)
                        Text(formatDate(game.date))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("\(game.score.unc) - \(game.score.opponent)")
                            .font(.headline)
                        Text(game.isHomeGame ? "Home" : "Away")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical, 5)
            }
            .navigationTitle("UNC Basketball")
            .task {
                await loadData()
            }
        }
    }
    
    func formatDate(_ date: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "MM/dd/yy"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .medium
        
        if let dateObj = inputFormatter.date(from: date) {
            return outputFormatter.string(from: dateObj)
        } else {
            return date // Fallback to original format
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else {
            print("Invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode([BasketballGame].self, from: data)
            
            games = decodedResponse.self

        } catch {
            print("Error fetching data")
        }
    }
}

#Preview {
    ContentView()
}
