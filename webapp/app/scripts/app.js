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

function setHeader(xhr)
  {
    xhr.setRequestHeader('Authorization', 'bearer ' + getURLParameter('access_token'));
  }


function getFile(file, path, callback)
  {
    if(file===undefined) { return; }
    var server = getURLParameter('server');
    $.ajax({
        url: server + '/data-manager/data/' + file + '/raw/' + path,
        type: 'GET',
        datatype: 'text/plain',
        success: function(data) { callback(data);  },
        error: function() { window.alert('Failed!'); },
        beforeSend: setHeader
      });
  }

function putFile(file, path, content)
  {
    if(file===undefined) { return; }
    var data = new FormData();
    data.append('msg', 'text edited in viewer');
    var blob = new Blob([content], {type: 'text/plain'});
    data.append('file', blob);
    var server = getURLParameter('server');
    $.ajax({
        url: server + '/data-manager/data/' + file + '/raw/' + path,
        type: 'PUT',
        data: data,
        contentType: false,
        processData: false,
        datatype: 'text/plain',
        success: function(data) { window.alert('File updated on server');  },
        error: function(jqXHR, textStatus, errorThrown) { window.alert('Failed! ' + errorThrown); },
        beforeSend: setHeader
      });
  }

