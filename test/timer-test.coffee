((->
  class TestView extends Backbone.View

  testTimerStarted = (t) ->
    module("timerStarted")
    ok(t.started, "t.started should be true")
    ok(t.finished == false, "t.finished should be false")

    ok(t.startTime != null, "t.startTime should not be null")
    ok(t.endTime == null, "t.endTime should be null (uninitialized)")
    ok(t.totalTime == null, "t.totalTime should be null")

  testTimerEnded = (t) ->
    module("timerEnded")
    ok(t.finished, "Timer should be finished")
    ok(t.totalTime != null, "Should have a total time")
    ok(t.endTime != null, "Should have an end time")
    ok(t.totalTime == t.endTime - t.startTime, "totalTime should be correct")

  testTimerNotStarted = (t) ->
    module("timerNotStarted")
    ok(t.started == false, "Timer is not started")
    ok(t.finished == false, "Timer is not finished")
    ok(not (t.startTime or t.endTime or t.totalTime), "No times should be initialized")


  # Test an extra assertion for the callback
  asyncTest('Test timeEvent', ->
    v = new TestView()
    t = new Backbone.Timer()
    t.timeEvent("test:event", v)

    t.on("timer:end", -> ok(true, "Timer should make a callback"); start())

    testTimerStarted(t)

    v.trigger("test:event")

    testTimerEnded(t)
  )

  asyncTest('Test timeEvents, two separate', ->
    v1 = new TestView()
    v2 = new TestView()
    t = new Backbone.Timer()
    t.timeEvents("test:start", v1, "test:end", v2)

    t.on("timer:end", -> ok(true, "Timer should make a callback"); start())

    testTimerNotStarted(t)

    v1.trigger("test:start")
    testTimerStarted(t)

    v2.trigger("test:end")

    testTimerEnded(t)
  )

  asyncTest('Test timeEvents, same object', ->
    v = new TestView()
    t = new Backbone.Timer()
    t.timeEvents("test:start", v, "test:end")

    t.on("timer:end", -> ok(true, "Timer should make a callback"); start())

    testTimerNotStarted(t)

    v.trigger("test:start")
    testTimerStarted(t)

    v.trigger("test:end")

    testTimerEnded(t)
  )

  asyncTest('Ensure that timer is around the correct time', ->
    v = new TestView()
    t = new Backbone.Timer()
    t.timeEvent("test:event", v)

    expected = 2000
    delta = 10

    t.on("timer:end", ->
      ok(expected - 15 < t.totalTime < expected + 15, "Time is within 15 ms")
      start()
    )

    setTimeout((->
      v.trigger("test:event")
    ), expected)

  )

)())
