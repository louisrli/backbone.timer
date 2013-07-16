###*
* Copyright 2013 Louis Li
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
###

###*
* This library provides a Backbone.EventTimer class for timing
* the triggering of events. It can either record the time
* elapsed between two events, or start timing immediately
* until an end event is triggered.
*
* Requires Backbone 0.9.x or later.
###

###*
* @name Backbone.Timer
* @class
###
Backbone.Timer = ((_) ->
  class EventTimer
    _.extend(@prototype, Backbone.Events)

    constructor: ->
      ###*
      * True if the timer has started.
      * @var {boolean} started
      * @instance
      * @memberOf Backbone.Timer
      ###
      @started = false

      ###*
      * True if the timer has finished.
      * @var {boolean} finished
      * @instance
      * @memberOf Backbone.Timer
      ###
      @finished = false

      ###*
      * Time (ms) when the timer started. null if not started.
      * @var {number} startTime
      * @instance
      * @memberOf Backbone.Timer
      ###
      @startTime = null

      ###*
      * Time (ms) when the timer ended. null if not ended.
      * @var {number} endTime
      * @instance
      * @memberOf Backbone.Timer
      ###
      @endTime = null

      ###*
      * Time (ms) elapsed from start to end. null if the timer has not finished.
      * @var {number} totalTime
      * @instance
      * @memberOf Backbone.Timer
      ###
      @totalTime = null

    ###*
    * @private
    ###
    _checkStarted: ->
      if @started
        console.error("Backbone.Timer was started twice.")
        return

    ###*
    * @private
    ###
    _startTimer: (endEvent, endTarget) ->
      @started = true
      @startTime = +new Date()

      # Start listening for the end event
      @listenToOnce(endTarget, endEvent, ->
        @finished = true
        @endTime = +new Date()
        @totalTime = @endTime - @startTime

        # Trigger an event that others can use
        @trigger("timer:end")
      )

    ###*
    * Start timing an event immediately, and listen to
    * the given event and target to end the timer.
    *
    * @name timeEvent
    * @memberOf Backbone.Timer
    * @method
    * @instance
    * @param {string} endEvent The event the timer listens to for stopping the timer
    * @param {Backbone.Events} endTarget The object to listen to for stopping the timer
    ###
    timeEvent: (endEvent, endTarget) ->
      @_checkStarted()
      @_startTimer(endEvent, endTarget)

    ###*
    * Start timing when a target event is triggered. Listen to
    * the given event and target to end the timer.
    *
    * @name timeEvents
    * @instance
    * @memberOf Backbone.Timer
    * @method
    * @param {string} startEvent The event the timer listens to for starting the timer
    * @param {Backbone.Events} startTarget The object to listen to for starting the timer.
    * @param {string} endEvent The event the timer listens to for stopping the timer
    * @param {Backbone.Events} [endTarget] The object to listen to for stopping the timer. If not provided, then the endTarget will be the same as the startTarget.
    ###
    timeEvents: (startEvent, startTarget, endEvent, endTarget) ->
      @_checkStarted()

      # If unprovided, use the same target for both start and end
      if endTarget == undefined
        endTarget = startTarget

      @listenToOnce(startTarget, startEvent, ->
        @_startTimer(endEvent, endTarget)
      )

  return EventTimer
)(_)
