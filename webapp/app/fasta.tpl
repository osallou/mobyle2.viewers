<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Mobyle2</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- Place favicon.ico and apple-touch-icon.png in the root directory -->
    <!-- build:css styles/vendorfasta.css -->
    <!-- bower:css -->
    <link rel="stylesheet" href="bower_components/codemirror/lib/codemirror.css" />
    <link rel="stylesheet" href="bower_components/bootstrap/dist/css/bootstrap.css" />
    <link rel="stylesheet" href="bower_components/bootstrap/dist/css/bootstrap-theme.css" />
    <!-- endbower -->
    <!-- endbuild -->
    <!-- build:css({.tmp,app}) styles/appfasta.css -->
    <link rel="stylesheet" href="styles/app.css">
    <!-- endbuild -->

</head>
<body>
     <!--(bake includes/header.html)-->
    <div class="container">
    <div class="content">
      <div class="row" >
        <h1>Fasta editor</h1>
      </div>
      <div class="row">
      <div class="col-md-8">
      <textarea id="fileeditor">
      </textarea>
      </div>
      <div class="col-md-4">
          <button id="save" class="btn btn-large btn-primary">Save</button>
      </div>
      </div>
    </div>
    </div><!-- /.container -->

<!--(bake includes/footer.html)-->

<!-- build:js scripts/vendorfasta.js -->
<!-- bower:js -->
<script src="bower_components/jquery/dist/jquery.js"></script>
<script src="bower_components/bootstrap/dist/js/bootstrap.js"></script>
<script src="bower_components/knockoutjs/dist/knockout.js"></script>
<script src="bower_components/codemirror/lib/codemirror.js"></script>
<!-- endbower -->
<!-- endbuild -->
<!-- build:js({.tmp,app}) scripts/scriptsfasta.js -->
<script src="scripts/app.js"></script>
<script src="scripts/fasta.js"></script>
<!-- endbuild -->


<script>

var editor = null;

    $( document ).ready(function() {

        setInterval(function() { refreshToken($("#server").val());}, 1800000);

        var file = getURLParameter('file');
        var path = getURLParameter('path');
        getFile(file, path, displayFile);

        $("#save").click(function() {
          var file = getURLParameter('file');
          var path = getURLParameter('path');
          putFile(file, path, editor.getValue());
        });
    });


function displayFile(data) {
    var mytextarea = $("#fileeditor");
    mytextarea.text(data);
    editor = CodeMirror.fromTextArea(mytextarea[0], {
                                               mode: "text/x-fasta",
                                               lineNumbers: true,
                                               lineWrapping: true
                                               });

}

</script>

</body>
</html>
