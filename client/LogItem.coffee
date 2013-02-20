ko = require 'knockoutify'

module.exports = class LogItem
	constructor : ->
		@type    = ko.observable('')
		@message = ko.observable()
		@code    = ko.observable()
		@file    = ko.observable()
		@line    = ko.observable()
		@trace   = ko.observable()
		@context = ko.observable()

		@isLog = ko.computed =>
			@type().match /log/i
		@isWarning = ko.computed =>
			@type().match /warning/i
		@isNotice = ko.computed =>
			@type().match /notice/i
		@isStrict = ko.computed =>
			@type().match /strict/i
		@isError = ko.computed =>
			not @isWarning() and not @isNotice() and not @isStrict()

	populate : (data)->
		for own key, value of data
			if @hasOwnProperty key
				@[key]?(value)
		@
