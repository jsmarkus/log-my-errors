module.exports = notify = (title, content)->
	if window.webkitNotifications?.checkPermission() is 0
		notification = window.webkitNotifications.createNotification null,
			title,
			content
		notification.show()
	else
		window.webkitNotifications?.requestPermission()

notify.enable = ->window.webkitNotifications?.requestPermission()
notify.isEnabled = ->window.webkitNotifications?.checkPermission() is 0