# Sealed Classes & Interfaces
#android/Kotlin/Unique

> [!NOTE]
> Sealed classes represent restricted class hierarchies where all subclasses are known at compile time. Think of them as enums on steroids - they can have state, multiple instances, and different types. Perfect for representing states, results, and algebraic data types.

### Basic Sealed Class

```kotlin
sealed class Result {
    data class Success(val data: String) : Result()
    data class Error(val message: String) : Result()
    object Loading : Result()
}

// Usage with when (exhaustive)
fun handle(result: Result) = when (result) {
    is Result.Success -> println("Data: ${result.data}")
    is Result.Error -> println("Error: ${result.message}")
    is Result.Loading -> println("Loading...")
    // No else needed - compiler knows all cases!
}
```

**Swift comparison:**

```swift
// Swift enum with associated values
enum Result {
    case success(data: String)
    case error(message: String)
    case loading
}

// Switch must be exhaustive
switch result {
case .success(let data): 
    print("Data: \(data)")
case .error(let message): 
    print("Error: \(message)")
case .loading: 
    print("Loading...")
}
```

### Why Sealed Classes?

> [!TIP]
> **Sealed classes are perfect for:**
> - Representing finite state machines
> - API responses (Success/Error/Loading)
> - UI states
> - Navigation destinations
> - Command patterns
> - Any restricted hierarchy where you want exhaustive when expressions

### Declaring Subclasses

> [!NOTE]
> As of Kotlin 1.5+, subclasses can be in the same package (not just same file). This gives more flexibility in organizing code.

```kotlin
// All in one file (traditional)
sealed class UiState {
    object Loading : UiState()
    data class Success(val data: List<String>) : UiState()
    data class Error(val message: String) : UiState()
}

// Or in separate files (same package)
// File: UiState.kt
sealed class UiState

// File: Loading.kt
object Loading : UiState()

// File: Success.kt
data class Success(val data: List<String>) : UiState()

// File: Error.kt  
data class Error(val message: String) : UiState()
```

### Sealed Classes vs Enums

> [!IMPORTANT]
> **Enums**: All instances are singletons (one instance per case)
> **Sealed classes**: Can have multiple instances with different data

```kotlin
// Enum - limited to singleton instances
enum class Color {
    RED, GREEN, BLUE
}

// Sealed class - multiple instances with data
sealed class Color {
    data class RGB(val r: Int, val g: Int, val b: Int) : Color()
    data class HSV(val h: Float, val s: Float, val v: Float) : Color()
}

val color1 = Color.RGB(255, 0, 0)
val color2 = Color.RGB(0, 255, 0)  // Different instance
```

### Exhaustive When Expressions

> [!TIP]
> The killer feature: when expressions with sealed classes don't need `else` if all cases are covered. The compiler enforces this!

```kotlin
sealed class Result {
    data class Success(val data: String) : Result()
    data class Error(val message: String) : Result()
}

// Exhaustive - no else needed
fun handle(result: Result): String = when (result) {
    is Result.Success -> result.data
    is Result.Error -> result.message
}

// If you add a new case, compiler will error at all when expressions
sealed class Result {
    data class Success(val data: String) : Result()
    data class Error(val message: String) : Result()
    object Loading : Result()  // Added new case
}

// Now this will error - must add Loading case!
// fun handle(result: Result): String = when (result) {
//     is Result.Success -> result.data
//     is Result.Error -> result.message
// }
```

### Smart Casts with Sealed Classes

```kotlin
sealed class Shape {
    data class Circle(val radius: Double) : Shape()
    data class Rectangle(val width: Double, val height: Double) : Shape()
}

fun area(shape: Shape): Double = when (shape) {
    is Shape.Circle -> Math.PI * shape.radius * shape.radius
    is Shape.Rectangle -> shape.width * shape.height
    // shape is smart-cast in each branch
}
```

### Common Patterns

**API Response:**

```kotlin
sealed class ApiResponse<out T> {
    data class Success<T>(val data: T) : ApiResponse<T>()
    data class Error(val code: Int, val message: String) : ApiResponse<Nothing>()
    object Loading : ApiResponse<Nothing>()
}

// Usage
fun handleResponse(response: ApiResponse<User>) = when (response) {
    is ApiResponse.Success -> displayUser(response.data)
    is ApiResponse.Error -> showError(response.message)
    is ApiResponse.Loading -> showLoading()
}
```

**UI State:**

```kotlin
sealed class UiState {
    object Initial : UiState()
    object Loading : UiState()
    data class Content(val items: List<String>) : UiState()
    data class Error(val message: String) : UiState()
}

// State machine
fun transition(current: UiState, event: Event): UiState = when (event) {
    is Event.Load -> when (current) {
        is UiState.Initial -> UiState.Loading
        else -> current
    }
    is Event.Success -> UiState.Content(event.data)
    is Event.Error -> UiState.Error(event.message)
}
```

**Navigation Destinations:**

```kotlin
sealed class Screen {
    object Home : Screen()
    data class Profile(val userId: String) : Screen()
    data class Details(val itemId: Int, val title: String) : Screen()
    object Settings : Screen()
}

fun navigate(screen: Screen) = when (screen) {
    is Screen.Home -> HomeFragment()
    is Screen.Profile -> ProfileFragment.newInstance(screen.userId)
    is Screen.Details -> DetailsFragment.newInstance(screen.itemId, screen.title)
    is Screen.Settings -> SettingsFragment()
}
```

### Sealed Classes with Generic Types

```kotlin
sealed class Result<out T> {
    data class Success<T>(val data: T) : Result<T>()
    data class Error(val exception: Exception) : Result<Nothing>()
}

fun <T> handleResult(result: Result<T>): T? = when (result) {
    is Result.Success -> result.data
    is Result.Error -> {
        println("Error: ${result.exception}")
        null
    }
}

// Usage
val stringResult: Result<String> = Result.Success("Hello")
val intResult: Result<Int> = Result.Success(42)
```

### Nested Sealed Classes

```kotlin
sealed class Outer {
    sealed class Inner : Outer() {
        data class A(val value: String) : Inner()
        data class B(val count: Int) : Inner()
    }
    
    object Other : Outer()
}

fun process(outer: Outer) = when (outer) {
    is Outer.Inner -> when (outer) {
        is Outer.Inner.A -> println(outer.value)
        is Outer.Inner.B -> println(outer.count)
    }
    is Outer.Other -> println("Other")
}
```

### Sealed Interfaces (Kotlin 1.5+)

> [!NOTE]
> Sealed interfaces work like sealed classes but allow multiple inheritance. Classes can implement multiple sealed interfaces but only extend one sealed class.

```kotlin
sealed interface Error
sealed interface NetworkError : Error

data class Timeout(val duration: Long) : NetworkError
data class NoConnection(val reason: String) : NetworkError
data class InvalidResponse(val code: Int) : Error

fun handle(error: Error) = when (error) {
    is Timeout -> println("Timeout after ${error.duration}ms")
    is NoConnection -> println("No connection: ${error.reason}")
    is InvalidResponse -> println("Invalid response: ${error.code}")
}

// Can implement multiple sealed interfaces
sealed interface Loadable
sealed interface Refreshable

data class Content(val data: String) : Loadable, Refreshable
```

### Combining with Data Classes

> [!TIP]
> Most subclasses of sealed classes are data classes. This gives you all the benefits of both.

```kotlin
sealed class ViewEvent {
    data class ShowMessage(val message: String) : ViewEvent()
    data class NavigateTo(val screen: Screen) : ViewEvent()
    data class ShowDialog(val title: String, val message: String) : ViewEvent()
    object Dismiss : ViewEvent()
}

// All data class benefits: copy, destructuring, etc.
val event = ViewEvent.ShowMessage("Hello")
val modified = event.copy(message = "Hi")
```

### Extension Functions on Sealed Classes

```kotlin
sealed class Result<out T> {
    data class Success<T>(val data: T) : Result<T>()
    data class Error(val message: String) : Result<Nothing>()
}

// Extension on sealed class
fun <T> Result<T>.getOrNull(): T? = when (this) {
    is Result.Success -> data
    is Result.Error -> null
}

fun <T> Result<T>.getOrDefault(default: T): T = when (this) {
    is Result.Success -> data
    is Result.Error -> default
}

// Usage
val result: Result<String> = fetchData()
val value = result.getOrNull()
```

### Mapping and Transforming

```kotlin
sealed class Result<out T> {
    data class Success<T>(val data: T) : Result<T>()
    data class Error(val message: String) : Result<Nothing>()
}

// Map success value
fun <T, R> Result<T>.map(transform: (T) -> R): Result<R> = when (this) {
    is Result.Success -> Result.Success(transform(data))
    is Result.Error -> this
}

// Flat map
fun <T, R> Result<T>.flatMap(transform: (T) -> Result<R>): Result<R> = when (this) {
    is Result.Success -> transform(data)
    is Result.Error -> this
}

// Usage
val result: Result<String> = Result.Success("42")
val doubled: Result<Int> = result.map { it.toInt() * 2 }
```

### State Machines

```kotlin
sealed class State {
    object Idle : State()
    object Loading : State()
    data class Success(val data: String) : State()
    data class Error(val message: String) : State()
}

sealed class Event {
    object Load : Event()
    data class LoadSuccess(val data: String) : Event()
    data class LoadError(val message: String) : Event()
    object Retry : Event()
}

fun reduce(state: State, event: Event): State = when (state) {
    is State.Idle -> when (event) {
        is Event.Load -> State.Loading
        else -> state
    }
    is State.Loading -> when (event) {
        is Event.LoadSuccess -> State.Success(event.data)
        is Event.LoadError -> State.Error(event.message)
        else -> state
    }
    is State.Error -> when (event) {
        is Event.Retry -> State.Loading
        else -> state
    }
    is State.Success -> state
}
```

### Sealed Classes in Collections

```kotlin
sealed class Result {
    data class Success(val value: Int) : Result()
    data class Error(val message: String) : Result()
}

val results = listOf(
    Result.Success(1),
    Result.Error("Failed"),
    Result.Success(2),
    Result.Success(3)
)

// Filter by type
val successes = results.filterIsInstance<Result.Success>()

// Map with when
val values = results.mapNotNull { result ->
    when (result) {
        is Result.Success -> result.value
        is Result.Error -> null
    }
}

// Partition
val (good, bad) = results.partition { it is Result.Success }
```

### Testing with Sealed Classes

```kotlin
sealed class LoginResult {
    object Success : LoginResult()
    data class Error(val reason: String) : LoginResult()
    object InvalidCredentials : LoginResult()
}

// Easy to test all cases
@Test
fun `test login result handling`() {
    // Test success
    val success = handle(LoginResult.Success)
    assertEquals(expected, success)
    
    // Test error
    val error = handle(LoginResult.Error("Network error"))
    assertEquals(expectedError, error)
    
    // Test invalid credentials
    val invalid = handle(LoginResult.InvalidCredentials)
    assertEquals(expectedInvalid, invalid)
}
```

### Common Mistakes

> [!WARNING]
> **Common pitfalls:**

```kotlin
// ❌ Forgetting to make subclass a data class
sealed class Result {
    class Success(val data: String) : Result()  // Not data class!
}
// Now Success doesn't get equals/hashCode/copy

// ✅ Use data class
sealed class Result {
    data class Success(val data: String) : Result()
}

// ❌ Using else when you want exhaustive checking
fun handle(result: Result) = when (result) {
    is Result.Success -> "success"
    else -> "other"  // Now adding new cases won't cause compile error!
}

// ✅ Don't use else
fun handle(result: Result) = when (result) {
    is Result.Success -> "success"
    is Result.Error -> "error"
    // Compiler will error if you add new case
}
```

### Sealed Classes vs Sealed Interfaces

| Feature | Sealed Class | Sealed Interface |
|---------|--------------|------------------|
| Inheritance | Single inheritance | Multiple inheritance |
| State | Can have state | Abstract state only |
| Constructor | Can have constructor | Cannot have constructor |
| Use case | Primary hierarchy | Mix-in capabilities |

### Key Takeaways

> [!IMPORTANT]
> **Remember:**
> - Sealed classes represent restricted hierarchies known at compile time
> - Enable exhaustive `when` expressions without `else`
> - Perfect for state machines, API responses, and ADTs
> - Combine with data classes for maximum benefit
> - Compiler enforces handling all cases
> - Can use generics for flexible type-safe code
> - Sealed interfaces (1.5+) allow multiple inheritance
> - More powerful than enums - can have state and multiple instances
> - Similar to Swift enums with associated values, but reference types