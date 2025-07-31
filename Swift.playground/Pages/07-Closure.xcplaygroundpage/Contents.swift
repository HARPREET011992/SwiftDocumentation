import Foundation

// Closure is self-contained block of code that can be passed around and used in your code

// -> Escaping closure
// -> Non - Escaping closure
// -> Trailing closure
// -> Auto closure

// Non - Escaping closure(by-default)

let sumClosure : ((Int, Int) -> Int) = { (a, b) in
    a + b
}

let value = sumClosure(3,4)
print(value)

func sum(a:Int, b: Int, sumClosure: (Int, Int) -> Int) {
    let result = sumClosure(a, b)
    print(result)
}

//Trailing closure A closure placed outside the function parentheses if it's the last parameter.
sum(a: 3, b: 19) { $0 + $1 }

// Escaping closure
func processData(completion: @escaping (Int) -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//        completion(42)
    }
}

struct User: Decodable {
     let userId: Int
      let id: Int
      let title: String
      let completed: Bool
}

func processData(completion: @escaping (User?) -> Void) {
    guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1") else {
        completion(nil)
        return }
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let data {
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                completion(user)
            } catch {
                print("Decoding error:", error)
                completion(nil)
            }
        } else {
            print("Network error:", error ?? "Unknown error")
            completion(nil)
        }

    }.resume()
}

func fetchApi() {
    processData { user in
        if let user = user {
            print("User ID:", user.userId)
        } else {
            print("Failed to fetch user.")
        }
    }
}

print(fetchApi())
