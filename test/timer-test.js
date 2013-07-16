(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  (function() {
    var TestView, testTimerEnded, testTimerNotStarted, testTimerStarted, _ref;
    TestView = (function(_super) {
      __extends(TestView, _super);

      function TestView() {
        _ref = TestView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      return TestView;

    })(Backbone.View);
    testTimerStarted = function(t) {
      module("timerStarted");
      ok(t.started, "t.started should be true");
      ok(t.finished === false, "t.finished should be false");
      ok(t.startTime !== null, "t.startTime should not be null");
      ok(t.endTime === null, "t.endTime should be null (uninitialized)");
      return ok(t.totalTime === null, "t.totalTime should be null");
    };
    testTimerEnded = function(t) {
      module("timerEnded");
      ok(t.finished, "Timer should be finished");
      ok(t.totalTime !== null, "Should have a total time");
      ok(t.endTime !== null, "Should have an end time");
      return ok(t.totalTime === t.endTime - t.startTime, "totalTime should be correct");
    };
    testTimerNotStarted = function(t) {
      module("timerNotStarted");
      ok(t.started === false, "Timer is not started");
      ok(t.finished === false, "Timer is not finished");
      return ok(!(t.startTime || t.endTime || t.totalTime), "No times should be initialized");
    };
    asyncTest('Test timeEvent', function() {
      var t, v;
      v = new TestView();
      t = new Backbone.Timer();
      t.timeEvent("test:event", v);
      t.on("timer:end", function() {
        ok(true, "Timer should make a callback");
        return start();
      });
      testTimerStarted(t);
      v.trigger("test:event");
      return testTimerEnded(t);
    });
    asyncTest('Test timeEvents, two separate', function() {
      var t, v1, v2;
      v1 = new TestView();
      v2 = new TestView();
      t = new Backbone.Timer();
      t.timeEvents("test:start", v1, "test:end", v2);
      t.on("timer:end", function() {
        ok(true, "Timer should make a callback");
        return start();
      });
      testTimerNotStarted(t);
      v1.trigger("test:start");
      testTimerStarted(t);
      v2.trigger("test:end");
      return testTimerEnded(t);
    });
    asyncTest('Test timeEvents, same object', function() {
      var t, v;
      v = new TestView();
      t = new Backbone.Timer();
      t.timeEvents("test:start", v, "test:end");
      t.on("timer:end", function() {
        ok(true, "Timer should make a callback");
        return start();
      });
      testTimerNotStarted(t);
      v.trigger("test:start");
      testTimerStarted(t);
      v.trigger("test:end");
      return testTimerEnded(t);
    });
    return asyncTest('Ensure that timer is around the correct time', function() {
      var delta, expected, t, v;
      v = new TestView();
      t = new Backbone.Timer();
      t.timeEvent("test:event", v);
      expected = 2000;
      delta = 10;
      t.on("timer:end", function() {
        var _ref1;
        ok((expected - 15 < (_ref1 = t.totalTime) && _ref1 < expected + 15), "Time is within 15 ms");
        return start();
      });
      return setTimeout((function() {
        return v.trigger("test:event");
      }), expected);
    });
  })();

}).call(this);
