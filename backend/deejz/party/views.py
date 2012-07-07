from django.http import HttpResponse, HttpResponseBadRequest
from django.shortcuts import render_to_response
from party.models import PartyPlaylist, Song
from django.template import RequestContext
from django.core import serializers
import simplejson as json
from simplejson import JSONDecodeError
import random
import string

def index(request):
	return HttpResponse("index")
	
def party(request, party_slug):
	playlist = PartyPlaylist.objects.get(slug=party_slug)
	context = RequestContext(request, {'party': playlist, 'songs': playlist.song_set.all() })
	return render_to_response('party.html', context)
	
def playlist_json(request, party_slug):
	fete = PartyPlaylist.objects.get(slug=party_slug)
	data = serializers.serialize("json", fete.song_set.all())
	return HttpResponse(data, mimetype="application/json")

def details_json(request, party_slug):
	data = serializers.serialize("json", [PartyPlaylist.objects.get(slug=party_slug)])
	return HttpResponse(data, mimetype="application/json")
	
# get the current (without changing the playlist)
def get_current_song(request, party_slug):
	fete = PartyPlaylist.objects.get(slug=party_slug)
	data = serializers.serialize("json", fete.song_set.all()[0:])
	return HttpResponse(data, mimetype="application/json")
	
# will move next song on playlist to current song
def get_next_song(request, party_slug):
	fete = PartyPlaylist.objects.get(slug=party_slug)
	data = serializers.serialize("json", fete.song_set.all()[1:])
	return HttpResponse(data, mimetype="application/json")
	
def add_song(request, party_slug):
	try:
		data = json.loads(request.raw_post_data)
		fete = PartyPlaylist.objects.get(slug=party_slug)
		song = Song(party=fete, 
			added_by_uuid=data['uuid'], 
			deezer_id=data['deezer_id'],
			title=data['title'])
		song.save()
	except KeyError, e:
		print e
		return HttpResponseBadRequest("KeyError: %s" % e)
	except JSONDecodeError, e:
		print e
		return HttpResponseBadRequest("JSONDecodeError: %s" % e)

	return HttpResponse('Song added.')
		
def create_party(request):
	# try to create the autoslug as long as you need to get one that isn't in
	# database yet.
	autoslug = ''
	while(True):
		autoslug = ''.join(random.sample(string.ascii_lowercase, 10))
		try: 
			partylist = PartyPlaylist.objects.get(slug=autoslug)
		except PartyPlaylist.DoesNotExist:
			break
	try:
		data = json.loads(request.raw_post_data)
		fete = PartyPlaylist(slug=autoslug,
			name=data['name'],
			address=data['address'],
			longitude=float(data['longitude']),
			latitude=float(data['latitude']))
		fete.save()
	except KeyError, e:
		print e
		return HttpResponseBadRequest("KeyError: %s" % e)
	except JSONDecodeError, e:
		print e
		return HttpResponseBadRequest("JSONDecodeError: %s" % e)
	return HttpResponse('{"partyslug": "%s"}' % autoslug, mimetype="application/json")
	
def vote(request, party_slug):
	return HttpResponse("vote")
	
def veto(request, party_slug):
	return HttpResponse("VETO")