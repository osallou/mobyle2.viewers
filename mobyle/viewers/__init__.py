# -*- coding: utf-8 -*-
from hashlib import sha1
from random import randint

from pyramid.config import Configurator
from pyramid.events import subscriber
from pyramid.events import NewRequest, BeforeRender, NewResponse
from pyramid.security import authenticated_userid
from pyramid.authentication import AuthTktAuthenticationPolicy
from pyramid.authorization import ACLAuthorizationPolicy
from pyramid.renderers import JSON
import pyramid_beaker
from bson import json_util
from mongokit import ObjectId


def data_include(config):
    config.add_static_view('static', 'mobyle.web:static')
    config.add_static_view('type', '../../webapp/dist')


def main(global_config, **settings):
    """
    This function returns a Pyramid WSGI application.
    """

    # instantiate mobyle config
    from mobyle.common.config import Config
    mobyle_config = Config().config()
    # copy pyramid app:main settings to mobyle config (DB config, etc.)
    for setting in global_config:
        mobyle_config.set('app:main', setting, global_config[setting])
    for setting in settings:
        mobyle_config.set('app:main', setting, settings[setting])
    # then import connection
    from mobyle.common import connection
    from mobyle.web.resources import Root
    from mobyle.web.security import groupFinder


    config = Configurator(root_factory=Root, settings=global_config)
    config.include(pyramid_beaker)
    config.include('pyramid_mailer')

    authentication_policy = AuthTktAuthenticationPolicy('seekrit',
        callback=groupFinder, hashalg='sha512')
    authorization_policy = ACLAuthorizationPolicy()

    config.set_authentication_policy(authentication_policy)
    config.set_authorization_policy(authorization_policy)

    config.add_route('main', '/')
    config.add_route('fasta', '/fasta')


    config.include(data_include, route_prefix='/viewers')
    config.scan()

    # automatically serialize bson ObjectId to Mongo extended JSON
    json_renderer = JSON()

    def objectId_adapter(obj, request):
        return json_util.default(obj)
    json_renderer.add_adapter(ObjectId, objectId_adapter)
    config.add_renderer('json', json_renderer)

    return config.make_wsgi_app()



