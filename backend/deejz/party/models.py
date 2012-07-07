from django.db import models

class PartyPlaylist(models.Model):
	name = models.CharField(blank=False, default="It's my party.", max_length=1024)
	address = models.TextField(blank=True)
	slug = models.SlugField(blank=False, default='')
	longitude = models.FloatField(blank=True, null=True)
	latitude = models.FloatField(blank=True, null=True)
	
	def __unicode__(self):
		return self.name
	
class Song(models.Model):
	party = models.ForeignKey('PartyPlaylist')
	deezer_id = models.IntegerField(default=3135556)
	title = models.CharField(max_length=1024, null=True)
	played = models.DateTimeField(blank=True, null=True)
	vetoed = models.BooleanField(default=False)
	added_by_uuid = models.CharField(max_length=1024, null=True)
	
	def __unicode__(self):
		return '%s (%d)' % (self.title, self.deezer_id)
		
class SongVote(models.Model):
	"""
	a = models.Song.objects.all()
	s = models.SongVote(song=a[0], uuid='123')
	"""
	song = models.ForeignKey('Song')
	uuid = models.CharField(max_length=1024)
	
	def __unicode__(self):
		return '"%s" voted for "%s"' % (self.uuid, self.song)
	
class SongVeto(models.Model):
	song = models.ForeignKey('Song')
	uuid = models.CharField(max_length=1024)
	
	def __unicode__(self):
		return '"%s" hates "%s"' % (self.uuid, self.song)