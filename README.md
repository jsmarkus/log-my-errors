log-my-errors
=============

Log-my-errors (LME) logs errors, exceptions and simple messages from PHP to web-server.

Messages are displayed in web-interface like this:

![](/media/screen1.png)

Installation
------------

To install LME, clone the repo, go to folder and type:

    npm install

This will install npm dependencies.

Run
---

To run LME, go to folder and type:

    npm start

This will start backend server.

Then go to http://127.0.0.1:7001/.

Press "Get code" button, copy PHP code and insert it into your php application.

Now all your warnings, notices, errors and exceptions will be automatically displayed in LME web-interface.

You may also use:

    LME::log($anything);

from your PHP code to dump any kind of PHP value - string, object, array, etc.
