# -*- coding: utf-8 -*-
import datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models


class Migration(SchemaMigration):

    def forwards(self, orm):
        # Adding model 'PartyPlaylist'
        db.create_table('party_partyplaylist', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('name', self.gf('django.db.models.fields.TextField')()),
        ))
        db.send_create_signal('party', ['PartyPlaylist'])


    def backwards(self, orm):
        # Deleting model 'PartyPlaylist'
        db.delete_table('party_partyplaylist')


    models = {
        'party.partyplaylist': {
            'Meta': {'object_name': 'PartyPlaylist'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'name': ('django.db.models.fields.TextField', [], {})
        }
    }

    complete_apps = ['party']