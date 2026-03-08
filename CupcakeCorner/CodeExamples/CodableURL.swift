//
//  CodableURL.swift
//  CupcakeCorner
//  https://youtu.be/U_yWXH141DY
//  Created by Uri on 7/3/26.
//

import SwiftUI

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}

struct CodableURL: View {

    @State private var results: [Result] = []

    var body: some View {
        List(results, id: \.trackId) { item in
            VStack(alignment: .leading) {
                Text(item.trackName)
                    .font(.headline)

                Text(item.collectionName)
            }
        }
        .task {
            await loadData()
        }
    }
}

#Preview {
    CodableURL()
}

extension CodableURL {

    private func loadData() async {
        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
            debugPrint("Invalid URL")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                results = decodedResponse.results
            }
        } catch {
            debugPrint("Invalid data")
        }

    }
}
