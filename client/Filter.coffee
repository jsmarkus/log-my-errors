ko = require 'knockoutify'

module.exports = class Filter
    constructor : ->
        @all = ko.observable on
        @warning = ko.observable off
        @error = ko.observable off
        @log = ko.observable off

        @enabled = ko.observable on

    reset : ->
        @all off
        @warning off
        @error off
        @log off

    toggleAll : ->
        @enabled off
        @reset()
        @all on
        @enabled on

    toggleWarning : ->
        @enabled off
        @reset()
        @warning on
        @enabled on

    toggleError : ->
        @enabled off
        @reset()
        @error on
        @enabled on

    toggleLog : ->
        @enabled off
        @reset()
        @log on
        @enabled on
