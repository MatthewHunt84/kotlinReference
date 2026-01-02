# Delegation
#android/Kotlin/Unique

> [!NOTE]
> Delegation is a design pattern where an object handles a request by delegating to another object. Kotlin has first-class support for delegation with the `by` keyword for both class delegation and property delegation.

### Class Delegation

> [!NOTE]
> Class delegation allows a class to implement an interface by delegating to another object. The `by` keyword automatically forwards interface methods to the delegate.

```kotlin
interface Printer {
    fun print(message: String)
    fun status(): String
}

class ConsolePrinter : Printer {
    override fun print(message: String) {
        println("Printing: $message")
    }
    
    override fun status() = "Ready"
}

// Delegate all Printer methods to printer instance
class Document(printer: Printer) : Printer by printer {
    // Can still override specific methods if needed
    override fun print(message: String) {
        println("Document: preparing to print")
        printer.print(message)
    }
}

val doc = Document(ConsolePrinter())
doc.print("Hello")  // Uses overridden method
println(doc.status())  // Uses delegated method
```

**Without delegation (manual):**

```kotlin
class Document(private val printer: Printer) : Printer {
    override fun print(message: String) = printer.print(message)
    override fun status() = printer.status()
    // Must manually delegate every method!
}
```

**With delegation:**

```kotlin
class Document(printer: Printer) : Printer by printer {
    // Automatically delegates all methods!
}
```

### Property Delegation

> [!NOTE]
> Property delegation uses `by` to delegate property get/set operations to another object. The delegate must provide `getValue` and optionally `setValue` operator functions.

```kotlin
import kotlin.properties.ReadWriteProperty
import kotlin.reflect.KProperty

class LoggingDelegate<T>(private var value: T) : ReadWriteProperty<Any?, T> {
    override fun getValue(thisRef: Any?, property: KProperty<*>): T {
        println("Getting ${property.name}: $value")
        return value
    }
    
    override fun setValue(thisRef: Any?, property: KProperty<*>, value: T) {
        println("Setting ${property.name} from $this.value to $value")
        this.value = value
    }
}

class User {
    var name: String by LoggingDelegate("Unknown")
}

val user = User()
user.name = "Alice"  // Prints: Setting name from Unknown to Alice
println(user.name)   // Prints: Getting name: Alice
```

### Standard Delegates

#### lazy

> [!NOTE]
> `lazy` is a property delegate for lazy initialization. The value is computed only once, on first access, and cached.

```kotlin
class DataManager {
    val data: List<String> by lazy {
        println("Loading expensive data...")
        loadData()  // Called only once
    }
    
    private fun loadData(): List<String> {
        Thread.sleep(1000)
        return listOf("item1", "item2", "item3")
    }
}

val manager = DataManager()
println("Created manager")
// data is not loaded yet

println(manager.data)  // Now loads data
// Prints: Loading expensive data...
// Then: [item1, item2, item3]

println(manager.data)  // Uses cached value
// Immediately prints: [item1, item2, item3]
```

**Thread safety modes:**

```kotlin
// Thread-safe (default)
val data by lazy { loadData() }

// Not thread-safe (faster if single-threaded)
val data by lazy(LazyThreadSafetyMode.NONE) { loadData() }

// Synchronized with custom lock
val data by lazy(LazyThreadSafetyMode.SYNCHRONIZED) { loadData() }
```

#### observable

> [!NOTE]
> `observable` delegates notify you when a property changes.

```kotlin
import kotlin.properties.Delegates

class User {
    var name: String by Delegates.observable("initial") { prop, old, new ->
        println("${prop.name} changed from $old to $new")
    }
}

val user = User()
user.name = "Alice"  // Prints: name changed from initial to Alice
user.name = "Bob"    // Prints: name changed from Alice to Bob
```

#### vetoable

> [!NOTE]
> `vetoable` lets you approve or reject property changes.

```kotlin
import kotlin.properties.Delegates

class User {
    var age: Int by Delegates.vetoable(0) { prop, old, new ->
        new >= 0  // Only allow non-negative values
    }
}

val user = User()
user.age = 25
println(user.age)  // 25

user.age = -5
println(user.age)  // Still 25 (change rejected)
```

#### notNull

> [!NOTE]
> `notNull` for late initialization of non-null properties (alternative to `lateinit`).

```kotlin
import kotlin.properties.Delegates

class User {
    var name: String by Delegates.notNull()
}

val user = User()
// println(user.name)  // Would throw IllegalStateException

user.name = "Alice"
println(user.name)  // Alice
```

**Difference from `lateinit`:**

```kotlin
// lateinit - only for var, cannot be primitives
lateinit var name: String

// notNull - works with any type including primitives
var age: Int by Delegates.notNull()
```

### Map Delegation

> [!NOTE]
> You can delegate properties to a Map, useful for parsing JSON or working with dynamic data.

```kotlin
class User(map: Map<String, Any>) {
    val name: String by map
    val age: Int by map
    val email: String by map
}

val map = mapOf(
    "name" to "Alice",
    "age" to 25,
    "email" to "alice@example.com"
)

val user = User(map)
println(user.name)   // Alice
println(user.age)    // 25
println(user.email)  // alice@example.com

// With mutable map
class MutableUser(map: MutableMap<String, Any>) {
    var name: String by map
    var age: Int by map
}

val mutableMap = mutableMapOf(
    "name" to "Bob",
    "age" to 30
)

val user2 = MutableUser(mutableMap)
user2.name = "Charlie"
println(mutableMap)  // {name=Charlie, age=30}
```

### Custom Property Delegates

**Simple read-only delegate:**

```kotlin
class UppercaseDelegate(private val value: String) {
    operator fun getValue(thisRef: Any?, property: KProperty<*>): String {
        return value.uppercase()
    }
}

class Example {
    val greeting: String by UppercaseDelegate("hello")
}

val ex = Example()
println(ex.greeting)  // HELLO
```

**Read-write delegate:**

```kotlin
class RangeDelegate(private var value: Int, private val range: IntRange) {
    operator fun getValue(thisRef: Any?, property: KProperty<*>): Int {
        return value
    }
    
    operator fun setValue(thisRef: Any?, property: KProperty<*>, newValue: Int) {
        if (newValue in range) {
            value = newValue
        } else {
            throw IllegalArgumentException("Value must be in $range")
        }
    }
}

class Settings {
    var volume: Int by RangeDelegate(50, 0..100)
}

val settings = Settings()
settings.volume = 75   // OK
// settings.volume = 150  // Throws exception
```

### Providing Delegates

> [!NOTE]
> You can create delegate providers that return different delegates based on the property.

```kotlin
class ResourceLoader {
    operator fun provideDelegate(
        thisRef: Any?,
        property: KProperty<*>
    ): ReadOnlyProperty<Any?, String> {
        checkPropertyName(property.name)
        return ResourceDelegate(property.name)
    }
    
    private fun checkPropertyName(name: String) {
        if (!name.startsWith("resource_")) {
            throw IllegalArgumentException(
                "Property name must start with 'resource_'"
            )
        }
    }
}

class ResourceDelegate(private val name: String) : ReadOnlyProperty<Any?, String> {
    override fun getValue(thisRef: Any?, property: KProperty<*>): String {
        return "Loading $name"
    }
}

class MyClass {
    val resource_image by ResourceLoader()  // OK
    // val image by ResourceLoader()  // Would throw exception
}
```

### Delegated Properties in Interfaces

```kotlin
interface Named {
    val name: String
}

class NamedImpl(override val name: String) : Named

class Person(named: Named) : Named by named {
    // name is delegated to named parameter
}

val person = Person(NamedImpl("Alice"))
println(person.name)  // Alice
```

### Common Delegate Patterns

**Cached computation:**

```kotlin
fun <T> cached(compute: () -> T): ReadOnlyProperty<Any?, T> {
    return object : ReadOnlyProperty<Any?, T> {
        private var cached: T? = null
        
        override fun getValue(thisRef: Any?, property: KProperty<*>): T {
            if (cached == null) {
                cached = compute()
            }
            return cached!!
        }
    }
}

class DataProcessor {
    val processedData: List<String> by cached {
        println("Processing...")
        expensiveProcessing()
    }
}
```

**Validated properties:**

```kotlin
fun <T> validated(
    initialValue: T,
    validator: (T) -> Boolean
): ReadWriteProperty<Any?, T> {
    return object : ReadWriteProperty<Any?, T> {
        private var value = initialValue
        
        override fun getValue(thisRef: Any?, property: KProperty<*>) = value
        
        override fun setValue(thisRef: Any?, property: KProperty<*>, newValue: T) {
            require(validator(newValue)) { "Invalid value: $newValue" }
            value = newValue
        }
    }
}

class User {
    var email: String by validated("") { it.contains("@") }
    var age: Int by validated(0) { it >= 0 }
}
```

**Synchronized access:**

```kotlin
fun <T> synchronized(initialValue: T): ReadWriteProperty<Any?, T> {
    return object : ReadWriteProperty<Any?, T> {
        private var value = initialValue
        private val lock = Any()
        
        override fun getValue(thisRef: Any?, property: KProperty<*>): T {
            kotlin.synchronized(lock) {
                return value
            }
        }
        
        override fun setValue(thisRef: Any?, property: KProperty<*>, newValue: T) {
            kotlin.synchronized(lock) {
                value = newValue
            }
        }
    }
}
```

### Local Delegated Properties

```kotlin
fun example() {
    val lazyValue: String by lazy {
        println("Computed once")
        "Hello"
    }
    
    println(lazyValue)  // Prints: Computed once, then Hello
    println(lazyValue)  // Prints: Hello (uses cached value)
}
```

### Delegation in Data Classes

```kotlin
import kotlin.properties.Delegates

data class User(
    private val _name: String,
    private val _age: Int
) {
    var name: String by Delegates.observable(_name) { _, old, new ->
        println("Name changed from $old to $new")
    }
    
    var age: Int by Delegates.observable(_age) { _, old, new ->
        println("Age changed from $old to $new")
    }
}
```

### Android-Specific Delegates

**View binding delegate:**

```kotlin
fun <T : ViewBinding> Activity.viewBinding(
    bindingClass: Class<T>
): ReadOnlyProperty<Activity, T> {
    return object : ReadOnlyProperty<Activity, T> {
        private var binding: T? = null
        
        override fun getValue(thisRef: Activity, property: KProperty<*>): T {
            if (binding == null) {
                val inflateMethod = bindingClass.getMethod("inflate", LayoutInflater::class.java)
                binding = inflateMethod.invoke(null, thisRef.layoutInflater) as T
                thisRef.setContentView(binding!!.root)
            }
            return binding!!
        }
    }
}

// Usage in Activity
class MainActivity : AppCompatActivity() {
    private val binding by viewBinding(ActivityMainBinding::class.java)
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding.textView.text = "Hello"
    }
}
```

**Preference delegate:**

```kotlin
fun SharedPreferences.stringPreference(
    key: String,
    defaultValue: String = ""
): ReadWriteProperty<Any?, String> {
    return object : ReadWriteProperty<Any?, String> {
        override fun getValue(thisRef: Any?, property: KProperty<*>): String {
            return getString(key, defaultValue) ?: defaultValue
        }
        
        override fun setValue(thisRef: Any?, property: KProperty<*>, value: String) {
            edit().putString(key, value).apply()
        }
    }
}

// Usage
class Settings(private val prefs: SharedPreferences) {
    var username: String by prefs.stringPreference("username")
    var theme: String by prefs.stringPreference("theme", "light")
}
```

### Delegation vs Inheritance

> [!TIP]
> **Use delegation when:**
> - You want to reuse behavior without inheritance
> - The relationship is "has-a" not "is-a"
> - You need flexibility to swap implementations
> - You want to avoid diamond problem

```kotlin
// ❌ Inheritance for code reuse
open class Logger {
    fun log(message: String) {
        println(message)
    }
}

class UserService : Logger() {
    fun createUser() {
        log("Creating user")
    }
}

// ✅ Delegation for code reuse
interface Logger {
    fun log(message: String)
}

class ConsoleLogger : Logger {
    override fun log(message: String) {
        println(message)
    }
}

class UserService(logger: Logger) : Logger by logger {
    fun createUser() {
        log("Creating user")
    }
}
```

### Key Takeaways

> [!IMPORTANT]
> **Remember:**
> - **Class delegation**: `class C(d: D) : I by d` delegates interface methods
> - **Property delegation**: `var prop by delegate` delegates get/set
> - Built-in delegates: `lazy`, `observable`, `vetoable`, `notNull`
> - Map delegation great for parsing dynamic data
> - Create custom delegates with `getValue`/`setValue` operators
> - `lazy` is thread-safe by default
> - Delegation promotes composition over inheritance
> - Can be used for validation, caching, logging, synchronization
> - Very useful in Android for ViewBinding, Preferences, etc.