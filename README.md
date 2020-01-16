# QueueStack
Queue and Stack implementation for Mathematica

I'm an academic, so if you use this for anything, please let me know so that I can add it to my resume.

Code started with several Mathematica Stackexchange answers:
- (Carl Woll)	https://mathematica.stackexchange.com/questions/198341/implementing-core-data-structures/198345 
- (Carl Woll)	https://mathematica.stackexchange.com/questions/151948/remove-element-from-list-and-store-it-in-variable
- (Leonid Shifrin) https://mathematica.stackexchange.com/questions/24988/can-one-identify-the-design-patterns-of-mathematica/25474#25474

I gave the two (queues and stacks) a common syntax and behavior when empty, added a Select function and a Peek function, and made the data structure hidden.

The ID for a stack or queue can be any Mathematica object, but I've only tested Integer and String objects. A stack with ID "primes" is a different object than a queue with ID "primes"; you can have both and they will not interact.

## Example Usage
```
(* To load the package *)
<< QueueStack`

(* Add 120000 primes to a queue in about a second *)
(* Queues are represented as Association[] internally, but the user doesn't need to know that *)
AbsoluteTiming[Do[QueuePush["primes", Prime[k]], {k, 1, 120000}]]

(* The queue has ID "primes". An ID can be anything, I suppose, but better to keep it simple: an integer or a string works fine. *)
(* Operations on a queue *)
QueueLength["primes"]
QueueEmpty["primes"]
QueuePeek["primes"]
Table[QueuePop["primes"], {5}]
QueueSelect["primes", "1mod4", Mod[#, 4] == 1 &]
QueueLength["1mod4"]
QueuePop["1mod4"]
QueueSelect["1mod4", "a few", GreaterThan[1000], 10]
QueueList["a few"]
QueueClear[{"primes", "1mod4", "a few"}]

(* Stacks are about twice as fast as queue's. *)
(* Stacks are represented as nested lists {{{},"a"},"b"},"c"}, but you don't need to understand how or why. *)
AbsoluteTiming[Do[StackPush["primes", Prime[k]], {k, 1, 120000}]]

(* The stack has ID "primes". *)
StackLength["primes"]
StackEmpty["primes"]
StackPeek["primes"]
Table[StackPop["primes"], {5}]
StackSelect["primes", "1mod4", Mod[#, 4] == 1 &]
StackLength["1mod4"]
StackPop["1mod4"]
StackSelect["1mod4", "a few", GreaterThan[1000], 10]
StackList["a few"]
StackClear[{"primes", "1mod4", "a few"}]

(* Notice that QueueSelect preserves the order in the queue, while StackSelect reverses the order. *)
```
