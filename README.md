# Regexp on Array - ARE

Maintained by: Soutaro Matsumoto

## Abstract

`Regexp` is a powerful tool for defining the set of string, and testing membership of a string with the set.
This library provides such kind of tool for `Array` and other classes with `each` method.

## Installation

````
gem install are
````


## Reference

````ruby
require "are"

ARE.any                        # /./
ARE(1,2)                       # /12/           Concatenation
ARE(1,2) + ARE(3,4)            # /1234/         Concatenation
ARE(1,2) | ARE(3,4)            # /(12)|(34)/    Alternation
ARE.oneof(1,2,3)               # /[123]/
ARE.except(0,1,2)              # /[^012]/
ARE.start + ARE.any + ARE.last # /\A.\Z/
ARE(1,2).star                  # /(12)*/        Repeat
ARE(1,2).plus                  # /(12)+/        Repeat
ARE(1,2)._?                    # /(12)?/        Optional
ARE(1,2).star(min:3, max:4)    # /(12){3,4}/
````

### Examples

#### Array should contain `1`

````ruby
ARE(1) =~ array
array.includes?(1)
````

#### Array should contain subarray `[1,2]`

````ruby
ARE(1,2)
````

#### Array should contain subarray of `[1,2]` and `[3,4]`

````ruby
ARE(1,2) + ARE.any.star + ARE(3,4)
````

#### Array should contain subarray of `[1,2]` and `[3,4]`, and should have more than 4 elements between them

````ruby
ARE(1,2) + ARE.any + ARE.any + ARE.any + ARE.any + ARE.any.star + ARE(3,4)
ARE(1,2) + ARE.any.star(min:4) + ARE(3,4)
````

#### Array should contain subarray of `[1,2]` and `[3,4]`, and should not have `5` or `6` between them 

````ruby
ARE(1,2) + ARE.except(5,6).star + ARE(3,4)
````

### Testing a element of Array

It uses `===` operator.

````ruby
ARE(Fixnum, Symbol, String) =~ [1, :x, "a"]       # => 0
ARE(:even?.to_proc) =~ [1,3,5]                    # => nil
ARE(1...3) =~ [5,4,3,2,1]                         # => 3
````

