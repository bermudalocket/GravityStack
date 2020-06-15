# GravityStack

A versatile stack view that pulls its contents in a given direction.

A basic use case:
```
HStack {
    Text("Page Title")
        .font(.largeTitle)
    Spacer()
}
```

can be replaced with

```
GravityStack {
    Text("Page Title")
        .font(.largeTitle)
}
```

Gravity pulls in the `leading` direction by default.

A more robust initializer is:

```
GravityStack(.vertical, gravity: .trailing, gravityStrength: 0.75) {
    MyContent()
}
```
