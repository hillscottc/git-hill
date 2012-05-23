from django.contrib import admin
from shoe_app.models import ShoeColor
from shoe_app.models import ShoeType
from shoe_app.models import Shoe

# class ShoeColorInline(admin.TabularInline):
#     model = ShoeColor
#     extra = 3

# class ShoeAdmin(admin.ModelAdmin):
#     fieldsets = [
#         (None,               {'fields': ['name']}),
#         ('Date information', {'fields': ['add_date'], 'classes': ['collapse']}),
#     ]
#     inlines = [ShoeColorInline]
#     list_display = ('question', 'pub_date', 'was_published_recently')

admin.site.register(ShoeColor)
admin.site.register(ShoeType)
admin.site.register(Shoe)
