import UIKit

/*:
 # Asynchronous and Parallel Code (Concurrency) in Swift

 ## Definition
 **Concurrency** in Swift refers to the combination of **asynchronous** and **parallel** code execution.
 -   **Asynchronous code** can be suspended and resumed later, allowing a program to make progress on other tasks (e.g., updating UI) while waiting for long-running operations (e.g., network requests). Only one piece of asynchronous code truly executes at a time on a single thread.
 -   **Parallel code** means multiple pieces of code run *simultaneously* on different processor cores.

 Swift's language-level support for concurrency helps prevent **data races** (when multiple pieces of code access shared mutable state concurrently), often detecting them at compile time or terminating execution at runtime. This is primarily achieved through **actors and isolation**, eliminating the direct need to manage threads.

 ---

 ## Defining and Calling Asynchronous Functions

 An **asynchronous function** (or method) can pause its execution while waiting for something (like a network response) and then resume.

 -   Mark an asynchronous function with the `async` keyword after its parameters. If it returns a value, `async` goes before the `->`.
 -   If it's also throwing, write `async throws`.
 -   When calling an asynchronous function, use the `await` keyword. This marks a potential **suspension point** where the current task might pause, allowing other concurrent code to run on the same thread.

 */
print("--- Asynchronous Functions in Action ---")

// Simulate a network request that takes 2 seconds
func listPhotos(inGallery name: String) async throws -> [String] {
    print("  (Start fetching photos for '\(name)')...")
    try await Task.sleep(for: .seconds(2)) // Simulate network delay
    print("  (Finished fetching photos for '\(name)').")
    return ["IMG001.jpg", "IMG99.png", "IMG0404.heic"]
}

// Simulate downloading a single photo
func downloadPhoto(named name: String) async -> Data {
    print("  (Start downloading '\(name)')...")
    try? await Task.sleep(for: .seconds(1)) // Simulate network delay
    print("  (Finished downloading '\(name)').")
    return Data("Photo data for \(name)".utf8)
}

// Dummy function to "show" a photo
func show(_ photo: Data) {
    print("  Showing photo: '\(String(data: photo, encoding: .utf8) ?? "Unknown")'")
}

// An asynchronous function that uses other async functions
func processGallery(galleryName: String) async {
    print("Starting process for '\(galleryName)'...")
    do {
        let photoNames = try await listPhotos(inGallery: galleryName) // Potential suspension point
        print("Got photo names: \(photoNames)")

        let sortedNames = photoNames.sorted()
        let firstName = sortedNames[0]

        let photoData = await downloadPhoto(named: firstName) // Another potential suspension point
        show(photoData)
        print("Finished processing for '\(galleryName)'.")
    } catch {
        print("Error processing gallery: \(error)")
    }
}

// Call an async function from a task (or `@main` entry point)
Task {
    await processGallery(galleryName: "Summer Vacation")
    print("Main task finished after Summer Vacation.")
}

/*:
 -   **Key takeaway for `await`:** It signals that the current piece of code might temporarily **yield the thread**, allowing other concurrent code to execute while it waits for a result.
 -   Asynchronous functions can only be called from other asynchronous contexts (e.g., another `async` function, a `Task`, or an `@main` type).
 */

/* Asynchronous Sequences (`for await in`)

An **asynchronous sequence** allows you to iterate over elements one at a time as they become available asynchronously, rather than waiting for the entire collection to be ready.

*/
print("\n--- Asynchronous Sequences ---")

// Example: Simulating a stream of data lines
struct AsyncLineStream: AsyncSequence, AsyncIteratorProtocol {
    typealias Element = String
    private var lines = ["Line 1", "Line 2", "Line 3", "End"]
    private var index = 0

    mutating func next() async throws -> String? {
        // Simulate an asynchronous delay before providing the next element
        try await Task.sleep(for: .milliseconds(500))
        guard index < lines.count else { return nil }
        let line = lines[index]
        index += 1
        return line == "End" ? nil : line // "End" signals completion
    }

    func makeAsyncIterator() -> AsyncLineStream {
        return self
    }
}

Task {
    print("Reading from async stream:")
    for try await line in AsyncLineStream() { // `for await in`
        print("  Received: \(line)")
    }
    print("Finished reading from async stream.")
}

/*:
 -   `for await in` is used when iterating over types conforming to `AsyncSequence`.
 -   Each iteration of a `for await in` loop is a potential suspension point.

 ---

 ## Calling Asynchronous Functions in Parallel (`async let`)

 Using `await` runs tasks sequentially. To run multiple asynchronous operations **in parallel** when their results aren't immediately dependent on each other, use `async let`.

 */
print("\n--- Calling Functions in Parallel (`async let`) ---")

func downloadLargePhoto(named name: String) async -> Data {
    print("    Starting large download for \(name)...")
    try? await Task.sleep(for: .seconds(2)) // Longer delay
    print("    Finished large download for \(name).")
    return Data("Large photo of \(name)".utf8)
}

Task {
    print("Beginning parallel downloads...")
    // All three downloads start immediately (or as resources allow)
    async let photo1 = downloadLargePhoto(named: "Waterfall")
    async let photo2 = downloadLargePhoto(named: "Mountain")
    async let photo3 = downloadLargePhoto(named: "Forest")

    // The `await` here waits for ALL of them to complete
    let downloadedPhotos = await [photo1, photo2, photo3]
    print("All parallel downloads complete. Showing all photos.")
    downloadedPhotos.forEach { show($0) }
}

/*:
 -   `async let` defines a constant that will eventually hold the result of an asynchronous operation. The operation starts immediately.
 -   You use `await` *only when you need the result* of that `async let` constant.

 ---

 ## Tasks and Task Groups (Structured Concurrency)

 A **task** is a unit of asynchronous work. All asynchronous code runs within a task. Swift's concurrency model emphasizes **structured concurrency**, where tasks form a hierarchy (parent-child relationships).

 -   **`Task { ... }`**: Creates an unstructured task that runs similarly to the surrounding code (inherits priority, actor isolation).
 -   **`Task.detached { ... }`**: Creates an unstructured, independent task (doesn't inherit priority, actor isolation, or task-local state).
 -   **`withTaskGroup { ... }`**: Creates a **task group**, allowing you to dynamically create and manage multiple **child tasks**. This provides strong guarantees:
    -   You can't forget to `await` for child tasks to complete.
    -   Cancellation of a parent task automatically cancels child tasks.
    -   Priority escalation propagates to children.

 */
print("\n--- Tasks and Task Groups (Structured Concurrency) ---")

Task {
    print("Using a task group to download photos dynamically:")
    // `of: Data.self` specifies the type of result each child task returns.
    // `returning: Void.self` indicates the group itself won't return a value directly,
    // we'll just process results as they come.
    await withTaskGroup(of: Data?.self) { group in
        let photoNames = ["Cityscape", "Ocean View", "Desert Sunset", "Aurora"]
        for name in photoNames {
            // Adds a child task to the group. `addTaskUnlessCancelled` is for cooperative cancellation.
            group.addTaskUnlessCancelled {
                // Each child task can run concurrently
                if Task.isCancelled {
                    print("    Task for \(name) was cancelled before starting download.")
                    return nil
                }
                return await downloadLargePhoto(named: name)
            }
        }

        // Iterate over the results of child tasks as they complete
        for await photoResult in group {
            if let photo = photoResult {
                show(photo)
            }
        }
        print("All task group downloads processed.")
    }
}

/*:
 ### Task Cancellation (Cooperative)

 Swift's cancellation model is **cooperative**. A task must explicitly check if it has been canceled and respond accordingly.

 -   `Task.checkCancellation()`: Throws a `CancellationError` if the task is canceled.
 -   `Task.isCancelled`: A boolean property to check cancellation status, allowing for custom clean-up.
 -   `addTaskUnlessCancelled`: Prevents adding new child tasks if the group is already canceled.
 -   `Task.withTaskCancellationHandler`: For immediate notification of cancellation.

 */
print("\n--- Task Cancellation ---")

// Example of a cancellable long-running task
let longRunningTask = Task {
    for i in 1...10 {
        try Task.checkCancellation() // Check for cancellation
        print("  Long task step \(i)...")
        try await Task.sleep(for: .milliseconds(300))
    }
    print("  Long task completed normally.")
}

Task {
    try? await Task.sleep(for: .seconds(1)) // Wait a bit
    print("Requesting cancellation of long task.")
    longRunningTask.cancel() // Cancel the task
}

/*:
 ---

 ## Isolation (Protecting Shared Data)

 **Data isolation** means Swift ensures that when you read or modify a piece of data, no other code is modifying it concurrently, preventing **data races**.

 -   **Immutable data:** Constants (`let`) are inherently safe.
 -   **Task-local data:** Local variables within a task are safe because only that task has access.
 -   **Actors:** The primary mechanism for protecting **mutable shared state**. An actor allows only one task to access its mutable state at a time.

 ### The Main Actor (`@MainActor`)

 The **main actor** is a special actor that protects all data related to the UI. All UI updates **must** run on the main actor to prevent data races and ensure thread safety for UI operations.

 -   Mark functions, properties, or entire types with `@MainActor` to ensure they run on the main actor.
 -   Accessing main actor-isolated properties or calling main actor-isolated functions from non-main actor code requires `await`, as it's a potential suspension point (switching execution context).

 */
print("\n--- Main Actor and Isolation ---")

@MainActor
func updateUI(with text: String) {
    print("  UI Updated: \(text) (on Main Actor)")
    // In a real app, this would update a UILabel, etc.
}

func fetchDataAndDisplay(name: String) async {
    print("Fetching data for \(name) in background...")
    let data = await downloadLargePhoto(named: name) // Background work

    // Switch to main actor to update UI
    await updateUI(with: String(data: data, encoding: .utf8) ?? "N/A")
    print("Finished fetching and displaying for \(name).")
}

Task {
    await fetchDataAndDisplay(name: "Sunset")
}

/*:
 ### Custom Actors

 You can define your own **actors** using the `actor` keyword to protect mutable state. Like classes, actors are reference types.

 -   Accessing an actor's properties or methods from *outside* the actor requires `await`.
 -   Code *inside* the actor can access its properties and methods synchronously, as the actor ensures single-threaded access to its state.

 */
print("\n--- Custom Actors ---")

actor TemperatureLogger {
    let label: String
    private(set) var measurements: [Int] // private(set) makes setter private to actor
    private var maxMeasurement: Int

    init(label: String, initialMeasurement: Int) {
        self.label = label
        self.measurements = [initialMeasurement]
        self.maxMeasurement = initialMeasurement
    }

    // This method is isolated to the actor, no `await` needed for internal access
    func record(measurement: Int) {
        measurements.append(measurement)
        if measurement > maxMeasurement {
            maxMeasurement = measurement
        }
        print("  \(label) recorded: \(measurement). Current max: \(maxMeasurement).")
    }

    // This method is isolated to the actor
    func getMaxMeasurement() -> Int {
        return maxMeasurement
    }

    // An example of an actor method accessing its state
    func getRecentMeasurements(count: Int) -> [Int] {
        return Array(measurements.suffix(count))
    }
}

Task {
    let logger = TemperatureLogger(label: "Server Room", initialMeasurement: 20)

    // Accessing actor properties/methods from outside requires `await`
    print("Initial max for \(await logger.label): \(await logger.getMaxMeasurement())")

    // Concurrent tasks interacting with the same actor instance
    async let task1 = logger.record(measurement: 22)
    async let task2 = logger.record(measurement: 18)
    async let task3 = logger.record(measurement: 25)

    _ = await [task1, task2, task3] // Wait for all records to complete

    print("Final max for \(await logger.label): \(await logger.getMaxMeasurement())") // Will be 25
    print("Recent measurements: \(await logger.getRecentMeasurements(count: 3))")
}

/*:
 Swift's concurrency model, with `async`/`await`, structured tasks, and actors, provides a powerful and safe way to write concurrent code, significantly reducing the common pitfalls of multithreading. It allows for efficient use of system resources while keeping your code readable and robust against data races.
 */
