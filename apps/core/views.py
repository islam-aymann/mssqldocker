from django.http import HttpRequest, JsonResponse
from django.views import View

from apps.core.models import Person


class Index(View):
    def get(self, request: HttpRequest):
        persons = Person.objects.all()

        return JsonResponse({"data": [person.name for person in persons]})
