import Foundation

enum NetworkError: Error {
    case invalidURL
    case httpResponse
    case parsingError
    case dataError
    case invalidQuery

    func localizedDescription() -> String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .httpResponse:
            return "HTTP response error"
        case .parsingError:
            return "Parsing error"
        case .dataError:
            return "Data error"
        case .invalidQuery:
            return "Invalid Query"
        }
    }

}
func fetchJson() {
    guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
        return
    }

    URLSession.shared.dataTask(with: url, completionHandler: { data, reponse, error in
        if let data {
            print(String(data: data, encoding: .utf8) ?? "No data")
        }

    }).resume()
}

print(fetchJson())

func fetchJson1() async throws {
    guard let url = URL(string: "https://jsonplaceholder.typicode.com/postss") else {
        throw NetworkError.invalidURL
    }

    do {
        let (data, response) = try await URLSession.shared.data(from: url)

        // Check HTTP status code
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            throw NetworkError.httpResponse
        }

        let json = try JSONSerialization.jsonObject(with: data)
        print(json)
    } catch {
        throw NetworkError.dataError
    }
}


func fetch() {
    Task {
        do {
            try await fetchJson1()
        } catch {
            print("Error:", error)
        }
    }
}
print(fetch())

func fetchMultipleJson() async {
    let endpoints = [
        "https://jsonplaceholder.typicode.com/posts",
        "https://jsonplaceholder.typicode.com/comments",
        "https://jsonplaceholder.typicode.com/users"
    ]

    await withTaskGroup(of: (String, String?).self) { group in
        for endpoint in endpoints {
            group.addTask {
                guard let url = URL(string: endpoint) else {
                    return (endpoint, nil)
                }

                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    let jsonString = String(data: data, encoding: .utf8)
                    return (endpoint, jsonString)
                } catch {
                    return (endpoint, "Error: \(error.localizedDescription)")
                }
            }
        }

        for await (endpoint, result) in group {
            print("Response from \(endpoint):\n")
            print(result ?? "No data")
            print("\n----------------------------\n")
        }
    }
}

Task {
    await fetchMultipleJson()
}

func listPhotos(inGallery name: String) async throws -> [String] {
    try await Task.sleep(for: .seconds(20))
    return ["IMG001", "IMG99", "IMG0404"]
}

func fetchJSON() {
    Task {
        do {
            let val = try await listPhotos(inGallery: "harpreet")
            print(val)
        } catch {
            NetworkError.dataError
        }
    }
}
print(fetchJSON())

func searchGitHubUsers(query: String) async throws {
    // Cancel early if search text is too short
    guard query.count >= 3 else {
        print("🔴 Search query too short — cancelling task.")
        throw NetworkError.invalidQuery
    }

    try Task.checkCancellation() // respect external cancellation

    guard let url = URL(string: "https://api.github.com/search/users?q=\(query)") else {
        throw NetworkError.invalidURL
    }

    let (data, response) = try await URLSession.shared.data(from: url)

    try Task.checkCancellation()

    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw NetworkError.httpResponse
    }

    if let json = try? JSONSerialization.jsonObject(with: data) {
        print("✅ Result for query '\(query)':\n\(json)")
    } else {
        throw NetworkError.dataError
    }
}

var currentTask: Task<Void, Never>?

@MainActor
func performSearch(query: String) {
    // Cancel any previous task
    currentTask?.cancel()

    currentTask = Task {
        do {
            try await searchGitHubUsers(query: query)
        } catch is CancellationError {
            print("⛔️ Task was cancelled.")
        } catch NetworkError.invalidQuery {
            print("❗️Query too short. Must be at least 3 characters.")
        } catch {
            print("⚠️ Error:", error)
        }
    }
}

print(performSearch(query: "ab"))
print(performSearch(query: "john"))

struct Config {
    static let maxUsers = 100
}

class DataLoader {
    lazy var data: [String] = loadData()
    func loadData() -> [String] {
        print("Loading data...")
        return ["Item1", "Item2"]
    }
}
let dl = DataLoader()
print(dl.data)
