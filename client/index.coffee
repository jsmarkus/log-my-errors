ko = require 'knockoutify'
LogItem = require './LogItem'
Filter = require './Filter'
Log = require './Log'
require './visibility'

vm =
	log : new Log(new Filter)

	currentItem : ko.observable()

	unreadItemsCount : ko.observable(0)

	pageTitle : ko.computed
		deferEvaluation : true
		read : =>
			unread = vm.unreadItemsCount()
			if unread
				return "LME (#{unread})"
			return "LME"

	phpCode : ko.observable('')

	codeShown : ko.observable(no)

	filter : new Filter

	onGetCodeClick : ()->
		vm.codeShown yes

	onCloseCodeClick : ()->
		vm.codeShown no


	onClearClick : ()->
		vm.log.items []
		vm.currentItem null

	onRowClick : (item)->
		if vm.currentItem() is item
			vm.currentItem null
		else
			vm.currentItem item

ko.applyBindings vm

#################


backendUrl = document.location.href.replace /\/$/, ''
vm.phpCode """
//TODO: remove the code below!
define('LME_BACKEND', '#{backendUrl}');
eval('?>'.file_get_contents(LME_BACKEND.'/LME.php'));
//TODO: remove the code above!
"""

#################

socket = io.connect '/'
socket.on 'log', (data)->
	vm.log.items.unshift (new LogItem).populate(data)
	vm.unreadItemsCount 1 + vm.unreadItemsCount()

#################
isVisible = yes

visibly.onVisible ->
	vm.unreadItemsCount 0
	isVisible = yes

visibly.onHidden ->
	isVisible = no