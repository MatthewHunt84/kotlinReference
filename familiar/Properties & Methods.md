# Properties & Methods
#Android/Kotlin/Familiar

### Stored Properties

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Mutable property | `var name: String` | | |
| Immutable property | `let name: String` | `val name: String` | |
| With initial value | `var count = 0` | | |
| Optional property | `var name: String?` | | |
| Implicitly unwrapped | `var name: String!` | No equivalent | Use lateinit or nullable |
| Late initialization | `var name: String!` or `lazy var` | `lateinit var name: String` | Must be var, cannot be primitive |

### Computed Properties

> [!NOTE]
> Kotlin computed properties use explicit `get()` and optionally `set()` accessors. The syntax is very similar to Swift.

```swift
// Swift
var fullName: String {
    get {
        return "\(firstName) \(lastName)"
    }
    set {
        let parts = newValue.split(separator: " ")
        firstName = String(parts[0])
        lastName = String(parts[1])
    }
}
```

```kotlin
// Kotlin
var fullName: String
    get() = "$firstName $lastName"
    set(value) {
        val parts = value.split(" ")
        firstName = parts[0]
        lastName = parts[1]
    }
```

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Read-only computed | `var name: String { return ... }` | `val name: String get() = ...` | |
| With setter | `var name: String { get { } set { } }` | `var name: String` <br> `  get() = ...` <br> `  set(value) { }` | |
| Setter parameter | Implicit `newValue` | `set(value)` | Must specify parameter |
| Single-expression getter | `var name: String { firstName }` | `val name: String get() = firstName` | Need `get() =` syntax |

### Property Observers

> [!WARNING]
> Kotlin doesn't have `willSet`/`didSet` observers. Instead, use a backing field with a custom setter.

```swift
// Swift
var count = 0 {
    willSet {
        print("Will set to \(newValue)")
    }
    didSet {
        print("Changed from \(oldValue)")
    }
}
```

```kotlin
// Kotlin - use backing field
var count: Int = 0
    set(value) {
        println("Will set to $value (old: $field)")
        field = value
        println("Changed to $field")
    }
```

### Lazy Properties

> [!NOTE]
> Kotlin's `lazy` uses delegation syntax `by lazy`. It's thread-safe by default and initialized only once on first access.

```swift
// Swift
lazy var data: [String] = {
    return loadExpensiveData()
}()
```

```kotlin
// Kotlin
val data: List<String> by lazy {
    loadExpensiveData()
}
```

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Lazy property | `lazy var data = loadData()` | `val data by lazy { loadData() }` | Must be `val` |
| Access | `let result = data` | | Computed on first access |

### Type Properties / Static Properties

> [!NOTE]
> Kotlin doesn't have `static` keyword. Use companion objects (see Part 2) for class-level properties.

```swift
// Swift
class Counter {
    static var count = 0
    static let maxCount = 100
}

Counter.count
```

```kotlin
// Kotlin
class Counter {
    companion object {
        var count = 0
        const val MAX_COUNT = 100  // compile-time constant
    }
}

Counter.count
Counter.MAX_COUNT
```

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Static property | `static var count = 0` | Put in companion object | See Part 2 |
| Static constant | `static let max = 100` | `const val MAX = 100` in companion | |
| Access | `ClassName.property` | | |

### Instance Methods

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Basic method | `func greet() { }` | `fun greet() { }` | |
| With return | `func getName() -> String { }` | `fun getName(): String { }` | |
| With parameters | `func greet(name: String) { }` | | |
| Default parameters | `func greet(name: String = "World") { }` | | |
| Return self | `func update() -> Self { return self }` | `fun update(): User = this` | Use concrete type |

### Mutating Methods

> [!WARNING]
> Kotlin doesn't have `mutating` keyword. Methods on classes can always mutate state. For `val` properties, you cannot reassign them, but you can mutate their contents if they're mutable types.

```swift
// Swift struct
struct Point {
    var x: Int
    var y: Int
    
    mutating func moveBy(dx: Int, dy: Int) {
        x += dx
        y += dy
    }
}
```

```kotlin
// Kotlin - classes don't need mutating keyword
class Point(var x: Int, var y: Int) {
    fun moveBy(dx: Int, dy: Int) {
        x += dx
        y += dy
    }
}
```

### Type Methods / Static Methods

> [!NOTE]
> Again, use companion objects for class-level methods. See Part 2 for details.

```swift
// Swift
class Math {
    static func abs(_ x: Int) -> Int {
        return x < 0 ? -x : x
    }
}

Math.abs(-5)
```

```kotlin
// Kotlin
class Math {
    companion object {
        fun abs(x: Int): Int {
            return if (x < 0) -x else x
        }
    }
}

Math.abs(-5)
```

### Method Overloading

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| By parameter count | `func print(_ x: Int) { }` <br> `func print(_ x: Int, _ y: Int) { }` | `fun print(x: Int) { }` <br> `fun print(x: Int, y: Int) { }` | |
| By parameter type | `func process(_ x: Int) { }` <br> `func process(_ x: String) { }` | `fun process(x: Int) { }` <br> `fun process(x: String) { }` | |
| By return type | Can distinguish with context | Not allowed | Must differ by parameters |

### Subscripts

> [!NOTE]
> Kotlin uses `operator` functions instead of subscripts. You can overload `get` and `set` operators to achieve similar functionality.

```swift
// Swift
class Matrix {
    subscript(row: Int, col: Int) -> Int {
        get { return data[row][col] }
        set { data[row][col] = newValue }
    }
}

let value = matrix[0, 1]
matrix[0, 1] = 5
```

```kotlin
// Kotlin
class Matrix {
    operator fun get(row: Int, col: Int): Int {
        return data[row][col]
    }
    
    operator fun set(row: Int, col: Int, value: Int) {
        data[row][col] = value
    }
}

val value = matrix[0, 1]
matrix[0, 1] = 5
```

### Access Control in Properties

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Public | `public var name: String` | `var name: String` | Public by default in Kotlin |
| Private | `private var count: Int` | | |
| Private setter | `private(set) var count: Int` | `var count: Int` <br> `  private set` | |
| Protected | N/A for properties | `protected var value: Int` | Only in classes |

### Backing Fields

> [!NOTE]
> In Kotlin, use `field` keyword to access the backing field inside custom accessors. This is how you implement property observers.

```kotlin
var name: String = ""
    get() = field.uppercase()  // field refers to the backing storage
    set(value) {
        println("Setting name to $value")
        field = value  // field is the actual storage
    }
```

### Property Delegation

> [!NOTE]
> Kotlin has powerful property delegation using `by` keyword. The most common is `lazy`, but you can create custom delegates. See Part 2 for details.

```kotlin
// Lazy
val data by lazy { loadData() }

// Observable
var name: String by Delegates.observable("initial") { prop, old, new ->
    println("$old -> $new")
}

// Custom delegation - see Part 2
```

### Extension Properties

> [!NOTE]
> Both languages support adding computed properties to existing types via extensions. See Part 2 for Kotlin details.

```swift
// Swift
extension String {
    var firstLetter: Character? {
        return self.first
    }
}
```

```kotlin
// Kotlin
val String.firstLetter: Char?
    get() = this.firstOrNull()
```

### Inlining Getters/Setters

> [!NOTE]
> Kotlin has `inline` keyword for properties with backing fields, but it's rarely needed. It's different from Swift's `@inline`.

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Inline hint | `@inline(__always) var x: Int` | `inline var x: Int` | Different purposes |

### Key Differences to Remember

> [!TIP]
> **Kotlin advantages:**
> - `lateinit` for late initialization (no need for optionals)
> - Property delegation with `by` for common patterns
> - Backing field with `field` keyword is cleaner
> - `const val` for compile-time constants

> [!WARNING]
> **Watch out for:**
> - No `willSet`/`didSet` - use backing field with setter
> - `lazy` must be `val`, not `var`
> - No `static` keyword - use companion objects
> - Must specify setter parameter name (no implicit `newValue`)
> - Private setter uses different syntax: `private set`
> - No `mutating` keyword - not needed for classes
> - Use `operator fun get/set` instead of subscripts
> - Use `field` to access backing storage in accessors