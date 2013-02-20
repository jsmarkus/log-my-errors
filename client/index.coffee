ko = require 'knockoutify'
LogItem = require './LogItem'
notify = require './notify'
require './visibility'

vm =
	logItems : ko.observableArray []

	currentItem : ko.observable()

	unreadItemsCount : ko.observable(0)

	notificationsEnabled : ko.computed
		deferEvaluation : true
		read : => notify.isEnabled()

	pageTitle : ko.computed
		deferEvaluation : true
		read : =>
			unread = vm.unreadItemsCount()
			if unread
				return "(#{unread})"
			return "clear"

	phpCode : ko.observable('')

	codeShown : ko.observable(no)

	onGetCodeClick : ()->
		vm.codeShown yes

	onCloseCodeClick : ()->
		vm.codeShown no


	onClearClick : ()->
		vm.logItems []
		vm.currentItem null

	onRowClick : (item)->
		if vm.currentItem() is item
			vm.currentItem null
		else
			vm.currentItem item

	onEnableNotificationsClick : ->
		notify.enable()

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
	vm.logItems.unshift (new LogItem).populate(data)
	vm.unreadItemsCount 1 + vm.unreadItemsCount()
	notify data.type, data.message unless isVisible

#################
isVisible = yes

visibly.onVisible ->
	vm.unreadItemsCount 0
	isVisible = yes

visibly.onHidden ->
	isVisible = no