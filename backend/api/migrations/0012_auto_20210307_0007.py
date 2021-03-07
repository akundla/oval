# Generated by Django 3.0.4 on 2021-03-07 00:07

from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0011_auto_20210307_0004'),
    ]

    operations = [
        migrations.AlterField(
            model_name='answer',
            name='comments',
            field=models.ManyToManyField(blank=True, to='api.Comment'),
        ),
        migrations.AlterField(
            model_name='answer',
            name='upvotes',
            field=models.ManyToManyField(blank=True, related_name='answers_upvoted', to=settings.AUTH_USER_MODEL),
        ),
        migrations.AlterField(
            model_name='comment',
            name='upvotes',
            field=models.ManyToManyField(blank=True, related_name='comments_upvoted', to=settings.AUTH_USER_MODEL),
        ),
    ]
