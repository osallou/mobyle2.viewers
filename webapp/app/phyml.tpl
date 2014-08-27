<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Mobyle2</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- Place favicon.ico and apple-touch-icon.png in the root directory -->
    <!-- build:css styles/vendor.css -->
    <!-- bower:css -->
    <link rel="stylesheet" href="bower_components/bootstrap/dist/css/bootstrap.css" />
    <link rel="stylesheet" href="bower_components/bootstrap/dist/css/bootstrap-theme.css" />
    <!-- endbower -->
    <!-- endbuild -->
    <!-- build:css({.tmp,app}) styles/app.css -->
    <link rel="stylesheet" href="styles/app.css">
    <!-- endbuild -->

</head>
<body>
     <!--(bake includes/header.html)-->
    <div class="container">
    <div class="content">
      <div class="row" >
        <h1>PhyML editor</h1>
      </div>
      <div class="row">
         <div id="phyCanvas"></div>
      </div>

    </div>
    </div><!-- /.container -->

<!--(bake includes/footer.html)-->

<!-- build:js scripts/vendor.js -->
<!-- bower:js -->
<script src="bower_components/jquery/dist/jquery.js"></script>
<script src="bower_components/bootstrap/dist/js/bootstrap.js"></script>
<script src="bower_components/knockoutjs/dist/knockout.js"></script>
<script src="bower_components/raphael/raphael-min.js"></script>
<!-- endbower -->
<!-- endbuild -->
<!-- build:js({.tmp,app}) scripts/scripts.js -->
<script src="scripts/app.js"></script>
<script src="scripts/jsphylosvg-min.js"></script>
<!-- endbuild -->


<script>

var editor = null;

    $( document ).ready(function() {

        setInterval(function() { refreshToken($("#server").val());}, 1800000);

        var file = getURLParameter('file');
        var path = getURLParameter('path');
        getFile(file, path);

    });

function getFile(file, path)
{
  if(file===undefined) { return; }
  var server = getURLParameter('server');
  $.ajax({
    url: server+'/data-manager/download/'+file+'/'+path,
    type: 'GET',
    datatype: 'text/plain',
    success: function(data) { displayFile(data);  },
    error: function() { alert('Failed!'); },
    beforeSend: setHeader
  });
}


function setHeader(xhr)
{
    xhr.setRequestHeader('Authorization', 'bearer ' + getURLParameter('access_token'));
}

function displayFile(data) {
    drawNewick(data);
});

function drawNewick(xml) {
    var phylocanvas = new Smits.PhyloCanvas(
                 xml,             // Newick or XML string
                'phyCanvas',    // Div Id where to render
                800, 800,              // Height, Width in pixels
                'circular'
                ); 

}

function drawPhy(xml) {
    var dataObject = {
                phyloxml: xml,     // If using phyloXML, need to tell us - or else we assume it is Newick
                fileSource: true    // Need to indicate that it is from a file for us to process it correctly
        };  
    var phylocanvas = new Smits.PhyloCanvas(
                dataObject,             // Newick or XML string
                'phyCanvas',    // Div Id where to render
                800, 800,              // Height, Width in pixels
                'circular'
                ); 
}


}

</script>

</body>
</html>
