/*global $:false */
'use strict';

function getURLParameter(sParam)
  {
    var sPageURL = window.location.search.substring(1);
    var sURLVariables = sPageURL.split('&');
    for (var i = 0; i < sURLVariables.length; i++)
    {
      var sParameterName = sURLVariables[i].split('=');
      if (sParameterName[0] === sParam)
      {
        return sParameterName[1];
      }
    }
  }

function refreshToken(server) {
    if(getURLParameter('access_token')===undefined) {
      return;
    }
    var refreshurl = server+'/data-manager/oauth/v2/token?';
    refreshurl += 'grant_type=refresh_token&refresh_token=';
    refreshurl += getURLParameter('refresh_token');
    $.ajax({
        type: 'POST',
        url: refreshurl,
        data: {},
        dataType: 'json',
        success: function(data, textStatus) {
            if (data.redirect) {
              console.log(data.redirect);
            }
            else {
              // data.form contains the HTML for the replacement form
              console.log(data);
            }
          }
      });
  }
