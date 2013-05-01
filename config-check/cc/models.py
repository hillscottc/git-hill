from django.db import models

class ClientHost(models.Model):
    name = models.CharField(max_length=25)
    host = models.CharField(max_length=40)
    cmd = models.CharField(max_length=25, blank=True )
    def __unicode__(self):
        return self.name



