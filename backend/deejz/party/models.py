from django.db import models

class PartyPlaylist(models.Model):
	name = models.TextField(blank=False, default="It's my party.")
	address = models.TextField(blank=True)
	slug = models.SlugField(blank=False, default='')
	longitude = models.FloatField(blank=True, null=True)
	latitude = models.FloatField(blank=True, null=True)