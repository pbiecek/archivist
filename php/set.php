<?php
$link = preg_replace("/[^0-9ABCDEFabcdef]*/","",htmlspecialchars($_GET["ID"]));

$content2 = '<script src="http://code.jquery.com/jquery-1.6.2.min.js"></script><script src="html-crc-reload.js"></script><body style="margin:0px;padding:0px;overflow:hidden">
    <iframe src="https://rawgithub.com/pbiecek/graphGallery/master/'. $link .'/index.html" frameborder="0" style="overflow:hidden;height:100%;width:100%" height="100%" width="100%"></iframe>
</body>';

file_put_contents("index.html", $content2);

$content = '<meta http-equiv="Refresh" content="2;URL=http://smarterpoland.pl/QRka/index.html"><body style="margin:0px;padding:0px;overflow:hidden">
    <iframe src="https://rawgithub.com/pbiecek/graphGallery/master/'. $link .'/index.html" frameborder="0" style="overflow:hidden;height:100%;width:100%" height="100%" width="100%"></iframe>
</body>';

echo $content;
?>
