from django.db import models
import datetime
from django.utils import timezone


class ShoeColor(models.Model):
    name = models.CharField("color", max_length=12)

    def __unicode__(self):
        return self.name

class ShoeType(models.Model):
    name = models.CharField(max_length=12)

    def __unicode__(self):
        return self.name

class Shoe(models.Model):
    name = models.CharField(max_length=200)
    shoeColor = models.ForeignKey(ShoeColor, blank=True, null=True)
    shoeType = models.ForeignKey(ShoeType, blank=True, null=True)
    add_date = models.DateTimeField('date added', null=True)

    class Meta:
        ordering = ["-name"]

    def __unicode__(self):
        return self.name

    def was_added_recently(self):
        return self.add_date >= timezone.now() - datetime.timedelta(days=1)
