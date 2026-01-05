# Object Companions
#android/Kotlin/Unique

> [!NOTE]
> Kotlin doesn't have a `static` keyword. Instead, it uses object declarations and companion objects. Object declarations create singletons, while companion objects provide class-level members (like static members in other languages).

### Object Declarations (Singletons)

> [!NOTE]
> An `object` declaration creates a singleton - a class with exactly one instance. It's lazily initialized on first access and thread-safe.

```kotlin
// Object declaration - automatic singleton
object DatabaseConfig {
    val host = "localhost"
    val port = 5432
    
    fun connect() {
        println("Connecting to $host:$port")
    }
}

// Usage - no need to instantiate
DatabaseConfig.connect()
println(DatabaseConfig.host)
```

**Swift comparison:**

```swift
// Swift singleton
class DatabaseConfig {
    static let shared = DatabaseConfig()
    private init() {}
    
    let host = "localhost"
    let port = 5432
}

// Usage
DatabaseConfig.shared.host
```

```kotlin
// Kotlin - much simpler
object DatabaseConfig {
    val host = "localhost"
    val port = 5432
}

// Usage
DatabaseConfig.host
```

### Companion Objects

> [!NOTE]
> A companion object is an object declaration inside a class. Its members can be accessed using the class name, similar to static members. Each class can have only one companion object.

```kotlin
class User(val name: String, val age: Int) {
    companion object {
        const val MIN_AGE = 18
        
        fun create(name: String, age: Int): User {
            require(age >= MIN_AGE) { "User must be at least $MIN_AGE" }
            return User(name, age)
        }
    }
}

// Usage
println(User.MIN_AGE)
val user = User.create("Alice", 25)
```

**Swift comparison:**

```swift
// Swift static members
class User {
    static let minAge = 18
    
    static func create(name: String, age: Int) -> User {
        // ...
    }
}

// Usage
User.minAge
User.create(name: "Alice", age: 25)
```

### Named Companion Objects

```kotlin
class User {
    companion object Factory {
        fun create(name: String) = User(name)
    }
}

// Can access with or without name
val user1 = User.create("Alice")
val user2 = User.Factory.create("Bob")
```

### Constants in Companion Objects

> [!IMPORTANT]
> Use `const val` for compile-time constants. These must be primitive types or Strings and are directly inlined by the compiler.

```kotlin
class Config {
    companion object {
        const val API_KEY = "abc123"  // Compile-time constant
        val timeout = 30000L          // Runtime constant
        
        // Only primitive types and String allowed with const
        // const val user = User()  // Error!
    }
}
```

### Factory Methods

> [!TIP]
> Companion objects are perfect for factory methods and alternative constructors.

```kotlin
class User private constructor(val id: Int, val name: String) {
    companion object {
        private var nextId = 0
        
        fun create(name: String): User {
            return User(nextId++, name)
        }
        
        fun fromMap(map: Map<String, Any>): User {
            return User(
                id = map["id"] as Int,
                name = map["name"] as String
            )
        }
        
        fun guest(): User {
            return User(-1, "Guest")
        }
    }
}

// Usage
val user1 = User.create("Alice")
val user2 = User.fromMap(mapOf("id" to 1, "name" to "Bob"))
val guest = User.guest()
```

### Object Expressions (Anonymous Objects)

> [!NOTE]
> Object expressions create anonymous objects on the fly, similar to Swift's anonymous classes or object literals.

```kotlin
// Object expression - anonymous object
val clickListener = object : View.OnClickListener {
    override fun onClick(v: View) {
        println("Clicked!")
    }
}

// With multiple interfaces
val handler = object : OnClickListener, OnLongClickListener {
    override fun onClick(v: View) { }
    override fun onLongClick(v: View): Boolean = true
}

// Anonymous object with properties
fun createCounter() = object {
    var count = 0
    fun increment() { count++ }
    fun getCount() = count
}

val counter = createCounter()
counter.increment()
println(counter.getCount())
```

### Companion Object Implementing Interfaces

```kotlin
interface Factory<T> {
    fun create(): T
}

class User(val name: String) {
    companion object : Factory<User> {
        override fun create(): User {
            return User("Default")
        }
    }
}

// Can pass companion as interface
fun <T> produce(factory: Factory<T>): T {
    return factory.create()
}

val user = produce(User)  // Companion object is passed
```

### Extension Functions on Companion Objects

```kotlin
class User {
    companion object {
        // Members defined here
    }
}

// Extension function on companion
fun User.Companion.fromJson(json: String): User {
    // Parse JSON
    return User(/* parsed data */)
}

// Usage
val user = User.fromJson(jsonString)
```

### Object Declarations with Interfaces

```kotlin
interface Comparator<T> {
    fun compare(a: T, b: T): Int
}

object CaseInsensitiveComparator : Comparator<String> {
    override fun compare(a: String, b: String): Int {
        return a.lowercase().compareTo(b.lowercase())
    }
}

// Usage
val strings = listOf("banana", "Apple", "cherry")
val sorted = strings.sortedWith(CaseInsensitiveComparator)
```

### Common Patterns

**Configuration singleton:**

```kotlin
object AppConfig {
    var isDevelopment = false
    var apiUrl = "https://api.prod.example.com"
    
    fun configure(isDev: Boolean) {
        isDevelopment = isDev
        apiUrl = if (isDev) {
            "https://api.dev.example.com"
        } else {
            "https://api.prod.example.com"
        }
    }
}
```

**Logger singleton:**

```kotlin
object Logger {
    private val tag = "App"
    
    fun debug(message: String) {
        if (BuildConfig.DEBUG) {
            println("[$tag] DEBUG: $message")
        }
    }
    
    fun error(message: String, throwable: Throwable? = null) {
        println("[$tag] ERROR: $message")
        throwable?.printStackTrace()
    }
}

// Usage
Logger.debug("Application started")
Logger.error("Failed to load", exception)
```

**Registry pattern:**

```kotlin
object ServiceRegistry {
    private val services = mutableMapOf<String, Any>()
    
    fun <T : Any> register(name: String, service: T) {
        services[name] = service
    }
    
    fun <T> get(name: String): T? {
        return services[name] as? T
    }
}

// Usage
ServiceRegistry.register("api", ApiService())
val api = ServiceRegistry.get<ApiService>("api")
```

**Constants container:**

```kotlin
object Constants {
    const val APP_NAME = "MyApp"
    const val VERSION = "1.0.0"
    
    object Network {
        const val TIMEOUT = 30000L
        const val MAX_RETRIES = 3
    }
    
    object UI {
        const val ANIMATION_DURATION = 300L
        const val MAX_WIDTH = 1200
    }
}

// Usage
println(Constants.APP_NAME)
println(Constants.Network.TIMEOUT)
```

### Data Objects (Kotlin 1.9+)

> [!NOTE]
> Kotlin 1.9 introduced `data object` which combines object declarations with data class features (toString, equals, hashCode).

```kotlin
sealed class Result {
    data class Success(val data: String) : Result()
    data class Error(val message: String) : Result()
    data object Loading : Result()  // Now has nice toString
}

val state: Result = Result.Loading
println(state)  // Prints: Loading (not ugly object hash)
```

### Companion vs Top-Level Functions

> [!TIP]
> **When to use companion objects vs top-level functions:**

```kotlin
// Companion object - when related to class
class User {
    companion object {
        fun create(name: String) = User(name)  // Factory for User
    }
}

// Top-level function - when not tied to specific class
fun parseJson(json: String): Map<String, Any> {
    // General utility, not specific to one class
}

// Both are valid, choose based on context
```

### Accessing Companion from Instance

```kotlin
class MyClass {
    companion object {
        val constant = 42
    }
    
    fun useCompanion() {
        // Can access companion members
        println(constant)
        // Or explicitly
        println(MyClass.constant)
        println(Companion.constant)
    }
}
```

### Object Initialization

```kotlin
object DatabaseConnection {
    init {
        println("Initializing database connection")
        // Heavy initialization work
    }
    
    fun query(sql: String) {
        // Use connection
    }
}

// init block runs on first access
DatabaseConnection.query("SELECT * FROM users")  // Prints "Initializing..."
DatabaseConnection.query("SELECT * FROM posts")  // Doesn't print again
```

### Thread Safety

> [!IMPORTANT]
> Object declarations are thread-safe by default. The JVM guarantees thread-safe lazy initialization.

```kotlin
object Singleton {
    init {
        println("Initialized by ${Thread.currentThread().name}")
    }
    
    var counter = 0
}

// Safe from multiple threads
// First thread to access will initialize
// Other threads will wait for initialization to complete
```

### Nested Objects

```kotlin
class Outer {
    object Nested {
        fun doSomething() {
            println("From nested object")
        }
    }
}

// Access nested object
Outer.Nested.doSomething()
```

### Object Expressions vs Object Declarations

> [!NOTE]
> **Object expressions** are evaluated immediately where used. **Object declarations** are lazily initialized singletons.

```kotlin
// Object declaration - singleton, lazy
object Config {
    val setting = "value"
}

// Object expression - new instance, immediate
fun getListener() = object : ClickListener {
    override fun onClick() { }
}

// Each call to getListener() creates new object
val listener1 = getListener()
val listener2 = getListener()
println(listener1 === listener2)  // false

// Singleton always same instance
val config1 = Config
val config2 = Config  
println(config1 === config2)  // true
```

### Common Mistakes

> [!WARNING]
> **Common pitfalls:**

```kotlin
// ❌ Trying to have multiple companion objects
class MyClass {
    companion object One { }
    // companion object Two { }  // Error!
}

// ❌ Trying to make companion object open
class MyClass {
    // open companion object { }  // Error!
}

// ❌ Forgetting companion objects can't have constructors
class MyClass {
    companion object {
        // init { }  // This works
        // constructor() { }  // Error!
    }
}

// ✅ Use init block instead
class MyClass {
    companion object {
        init {
            // Initialization code
        }
    }
}
```

### Testing Companion Objects

```kotlin
class UserService {
    companion object {
        var apiClient: ApiClient = RealApiClient()
    }
    
    fun getUser(id: Int): User {
        return apiClient.fetchUser(id)
    }
}

// In tests - can swap implementation
@Test
fun testUserService() {
    UserService.apiClient = MockApiClient()
    // Now can test without real API
}
```

### Java Interop

> [!NOTE]
> When calling from Java, companion object members are accessed through `Companion` field.

```kotlin
// Kotlin
class MyClass {
    companion object {
        fun doSomething() { }
        const val CONSTANT = 42
    }
}
```

```java
// Java
MyClass.Companion.doSomething();
int value = MyClass.CONSTANT;  // const vals are static

// Or with @JvmStatic
```

```kotlin
class MyClass {
    companion object {
        @JvmStatic
        fun doSomething() { }
    }
}
```

```java
// Now can call as regular static
MyClass.doSomething();
```

### Key Takeaways

> [!IMPORTANT]
> **Remember:**
> - `object` declarations create thread-safe singletons
> - Companion objects provide class-level members (replaces `static`)
> - Use `const val` for compile-time constants in companion objects
> - Perfect for factory methods, constants, and utilities
> - Only one companion object per class (but can be named)
> - Can implement interfaces
> - Object expressions create new instances (not singletons)
> - Lazily initialized on first access
> - Thread-safe by default
> - Use `@JvmStatic` for better Java interop
