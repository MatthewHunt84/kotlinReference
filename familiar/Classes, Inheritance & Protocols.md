# Classes, Inheritance & Protocols
#Android/Kotlin/Familiar

### Basic Class Definition

> [!NOTE]
> Kotlin classes are final by default (cannot be subclassed). Use `open` keyword to allow inheritance. This is opposite to Swift where classes are open by default.

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Define class | `class Person { }` | | |
| Inheritable class | - | `open class Person { }` | Must use `open` keyword |
| Final class | `final class Person { }` | `class Person { }` | Final by default in Kotlin |

### Initializers / Constructors

> [!NOTE]
> Kotlin has a primary constructor in the class header, which can include property declarations. Secondary constructors are less common but available.

```swift
// Swift
class Person {
    let name: String
    var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

// When creating an instance we stick with colons (kotlin uses equals signs)
let person = Person(name: "Alice", age "28")
```

```kotlin
// Kotlin - primary constructor in class header
class Person(val name: String, var age: Int)

// Or with body:
class Person(val name: String, var age: Int) {
    init {
        // initialization code
    }
}

// When creating an instance kotlin uses equals signs
let person = Person(name = "Alice", age = "28")
```

In the examples above, both arguments are properties of that class - so they have a `val` or `var` in front of the argument label. You can also pass in an argument which is not a property! For example:
```kotlin
// Kotlin

// While name is a property of this class, both age and multiplier are not - they're just passed in to calculate the readingAge
class Person(val name: String, age: Int, multiplier: Int) {
	var readingAge: Int = age * multiplier // Note that this isn't in the Person declaration above. It's okay to assign it inside the class body
}

val test = Person(name = "Alice", age = 25, multiplier = 2)
println(test.readingAge) // prints 50

```

In swift we can create multiple init methods which take various properties like this:
```swift
// Swift
class Person {
    let name: String
    let readingAge: Int
    
    init(name: String, age: Int, multiplier: Int) {
        self.name = name
        self.age = age * multiplier
    }
}
```

In kotlin we do the same thing with a **secondary constructor**
```kotlin
class Person(val name: String, val readingAge: Int) {
    
    constructor(name: String, age: Int, multiplier: Int) : this( // note the use of THIS here
        name = student.name,
        readingAge = age * multiplier
    )
}

val person = Person(name = "Alice", age = 25, multiplier = 50)
println("${person.name}, ${person.readingAge}")  // Alice, 50
```

> [!TIP] Although this is similar to swift, in practice when initializing from another class kotlin folk tend to prefer companion object factories like the one below
> ```kotlin
> // Kotlin
> // Lets say we're initializing from a different class
> data class Student(val name: String, val age: Double)
> 
> class Person(val name: String, val readingAge: Int) {
>     companion object {
>         fun fromStudent(student: Student): Person {
>             return Person(
>                 name = student.name,
>                 readingAge = student.age.toInt() * 2
>             )
>         }
>     }
> }


| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Primary constructor | `init(name: String) { }` | `class Person(val name: String)` | In class header |
| Constructor with body | `init() { ... }` | `init { ... }` | Use `init` block |
| Secondary constructor | Additional `init` methods | `constructor(name: String) : this(name, 0) { }` | Must call primary |
| Default parameters | `init(name: String = "Unknown") { }` | `class Person(val name: String = "Unknown")` | |

### Properties

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Stored property | `var name: String` | `var name: String` | |
| Immutable property | `let name: String` | `val name: String` | |
| Computed property | `var fullName: String { return "\(first) \(last)" }` | `val fullName: String get() = "$first $last"` | |
| With setter | `var name: String { get { } set { } }` | `var name: String` <br> `  get() = ...` <br> `  set(value) { }` | |
| Lazy property | `lazy var data = loadData()` | `val data by lazy { loadData() }` | Use delegation |
| Property observer | `var count = 0 { didSet { } }` | Not built-in | Use custom setter |

### Methods

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Instance method | `func greet() { }` | `fun greet() { }` | |
| Method with params | `func greet(name: String) { }` | | |
| Overridable method | `func draw() { }` | `open fun draw() { }` | Must use `open` |
| Override method | `override func draw() { }` | | |
| Final method | `final func draw() { }` | `fun draw() { }` | Final by default |

### Inheritance

> [!WARNING]
> Remember: Kotlin classes and methods are final by default. Must use `open` to allow inheritance/overriding.

```swift
// Swift
class Animal {
    func makeSound() { }
}

class Dog: Animal {
    override func makeSound() {
        print("Woof")
    }
}
```

```kotlin
// Kotlin
open class Animal {
    open fun makeSound() { }
}

class Dog : Animal() {
    override fun makeSound() {
        println("Woof")
    }
}
```

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Inherit from class | `class Dog: Animal { }` | `class Dog : Animal() { }` | Must call superclass constructor |
| Call super | `super.method()` | | |
| Override | `override func method() { }` | `override fun method() { }` | |
| Prevent override | `final func method() { }` | `final override fun method() { }` | Only needed when overriding |

### Protocols / Interfaces

> [!NOTE]
> Kotlin uses `interface` keyword. Unlike Swift protocols, Kotlin interfaces can have default implementations (like protocol extensions in Swift, but built-in).

```swift
// Swift
protocol Drawable {
    func draw()
}

class Circle: Drawable {
    func draw() {
        // implementation
    }
}
```

```kotlin
// Kotlin
interface Drawable {
    fun draw()
}

class Circle : Drawable {
    override fun draw() {
        // implementation
    }
}
```

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Define protocol | `protocol Named { }` | `interface Named { }` | |
| Required method | `func getName() -> String` | `fun getName(): String` | |
| Required property | `var name: String { get }` | `val name: String` | |
| Conform to protocol | `class Person: Named { }` | `class Person : Named { }` | |
| Multiple protocols | `class Person: Named, Aged { }` | `class Person : Named, Aged { }` | |
| Protocol with default | Extension with default implementation | `interface Named {` <br> `  fun getName() = "Unknown"` <br> `}` | Built into interface |

### Abstract Classes

> [!NOTE]
> Both languages support abstract classes that cannot be instantiated and can have abstract methods.

```swift
// Swift - protocols are more common
```

```kotlin
// Kotlin
abstract class Shape {
    abstract fun area(): Double
    
    fun describe() {
        println("Area: ${area()}")
    }
}

class Circle(val radius: Double) : Shape() {
    override fun area() = Math.PI * radius * radius
}
```

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Abstract class | Not directly supported | `abstract class Shape { }` | |
| Abstract method | - | `abstract fun area(): Double` | |
| Cannot instantiate | - | Cannot create `Shape()` | |

### Type Checking and Casting

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Type check | `if obj is String { }` | `if (obj is String) { }` | |
| Safe cast | `obj as? String` | | |
| Force cast | `obj as! String` | `obj as String` | |
| Smart cast | Limited | Automatic after type check | Kotlin is more powerful |

### Static Members / Class Members

> [!NOTE]
> Kotlin doesn't have `static` keyword. Instead, use companion objects (see Part 2) or package-level functions.

```swift
// Swift
class Math {
    static let pi = 3.14159
    static func abs(_ x: Int) -> Int { }
}

Math.pi
Math.abs(-5)
```

```kotlin
// Kotlin - see Part 2 for companion objects
class Math {
    companion object {
        const val PI = 3.14159
        fun abs(x: Int): Int { }
    }
}

Math.PI
Math.abs(-5)
```

### Visibility Modifiers

> [!NOTE]
> Kotlin has four visibility modifiers. The default is `public`, unlike Swift where the default is `internal`.

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Public | `public class Person { }` | `class Person { }` or `public class Person { }` | Public by default in Kotlin |
| Internal | `internal class Person { }` | `internal class Person { }` | Module-level |
| Private | `private var count = 0` | `private var count = 0` | File-level in Kotlin for top-level |
| Fileprivate | `fileprivate var count = 0` | `private var count = 0` | Same as private for top-level |
| Protected | `// N/A for classes` | `protected open fun method() { }` | Available in Kotlin |

### Nested Classes

> [!NOTE]
> **Important**: Kotlin's nested classes are static by default (don't hold reference to outer class). Use `inner` keyword for Swift-like behavior.

```swift
// Swift - nested classes hold reference to outer
class Outer {
    var value = 10
    
    class Nested {
        func getValue() -> Int {
            // Can access outer's properties
        }
    }
}
```

```kotlin
// Kotlin - nested class is static by default
class Outer {
    var value = 10
    
    class Nested {
        // Cannot access outer's properties
    }
    
    inner class Inner {
        fun getValue() = value  // Can access outer's properties
    }
}
```

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Nested class | `class Nested { }` | `class Nested { }` | Static in Kotlin |
| Inner class (non-static) | Default behavior | `inner class Inner { }` | Must use `inner` keyword |
| Access outer | `// automatic` | `this@Outer` | Explicit syntax needed |

### Extensions

> [!NOTE]
> Both languages support extending existing classes. See Part 2 for detailed Kotlin extension functions.

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Extend class | `extension String { }` | `fun String.method() { }` | No wrapper in Kotlin |
| Add method | Inside extension block | Define extension function | See Part 2 |

### Structs

> [!WARNING]
> Kotlin doesn't have structs. Use data classes instead (see Part 2), which are similar but are reference types, not value types.

### Enums

> [!NOTE]
> See the Control Flow section for `when` expressions, which work great with enums. Kotlin enums can have properties and methods.

```swift
// Swift
enum Direction {
    case north, south, east, west
}
```

```kotlin
// Kotlin
enum class Direction {
    NORTH, SOUTH, EAST, WEST
}

// With properties
enum class Direction(val degrees: Int) {
    NORTH(0), SOUTH(180), EAST(90), WEST(270)
}
```

### Key Differences to Remember

> [!TIP]
> **Kotlin advantages:**
> - Primary constructor syntax is more concise
> - Smart casts reduce boilerplate
> - Interfaces can have default implementations
> - Protected visibility available

> [!WARNING]
> **Watch out for:**
> - Classes and methods are **final by default** - must use `open`
> - No `static` keyword - use companion objects (Part 2)
> - Nested classes are static by default - use `inner` for non-static
> - Must call superclass constructor with `()`: `Animal()`
> - No structs - use data classes (Part 2)
> - `interface` keyword, not `protocol`
> - Public is the default visibility
> - Property observers not built-in - use custom setters
