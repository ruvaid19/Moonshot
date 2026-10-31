//
//  ContentView.swift
//  Moonshot
//
//  Created by Ruvaid on 23/10/26.
//

import SwiftUI

struct Astronaut: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
}

struct Mission: Codable, Identifiable {
    struct CrewRole: Codable {
        let name: String
        let role: String
    }

    let id: Int
    let launchDate: String?
    let crew: [CrewRole]
    let description: String
}

extension Bundle {
    func decode<T: Codable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()

        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError(
                "Failed to decode \(file) from bundle due to missing key '\(key.stringValue)' – \(context.debugDescription)"
            )
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError(
                "Failed to decode \(file) from bundle due to type mismatch – \(context.debugDescription)"
            )
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError(
                "Failed to decode \(file) from bundle due to missing \(type) value – \(context.debugDescription)"
            )
        } catch DecodingError.dataCorrupted(_) {
            fatalError(
                "Failed to decode \(file) from bundle because it appears to be invalid JSON."
            )
        } catch {
            fatalError(
                "Failed to decode \(file) from bundle: \(error.localizedDescription)"
            )
        }
    }
}

struct ContentView: View {
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")

    var body: some View {
        VStack(spacing: 10) {
            Text("Astronauts: \(astronauts.count)")
            Text("Missions: \(missions.count)")
        }
    }
}

#Preview {
    ContentView()
}
