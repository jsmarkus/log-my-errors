ko = require 'knockoutify'

module.exports = class Log

    constructor : (filter)->
        @items = ko.observableArray []
        @filter = filter
        # @filter.enabled.subscribe @onFilter
        @filteredItems = ko.computed @_filter

    # onFilter : (enabled)=>
    #     return unless enabled
    #     console.log 'filter!'

    _filter : ()=>
        return [] unless @filter.enabled()
        return ko.utils.arrayFilter @items(), (item)=>
            return true if @filter.all()
            return item.isWarning() || item.isStrict() || item.isNotice() if @filter.warning()
            return item.isError() if @filter.error()
            return item.isLog() if @filter.log()
