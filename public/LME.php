<?php
class LME {
    static function restoreAll()
    {
        for($i=0; $i<10; $i++) {
            restore_error_handler();
            restore_exception_handler();
        }

    }

    protected static function friendlyErrorType($type)
    {
        switch($type)
            {
            case E_ERROR: // 1 //
                return 'E_ERROR';
            case E_WARNING: // 2 //
                return 'E_WARNING';
            case E_PARSE: // 4 //
                return 'E_PARSE';
            case E_NOTICE: // 8 //
                return 'E_NOTICE';
            case E_CORE_ERROR: // 16 //
                return 'E_CORE_ERROR';
            case E_CORE_WARNING: // 32 //
                return 'E_CORE_WARNING';
            case E_CORE_ERROR: // 64 //
                return 'E_COMPILE_ERROR';
            case E_CORE_WARNING: // 128 //
                return 'E_COMPILE_WARNING';
            case E_USER_ERROR: // 256 //
                return 'E_USER_ERROR';
            case E_USER_WARNING: // 512 //
                return 'E_USER_WARNING';
            case E_USER_NOTICE: // 1024 //
                return 'E_USER_NOTICE';
            case E_STRICT: // 2048 //
                return 'E_STRICT';
            case E_RECOVERABLE_ERROR: // 4096 //
                return 'E_RECOVERABLE_ERROR';
            case E_DEPRECATED: // 8192 //
                return 'E_DEPRECATED';
            case E_USER_DEPRECATED: // 16384 //
                return 'E_USER_DEPRECATED';
            }
        return $type;
    }

    protected static function post($data)
    {
        $url = LME_BACKEND.'/api/v1/log';
        $fields = http_build_query($data, '', '&');

        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $fields);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER , 1);
        curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 2);
        curl_setopt($ch, CURLOPT_TIMEOUT, 2);
        curl_exec($ch);
    }

    protected static function safeToString($item) {
        if(
            ( !is_array( $item ) ) &&
            ( ( !is_object( $item ) && settype( $item, 'string' ) !== false ) ||
            ( is_object( $item ) && method_exists( $item, '__toString' ) ) )
        ) {
            return ''.$item;
        }

        if(is_array( $item )) {
            return 'Array['.count($item).']';
        }

        if(is_object($item)) {
            return 'Object('.get_class($item).')';
        }

        return '...';
    }

    protected static function getBacktrace($ignore = 2)
    {
        $trace = '';
        foreach (debug_backtrace() as $k => $v) {
            if ($k < $ignore) {
                continue;
            }

            $args = array_map(array('LME', 'safeToString'), $v['args']);

            $trace .= '#' . ($k - $ignore) . ' ' . $v['file'] .
                '(' . $v['line'] . '): ' .
                (isset($v['class']) ? $v['class'] . '->' : '') .
                $v['function'] .
                '(' .implode(', ', $args) . ')' . "\n";
        }

        return $trace;
    }

    static function log($value)
    {
        $info = array(
                'type'=>'LOG',
                'message'=>self::safeToString($value),
                'code'=>null,
                'file'=>null,
                'line'=>null,
                'body'=>var_export($value, true),
                'trace'=>self::getBacktrace()
            );
        self::post($info);
    }
    static function errorHandler($errno, $errstr, $errfile, $errline, $errcontext)
    {
        $info = array(
                'type'=>self::friendlyErrorType($errno),
                'message'=>$errstr,
                'code'=>$errno,
                'file'=>$errfile,
                'line'=>$errline,
                'trace'=>self::getBacktrace(),
                // 'context'=>var_export($errcontext, true),
            );
        self::post($info);
    }

    static function exceptionHandler(Exception $e)
    {
        $info = array(
                'type'=>'EXCEPTION',
                'message'=>$e->getMessage(),
                'code'=>$e->getCode(),
                'file'=>$e->getFile(),
                'line'=>$e->getLine(),
                'trace'=>$e->getTraceAsString(),
                'context'=>null,
            );
        self::post($info);
    }

    static function shutdownHandler()
    {
        $error = error_get_last();
        if($error !== NULL){
            $info = array(
                'type'=>self::friendlyErrorType($error['type']),
                'message'=>$error['message'],
                'code'=>$error['type'],
                'file'=>$error['file'],
                'line'=>$error['line'],
                'trace'=>null,
            );
            self::post($info);
        }
    }

    static function enable()
    {
        self::restoreAll();
        set_error_handler(array('LME', 'errorHandler'));
        set_exception_handler(array('LME','exceptionHandler'));
        register_shutdown_function(array('LME','shutdownHandler'));
    }
}




//--------------------------------------------------------------------

LME::enable();
