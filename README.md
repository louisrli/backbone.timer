Backbone.Timer
=================

**Backbone.Timer** is a tiny Backbone extension (824 bytes) for timing event triggering.

It exposes a single class, `Backbone.Timer`, that can time event triggers on any object that extends `Backbone.Events` (i.e. `Backbone.View`, `Backbone.Model`, or arbitrary objects through `_.extend(myObject, Backbone.Events`).

Requirements
-------
This library requires a version of [Backbone](http://backbonejs.org) later than `0.9.x`.

Usage
--------

`Backbone.Timer` has two methods:

- `timeEvents(startEvent, startTarget, endEvent[, endTarget])`
- `timeEvent(endEvent, endTarget)` 

Only one should be used for a given instance of the timer. That is, a timer should only be used once: an error will be logged in the console if a timer is started multiple times.

### Time between two events

To listen to the time between two events, use `timeEvents(startEvent, startTarget, endEvent, endTarget)`:

```javascript
var myView = new CustomView();  // a Backbone view
var mySecondView = new OtherView();
var timer = new Backbone.Timer();

// Listen to our custom events on the view
timer.timeEvents("myView:shown", myView, "mySecondView:buttonClicked", mySecondView);

// ... do other stuff ...

myView.trigger("myView:shown");  // begin timer

// ... do more stuff, but the timer's running ...

mySecondView.trigger("mySecondView:buttonClicked");  // end timer

console.log(timer.totalTime);
```

If the fourth argument is omitted, the timer will listen to the `startTarget` for both the starting and ending events:

```
// These two are the same
timer1.timeEvents("mouseenter", myView, "click")
timer2.timeEvents("mouseenter", myView, "click", myView)
```

### Time until an event

For convenience, the `timeEvent(endEvent, endTarget)` method will start the timer immediately upon calling -- triggering the starting event is not necessary.

```javascript
var person = new Person();  // a Backbone model
var timer = new Backbone.Timer();

timer.timeEvent("person:turned40", person); // starts timing immediately

// ... do other stuff ...

person.trigger("person:turned40"); // end timer

console.log(timer.totalTime);
```

### Executing code when the timer finishes

A callback can be registered for the end of timing by monitoring the `timer:end` event.

```javascript
timer.on("timer:end", function(e) {
  // `this` is `timer`
});

// or...

myView.listenTo(timer, "timer:end", function(e) {
  // `this` is `myView`
});
```

### Properties

An instance of `Backbone.Timer` has the following properties:

- `startTime`
- `endTime`
- `totalTime`
- `started`
- `finished`

For more details, see the documentation.

Docs
--------
The documentation for the `Backbone.Timer` class can be found [here](http://louisrli.github.io/backbone.timer/Backbone.Timer.html).

License
--------
Copyright 2013 Louis Li

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

```
http://www.apache.org/licenses/LICENSE-2.0
```

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
