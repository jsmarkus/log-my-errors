<?php

define('LME_BACKEND', 'http://127.0.0.1:7001');
eval('?>'.file_get_contents(LME_BACKEND.'/LME.php'));

trigger_error('user_error');
fopen('asd');
LME::log($_SERVER);
LME::log(array(1,2,3));
require('test2.php');
