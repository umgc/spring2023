# ViroTour UI Testing
The ViroTour UI testing folder contains three folders:

1. `Unit` - tests a single function, method, or class.
2. `Widget` - (in other UI frameworks referred to as component test) tests a single widget.
3. `Integration` - tests a complete app or a large part of an app.

Generally speaking, a well-tested app has many unit and widget tests, tracked by code coverage, plus enough integration tests to cover all the important use cases. This advice is based on the fact that there are trade-offs between different kinds of testing, seen below.

|                  | Unit  | Widget | Integration |
|------------------|-------|--------|-------------|
| Confidence       | Low   | Higher | Highest     |
| Maintenance Cost | Low   | Higher | Highest     |
| Dependencies     | Few   | More   | Most        |
| Execution Speed  | Quick | Quick  | Slow        |

For more information, see the [Testing Flutter apps](https://docs.flutter.dev/testing) documentation.


To run tests, you must follow these steps:
1. Make sure you are in the `test` folder
2. Run the command `flutter test ./{unit/widget/integration folder}/{test file name}
