from django.db import models
from django.contrib.auth import get_user_model
from django.utils import timezone

User = get_user_model()


class Invoice(models.Model):
    STATUS_CHOICES = [
        ('pending', 'Pending'),
        ('paid', 'Paid'),
        ('failed', 'Failed'),
    ]

    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="invoices")
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    description = models.CharField(max_length=255, null=True, blank=True)
    status = models.CharField(max_length=10, choices=STATUS_CHOICES, default='pending')
    created_at = models.DateTimeField(default=timezone.now)
    subscription_tier = models.ForeignKey(
        'users.SubscriptionTier',
        on_delete=models.SET_NULL,
        null=True,
        related_name='invoices'
    )
    invoice_id = models.CharField(max_length=100, unique=True)  # PayPal/Payment reference ID

    def __str__(self):
        return f"Invoice {self.invoice_id} for {self.user.email} - {self.status}"

    class Meta:
        ordering = ['-created_at']
        verbose_name = "Invoice"
        verbose_name_plural = "Invoices"
