/*global CodeMirror:false */
'use strict';

CodeMirror.defineMode('fasta', function(config, parserConfig) {
  function wordObj(words) {
    var o = {};
    for (var i = 0, e = words.length; i < e; ++i) { o[words[i]] = true; }
    return o;
  }
  var indentWords = wordObj([]);
  var dedentWords = wordObj([]);
  var curPunc;


  function isMember(element,list) {
    return (-1 < list.indexOf(element));
  }

  function chain(newtok, stream, state) {
    state.tokenize.push(newtok);
    return newtok(stream, state);
  }

  function tokenBase(stream, state) {
    curPunc = null;
    var ch = stream.next();
    
   
    if (ch === '#'){
      stream.skipToEnd();
      return 'comment';
    } else if(ch === '>') {
      stream.skipToEnd();
      return 'header';
    } else {
      stream.eatWhile(/[\w\?]/);
      return null;
    }
  }

  return {
    startState: function() {
      return {tokenize: [tokenBase],
              indented: 0,
              context: {type: 'top', indented: -config.indentUnit},
              continuedLine: false,
              lastTok: null,
              varList: false};
    },

    token: function(stream, state) {
      var style = state.tokenize[state.tokenize.length-1](stream, state),
kwtype;
      return style;
    }

  };
});

CodeMirror.defineMIME('text/x-fasta', 'fasta');

