struct MyPair:
    var first: Int
    var second: Int

    fn __init__(inout self, first: Int, second: Int):
        self.first = first
        self.second = second

    fn get_sum(self) -> Int:
        return self.first + self.second


# synthesize the essential lifecycle methods so your object provides full value semantics
# generates the __init__(), __copyinit__(), and __moveinit__() methods
@value
struct MyValueType:
    var name: String
    var age: Int
