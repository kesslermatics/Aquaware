# Generated by Django 4.2.13 on 2024-09-20 10:03

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('environments', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='WaterParameter',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=255, unique=True)),
                ('unit', models.CharField(max_length=50)),
            ],
        ),
        migrations.CreateModel(
            name='WaterValue',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('value', models.DecimalField(decimal_places=3, max_digits=10)),
                ('measured_at', models.DateTimeField()),
                ('added_at', models.DateTimeField(auto_now_add=True)),
                ('generated', models.BooleanField(default=False)),
                ('environment', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='water_values', to='environments.environment')),
                ('parameter', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='water_values', to='water.waterparameter')),
            ],
        ),
        migrations.CreateModel(
            name='UserAlertSetting',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('under_value', models.FloatField(blank=True, null=True)),
                ('above_value', models.FloatField(blank=True, null=True)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('environment', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='environments.environment')),
                ('parameter', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='water.waterparameter')),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'unique_together': {('user', 'environment', 'parameter')},
            },
        ),
    ]