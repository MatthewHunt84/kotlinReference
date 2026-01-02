# Method Reference
#android/Kotlin/Unique

The method reference `::` is kotlin syntax sugar for calling a function which accepts just a single argument.
I wouldn’t call it syntax sugar though, as it seems to make the code less clear from my perspective, but what do I know?

### Can be used when referencing implicit `it` for a function that takes a single argument
```kotlin
val exampleString = "print me"
exampleString.let {
	println(it) // Here's a candidate for using the method reference. This would be print($0) in swift
}
```
In the example above println takes a single argument of type `String`. We can write this using the method reference instead if you want to make things shorter and more confusing.
```kotlin
val exampleString = "print me"
exampleString.let {
	::println // This is the same as println(it)
}
```

### You can also reference a method on an instance of a class
```kotlin
// Strings in kotlin have a 'length' parameter, just like swift's 'count'
val lengthFunction = "example string".length // 14

// Lets say we have a function which returns a basic string
fun returnAString(): String {
	return "a basic string"
}
```

We could create make a constant that computes the length of the input string using familiar syntax like this:
```kotlin
val getLength = returnAString().length // Normal syntax
```
However we could also use the method reference operator to access the length method.
```kotlin
val instanceOfString = returnAString() // If we have an instance of a String
val lengthLambda = instanceOfString::length // then we can create a lambda which uses the method reference (::)

println(lengthLambda()) // So long as we call the lambda like a method
```

#### There are some conditions that confused me at first:
1. We can only use the method reference on an instance of a class
```kotlin
// This is not okay, because returnAString is a function, not an instance
val notAnInstance = returnAString::length

// We need to get the instance first:
val instance = returnAString() // returns a string instance
val lengthLambda = instance::length // then we can use the method reference
```
2. The stored property which uses a method reference is a lambda rather than a computed property
```kotlin
val instance = returnAString()
val lengthLambda = instance::length

// This is not okay, lengthLambda is not like a swiftt computed property
println(lengthLambda) // This will print the function's string representation 'property length (Kotlin reflection is not available)' rather than actually invoking the function and printing the result

// Instead, it must be called like a swift closure 
println(lengthLambda()) // This will return 14
```

### The Method Reference operator can also be used for constructors and initialization

> [!NOTE] 
> Constructor references are most useful when passing a constructor to a higher-order function (like map), rather than for direct instantiation.
> In this way, they are similar to swift closures where you pass `class.init` to a function.
> For basic use cases just stick with the standard initializtion syntax at the bottom of this explanation

As you are learning, kotlin classes don’t have an init method with free memberwise intializers. 
What you can do however is use the method reference operator directly on a class like this: 
```kotlin
// Given a simple class with three properties
data class User(val name: String, val age: Int, val email: String)

// We could create a lambda as an initializer
val createUserLambda: (String, Int, String) -> User = { name, age, email -> 
    User(name, age, email) 
}
createUserLambda("Alice", 30, "alice@example.com")

// But we can also use a method reference
val createUser = ::User
createUser("Alice", 30, "alice@example.com")
```

As noted above, for all simple cases just use the standard syntax
```kotlin
User("Alice", 30, "alice@example.com")
```
