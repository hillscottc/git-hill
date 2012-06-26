from django.db import models
import datetime
from django.utils import timezone
from django import forms
from django.forms import ModelForm
from django.forms import Textarea


class ShoeColor(models.Model):
    name = models.CharField("color", max_length=12)
    def __str__(self):
        return self.name
    def __unicode__(self):
        return self.name

class ShoeType(models.Model):
    name = models.CharField(max_length=12)
    def __str__(self):
        return self.name
    def __unicode__(self):
        return self.name

class Shoe(models.Model):
    name = models.CharField(max_length=200)
    shoeColor = models.ForeignKey(ShoeColor, blank=True, null=True)
    shoeType = models.ForeignKey(ShoeType, blank=True, null=True)
    add_date = models.DateTimeField('date added', null=True)
    class Meta:
        ordering = ["-name"]
    def __str__(self):
        return self.name
    def __unicode__(self):
        return self.name
    def was_added_recently(self):
        return self.add_date >= timezone.now() - datetime.timedelta(days=1)

class ShoeForm(ModelForm):
    class Meta:
        model = Shoe


class Tag(models.Model):
    name = models.CharField(max_length=64, unique=True)
    shoes = models.ManyToManyField(Shoe)
    def __str__(self):
        return self.name
    def __unicode__(self):
        return self.name

class TagForm(ModelForm):
    class Meta:
        model = Tag