# -*- coding: utf-8 -*-
import os

from setuptools import setup, find_packages

here = os.path.abspath(os.path.dirname(__file__))
README = open(os.path.join(here, 'README.md')).read()
CHANGES = open(os.path.join(here, 'CHANGES.txt')).read()

requires = [
    'pyramid>=1.4',
    'pyramid_debugtoolbar',
    'waitress',
    "pyramid_beaker",
    "pyramid_mailer",
    "pyramid_mako",
    "pyScss",
    "uuid",
    "webtest"
    ]

setup(name='mobyle.viewers',
      version='0.0',
      description='mobyle viwers web portal',
      dependency_links = [],
      long_description=README + '\n\n' +  CHANGES,
      classifiers=[
        "Programming Language :: Python",
        "Framework :: Pylons",
        "Topic :: Internet :: WWW/HTTP",
        "Topic :: Internet :: WWW/HTTP :: WSGI :: Application",
        ],
      author='Olivier Sallou',
      author_email='olivier.sallou@irisa.fr',
      url='',
      keywords='web pyramid pylons',
      packages=find_packages(),
      include_package_data=True,
      zip_safe=False,
      install_requires=requires,
      tests_require=requires,
      test_suite="test",
      entry_points = """\
      [paste.app_factory]
      main = mobyle.viewers:main
      """,
      )

