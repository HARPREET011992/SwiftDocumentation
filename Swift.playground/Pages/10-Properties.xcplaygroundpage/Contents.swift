import Foundation

// stored and computed properties

// Stored Property
var name = "Harpreet"
var lastName = "Kaur"

// Computed Property (it is variable property whose value is calculated every time it is used
//it  don't store anthing in memory just calculate everything on the go

// read only computed property
var fullName: String {
    return "\(name) \(lastName)"
}

// read-write computed proerty
var fullName2: String {
    get {
        return "\(name) \(lastName)"
    }
    set {
        let components = newValue.split(separator: " ")
        if components.count == 2 {
            name = String(components[0])
            lastName = String(components[1])
        }
    }
}


print(fullName)

//Lazy stored Property (its initial value is not calculated until it is used for first time)

class DataManager {
    init() {
        print("DataManager initialized")
    }

    func loadData() -> String {
        return "Data loaded!"
    }
}

class AppController {
    lazy var dataManager = DataManager()  // Lazy property

    func start() {
        print("App started")
        print(dataManager.loadData())  // Triggers initialization of dataManager
    }
}

let app = AppController()
app.start()

// Property Observer is used to observe and respond to changes in property

struct Counter {
    var totalSteps: Int = 0 {
        willSet {
            print("About to take \(newValue) steps")
        }
        didSet {
            if totalSteps > oldValue {
                print("Congratulations on taking more steps!")
            }
        }
    }
}

var counter = Counter()
counter.totalSteps = 100
counter.totalSteps = 200


struct CalculateArea {
    var width: Double {
        willSet {
            print("Width is about to be set to \(newValue)")
        }
        didSet {
            if width > oldValue {
                print("Width increased!")
            }
        }
    }
    var height: Double {
        willSet {
            print( "Height is about to be set to \(newValue)")
        }
        didSet {
            print( "Height increased!")
        }
    }

    var area: Double {
        get {
            width * height
        }
    }

}

var calculateArea = CalculateArea(width: 10, height: 20)

print("Initial area: \(calculateArea.area)")

calculateArea.width = 30
calculateArea.height = 40

print("Updated area: \(calculateArea.area)")

