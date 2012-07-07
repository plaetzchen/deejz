from django.conf.urls import patterns, include, url
from django.contrib.staticfiles.urls import staticfiles_urlpatterns

# Uncomment the next two lines to enable the admin:
from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'deejz.views.home', name='home'),
    # url(r'^deejz/', include('deejz.foo.urls')),

    # Uncomment the admin/doc line below to enable admin documentation:
    # url(r'^admin/doc/', include('django.contrib.admindocs.urls')),
	url(r'^party\/(?P<party_slug>\d+)/$', 'party.views.party'),
	url(r'^party\/(?P<party_slug>\d+)/playlist\.json$', 'party.views.playlist_json'),
	url(r'^party\/(?P<party_slug>\d+)/details\.json$', 'party.views.details_json'),
	url(r'^party\/(?P<party_slug>\d+)/add_song/$', 'party.views.add_song'),
	url(r'^party\/(?P<party_slug>\d+)/next_song\.json$', 'party.views.get_next_song'),
	url(r'^party\/(?P<party_slug>\d+)/current_song\.json/$', 'party.views.get_current_song'),
	
    # Uncomment the next line to enable the admin:
    url(r'^admin/', include(admin.site.urls)),
)

urlpatterns += staticfiles_urlpatterns()