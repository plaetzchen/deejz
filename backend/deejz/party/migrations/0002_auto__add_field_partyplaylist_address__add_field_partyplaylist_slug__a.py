# -*- coding: utf-8 -*-
import datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models


class Migration(SchemaMigration):

    def forwards(self, orm):
        # Adding field 'PartyPlaylist.address'
        db.add_column('party_partyplaylist', 'address',
                      self.gf('django.db.models.fields.TextField')(default='', blank=True),
                      keep_default=False)

        # Adding field 'PartyPlaylist.slug'
        db.add_column('party_partyplaylist', 'slug',
                      self.gf('django.db.models.fields.SlugField')(default='', max_length=50),
                      keep_default=False)

        # Adding field 'PartyPlaylist.longitude'
        db.add_column('party_partyplaylist', 'longitude',
                      self.gf('django.db.models.fields.FloatField')(null=True, blank=True),
                      keep_default=False)

        # Adding field 'PartyPlaylist.latitude'
        db.add_column('party_partyplaylist', 'latitude',
                      self.gf('django.db.models.fields.FloatField')(null=True, blank=True),
                      keep_default=False)


    def backwards(self, orm):
        # Deleting field 'PartyPlaylist.address'
        db.delete_column('party_partyplaylist', 'address')

        # Deleting field 'PartyPlaylist.slug'
        db.delete_column('party_partyplaylist', 'slug')

        # Deleting field 'PartyPlaylist.longitude'
        db.delete_column('party_partyplaylist', 'longitude')

        # Deleting field 'PartyPlaylist.latitude'
        db.delete_column('party_partyplaylist', 'latitude')


    models = {
        'party.partyplaylist': {
            'Meta': {'object_name': 'PartyPlaylist'},
            'address': ('django.db.models.fields.TextField', [], {'blank': 'True'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'latitude': ('django.db.models.fields.FloatField', [], {'null': 'True', 'blank': 'True'}),
            'longitude': ('django.db.models.fields.FloatField', [], {'null': 'True', 'blank': 'True'}),
            'name': ('django.db.models.fields.TextField', [], {'default': '"It\'s my party."'}),
            'slug': ('django.db.models.fields.SlugField', [], {'default': "''", 'max_length': '50'})
        }
    }

    complete_apps = ['party']