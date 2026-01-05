# Inline Functions
#android/Kotlin/Unique

> [!NOTE]
> Inline functions tell the compiler to copy the function's code to every call site instead of calling the function. This eliminates function call overhead and enables reified type parameters, but increases bytecode size.

### Basic Inline Functions

```kotlin
inline fun calculateSum(a: Int, b: Int): Int {
    return a + b
}

// At compile time, this:
val result = calculateSum(5, 3)

// Becomes this:
val result = 5 + 3
```

**Regular vs Inline:**

```kotlin
// Regular function - creates function call
fun regular(x: Int): Int {
    return x * 2
}

// Inline function - code is copied
inline fun inlined(x: Int): Int {
    return x * 2
}

// Usage
val a = regular(5)   // Function call overhead
val b = inlined(5)   // No function call, code copied directly
```

### Why Inline Functions?

> [!IMPORTANT]
> **Main reasons to use inline:**
> 1. Eliminate lambda allocation overhead
> 2. Enable non-local returns from lambdas
> 3. Enable reified type parameters
> 4. Reduce function call overhead for small functions

### Inline Functions with Lambdas

> [!NOTE]
> The main benefit of inline functions: lambdas are also inlined, avoiding object allocation.

```kotlin
// Not inline - lambda creates object
fun repeat(times: Int, action: () -> Unit) {
    for (i in 0 until times) {
        action()  // Each call allocates lambda object
    }
}

// Inline - lambda code is copied
inline fun repeatInline(times: Int, action: () -> Unit) {
    for (i in 0 until times) {
        action()  // No lambda object created
    }
}

// This code:
repeatInline(3) {
    println("Hello")
}

// Becomes:
for (i in 0 until 3) {
    println("Hello")
}
// No lambda object created!
```

### Non-Local Returns

> [!NOTE]
> In inline functions, you can `return` from the lambda and it will return from the enclosing function. This doesn't work with regular functions.

```kotlin
fun findInList(list: List<Int>): Int? {
    list.forEach { item ->
        if (item > 5) {
            // return item  // Error! Can't return from enclosing function
            return@forEach   // Can only return from lambda
        }
    }
    return null
}

// With inline function
inline fun findInListInline(list: List<Int>): Int? {
    list.forEach { item ->
        if (item > 5) {
            return item  // ✅ Returns from findInListInline!
        }
    }
    return null
}
```

**Example:**

```kotlin
fun processUser(user: User?) {
    user?.let {
        if (!it.isValid()) {
            return  // ✅ Returns from processUser because let is inline
        }
        // Process user
    }
}
```

### noinline Modifier

> [!NOTE]
> Use `noinline` when you need to pass a lambda parameter to a non-inline function or store it.

```kotlin
inline fun processItems(
    items: List<String>,
    noinline logger: (String) -> Unit  // This lambda won't be inlined
) {
    items.forEach { item ->
        process(item)
        logger(item)  // Can pass to other functions
    }
}

fun saveLogger(log: (String) -> Unit) {
    // Store logger for later use
}

// Usage
processItems(list, ::println)
processItems(list) { msg -> 
    saveLogger { msg }  // OK because logger is noinline
}
```

### crossinline Modifier

> [!NOTE]
> Use `crossinline` when an inline lambda parameter is called from another execution context (like another lambda) and you want to prevent non-local returns.

```kotlin
inline fun runAsync(crossinline block: () -> Unit) {
    thread {
        // block is called from different context (thread)
        block()  // Non-local return would be problematic here
    }
}

// Without crossinline, this would be allowed:
runAsync {
    return  // Would try to return from outer function!
}

// With crossinline, this is prevented:
// The return statement is not allowed in crossinline lambdas
```

**When to use:**

```kotlin
// Regular inline - allows non-local returns
inline fun process(block: () -> Unit) {
    block()
}

// Crossinline - prevents non-local returns but allows lambda to be used in nested contexts
inline fun processAsync(crossinline block: () -> Unit) {
    runLater {  // Different execution context
        block()  // OK with crossinline
    }
}
```

### Reified Type Parameters

> [!NOTE]
> Inline functions enable reified type parameters (covered in Reified Types section).

```kotlin
inline fun <reified T> isType(value: Any): Boolean {
    return value is T
}

// Only works because function is inline
val result = isType<String>("hello")
```

### Performance Considerations

> [!WARNING]
> **Tradeoffs of inline functions:**
> - ✅ Eliminates function call overhead
> - ✅ Avoids lambda object allocation
> - ✅ Enables non-local returns
> - ❌ Increases bytecode size (code is copied)
> - ❌ Not suitable for large functions
> - ❌ Changes require recompilation of call sites

```kotlin
// ✅ Good candidate for inline - small and called frequently
inline fun <T> T.also(block: (T) -> Unit): T {
    block(this)
    return this
}

// ❌ Bad candidate for inline - large function body
inline fun processLargeData(data: List<String>) {
    // 100+ lines of code
    // This will be copied to every call site!
}
```

### Standard Library Examples

> [!TIP]
> Many Kotlin standard library functions are inline to avoid lambda allocation overhead.

```kotlin
// All of these are inline functions:

// let, run, with, apply, also
value.let { println(it) }

// forEach, map, filter, etc.
list.forEach { println(it) }
list.map { it * 2 }
list.filter { it > 5 }

// repeat
repeat(10) { println("Hi") }

// synchronized
synchronized(lock) { /* ... */ }

// use (for Closeable)
stream.use { it.read() }
```

### Inline Properties

> [!NOTE]
> You can inline property accessors too.

```kotlin
class Counter {
    private var _count = 0
    
    inline var count: Int
        get() = _count
        set(value) {
            _count = value
        }
}

// Access is inlined
val counter = Counter()
counter.count = 5  // Direct field access, no getter call
val value = counter.count  // Direct field access, no setter call
```

**With backing field:**

```kotlin
var name: String = ""
    inline get() = field
    inline set(value) {
        field = value
    }
```

### Common Patterns

**Resource management:**

```kotlin
inline fun <T : Closeable, R> T.use(block: (T) -> R): R {
    try {
        return block(this)
    } finally {
        this.close()
    }
}

// Usage - resource automatically closed
val data = FileInputStream("file.txt").use { stream ->
    stream.readBytes()
}
```

**Timing execution:**

```kotlin
inline fun measureTime(block: () -> Unit): Long {
    val start = System.currentTimeMillis()
    block()
    return System.currentTimeMillis() - start
}

val time = measureTime {
    // Expensive operation
    processData()
}
println("Took $time ms")
```

**Synchronized access:**

```kotlin
inline fun <R> synchronized(lock: Any, block: () -> R): R {
    kotlin.synchronized(lock) {
        return block()
    }
}

val result = synchronized(myLock) {
    // Critical section
    updateSharedState()
}
```

**Try-catch wrapper:**

```kotlin
inline fun <R> tryOrNull(block: () -> R): R? {
    return try {
        block()
    } catch (e: Exception) {
        null
    }
}

val result = tryOrNull {
    parseInt("not a number")
}  // null
```

### Inline Classes

> [!NOTE]
> Don't confuse inline functions with inline classes (value classes). Inline classes are for wrapping values without allocation overhead.

```kotlin
// This is an inline class (value class), not an inline function
@JvmInline
value class UserId(val value: Int)

// At runtime, UserId(123) is just the Int 123
val id = UserId(123)  // No object allocation!
```

### When NOT to Use Inline

> [!WARNING]
> **Don't inline:**

```kotlin
// ❌ Large functions
inline fun hugeFunction() {
    // 500 lines of code
    // This code will be copied to every call site!
}

// ❌ Functions with many call sites
inline fun veryCommonFunction() {
    // Called 1000+ times
    // Greatly increases bytecode size
}

// ❌ Functions that don't take lambdas or need reified
inline fun simpleAdd(a: Int, b: Int) = a + b
// No benefit, just increases code size

// ✅ Good uses
inline fun <T> List<T>.customForEach(action: (T) -> Unit) {
    for (item in this) action(item)
}

inline fun <reified T> parseJson(json: String): T {
    return gson.fromJson(json, T::class.java)
}
```

### Debugging Inline Functions

> [!NOTE]
> Debugging can be tricky with inline functions since the code is copied. Stack traces will show the call site, not the inline function.

```kotlin
inline fun process() {
    throw Exception("Error in inline function")
}

fun main() {
    process()  // Stack trace will point to this line
}
```

### Inline Functions and Recursion

> [!WARNING]
> Inline functions cannot be recursive (would cause infinite code expansion).

```kotlin
// ❌ This won't compile
// inline fun factorial(n: Int): Int {
//     return if (n <= 1) 1 else n * factorial(n - 1)
// }

// ✅ Remove inline for recursive functions
fun factorial(n: Int): Int {
    return if (n <= 1) 1 else n * factorial(n - 1)
}
```

### Inline + Extension Functions

```kotlin
inline fun <T> T.applyIf(condition: Boolean, block: T.() -> Unit): T {
    if (condition) {
        block()
    }
    return this
}

// Usage
val user = User()
    .applyIf(isDevelopment) {
        enableDebugMode()
    }
    .applyIf(hasPermission) {
        grantAccess()
    }
```

### Compile-Time Checks

```kotlin
// The compiler will warn if inline is not beneficial
inline fun add(a: Int, b: Int) = a + b
// Warning: Expected performance impact from inlining is insignificant

// Inline is most beneficial with lambdas
inline fun repeat(times: Int, action: () -> Unit) {
    for (i in 0 until times) action()
}
// No warning - lambda avoidance is beneficial
```

### Real-World Example: DSL

```kotlin
class HtmlBuilder {
    private val elements = mutableListOf<String>()
    
    inline fun tag(name: String, block: HtmlBuilder.() -> Unit) {
        elements.add("<$name>")
        this.block()  // Inlined - no lambda allocation
        elements.add("</$name>")
    }
    
    fun text(content: String) {
        elements.add(content)
    }
    
    override fun toString() = elements.joinToString("")
}

inline fun html(block: HtmlBuilder.() -> Unit): String {
    return HtmlBuilder().apply(block).toString()
}

// Usage - very efficient, no lambda allocations
val page = html {
    tag("div") {
        tag("h1") {
            text("Hello")
        }
        tag("p") {
            text("World")
        }
    }
}
```

### Key Takeaways

> [!IMPORTANT]
> **Remember:**
> - `inline` copies function code to call sites (no function call)
> - Main benefit: avoids lambda object allocation
> - Enables non-local returns from lambdas
> - Required for reified type parameters
> - Use `noinline` to prevent specific lambda parameters from inlining
> - Use `crossinline` to prevent non-local returns but allow lambda in different contexts
> - Don't inline large functions (increases bytecode size)
> - Best for small, frequently-called functions with lambda parameters
> - Standard library uses inline extensively (let, run, apply, forEach, etc.)
> - Cannot be recursive
> - Most useful when passing lambdas or using reified types
