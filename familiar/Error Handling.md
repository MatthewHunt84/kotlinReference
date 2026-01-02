# Error Handling
#Android/Kotlin/Familiar

> [!NOTE]
> **Major philosophical difference**: Swift uses typed errors with `throws`, `try`, and `catch`. Kotlin treats all exceptions as unchecked (like runtime exceptions in Java). You don't declare that a function throws, and you're not forced to catch exceptions.

### Throwing Errors

```swift
// Swift
enum NetworkError: Error {
    case badURL
    case timeout
    case noData
}

func fetchData() throws -> Data {
    if badCondition {
        throw NetworkError.badURL
    }
    return data
}
```

```kotlin
// Kotlin - no throws declaration needed
class NetworkException(message: String) : Exception(message)

fun fetchData(): Data {
    if (badCondition) {
        throw NetworkException("Bad URL")
    }
    return data
}
```

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Define error | `enum MyError: Error { }` | `class MyException(msg: String) : Exception(msg)` | Inherit from Exception |
| Throw error | `throw MyError.case` | `throw MyException("message")` | |
| Declare throwing | `func fetch() throws { }` | Not needed/supported | All exceptions unchecked |

### Catching Errors

```swift
// Swift
do {
    let data = try fetchData()
    print(data)
} catch NetworkError.badURL {
    print("Bad URL")
} catch NetworkError.timeout {
    print("Timeout")
} catch {
    print("Other error: \(error)")
}
```

```kotlin
// Kotlin
try {
    val data = fetchData()
    println(data)
} catch (e: NetworkException) {
    when (e.message) {
        "Bad URL" -> println("Bad URL")
        "Timeout" -> println("Timeout")
        else -> println("Other error: ${e.message}")
    }
} catch (e: Exception) {
    println("Other error: $e")
}
```

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Try-catch | `do { try ... } catch { }` | `try { ... } catch (e: Exception) { }` | No `do` keyword |
| Access error | Implicit `error` in catch | Must specify: `catch (e: Exception)` | |
| Multiple catches | `catch Error1 { } catch Error2 { }` | `catch (e: Error1) { } catch (e: Error2) { }` | Must specify exception variable |
| Catch all | `catch { }` | `catch (e: Exception) { }` | Must specify type |

### Try as Expression

> [!NOTE]
> In Kotlin, `try` is an expression and can return a value. This is useful for providing fallback values when operations fail.

```swift
// Swift - use do-try-catch and assign
let data: Data
do {
    data = try fetchData()
} catch {
    data = defaultData
}
```

```kotlin
// Kotlin - try as expression
val data = try {
    fetchData()
} catch (e: Exception) {
    defaultData
}
```

### Optional Try

> [!WARNING]
> Kotlin doesn't have `try?` that returns nil on failure. Use a regular try-catch that returns null, or use `runCatching` (see below).

```swift
// Swift
let data = try? fetchData()  // Returns Data? - nil if throws
```

```kotlin
// Kotlin - manual approach
val data = try {
    fetchData()
} catch (e: Exception) {
    null
}

// Or use runCatching (more idiomatic)
val data = runCatching { fetchData() }.getOrNull()
```

### Force Try

> [!WARNING]
> Kotlin doesn't have `try!`. Just call the function normally - if it throws, your app will crash (like `try!` in Swift).

```swift
// Swift
let data = try! fetchData()  // Crashes if throws
```

```kotlin
// Kotlin - just call it
val data = fetchData()  // Will crash if throws
```

### Rethrowing Functions

> [!NOTE]
> Since Kotlin doesn't have checked exceptions, there's no need for `rethrows`. Just throw normally.

```swift
// Swift
func process(operation: () throws -> Void) rethrows {
    try operation()
}
```

```kotlin
// Kotlin - just use regular function
fun process(operation: () -> Unit) {
    operation()  // Will propagate any exceptions
}
```

### Defer / Finally

> [!NOTE]
> Kotlin uses `finally` block (like Java) instead of Swift's `defer`. `finally` runs after try/catch, while `defer` runs at end of scope.

```swift
// Swift
func processFile() {
    let file = openFile()
    defer { file.close() }  // Runs when leaving scope
    
    // work with file
}
```

```kotlin
// Kotlin
fun processFile() {
    val file = openFile()
    try {
        // work with file
    } finally {
        file.close()  // Runs after try/catch
    }
}

// Or use 'use' for auto-closeable resources
fun processFile() {
    File("path").inputStream().use { stream ->
        // work with stream
        // automatically closed
    }
}
```

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Cleanup code | `defer { cleanup() }` | `finally { cleanup() }` | `finally` is part of try-catch |
| Auto-close resource | - | `.use { }` | For Closeable resources |

### Result Type

> [!NOTE]
> Kotlin has a `Result` type similar to Swift's, added in Kotlin 1.3. It's useful for functional error handling without exceptions.

```swift
// Swift
func fetchData() -> Result<Data, Error> {
    if success {
        return .success(data)
    } else {
        return .failure(error)
    }
}

switch fetchData() {
case .success(let data):
    print(data)
case .failure(let error):
    print(error)
}
```

```kotlin
// Kotlin
fun fetchData(): Result<Data> {
    return if (success) {
        Result.success(data)
    } else {
        Result.failure(error)
    }
}

fetchData()
    .onSuccess { data -> println(data) }
    .onFailure { error -> println(error) }

// Or
when (val result = fetchData()) {
    // Result doesn't have is checks, use methods instead
}
```

### RunCatching

> [!TIP]
> Kotlin's `runCatching` is a convenient way to convert exceptions into `Result` objects. It's more concise than manual try-catch.

```kotlin
// Kotlin
val result: Result<Data> = runCatching {
    fetchData()
}

result
    .onSuccess { println("Got data: $it") }
    .onFailure { println("Error: ${it.message}") }

// Get value or null
val data = runCatching { fetchData() }.getOrNull()

// Get value or default
val data = runCatching { fetchData() }.getOrDefault(defaultData)

// Chain operations
val processed = runCatching { fetchData() }
    .map { it.process() }
    .getOrNull()
```

### Assert / Preconditions

> [!NOTE]
> Kotlin has several functions for checking preconditions: `require()` for arguments, `check()` for state, and `assert()` for internal checks.

```swift
// Swift
func divide(_ a: Int, by b: Int) -> Int {
    precondition(b != 0, "Divisor cannot be zero")
    return a / b
}

assert(count >= 0, "Count must be non-negative")
```

```kotlin
// Kotlin
fun divide(a: Int, by: Int): Int {
    require(by != 0) { "Divisor cannot be zero" }  // IllegalArgumentException
    return a / by
}

// For state checks
check(initialized) { "Must be initialized" }  // IllegalStateException

// For assertions (can be disabled)
assert(count >= 0) { "Count must be non-negative" }  // AssertionError
```

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Check argument | `precondition(valid)` | `require(valid) { "message" }` | Throws IllegalArgumentException |
| Check state | `assert(initialized)` | `check(initialized) { "message" }` | Throws IllegalStateException |
| Assertion | `assert(condition)` | `assert(condition) { "message" }` | Can be disabled |
| Fatal error | `fatalError("message")` | `error("message")` | Always throws |

### Common Exception Types

> [!NOTE]
> Kotlin has standard exception types similar to Swift errors.

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Illegal argument | Custom error | `IllegalArgumentException` | For invalid parameters |
| Illegal state | Custom error | `IllegalStateException` | For invalid state |
| Not implemented | `fatalError("Not implemented")` | `NotImplementedError()` or `TODO()` | `TODO()` includes file/line |
| Null pointer | Force unwrap crashes | `NullPointerException` | Rare due to null safety |
| Index out of bounds | Array crash | `IndexOutOfBoundsException` | |
| Number format | `Int()` returns nil | `NumberFormatException` | From `.toInt()` |

### TODO and NotImplementedError

> [!TIP]
> Kotlin has `TODO()` function that throws `NotImplementedError` with the current location. Useful during development.

```kotlin
fun complexFunction(): Result {
    TODO("Implement this function")
    // Throws: NotImplementedError: An operation is not implemented: Implement this function
}

// Without message
fun anotherFunction() {
    TODO()  // Includes file and line number
}
```

### Custom Exceptions

```swift
// Swift
enum ValidationError: Error {
    case tooShort
    case tooLong
    case invalidFormat
}
```

```kotlin
// Kotlin
sealed class ValidationException(message: String) : Exception(message) {
    class TooShort : ValidationException("Input too short")
    class TooLong : ValidationException("Input too long")
    class InvalidFormat : ValidationException("Invalid format")
}

// Using sealed classes allows exhaustive when
when (exception) {
    is ValidationException.TooShort -> // handle
    is ValidationException.TooLong -> // handle
    is ValidationException.InvalidFormat -> // handle
}
```

### Key Differences to Remember

> [!TIP]
> **Kotlin advantages:**
> - `try` is an expression (can return value)
> - `runCatching` for functional error handling
> - `require()`/`check()` for clear preconditions
> - `Result` type for explicit error handling

> [!WARNING]
> **Watch out for:**
> - **No checked exceptions** - no `throws` declarations
> - No `try?` - use try-catch returning null or `runCatching`
> - No `try!` - just call the function
> - No `do` keyword - just `try { }`
> - `finally` instead of `defer`
> - Must specify exception variable in catch: `catch (e: Exception)`
> - Exceptions inherit from `Exception`, not `Error`
> - Use `.use { }` for auto-closing resources
> - `TODO()` is a real function that throws, not a compiler directive

---

## Rich Errors (Coming in Kotlin 2.4+)

> [!NOTE]
> **Experimental Feature Alert**: Rich Errors were announced at KotlinConf 2025 and are expected to arrive as an experimental feature in Kotlin 2.4. This is one of the most significant changes to Kotlin error handling since the language's creation. The syntax and semantics may evolve before final release.

### What Are Rich Errors?

Rich Errors introduce **union types for error handling**, allowing functions to explicitly declare which errors they might return as part of their type signature. Instead of throwing exceptions or wrapping results in `Result<T>`, functions can return `Value | Error1 | Error2`.

```kotlin
// Current Kotlin (exceptions)
fun fetchUser(): User {
    throw NetworkException("Connection failed")
}

// Current Kotlin (Result wrapper)
fun fetchUser(): Result<User> {
    return Result.failure(NetworkException("Connection failed"))
}

// Rich Errors (Kotlin 2.4+)
fun fetchUser(): User | NetworkError {
    return NetworkError("Connection failed")
}
```

### The Problem Rich Errors Solve

**Current challenges:**

```kotlin
// ❌ Exceptions are invisible in function signatures
fun processData(): String {
    // What exceptions might this throw? You can't tell from the signature!
}

// ❌ Result<T> wraps everything
fun processData(): Result<String> {
    // Forces wrapping/unwrapping at every level
}

// ❌ Sealed classes require boilerplate
sealed class DataResult {
    data class Success(val data: String) : DataResult()
    data class Error(val error: FetchError) : DataResult()
}
```

**Rich Errors make failure explicit:**

```kotlin
// ✅ Errors are visible in the signature
fun processData(): String | NetworkError | ParseError {
    // Compiler enforces handling all error cases
}
```

### Declaring Error Types

> [!NOTE]
> Error types are declared using the new `error` keyword. They can be objects (for parameterless errors) or classes (for errors with data).

```kotlin
// Simple error without data
error object NotFound

// Error with data
error class NetworkError(val message: String)

// Error with multiple properties
error class ValidationError(
    val field: String,
    val reason: String
)

// Errors can be organized in hierarchies
sealed interface AppError

error class DatabaseError(val query: String) : AppError
error class NetworkError(val endpoint: String) : AppError
error object NotAuthorized : AppError
```

### Union Type Syntax

Functions declare possible return types using the `|` (pipe) operator:

```kotlin
fun fetchUser(): User | NetworkError

fun parseJson(): JsonData | ParseError

fun login(): Token | NetworkError | InvalidCredentials

// Can use type aliases for complex unions
typealias UserError = NetworkError | ParseError | NotFound
fun getUser(): User | UserError
```

### Handling Rich Errors

> [!IMPORTANT]
> The compiler enforces that you handle all possible error cases. You cannot accidentally ignore errors like you can with exceptions.

**Basic handling:**

```kotlin
fun usage() {
    val result = fetchUser()
    
    // ❌ Can't use directly - might be an error
    // println(result.name)  // Compiler error!
    
    // ✅ Must check first
    if (result is User) {
        println(result.name)  // Smart cast to User
    } else {
        println("Error: $result")
    }
}
```

**Exhaustive when expressions:**

```kotlin
fun handleResult(result: User | NetworkError | ParseError) {
    when (result) {
        is User -> println("Success: ${result.name}")
        is NetworkError -> println("Network error: ${result.message}")
        is ParseError -> println("Parse error: ${result.details}")
        // No else needed - compiler knows all cases are covered
    }
}
```

**Early return pattern:**

```kotlin
fun processUser(): String | AppError {
    val user = fetchUser()
    if (user !is User) {
        return user  // Propagate error
    }
    
    // user is smart-cast to User here
    val validated = validateUser(user)
    if (validated !is ValidationSuccess) {
        return validated  // Propagate validation error
    }
    
    return "Success"
}
```

### Comparison with Swift

> [!NOTE]
> Rich Errors are conceptually similar to Swift's typed throws - both make errors explicit in function signatures and enforce handling at compile time.

**Swift's throwing functions:**

```swift
// Swift - errors declared with throws
enum FetchError: Error {
    case network
    case notFound
}

func fetchUser() throws -> User {
    throw FetchError.network
}

// Must handle with do-catch
do {
    let user = try fetchUser()
    print(user.name)
} catch {
    print("Error: \(error)")
}
```

**Kotlin's Rich Errors:**

```kotlin
// Kotlin 2.4+ - errors declared in return type
error class NetworkError
error object NotFound

fun fetchUser(): User | NetworkError | NotFound {
    return NetworkError()
}

// Handle with when (exhaustive checking)
when (val result = fetchUser()) {
    is User -> println(result.name)
    is NetworkError -> println("Network error")
    is NotFound -> println("Not found")
}
```

**Key difference**: Swift's `throws` is untyped (any Error), while Kotlin's Rich Errors are explicitly typed in the signature (`User | NetworkError`). This gives Kotlin's approach stronger compile-time guarantees about exactly which errors can occur.

### Chaining Operations

Rich Errors support functional composition patterns:

```kotlin
fun fetchUser(): User | NetworkError
fun User.validateProfile(): ValidProfile | ValidationError
fun ValidProfile.saveToDatabase(): Unit | DatabaseError

// Chaining with error propagation
fun processUser(): Unit | UserError {
    val user = fetchUser()
    if (user !is User) return user
    
    val profile = user.validateProfile()
    if (profile !is ValidProfile) return profile
    
    val saved = profile.saveToDatabase()
    if (saved !is Unit) return saved
    
    return Unit
}
```

> [!NOTE]
> The Kotlin team is exploring special operators (similar to Rust's `?` or Zig's `try`) to make error propagation even more concise. This syntax is not finalized yet.

### Real-World Example: API Client

```kotlin
// Define error types
error class NetworkError(val statusCode: Int, val message: String)
error class ParseError(val json: String, val reason: String)
error object Unauthorized

typealias ApiError = NetworkError | ParseError | Unauthorized

// API functions with explicit errors
interface UserApi {
    fun fetchUser(id: String): User | ApiError
    fun updateUser(user: User): Unit | ApiError
    fun deleteUser(id: String): Unit | ApiError
}

// Usage with exhaustive handling
fun displayUser(userId: String): String {
    return when (val result = userApi.fetchUser(userId)) {
        is User -> "Welcome, ${result.name}!"
        is NetworkError -> "Network error: ${result.message}"
        is ParseError -> "Failed to parse user data"
        is Unauthorized -> "Please log in"
    }
}
```

### Interop with Exceptions

> [!TIP]
> Rich Errors don't replace exceptions - they complement them. You can convert between the two approaches at API boundaries.

```kotlin
// Convert exception to rich error
fun fetchDataSafe(): Data | NetworkError {
    return try {
        legacyFetchData()  // Throws exceptions
    } catch (e: IOException) {
        NetworkError(e.message ?: "Unknown error")
    }
}

// Convert rich error to exception
fun fetchDataThrowing(): Data {
    return when (val result = fetchDataSafe()) {
        is Data -> result
        is NetworkError -> throw IOException(result.message)
    }
}
```

### Interop with Result<T>

```kotlin
// Result to rich error
fun fromResult(result: Result<User>): User | ErrorWrapper {
    return result.getOrElse { ErrorWrapper(it) }
}

// Rich error to Result
fun toResult(user: User | FetchError): Result<User> {
    return when (user) {
        is User -> Result.success(user)
        is FetchError -> Result.failure(Exception(user.message))
    }
}
```

### Must-Use Return Values

> [!IMPORTANT]
> Rich Errors work with the "must-use return values" feature (KEEP-412). The compiler will error if you ignore a function result that includes errors.

```kotlin
fun fetchUser(): User | NetworkError

// ❌ This will be a compiler error
fetchUser()  // Result ignored!

// ✅ Must handle the result
val result = fetchUser()
when (result) {
    is User -> // handle
    is NetworkError -> // handle
}
```

### When to Use Rich Errors vs Exceptions

> [!TIP]
> **Use Rich Errors for:**
> - Recoverable, expected failures (network errors, validation failures, not found)
> - Domain errors that callers should handle
> - When you want compile-time safety and exhaustive checking
> - API boundaries where error contracts should be explicit
> 
> **Use Exceptions for:**
> - Unrecoverable errors (out of memory, programming bugs)
> - Violated preconditions and invariants
> - Framework-level control flow (like cancellation)
> - Propagating errors across many layers without explicit handling

```kotlin
// ✅ Good for Rich Errors - recoverable, expected
fun findUser(id: String): User | NotFound

// ✅ Good for exceptions - programming error
fun getUser(id: String): User {
    require(id.isNotBlank()) { "ID cannot be blank" }  // Throws
    return users[id] ?: error("User must exist")  // Throws
}
```

### Benefits of Rich Errors

1. **Explicit failure modes**: Function signatures show exactly what can go wrong
2. **Compiler-enforced handling**: Can't accidentally ignore errors
3. **Type-safe**: Errors are first-class types with exhaustive checking
4. **Better composition**: Easier to chain operations with error propagation
5. **No wrapper boilerplate**: No need for `Result<T>` wrapping/unwrapping
6. **IDE support**: Autocomplete shows all possible return types
7. **Multiplatform friendly**: Errors are explicit types, not platform-specific exceptions

### Preparing for Rich Errors

> [!TIP]
> **You can prepare your codebase today:**

```kotlin
// Use sealed classes for error domains
sealed interface ApiError {
    data class Network(val message: String) : ApiError
    data class Parse(val json: String) : ApiError
    object NotFound : ApiError
}

// Use Result<T> with typed errors
fun fetchUser(): Result<User> {
    return runCatching {
        // API call
    }
}

// These patterns will be easy to migrate to Rich Errors
```

### Migration Path

```kotlin
// Before: Exception-based
fun fetchUser(): User {
    throw NetworkException()
}

// Intermediate: Result-based (use now)
fun fetchUser(): Result<User> {
    return Result.failure(NetworkException())
}

// After: Rich Errors (Kotlin 2.4+)
fun fetchUser(): User | NetworkError {
    return NetworkError("Connection failed")
}
```

### Limitations and Considerations

> [!WARNING]
> **Current limitations** (may change before final release):
> - Error types cannot have type parameters (no generic errors)
> - Errors must be explicitly declared with `error` keyword
> - Cannot use general union types (only for error handling)
> - Syntax and semantics are still evolving
> - IDE support may be limited initially

### Android Development Impact

Rich Errors will be particularly impactful for Android development:

```kotlin
// ViewModel with explicit error types
class UserViewModel : ViewModel() {
    fun loadUser(): User | LoadingError {
        // Clear error contract
    }
}

// Repository layer
interface UserRepository {
    suspend fun fetchUser(id: String): User | NetworkError | DatabaseError
    suspend fun saveUser(user: User): Unit | SaveError
}

// UI State modeling becomes cleaner
sealed interface UiState {
    data class Content(val user: User) : UiState
    data class Error(val error: LoadingError) : UiState
}

fun updateUiState(result: User | LoadingError): UiState {
    return when (result) {
        is User -> UiState.Content(result)
        is LoadingError -> UiState.Error(result)
    }
}
```

### Key Takeaways

> [!IMPORTANT]
> **What makes Rich Errors special:**
> - Built into the language (not a library solution)
> - Compiler-enforced exhaustive handling
> - Errors visible in function signatures
> - Smart casts work seamlessly
> - No wrapper overhead like `Result<T>`
> - Maintains Kotlin's type safety philosophy
> - Will fundamentally change how Kotlin code handles errors
> 
> **Remember:**
> - This is experimental in Kotlin 2.4+
> - Syntax may evolve before stable release
> - Doesn't replace exceptions, complements them
> - Start using sealed error hierarchies now to prepare
> - Think about which errors are "recoverable domain errors" vs "programming errors"

The Kotlin community is very excited about Rich Errors, and they represent the future direction of error handling in Kotlin. As you're learning Kotlin now, understanding both current approaches and upcoming Rich Errors will give you a head start!