# Reified Type Parameters
#android/Kotlin/Unique

> [!NOTE]
> Reified type parameters allow you to access type information at runtime in inline functions. Normally, type parameters are erased at runtime (type erasure), but `reified` with `inline` preserves the type information.

### The Problem: Type Erasure

```kotlin
// ❌ This doesn't work - type is erased at runtime
fun <T> isInstance(value: Any): Boolean {
    // return value is T  // Error! Cannot check type at runtime
}

// ❌ This doesn't work either
fun <T> createInstance(): T {
    // return T()  // Error! Cannot instantiate T
}
```

**In Swift, you can pass types as metatypes:**

```swift
func isInstance<T>(_ value: Any, ofType type: T.Type) -> Bool {
    return value is T
}

isInstance(42, ofType: Int.self)
```

**In Kotlin, use reified:**

```kotlin
inline fun <reified T> isInstance(value: Any): Boolean {
    return value is T  // Works! Type information preserved
}

isInstance<String>("hello")  // true
isInstance<Int>("hello")     // false
```

### Basic Reified Usage

> [!IMPORTANT]
> Reified type parameters require two things:
> 1. The function must be `inline`
> 2. The type parameter must be marked `reified`

```kotlin
inline fun <reified T> printType() {
    println(T::class.simpleName)
}

printType<String>()  // Prints: String
printType<Int>()     // Prints: Int
printType<List<String>>()  // Prints: List
```

### Type Checking

```kotlin
inline fun <reified T> checkType(value: Any): Boolean {
    return value is T
}

println(checkType<String>("hello"))  // true
println(checkType<Int>("hello"))     // false
println(checkType<List<*>>(listOf(1, 2, 3)))  // true
```

**With smart cast:**

```kotlin
inline fun <reified T> castOrNull(value: Any): T? {
    return if (value is T) value else null
}

val str: String? = castOrNull<String>("hello")  // "hello"
val num: Int? = castOrNull<Int>("hello")        // null
```

### Filtering Collections

> [!TIP]
> One of the most common uses of reified is filtering collections by type.

```kotlin
// Built into Kotlin standard library
inline fun <reified T> Iterable<*>.filterIsInstance(): List<T> {
    val result = mutableListOf<T>()
    for (element in this) {
        if (element is T) {
            result.add(element)
        }
    }
    return result
}

val items: List<Any> = listOf(1, "two", 3, "four", 5)

val strings = items.filterIsInstance<String>()
println(strings)  // [two, four]

val ints = items.filterIsInstance<Int>()
println(ints)  // [1, 3, 5]
```

### Finding in Collections

```kotlin
inline fun <reified T> List<*>.findInstance(): T? {
    return this.firstOrNull { it is T } as? T
}

val items: List<Any> = listOf(1, "hello", 3.14, true)

val string = items.findInstance<String>()  // "hello"
val double = items.findInstance<Double>()  // 3.14
val long = items.findInstance<Long>()      // null
```

### JSON Parsing

> [!NOTE]
> Reified type parameters are commonly used in JSON libraries for type-safe deserialization.

```kotlin
// Without reified (would need to pass class)
fun <T> parseJson(json: String, clazz: Class<T>): T {
    return gson.fromJson(json, clazz)
}

val user = parseJson(json, User::class.java)  // Ugly!

// With reified (cleaner)
inline fun <reified T> parseJson(json: String): T {
    return gson.fromJson(json, T::class.java)
}

val user = parseJson<User>(json)  // Clean!
```

### Getting Class References

```kotlin
inline fun <reified T> getKotlinClass() = T::class

inline fun <reified T> getJavaClass() = T::class.java

val stringClass = getKotlinClass<String>()  // KClass<String>
val stringJavaClass = getJavaClass<String>()  // Class<String>

// Useful for reflection
inline fun <reified T> createInstance(): T {
    return T::class.java.getDeclaredConstructor().newInstance()
}
```

### Android Examples

**Intent extras:**

```kotlin
inline fun <reified T : Activity> Context.startActivity(
    block: Intent.() -> Unit = {}
) {
    val intent = Intent(this, T::class.java)
    intent.block()
    startActivity(intent)
}

// Usage
startActivity<MainActivity>()

startActivity<DetailActivity> {
    putExtra("id", 123)
    putExtra("title", "Hello")
}
```

**Fragment finding:**

```kotlin
inline fun <reified T : Fragment> FragmentManager.findFragment(): T? {
    return fragments.filterIsInstance<T>().firstOrNull()
}

// Usage
val myFragment = supportFragmentManager.findFragment<MyFragment>()
```

**ViewModel retrieval:**

```kotlin
inline fun <reified VM : ViewModel> FragmentActivity.viewModel(): VM {
    return ViewModelProvider(this)[VM::class.java]
}

// Usage
val viewModel = viewModel<UserViewModel>()
```

### Combining with Other Features

**With sealed classes:**

```kotlin
sealed class Result<out T> {
    data class Success<T>(val data: T) : Result<T>()
    data class Error(val message: String) : Result<Nothing>()
}

inline fun <reified T> Result<*>.getSuccessOrNull(): T? {
    return when (this) {
        is Result.Success -> if (data is T) data else null
        is Result.Error -> null
    }
}

val result: Result<String> = Result.Success("hello")
val value = result.getSuccessOrNull<String>()  // "hello"
```

**With property delegation:**

```kotlin
inline fun <reified T> preference(key: String, default: T): ReadWriteProperty<Any?, T> {
    return object : ReadWriteProperty<Any?, T> {
        override fun getValue(thisRef: Any?, property: KProperty<*>): T {
            return when (T::class) {
                String::class -> prefs.getString(key, default as String) as T
                Int::class -> prefs.getInt(key, default as Int) as T
                Boolean::class -> prefs.getBoolean(key, default as Boolean) as T
                else -> throw IllegalArgumentException("Unsupported type")
            }
        }
        
        override fun setValue(thisRef: Any?, property: KProperty<*>, value: T) {
            when (value) {
                is String -> prefs.edit().putString(key, value).apply()
                is Int -> prefs.edit().putInt(key, value).apply()
                is Boolean -> prefs.edit().putBoolean(key, value).apply()
                else -> throw IllegalArgumentException("Unsupported type")
            }
        }
    }
}

class Settings {
    var username: String by preference("username", "")
    var count: Int by preference("count", 0)
}
```

### Type Bounds with Reified

```kotlin
inline fun <reified T : Number> sum(list: List<T>): Double {
    return list.sumOf { 
        when (it) {
            is Int -> it.toDouble()
            is Long -> it.toDouble()
            is Float -> it.toDouble()
            is Double -> it
            else -> 0.0
        }
    }
}

val ints = listOf(1, 2, 3)
val doubles = listOf(1.5, 2.5, 3.5)

println(sum(ints))     // 6.0
println(sum(doubles))  // 7.5
```

### Array Creation

> [!NOTE]
> One of the few ways to create a generic array in Kotlin.

```kotlin
inline fun <reified T> arrayOfNulls(size: Int): Array<T?> {
    return arrayOfNulls<T>(size)
}

inline fun <reified T> emptyArray(): Array<T> {
    return arrayOf()
}

val stringArray = arrayOfNulls<String>(5)  // Array<String?>
val intArray = emptyArray<Int>()  // Array<Int>
```

### Limitations

> [!WARNING]
> Reified type parameters have limitations:

```kotlin
// ✅ Can do
inline fun <reified T> check(value: Any) {
    value is T           // Type check
    value as T           // Type cast
    T::class            // Get class
    T::class.java       // Get Java class
}

// ❌ Cannot do
inline fun <reified T> problematic() {
    // T()                    // Cannot instantiate (unless with reflection)
    // val list = List<T>()   // Cannot create generic type
}

// ✅ But can use reflection
inline fun <reified T> createWithReflection(): T {
    return T::class.java.getDeclaredConstructor().newInstance()
}
```

### Multiple Reified Parameters

```kotlin
inline fun <reified A, reified B> pairTypes(): Pair<String, String> {
    return A::class.simpleName!! to B::class.simpleName!!
}

val types = pairTypes<String, Int>()
println(types)  // (String, Int)

inline fun <reified T1, reified T2> bothInstanceOf(v1: Any, v2: Any): Boolean {
    return v1 is T1 && v2 is T2
}

println(bothInstanceOf<String, Int>("hello", 42))  // true
println(bothInstanceOf<String, Int>(42, "hello"))  // false
```

### Performance Considerations

> [!NOTE]
> Since reified functions must be `inline`, their code is copied at each call site. This can increase bytecode size but eliminates function call overhead.

```kotlin
// This function's code will be inlined at each call site
inline fun <reified T> process(value: Any): T? {
    return value as? T
}

// Each call site will have the code inlined
val s = process<String>("hello")  // Code inlined here
val i = process<Int>(42)          // Code inlined here
```

### Real-World Example: Repository Pattern

```kotlin
interface Repository<T> {
    fun getAll(): List<T>
    fun getById(id: Int): T?
    fun save(entity: T)
}

class DatabaseManager {
    private val repositories = mutableMapOf<String, Repository<*>>()
    
    inline fun <reified T> getRepository(): Repository<T>? {
        return repositories[T::class.simpleName] as? Repository<T>
    }
    
    inline fun <reified T> register(repository: Repository<T>) {
        repositories[T::class.simpleName!!] = repository
    }
}

// Usage
data class User(val id: Int, val name: String)
data class Post(val id: Int, val title: String)

val db = DatabaseManager()
db.register(UserRepository())
db.register(PostRepository())

val userRepo = db.getRepository<User>()
val postRepo = db.getRepository<Post>()
```

### Comparison with Swift

| Feature | Swift | Kotlin |
|---------|-------|--------|
| Pass type | `T.self` | Reified with `inline` |
| Type checking | `value is T` | `value is T` (with reified) |
| Get type | `T.self` | `T::class` (with reified) |
| When needed | Built-in | Must be inline + reified |

### Common Patterns

**Safe casting:**

```kotlin
inline fun <reified T> Any?.safeCast(): T? = this as? T

val str: String? = "hello".safeCast<String>()  // "hello"
val int: Int? = "hello".safeCast<Int>()        // null
```

**Type validation:**

```kotlin
inline fun <reified T> validate(value: Any): T {
    require(value is T) { "Expected ${T::class.simpleName} but got ${value::class.simpleName}" }
    return value
}

val str = validate<String>("hello")  // OK
// val num = validate<Int>("hello")  // Throws exception
```

### Key Takeaways

> [!IMPORTANT]
> **Remember:**
> - Reified type parameters preserve type information at runtime
> - Must be used with `inline` functions
> - Enables type checks, casts, and getting class references
> - Common uses: collection filtering, JSON parsing, Android APIs
> - Code is inlined at call sites (affects bytecode size)
> - Cannot instantiate type directly (need reflection)
> - Very useful for creating type-safe, generic APIs
> - More concise than passing `Class<T>` parameters