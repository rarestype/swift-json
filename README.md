<div align="center">

🌷 &nbsp; **swift-json** &nbsp; 🌷

pure swift json parsing and encoding for high-performance, high-throughput server-side applications

[documentation and api reference](https://swiftinit.org/docs/swift-json/json)

</div>


## Requirements

The swift-json library requires Swift 6.2 or later.

<!-- DO NOT EDIT BELOW! AUTOSYNC CONTENT [STATUS TABLE] -->
| Platform | Status |
| -------- | ------ |
| 💬 Documentation | [![Status](https://raw.githubusercontent.com/rarestype/swift-json/refs/badges/ci/Documentation/_all/status.svg)](https://github.com/rarestype/swift-json/actions/workflows/Documentation.yml) |
| 🐧 Linux | [![Status](https://raw.githubusercontent.com/rarestype/swift-json/refs/badges/ci/Tests/Linux/status.svg)](https://github.com/rarestype/swift-json/actions/workflows/Tests.yml) |
| 🍏 Darwin | [![Status](https://raw.githubusercontent.com/rarestype/swift-json/refs/badges/ci/Tests/macOS/status.svg)](https://github.com/rarestype/swift-json/actions/workflows/Tests.yml) |
| 🍏 Darwin (iOS) | [![Status](https://raw.githubusercontent.com/rarestype/swift-json/refs/badges/ci/Tests/iOS/status.svg)](https://github.com/rarestype/swift-json/actions/workflows/Tests.yml) |
| 🍏 Darwin (tvOS) | [![Status](https://raw.githubusercontent.com/rarestype/swift-json/refs/badges/ci/Tests/tvOS/status.svg)](https://github.com/rarestype/swift-json/actions/workflows/Tests.yml) |
| 🍏 Darwin (visionOS) | [![Status](https://raw.githubusercontent.com/rarestype/swift-json/refs/badges/ci/Tests/visionOS/status.svg)](https://github.com/rarestype/swift-json/actions/workflows/Tests.yml) |
| 🍏 Darwin (watchOS) | [![Status](https://raw.githubusercontent.com/rarestype/swift-json/refs/badges/ci/Tests/watchOS/status.svg)](https://github.com/rarestype/swift-json/actions/workflows/Tests.yml) |
| 💝 Release | [![Status](https://raw.githubusercontent.com/rarestype/swift-json/refs/badges/ci/SemanticRelease/_all/status.svg)](https://github.com/rarestype/swift-json/actions/workflows/SemanticRelease.yml) |
<!-- DO NOT EDIT ABOVE! AUTOSYNC CONTENT [STATUS TABLE] -->

[Check deployment minimums](https://swiftinit.org/docs/swift-json#ss:platform-requirements)


## Getting started

Many users only need to parse simple JSON messages, which you can do with the `JSON.Node.init(parsing:)` initializer:

```swift
import JSON

let string: String = """
{"success": true, "value": 0.1}
"""

let root: JSON.Node = try .init(parsing: string)
```

If you have UTF-8 data in array form, you can skip the string entirely, and bind your native `UInt8` buffer to an instance of [`JSON`](https://swiftinit.org/docs/swift-json/jsonast/json).

```swift
let json: JSON = .init(utf8: buffer[...])
let root: JSON.Node = try .init(parsing: json)
```

The difference between `JSON` and [`JSON.Node`](https://swiftinit.org/docs/swift-json/jsonast/json/node) is the former is a unparsed buffer wrapper while the latter is a fully-parsed JSON abstract syntax tree (AST). The separation allows you to strongly-type JSON data without necessarily paying the cost of parsing it up front.

`JSON` is backed by `ArraySlice<UInt8>` to help you avoid unnecessary buffer copies.

Depending on what you want to do with JSON, you will either want to use the **query API** (`JQ`, named for the iconic command line tool it was inspired by), or the **modeling API**.


### Using the query API

The **query API** is good for when you want to extract data from JSON payloads at known locations, or make surgical modifications to the JSON without having to model, or even decode, irrelevant portions of the payload. The syntax should look instantly familiar if you have ever used the `jq` command line tool.

```swift
import JSON
import JQ

let string: String = """
{"id": 1, "scores": []}
"""

var root: JSON.Node = try .init(parsing: string)
try root["name"] &= "Barbara"
try root["scores"][0] &= .number(5)

// {"id":1,"scores":[5],"name":"Barbara"}
```

Assigning to JSON paths can throw an error if data already exists in that location, and the node in there is not compatible with the query path.

```swift
do {
    try root["scores"]["banana"] &= true
} catch let error {
    // cannot write to protected json node 'scores'
    print(error)
}
```

Alternatively, if you just want to read data without modifying it, you can do that by calling the `node` property on the accessor.

```swift
if  let score: JSON.Node = try root["scores"][0].node {
    print("read back score: \(score)")
}
```

The `JQ` setters are *vivifying*, in other words, they will create objects and arrays if they do not already exist in the AST.

```swift
try root["profile"]["address"]["city"] &= "Malibu"
// {"id":1,"scores":[5],"name":"Barbara","profile":{"address":{"city":"Malibu"}}}
```

You can also delete nodes by assigning `nil` to the node accessor, although `JQ` will not automatically clean up empty containers after deletion.

```swift
try root["profile"]["address"]["city"] &= nil
// {"id":1,"scores":[5],"name":"Barbara","profile":{"address":{}}}
try root["profile"] &= nil
// {"id":1,"scores":[5],"name":"Barbara"}
```

For this reason, more-sophisticated create-modify-delete operations are often better-served by the yielding accessor APIs, which take a closure argument and supply the caller with the preimage of the node being modified.

The yielding accessors are spelled with the `&`, `&?`, and `&!` operators.

```swift
/// this only creates the wrapper objects if the node is
/// assigned a non-nil value
try root["profile"]["address"]["city"] & {
    if  Bool.random() {
        $0 = .string("Tehran")
    }
}

/// this only calls the closure if the node already exists
root["profile"]["address"]["city"] &? {
    if  case .string(let string) = $0 {
        $0 = .string(string.value.uppercased())
    }
}
```

The most general form of `&` yields the accessed node as `(inout JSON.Node?)`, but it has a variant, `&!`, that passes the caller an `(inout JSON.Node)` binding. `&!` can be thought of as a special case of `&` that initializes the node with a default value of `null` if it does not already exist.

Do note that this `null` is a “hard” `null`, thus if you use `&!`, all wrapper objects will be created, and unlike the fully-general `&`, the update will fail if that `null` can’t be safely written back to the AST.

```swift
/// this initializes the node with a default value (of `null`)
/// if it does not already exist
try root["x"]["y"]["z"] &! {
    if  Bool.random() {
        $0 = true
    }
}
```

Empty brackets are used to bind a node to an array type. The array version of `&!` is just like the general version of `&!`, except it initializes missing fields to empty arrays instead of `null`. There is also `&?`, if the convenience of receiving a non-optional `(inout JSON.Array)` is more important to you than the flexibility to conditionally create or delete the array.

```swift
/// this appends a value to the array only if it already exists
try root["scores"][] & {
    $0?.elements.append(.number(8))
}

/// this initializes the field to an empty array if it does not already exist
try root["friends"][] &! {
    $0.elements.append("Paris")
}
// {"id":1,"scores":[5,8],"friends":["Paris"]}
```

Finally, it’s worth highlighting the powerful `|` and `|?` operators, which provide a concise means of expressing map operations over array fields.

```swift
let scores: [Int]? = try root["scores"][] | { try Int.init(json: $0) }
```

The only difference between `|` and `|?` is that the latter ignores invalid access paths and simply returns nil if the path is incompatible with the container.

There is no syntactical sugar for modifying array elements in place, to do that, you can just compose other library APIs with native Swift loops.

```swift
/// this adds 1 to each score in the 'scores' array
try root["scores"][] &! {
    for i: Int in $0.indices {
        let score: Int = try $0[i].decode()
        $0.elements[i] = .number(score + 1)
    }
}
// {"id":1,"scores":[6,9],"friends":["Paris"]}
```

Most developers using the query API import `JSON` alongside `JQ`, to take advantage of the library’s built-in error handling for casting JSON types. That is where the `try $0[i].decode()` API that we used to cast each `score` to `Int` came from. But `JQ` doesn’t actually depend on the full JSON parser, encoder, or decoder. If you are aggressively stripping down dependencies, you can get away with just importing `JSONAST`, which provides the minimal set of tools for working with JSON trees.

```swift
import JSONAST
import JQ
```

### Using the modeling API

Unlike the query API, the **modeling API** is an indexed API — it builds random-access indexes of the JSON, which makes it more efficient if you are trying to destructure a large portion of the data in a payload as opposed to a small subset.

As the name suggests, using the modeling API involves defining the full schema of the JSON you expect to receive. It requires writing more code, but is also significantly more type safe (as it involves reifying the schema into Swift structures), and also enables blazing fast JSON encoding performance, as modeled types know how to serialize themselves to raw JSON buffer output without building syntax trees at all.

Getting the most out of the modeling API will require learning and internalizing a set of reusable code patterns that can be composed to build roundtripping logic for sophisticated JSON data models. We suggest [reading the tutorial](https://swiftinit.org/docs/swift-json/json/decoding) to get started.
