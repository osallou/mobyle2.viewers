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
    <link rel="stylesheet" href="bower_components/handsontable/dist/jquery.handsontable.full.css" />
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
        <h1>CSV editor</h1>
      </div>
      <div class="row">
      <div class="col-md-8">
      <div id="csveditor">
      </div>
      </div>
      <div class="col-md-4">
          <button id="save" class="btn btn-large btn-primary">Save</button>
      </div>
      </div>
    </div>
    </div><!-- /.container -->

<!--(bake includes/footer.html)-->

<!-- build:js scripts/vendor.js -->
<!-- bower:js -->
<script src="bower_components/jquery/dist/jquery.js"></script>
<script src="bower_components/bootstrap/dist/js/bootstrap.js"></script>
<script src="bower_components/knockoutjs/dist/knockout.js"></script>
<script src="bower_components/handsontable/dist/jquery.handsontable.full.js"></script>
<!-- endbower -->
<!-- endbuild -->
<!-- build:js({.tmp,app}) scripts/scripts.js -->
<script src="scripts/app.js"></script>
<!-- endbuild -->


<script>

    $( document ).ready(function() {

        setInterval(function() { refreshToken($("#server").val());}, 1800000);

        var file = getURLParameter('file');
        var path = getURLParameter('path');
        getFile(file, path);

        $("#save").click(function() {
          var file = getURLParameter('file');
          var path = getURLParameter('path');
          putFile(file, path);
        });
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

function putFile(file, path)
{
  if(file===undefined) { return; }
  var data = new FormData();
  data.append('msg', 'text edited in viewer');
  var csv = '#'+$("#csveditor").handsontable("getColHeader").join()+"\n";
  var csvdata = $("#csveditor").data('handsontable').getData();
  for(i=0;i<csvdata.length;i++) {
        csv += csvdata[i].join();
    csv += "\n";
  }
  var blob = new Blob([csv], { type: 'text/plain'});
  data.append('file', blob);
  var server = getURLParameter('server');
  $.ajax({
    url: server+'/data-manager/data/'+file+'/upload/'+path,
    type: 'PUT',
    data: data,
    contentType: false,
    processData: false,
    datatype: 'text/plain',
    success: function(data) { alert('File updated on server');  },
    error: function(jqXHR, textStatus, errorThrown) { alert('Failed! '+errorThrown); },
    beforeSend: setHeader
  });
}


function setHeader(xhr)
{
    xhr.setRequestHeader('Authorization', 'bearer ' + getURLParameter('access_token'));
}

function displayFile(mycsv) {
    var rows =  mycsv.split("\n");
    var data = [];
    var tabheader = true;
    var header = new RegExp("^#");
    for(i=0;i<rows.length;i++) {
        if(header.test(rows[i])){
            tabheader = rows[i].split(/[,;\t]/);
            tabheader[0] = tabheader[0].substring(1);
            continue;
        }
        var columns = rows[i].split(/[,;\t]/);
        data.push(columns);
    }
    $('#csveditor').handsontable({
           data: data,
           minSpareRows: 1,
           colHeaders: tabheader,
           rowHeaders: true,
           manualColumnMove: true,
           manualColumnResize: true,
           persistentState: true, 
           contextMenu: true
    });
}

</script>

</body>
</html>
