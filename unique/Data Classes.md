# Data Classes
#android/Kotlin/Unique

> [!NOTE]
> Data classes are Kotlin's solution for classes that primarily hold data. They automatically generate `equals()`, `hashCode()`, `toString()`, `copy()`, and component functions. Think of them as similar to Swift structs, but they're reference types, not value types.

### Basic Syntax

```kotlin
// Simple data class
data class User(val name: String, val age: Int)

// The compiler automatically generates:
// - equals() / hashCode()
// - toString()
// - copy()
// - componentN() functions for destructuring
```

**Swift comparison:**

```swift
// Swift struct
struct User {
    let name: String
    let age: Int
}
// Automatically gets: ==, hashable, description
```

```kotlin
// Kotlin data class
data class User(val name: String, val age: Int)
// Automatically gets: equals, hashCode, toString, copy, componentN
```

### What Gets Generated

> [!IMPORTANT]
> The compiler only generates functions based on properties declared in the **primary constructor**. Properties in the class body are ignored.

```kotlin
data class Person(
    val firstName: String,
    val lastName: String
) {
    var age: Int = 0  // Not included in equals/hashCode/toString!
}

val p1 = Person("John", "Doe")
val p2 = Person("John", "Doe")
p1.age = 25
p2.age = 30

println(p1 == p2)  // true - age not considered!
```

### Automatically Generated Functions

**toString():**

```kotlin
data class User(val name: String, val age: Int)

val user = User("Alice", 25)
println(user)  // User(name=Alice, age=25)
```

**equals() and hashCode():**

```kotlin
val user1 = User("Alice", 25)
val user2 = User("Alice", 25)
val user3 = User("Bob", 30)

println(user1 == user2)  // true (structural equality)
println(user1 === user2)  // false (different objects)
println(user1 == user3)  // false

// Can use in sets/maps
val set = setOf(user1, user2, user3)
println(set.size)  // 2 (user1 and user2 are equal)
```

**copy():**

> [!TIP]
> The `copy()` function creates a new instance with some properties changed. This is one of the most useful features of data classes.

```kotlin
data class User(val name: String, val age: Int, val email: String)

val user = User("Alice", 25, "alice@example.com")

// Copy with changes
val olderUser = user.copy(age = 26)
// User(name=Alice, age=26, email=alice@example.com)

// Copy multiple properties
val different = user.copy(name = "Bob", age = 30)
// User(name=Bob, age=30, email=alice@example.com)

// Copy with no changes (creates new instance)
val clone = user.copy()
```

**Destructuring (componentN functions):**

```kotlin
data class User(val name: String, val age: Int, val email: String)

val user = User("Alice", 25, "alice@example.com")

// Destructure into variables
val (name, age, email) = user
println("$name is $age years old")

// Ignore components with _
val (name, _, email) = user

// Only take first N components
val (name, age) = user  // email ignored
```

### Requirements for Data Classes

> [!WARNING]
> Data classes have several requirements:
> - Primary constructor must have at least one parameter
> - All primary constructor parameters must be `val` or `var`
> - Cannot be `abstract`, `open`, `sealed`, or `inner`
> - Can implement interfaces
> - Can extend other classes (since Kotlin 1.1)

```kotlin
// ✅ Valid
data class Point(val x: Int, val y: Int)

// ✅ Valid - with var
data class Counter(var count: Int)

// ❌ Invalid - no parameters
// data class Empty()

// ❌ Invalid - parameter not val/var
// data class Invalid(name: String)

// ✅ Valid - implements interface
data class Person(val name: String) : Named

// ✅ Valid - extends class
data class SpecialUser(val name: String) : BaseUser()

// ❌ Invalid - open
// open data class User(val name: String)
```

### Mutable vs Immutable

> [!NOTE]
> While you can use `var` properties, immutable data classes with `val` properties are preferred for safety and thread-safety.

```kotlin
// Immutable (preferred)
data class Point(val x: Int, val y: Int)

val p1 = Point(0, 0)
// p1.x = 5  // Error - can't modify
val p2 = p1.copy(x = 5)  // Create new instance

// Mutable (use with caution)
data class MutablePoint(var x: Int, var y: Int)

val p3 = MutablePoint(0, 0)
p3.x = 5  // Allowed
```

### Properties in Class Body

> [!WARNING]
> Properties defined in the class body (not primary constructor) are **not** included in generated functions.

```kotlin
data class User(val id: Int) {
    var name: String = ""
    var age: Int = 0
}

val user1 = User(1).apply { 
    name = "Alice"
    age = 25 
}

val user2 = User(1).apply { 
    name = "Bob"
    age = 30 
}

println(user1 == user2)  // true! Only id is compared
println(user1)  // User(id=1) - name and age not in toString
```

**If you need these properties included:**

```kotlin
// Put them in primary constructor
data class User(
    val id: Int,
    val name: String,
    val age: Int
)
```

### Destructuring in Loops

```kotlin
data class User(val name: String, val age: Int)

val users = listOf(
    User("Alice", 25),
    User("Bob", 30),
    User("Charlie", 35)
)

// Destructure in for loop
for ((name, age) in users) {
    println("$name is $age years old")
}

// With withIndex()
for ((index, user) in users.withIndex()) {
    println("$index: $user")
}

// Destructure the user too
for ((index, user) in users.withIndex()) {
    val (name, age) = user
    println("$index: $name ($age)")
}
```

### Using with Collections

```kotlin
data class Product(val id: Int, val name: String, val price: Double)

val products = listOf(
    Product(1, "Phone", 699.99),
    Product(2, "Laptop", 999.99),
    Product(3, "Tablet", 499.99)
)

// Group by property
val byPrice = products.groupBy { it.price > 500 }

// Map to different type
val names = products.map { it.name }

// Find by property
val laptop = products.find { it.name == "Laptop" }

// Sort by property
val sorted = products.sortedBy { it.price }
```

### Inheritance with Data Classes

> [!NOTE]
> Data classes can extend other classes (non-data classes), but cannot extend other data classes.

```kotlin
open class Person(val name: String)

// ✅ Can extend regular class
data class Employee(
    val employeeId: Int,
    val employeeName: String
) : Person(employeeName)

// ❌ Cannot extend data class
data class Base(val x: Int)
// data class Derived(val x: Int, val y: Int) : Base(x)  // Error!
```

### Copying with Nested Data Classes

```kotlin
data class Address(val street: String, val city: String)
data class User(val name: String, val address: Address)

val user = User(
    "Alice",
    Address("123 Main St", "Springfield")
)

// Shallow copy - address is same reference
val user2 = user.copy(name = "Bob")

// To modify nested object, need nested copy
val user3 = user.copy(
    address = user.address.copy(city = "Shelbyville")
)
```

### Common Patterns

**Builder pattern with copy:**

```kotlin
data class User(
    val id: Int,
    val name: String,
    val email: String,
    val age: Int
)

fun User.withName(name: String) = copy(name = name)
fun User.withEmail(email: String) = copy(email = email)
fun User.withAge(age: Int) = copy(age = age)

// Usage
val user = User(1, "", "", 0)
    .withName("Alice")
    .withEmail("alice@example.com")
    .withAge(25)
```

**Validation in init block:**

```kotlin
data class Email(val address: String) {
    init {
        require(address.contains("@")) { "Invalid email" }
    }
}

data class Age(val value: Int) {
    init {
        require(value >= 0) { "Age must be non-negative" }
    }
}
```

**Creating from map:**

```kotlin
data class Config(
    val host: String,
    val port: Int,
    val timeout: Long
)

// Manual mapping
fun configFromMap(map: Map<String, Any>): Config {
    return Config(
        host = map["host"] as String,
        port = map["port"] as Int,
        timeout = map["timeout"] as Long
    )
}
```

### Data Classes vs Regular Classes

**When to use data classes:**

```kotlin
// ✅ Use data class
data class Point(val x: Int, val y: Int)
data class User(val id: Int, val name: String)
data class Result(val value: String, val timestamp: Long)

// ❌ Don't use data class (behavior-heavy)
class UserRepository {
    fun save(user: User) { }
    fun load(id: Int): User { }
}

// ❌ Don't use data class (need custom equality)
class IdentityUser(val id: Int, val name: String) {
    override fun equals(other: Any?) = 
        other is IdentityUser && other.id == id
}
```

### Data Classes in Android

> [!TIP]
> Data classes are heavily used in Android for:
> - ViewModels and UI state
> - API responses
> - Database entities (with Room)
> - Intent extras

```kotlin
// UI State
data class UiState(
    val isLoading: Boolean = false,
    val data: List<String> = emptyList(),
    val error: String? = null
)

// API Response
data class UserResponse(
    val id: Int,
    val name: String,
    val email: String
)

// Update state with copy
fun updateState(state: UiState, newData: List<String>) =
    state.copy(isLoading = false, data = newData)
```

### Serialization

> [!NOTE]
> Data classes work great with serialization libraries like kotlinx.serialization.

```kotlin
@Serializable
data class User(
    val id: Int,
    val name: String,
    val email: String
)

// Serialize
val json = Json.encodeToString(user)

// Deserialize
val user = Json.decodeFromString<User>(json)
```

### Key Differences from Swift Structs

| Feature | Swift Struct | Kotlin Data Class |
|---------|--------------|-------------------|
| Type | Value type | Reference type |
| Copying | Automatic (COW) | Explicit with `copy()` |
| Equality | Automatic `==` | Automatic `equals()` |
| Mutability | `let` vs `var` instance | `val` vs `var` properties |
| Inheritance | Cannot inherit | Can inherit classes |
| Default values | In declaration | In primary constructor |

### Key Takeaways

> [!IMPORTANT]
> **Remember:**
> - Data classes automatically generate `equals`, `hashCode`, `toString`, `copy`, and `componentN`
> - Only properties in primary constructor are included in generated functions
> - Use `val` for immutability (preferred)
> - `copy()` for creating modified copies
> - Destructuring with `val (a, b, c) = dataClass`
> - Great for immutable state, DTOs, and value objects
> - Reference types (not value types like Swift structs)
> - Can implement interfaces and extend classes
> - Cannot be `open` or `abstract`