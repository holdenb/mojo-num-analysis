# RUN: %mojo %s | FileCheck %s

from collections import List, Dict, Set
from tensor import Tensor, TensorShape
from analysis.trait_ex import StealthCow, make_it_quack


# Example of Dtypes (SIMD)
def describeDType[dtype: DType]():
    print(dtype, "is floating point:", dtype.is_floating_point())
    print(dtype, "is integral:", dtype.is_integral())
    # print("Min/max finite values for", dtype)
    # print(min_finite[dtype](), max_finite[dtype]())


# mutability
# All values passed into a Mojo def function are owned, by default.
# All values passed into a Mojo fn function are borrowed, by default.
fn add_mutable(inout x: Int, borrowed y: Int):
    x += y


# ownership and transfer op
# https://docs.modular.com/mojo/manual/values/ownership
# And finally, if you'd like your function to receive value ownership, add the owned keyword in front of the argument name.
# This convention is usually combined with use of the postfixed ^ "transfer" operator on the variable that is passed into the function, which ends the lifetime of that variable.
fn take_text(owned text: String):
    text += "!"
    print(text)


def my_func():
    var message: String = "Hello"
    take_text(message^)


# explicit ownership
def print_shape(borrowed tensor: Tensor[DType.float32]):
    shape = tensor.shape()
    print(str(shape))


def main():
    # CHECK: Hello Mojo 🔥!
    print("Hello Mojo 🔥!")
    for x in range(9, 0, -3):
        print(x)

    # strings
    var s: String = "Testing"
    s += " Mojo strings"
    print(s)

    # built-in containers
    var list = List(2, 3, 5)
    list.append(7)
    list.append(11)
    print("Popping last item from list: ", list.pop())
    for idx in range(len(list)):
        print(list[idx], end=", ")

    # dicts
    var d = Dict[String, Float64]()
    d["plasticity"] = 3.1
    d["elasticity"] = 1.3
    d["electricity"] = 9.7
    for item in d.items():
        print(item[].key, item[].value)

    # sets
    i_like = Set("sushi", "ice cream", "tacos", "pho")
    you_like = Set("burgers", "tacos", "salad", "ice cream")
    we_like = i_like.intersection(you_like)

    print("We both like:")
    for item in we_like:
        print("-", item[])

    # Optionals
    # Two ways to initialize an Optional with a value
    var opt1 = Optional(5)
    var opt2: Optional[Int] = 5
    # Two ways to initalize an Optional with no value
    var opt3 = Optional[Int]()
    var opt4: Optional[Int] = None

    var custom_greeting: Optional[String] = None
    print(custom_greeting.or_else("Hello"))

    custom_greeting = str("Hi")
    print(custom_greeting.or_else("Hello"))

    # explicit ownership example
    var tensor = Tensor[DType.float32](256, 256)
    print_shape(tensor)

    # traits example
    var cow = StealthCow()
    make_it_quack(cow)

    # https://docs.modular.com/mojo/manual/types
    describeDType[DType.float32]()
