<!DOCTYPE html><html><head><meta charset="utf-8"><meta http-equiv="X-UA-Compatible" content="chrome=1"><meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"><title>teeble</title><link rel="icon" href="http://static.hubspot.com/favicon.ico"><link type="text/css" rel="stylesheet" href="https://static2cdn.hubspot.com/hubspot_public_assets/static-1.112/shared/sass/hubspot_public_assets.css"><link type="text/css" rel="stylesheet" href="https://static.hubspot.com/bundles/navigation.css"><link rel="stylesheet" href="http://github.hubspot.com/documentation-example/css/print.css"><link rel="stylesheet" href="http://github.hubspot.com/documentation-example/css/navigation.css"><link rel="stylesheet" href="http://github.hubspot.com/documentation-example/css/documentation.css"><link rel="stylesheet" href="http://github.hubspot.com/documentation-example/css/highlight/github.css"><script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script><script type="text/javascript" src="//use.typekit.net/jbn8qxr.js"></script><script type="text/javascript">try{Typekit.load();}catch(e){}
</script></head><body><div id="hs-nav-v3" class="nav-width-flex signed-out-nav">
    <div class="hs-nav-section main-nav">
        <div class="nav-section-inner">
            <ul class="nav-links-left">
                <li class="first"><a class="nav-logo" href="http://www.hubspot.com/"><img height="34" src="https://static.hubspot.com/style-guide/img/nav-sprocket.png" width="29"></a></li>
                <li>
                    <a href="http://hubspot.github.com">
                        HubSpot Open Source
                    </a>
                </li>
                <li>
                    <a href="http://dev.hubspot.com">
                        Development Team
                    </a>
                </li>
            </ul>
            <ul class="nav-links-right">
                <li class="first">
                    <a href="https://login.hubspot.com/login/" class="sign-in">Work for HubSpot</a>
                </li>
                <li>
                    <span class="try-label">We're hiring:</span>
                </li>
            </ul>
        </div>
    </div>
</div><div class="hs-page-width-normal"><div class="row-fluid"><div class="span12"><h1 class="hs-doc-page-header">teeble</h1></div></div><div class="row-fluid"><div class="span3"><div class="hs-doc-sidenav"><nav><ul class="hs-public-sidenav"><li class=""><a href="../../../../../../index.html">Home</a></li><li><b>examples/netflix-client-paging</b></li><li class=""><a href="../../../../../../docs/build/examples/netflix-client-paging/app.js.html">app.js</a></li><li><b>examples/netflix-client-paging/collections</b></li><li class=""><a href="../../../../../../docs/build/examples/netflix-client-paging/collections/PaginatedCollection.js.html">PaginatedCollection.js</a></li><li><b>examples/netflix-client-paging/models</b></li><li class=""><a href="../../../../../../docs/build/examples/netflix-client-paging/models/Item.js.html">Item.js</a></li><li><b>examples/netflix-client-paging/views</b></li><li class=""><a href="../../../../../../docs/build/examples/netflix-client-paging/views/NetflixTable.js.html">NetflixTable.js</a></li><li><b>examples/netflix-request-paging</b></li><li class=""><a href="../../../../../../docs/build/examples/netflix-request-paging/app.js.html">app.js</a></li><li><b>examples/netflix-request-paging/collections</b></li><li class=""><a href="../../../../../../docs/build/examples/netflix-request-paging/collections/PaginatedCollection.js.html">PaginatedCollection.js</a></li><li><b>examples/netflix-request-paging/models</b></li><li class=""><a href="../../../../../../docs/build/examples/netflix-request-paging/models/Item.js.html">Item.js</a></li><li><b>examples/netflix-request-paging/views</b></li><li class=""><a href="../../../../../../docs/build/examples/netflix-request-paging/views/NetflixTable.js.html">NetflixTable.js</a></li><li><b>examples/sortbar</b></li><li class=""><a href="../../../../../../docs/build/examples/sortbar/app.js.html">app.js</a></li><li><b>examples/sortbar/collections</b></li><li class=""><a href="../../../../../../docs/build/examples/sortbar/collections/PaginatedCollection.js.html">PaginatedCollection.js</a></li><li><b>examples/sortbar/models</b></li><li class=""><a href="../../../../../../docs/build/examples/sortbar/models/Item.js.html">Item.js</a></li><li><b>examples/sortbar/views</b></li><li class=""><a href="../../../../../../docs/build/examples/sortbar/views/BrowserTableView.js.html">BrowserTableView.js</a></li><li><b>Annotated source</b></li><li class=""><a href="../../../../../../docs/build/source/setup.html">lib/setup.coffee</a></li><li class=""><a href="../../../../../../docs/build/source/table-renderer.html">lib/table-renderer.coffee</a></li><li class=""><a href="../../../../../../docs/build/source/teeble.html">lib/teeble.coffee</a></li></ul></nav></div></div><div class="span9"><div class="hs-doc-content"><p>(function ( views ) {</p>
<pre><code>views<span class="preprocessor">.NetflixTable</span> = Teeble<span class="preprocessor">.TableView</span><span class="preprocessor">.extend</span>({
})<span class="comment">;</span></code></pre>
<p>})( app.views );</p>
</div></div></div></div><div class="hs3-public-footer"><div class="row-fluid hs-page-width-normal"><div class="span3 hidden-phone"><h3>HubSpot</h3><ul><li><a href="http://www.hubspot.com">Home</a></li><li><a href="http://www.hubspot.com/software">Products</a></li><li><a href="http://www.hubspot.com/internet-marketing-company/">About</a></li></ul></div><div class="span3"><h3>Projects</h3><ul><li><a href="http://github.hubspot.com/messenger">Messenger</a></li><li><a href="http://github.hubspot.com/facewall">Facewall</a></li><li><a href="http://github.hubspot.com/jquery-zoomer">jQuery Zoomer</a></li><li><a href="http://github.hubspot.com/humanize">Humanize</a></li><li><a href="http://github.hubspot.com/teeble">Teeble</a></li></ul></div><div class="span3"><h3>Development Team</h3><ul><li><a href="http://dev.hubspot.com">Home</a></li><li><a href="http://dev.hubspot.com/teams">Teams</a></li><li><a href="http://dev.hubspot.com/people">People</a></li><li><a href="http://dev.hubspot.com/jobs">Jobs</a></li></ul></div><div class="span3 hidden-phone"><h3>Developer API</h3><ul><li><a href="http://developers.hubspot.com/">Developer Documentation</a></li></ul></div></div></div><!-- Start of Async HubSpot Analytics Code -->
<script type="text/javascript">
    (function(d,s,i,r) {
        if (d.getElementById(i)){return;}
        var n=d.createElement(s),e=d.getElementsByTagName(s)[0];
        n.id=i;n.src='//js.hubspot.com/analytics/'+(Math.ceil(new Date()/r)*r)+'/51294.js';
        e.parentNode.insertBefore(n, e);
    })(document,"script","hs-analytics",300000);
</script>
<!-- End of Async HubSpot Analytics Code --></body></html>