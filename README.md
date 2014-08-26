Sample viewers for Mobyle2 testing
==================================

Main page is in editor/index.html


License: MIT

Author: Olivier Sallou <olivier.sallou@irisa.fr>

this code embeds various javascript libraries with their own license though all
are open source (phyml, jquery, bootstrap, codemirror, ...). Check each license
before using it.

Usage
=====

In webapp run:
npm install
bower install
grunt

To run server:
pserve --reload --app-name=viewers --server-name=viewers src/mobyle2.conf/mobyle.ini

Main URL: http://localhost:6545/viewers/type/index.html
