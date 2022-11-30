<?php

function factorial($num) {
    if ($num == 0)
        return 1;
    return $num * factorial($num - 1);
}

$num = explode("/", $_SERVER['PHP_SELF'])[2];
if (!is_numeric($num)) {
    exit("Invalid integer $num");
}

$num = (int)$num;
echo factorial($num);
?>
