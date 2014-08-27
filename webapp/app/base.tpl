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
        <div class="row">
        <h1>Mobyle viewers and editors</h1>
        </div>
        <div class="row">
        <div class="col-xs-4">
        <label for="server">Mobyle server</label>
        <input name="server" id="server" value="http://localhost:6544"/>
        <form id="oauth_auth" method="post" action="">
<!--
http://localhost:6544/data-manager/oauth/v2/authorize?response_type=code&state=xyz&client_id=1&redirect_uri=https%3A%2F%2Flocalhost%2Fcb&scope=drive
-->
        <input type="hidden" name="response_type" value="code"/>
        <input type="hidden" id="state" name="state" value="xFrFFS"/>
        <input type="hidden" id="client_id" name="client_id" value="mobyle"/>
        <input type="hidden" id="redirect_uri" name="redirect_uri" value=""/>
        <input type="hidden" name="scope" value="drive,user:email"/>
        <button id="connect" type="button" class="btn">Connect</button>
        </form>
        </div>
        <div class="col-xs-8" id="data-list">
        <div class="row" id="user"></div>
        <div class="row" id="list">
            <table class="table">
            <thead>
            <tr><th>Id</th><th>Name</th><th>Type</th></tr>
            </thead>
            <tbody data-bind="foreach: data">
                <tr data-bind="attr: {id:  _id.$oid, path: data.path}">
                    <td data-bind="text: _id.$oid"></td>
                    <td data-bind="text: name"></td>
                    <td data-bind="text: data.type"></td>
                </tr>
            </tbody> 
            </table>
        </div>
        </div>
        </div>
    </div>
    </div><!-- /.container -->

<div id="contextMenu" class="dropdown clearfix">
<ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu" style="display:block;position:static;margin-bottom:5px;">
    <li><a tabindex="-1" data-viewer="vim" href="#">Text editor</a></li>
    <li><a tabindex="-1" data-viewer="fasta" href="#">Fasta editor</a></li>
    <li><a tabindex="-1" data-viewer="csv" href="#">CSV editor</a></li>
    <li><a tabindex="-1" data-viewer="phyml" href="#">PhyML editor</a></li>
</ul>
</div>

<!--(bake includes/footer.html)-->


<!-- build:js scripts/vendor.js -->
<!-- bower:js -->
<script src="bower_components/jquery/dist/jquery.js"></script>
<script src="bower_components/bootstrap/dist/js/bootstrap.js"></script>
<script src="bower_components/knockoutjs/dist/knockout.js"></script>
<!-- endbower -->
<!-- endbuild -->
<!-- build:js({.tmp,app}) scripts/scripts.js -->
<script src="scripts/app.js"></script>
<!-- endbuild -->

<script>
$( document ).ready(function() {

    setInterval(function() { refreshToken($("#server").val());}, 1800);

    $("#connect").click(function(){
        var auth_url = $("#server").val() + '/data-manager/oauth/v2/authorize';
        $("#oauth_auth").attr("action",auth_url);
        $("#oauth_auth").submit();
    });

    $("#redirect_uri").val(window.location.origin+window.location.pathname);

    if(getURLParameter('code')!=undefined) {
        getAccessToken(getURLParameter('code'));
    }
    if(getURLParameter('access_token')!=undefined) {
        getAPIAccess(getURLParameter('access_token'));
    }

});

function getAccessToken(code) {
  var server = $("#server").val();
  window.location = server+'/data-manager/oauth/v2/token?client_id='+$("#client_id").val()+'&redirect_uri='+encodeURI($("#redirect_uri").val())+'&grant_type=authorization_code&code='+code;
}

function getAPIAccess() {
  $("#user").html('<h2>'+getURLParameter('email')+'</h2>');
  $.ajax({
    url: $("#server").val()+'/data-manager/my.json',
    type: 'GET',
    datatype: 'json',
    success: function(data) { viewModel.data(data);  },
    error: function() { alert('Failed!'); },
    beforeSend: setHeader       
  }); 

}

function setHeader(xhr) {
  xhr.setRequestHeader('Authorization', 'bearer '+getURLParameter('access_token'));
}

var viewModel =  {
  data: ko.observableArray()
}

ko.applyBindings(viewModel);

var $contextMenu = $("#contextMenu");

//make sure menu closes on any click
$(document).click(function () {
    $contextMenu.hide();
});

$("body").on("contextmenu", "table tr", function(e) {
   $contextMenu.css({
      display: "block",
      left: e.pageX,
      top: e.pageY
   })
   .off('click')
   .data('invokedOn', e.currentTarget)
   .click(function(e) {
    console.log($($(this).data("invokedOn")).attr('id'));
    console.log($(e.target).attr('data-viewer'));
    $contextMenu.hide();
    var elt = $($(this).data("invokedOn"));
    var file = elt.attr('id');
    var path = elt.attr('path');
    var server = $("#server").val();
    window.location='vim.html?server='+encodeURI(server)+'&file='+file+'&path='+encodeURI(path)+'&access_token='+getURLParameter('access_token')+'&token_type='+getURLParameter('token_type')+'&expires_in='+getURLParameter('expires_in')+'&email='+getURLParameter('email')+'&refresh_token='+getURLParameter('refresh_token');
   });
   return false;
});

</script>
</body>
</html>
