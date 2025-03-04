//
//  ContentView.swift
//  iTunesSearch
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

//1. Find API info
//2. Make URL
//3. Make request with URLSession
//4. Create Codable Types to match this JSON
//5. Use JSONDecoder to fill in Swift types from Data
//6. Update State

struct iTunesSearchResponse: Codable{
    var results: [iTunesSearchResult]
}

struct iTunesSearchResult: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}

struct ContentView: View {
    @State private var results = [iTunesSearchResult]()
    
    
    var body: some View {
        List(results, id: \.trackId){ item in
            VStack(alignment: .leading){
                Text(item.trackName).font(.headline)
                Text(item.collectionName)
        }
        }.task{
            await loadData()
        }
     
    }
    
    func loadData() async{
        guard let url = URL(string: "https://itunes.apple.com/search?term=beatless&entity=song") else{
            print("Invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode(iTunesSearchResponse.self, from: data){
                results = decodedResponse.results
            }
        } catch {
            print("Invalid Data")
        }
        
    }
    
    
}

#Preview {
    ContentView()
}
