## Getting course from enrollment
Haal de enrollments op met deze url: `https://295785a6-7922-4ff5-b94f-71dc1e77ffc8.enrollments.api.brightspace.com/users/{userid}?excludeEnded=0&embedDepth=1&promotePins=1&pageSize=100`
Je krijgt dan een json object als dit:
```json
{
  "class": [
    "enrollments",
    "collection"
  ],
  "entities": [
    {
      "class": [
        "enrollment",
        "pinned"
      ],
      "rel": [
        "https://api.brightspace.com/rels/user-enrollment"
      ],
      "href": "https://295785a6-7922-4ff5-b94f-71dc1e77ffc8.enrollments.api.brightspace.com/enrolled-user/OM6IvVO7bjTBqp59gIh05Ua6wA4IlfrE5h082q-BCE0/enrollment"
    },
    {
      "class": [
        "enrollment",
        "unpinned"
      ],
      "rel": [
        "https://api.brightspace.com/rels/user-enrollment"
      ],
      "href": "https://295785a6-7922-4ff5-b94f-71dc1e77ffc8.enrollments.api.brightspace.com/enrolled-user/xHom8M51mQ137x1W34Y9tpjbtaSCs3-6GHZwIa3otgI/enrollment"
    }
  ]
}
```
Elke entity heeft een href waar een enrollment mee kan worden opgehaald.
Wanneer je een GET request stuurt met deze url krijg je de volgende data:
```json
{
    "class": [
        "named-entity",
        "describable-entity",
        "draft-published-entity",
        "published",
        "self-assignable",
        "active",
        "course-offering"
    ],
    "properties": {
        "name": "Basiskennis GGZ en HOZ",
        "code": "SW3.BGGZ.V20",
        "startDate": "2000-01-01T00:00:00.000Z",
        "endDate": null,
        "isActive": true,
        "description": ""
    },
    "entities": [
        {
            "class": [
                "richtext",
                "description"
            ],
            "rel": [
                "item"
            ],
            "properties": {
                "text": "",
                "html": ""
            }
        },
        {
            "class": [
                "color"
            ],
            "rel": [
                "https://api.brightspace.com/rels/color"
            ],
            "properties": {
                "hexString": "#035670",
                "description": ""
            }
        },
        {
            "class": [
                "course-image"
            ],
            "rel": [
                "https://api.brightspace.com/rels/organization-image",
                "nofollow"
            ],
            "href": "https://s.brightspace.com/course-images/images/8e6773f6-dff2-4733-8184-6524d087be60"
        },
        {
            "class": [
                "relative-uri"
            ],
            "rel": [
                "item",
                "https://api.brightspace.com/rels/organization-homepage"
            ],
            "properties": {
                "path": "/d2l/home/34268"
            }
        }
    ],
    "links": [
        {
            "rel": [
                "https://api.brightspace.com/rels/folio-org"
            ],
            "href": "https://295785a6-7922-4ff5-b94f-71dc1e77ffc8.folio.api.brightspace.com/organizations/34268"
        },
        {
            "rel": [
                "https://folio.api.brightspace.com/rels/filter-instructors"
            ],
            "href": "https://295785a6-7922-4ff5-b94f-71dc1e77ffc8.enrollments.api.brightspace.com/organizations/34268?filter=eyI4NzE1Y2Q4YS1jMWVhLTRkYjUtYTRlMy0yMjdlMDhhYTU3OTkiOlsiaW5zdHJ1Y3RvciJdfQ"
        },
        {
            "rel": [
                "https://folio.api.brightspace.com/rels/filter-students"
            ],
            "href": "https://295785a6-7922-4ff5-b94f-71dc1e77ffc8.enrollments.api.brightspace.com/organizations/34268?filter=eyI4NzE1Y2Q4YS1jMWVhLTRkYjUtYTRlMy0yMjdlMDhhYTU3OTkiOlsic3R1ZGVudCJdfQ"
        },
        {
            "rel": [
                "https://activities.api.brightspace.com/rels/organization-activities"
            ],
            "href": "https://295785a6-7922-4ff5-b94f-71dc1e77ffc8.activities.api.brightspace.com/activityusages/34268"
        },
        {
            "rel": [
                "https://activities.api.brightspace.com/rels/my-organization-activities"
            ],
            "href": "https://295785a6-7922-4ff5-b94f-71dc1e77ffc8.activities.api.brightspace.com/activityusages/34268/users/24557?start=2022-07-29T18%3a24%3a03.594Z&end=2022-08-05T18%3a24%3a03.594Z"
        },
        {
            "rel": [
                "https://activities.api.brightspace.com/rels/my-organization-activities#empty"
            ],
            "href": "https://295785a6-7922-4ff5-b94f-71dc1e77ffc8.activities.api.brightspace.com/activityusages/34268/users/24557"
        },
        {
            "rel": [
                "https://checklists.api.brightspace.com/rels/checklists"
            ],
            "href": "https://295785a6-7922-4ff5-b94f-71dc1e77ffc8.checklists.api.brightspace.com/organizations/34268"
        },
        {
            "rel": [
                "https://activities.api.brightspace.com/rels/activity-usage"
            ],
            "href": "https://295785a6-7922-4ff5-b94f-71dc1e77ffc8.activities.api.brightspace.com/old/activities/6606_706000_34268/usages/34268"
        },
        {
            "rel": [
                "https://api.brightspace.com/rels/sequence"
            ],
            "href": "https://295785a6-7922-4ff5-b94f-71dc1e77ffc8.sequences.api.brightspace.com/34268?deepEmbedEntities=1&embedDepth=1&filterOnDatesAndDepth=0"
        },
        {
            "rel": [
                "https://files.api.brightspace.com/rels/files"
            ],
            "href": "https://295785a6-7922-4ff5-b94f-71dc1e77ffc8.files.api.brightspace.com/34268"
        },
        {
            "rel": [
                "https://assignments.api.brightspace.com/rels/assignments"
            ],
            "href": "https://295785a6-7922-4ff5-b94f-71dc1e77ffc8.assignments.api.brightspace.com/34268"
        },
        {
            "rel": [
                "https://api.brightspace.com/rels/my-organization-grades"
            ],
            "href": "https://295785a6-7922-4ff5-b94f-71dc1e77ffc8.grades.api.brightspace.com/organizations/34268/users/24557"
        },
        {
            "rel": [
                "https://outcomes.api.brightspace.com/rels/intents"
            ],
            "href": "https://295785a6-7922-4ff5-b94f-71dc1e77ffc8.outcomes.api.brightspace.com/intents/f05116ae-3ece-4e1a-a419-c3d13ee59ee5"
        },
        {
            "rel": [
                "https://announcements.api.brightspace.com/rels/organization-announcements"
            ],
            "href": "https://295785a6-7922-4ff5-b94f-71dc1e77ffc8.announcements.api.brightspace.com/organizations/34268"
        },
        {
            "rel": [
                "https://notifications.api.brightspace.com/rels/organization-notifications"
            ],
            "href": "https://295785a6-7922-4ff5-b94f-71dc1e77ffc8.notifications.api.brightspace.com/my-notifications/organizations/34268"
        },
        {
            "rel": [
                "https://api.brightspace.com/rels/parent-semester"
            ],
            "href": "https://295785a6-7922-4ff5-b94f-71dc1e77ffc8.organizations.api.brightspace.com/15038"
        },
        {
            "rel": [
                "https://api.brightspace.com/rels/organization-homepage"
            ],
            "type": "text/html",
            "href": "https://leren.windesheim.nl/d2l/home/34268"
        },
        {
            "rel": [
                "self"
            ],
            "href": "https://295785a6-7922-4ff5-b94f-71dc1e77ffc8.organizations.api.brightspace.com/34268"
        },
        {
            "rel": [
                "https://api.brightspace.com/rels/notification-alerts"
            ],
            "href": "https://295785a6-7922-4ff5-b94f-71dc1e77ffc8.alerts.api.brightspace.com/notification-alerts"
        },
        {
            "rel": [
                "https://notifications.api.brightspace.com/rels/my-alerts"
            ],
            "href": "https://295785a6-7922-4ff5-b94f-71dc1e77ffc8.notifications.api.brightspace.com/alerts/34268"
        },
        {
            "rel": [
                "https://api.brightspace.com/rels/rubrics"
            ],
            "href": "https://295785a6-7922-4ff5-b94f-71dc1e77ffc8.rubrics.api.brightspace.com/organizations/34268"
        },
        {
            "class": [
                "active",
                "theme"
            ],
            "rel": [
                "https://themes.api.brightspace.com/rels/theme"
            ],
            "href": "https://295785a6-7922-4ff5-b94f-71dc1e77ffc8.themes.api.brightspace.com/34268/5017"
        }
    ]
}
```

## Getting a Table Of Contents of a course
Om de content op te halen voor een course kun je deze url gebruiken: `https://leren.windesheim.nl/d2l/api/le/1.41/{course id}/content/root/`

```json
[
    {
        "Description": {
            "Text": "\n\n\n\n\nIn de linkerkolom zie je de modules waar de inhoud onder verdeeld is. \nDe modules kunnen worden ingedeeld per lesweek, per thema of wat de docent daarin anders kiest.\nKlik een module open met het pijltje:\n\nJe vind dan de inhoud passend bij de module.\nDocumenten die als inhoud worden toegevoegd worden embedded getoond -> liever downloaden klik dan op de knop rechtsboven de content \n\n",
            "Html": "\n\n\n\n\n<p><img src=\"/content/enforced/9820-PREP-TN0001/banner-narrow-high-density-min-size%20(1).jpg?_&amp;d2lSessionVal=2WoRATrKWF5wIjzUwUN3n2zDO\" title=\"\" style=\"max-width: 100%;\" width=\"1\" height=\"1\"/></p>\n<p>In de linkerkolom zie je de modules waar de inhoud onder verdeeld is.&#160;</p>\n<p>De modules kunnen worden ingedeeld per lesweek, per thema of wat de docent daarin anders kiest.</p>\n<p>Klik een module open met het pijltje:</p>\n<p><img src=\"/content/enforced/9820-PREP-TN0001/unit%20openen1.PNG?_&amp;d2lSessionVal=Eb4H0YkebWZaN4EOxO4Aqrz7x&amp;_&amp;d2lSessionVal=Eb4H0YkebWZaN4EOxO4Aqrz7x&amp;_&amp;d2lSessionVal=2WoRATrKWF5wIjzUwUN3n2zDO\" alt=\"\" title=\"\" style=\"max-width: 100%;\"/></p>\n<p>Je vind dan de inhoud passend bij de module.</p>\n<p>Documenten die als inhoud worden toegevoegd worden embedded getoond -&gt; liever downloaden klik dan op de knop rechtsboven de content <img src=\"/content/enforced/9820-PREP-TN0001/downloadknop.PNG?_&amp;d2lSessionVal=Eb4H0YkebWZaN4EOxO4Aqrz7x&amp;_&amp;d2lSessionVal=Eb4H0YkebWZaN4EOxO4Aqrz7x&amp;_&amp;d2lSessionVal=Eb4H0YkebWZaN4EOxO4Aqrz7x&amp;_&amp;d2lSessionVal=Eb4H0YkebWZaN4EOxO4Aqrz7x&amp;_&amp;d2lSessionVal=2WoRATrKWF5wIjzUwUN3n2zDO\" alt=\"\" title=\"\" width=\"39\" height=\"30\" style=\"max-width: 100%;\"/></p>\n\n"
        },
        "ParentModuleId": null,
        "ModuleDueDate": null,
        "Structure": [
            {
                "Id": 5737,
                "Title": "Introductie Windesheim ELO Student",
                "ShortTitle": "",
                "Type": 1,
                "LastModifiedDate": "2021-08-25T14:19:21.867Z"
            },
            {
                "Id": 5719,
                "Title": "Studiewijzer",
                "ShortTitle": "",
                "Type": 1,
                "LastModifiedDate": "2021-06-09T08:26:54.197Z"
            }
        ],
        "ModuleStartDate": null,
        "ModuleEndDate": null,
        "IsHidden": false,
        "IsLocked": false,
        "Id": 5572,
        "Title": "Algemeen",
        "ShortTitle": "",
        "Type": 0,
        "LastModifiedDate": "2021-06-23T11:19:09.787Z"
    },
    {
        "Description": {
            "Text": "\n\n\n\nOnder deze module vind je een aantal beschrijvingen van functionaliteiten die Brightspace bied.\nHet is nog lang niet alles! Dus klik ook vooral de menu-opties aan en ontdek wat je allemaal kan!\n\n\n",
            "Html": "\n\n\n\n\n<p>Onder deze module vind je een aantal beschrijvingen van functionaliteiten die Brightspace bied.</p>\n<p>Het is nog lang niet alles! Dus klik ook vooral de menu-opties aan en ontdek wat je allemaal kan!</p>\n<p><img src=\"/content/enforced/9820-PREP-TN0001/banner-narrow-high-density-min-size.jpg?_&amp;d2lSessionVal=2WoRATrKWF5wIjzUwUN3n2zDO\" title=\"\" style=\"max-width: 100%;\" width=\"1\" height=\"1\"/></p>\n\n"
        },
        "ParentModuleId": null,
        "ModuleDueDate": null,
        "Structure": [
            {
                "Id": 6554,
                "Title": "Aantekeningen maken",
                "ShortTitle": "",
                "Type": 1,
                "LastModifiedDate": "2021-06-23T09:18:16.067Z"
            },
            {
                "Id": 6368,
                "Title": "Powerpoint ",
                "ShortTitle": "",
                "Type": 1,
                "LastModifiedDate": "2021-06-21T13:47:30.650Z"
            },
            {
                "Id": 5744,
                "Title": "Cursus vastpinnen",
                "ShortTitle": "",
                "Type": 1,
                "LastModifiedDate": "2021-06-10T07:39:30.410Z"
            },
            {
                "Id": 6394,
                "Title": "Brightspace Course Quiz",
                "ShortTitle": "",
                "Type": 1,
                "LastModifiedDate": "2021-06-23T09:10:53.350Z"
            },
            {
                "Id": 5739,
                "Title": "Discover/Ontdekken",
                "ShortTitle": "",
                "Type": 1,
                "LastModifiedDate": "2021-06-23T08:27:39.860Z"
            },
            {
                "Id": 6556,
                "Title": "App",
                "ShortTitle": "",
                "Type": 1,
                "LastModifiedDate": "2021-06-23T09:21:33.900Z"
            }
        ],
        "ModuleStartDate": null,
        "ModuleEndDate": null,
        "IsHidden": false,
        "IsLocked": false,
        "Id": 5721,
        "Title": "Brightspace functionaliteiten",
        "ShortTitle": "",
        "Type": 0,
        "LastModifiedDate": "2021-06-23T11:19:45.540Z"
    },
    {
        "Description": {
            "Text": "\n\n\n\nOnder deze module vind je de inleveropdrachten van deze course.\nAls je deze module open klikt zie je een directe link naar de inleveropdracht, het is ook mogelijk om via de navigatielint direct naar de inleveropdrachten te gaan:\nKlik op 'Assessment' en kies 'Assignments'/'Opdrachten', je landt op de Assignments homepage. Hier zie je alle inleveropdrachten van deze course. \n\nKlik op de naam van een assignment om deze in te leveren. Je kan je ingeleverde opdracht altijd openen, ook als de einddatum is verstreken.\n\n\n\nBij het inleveren van een opdracht kun je kiezen voor het uploaden van een bestand, audio opnemen of video opnemen.\n\n",
            "Html": "\n\n\n\n\n<p><img src=\"/content/enforced/9820-PREP-TN0001/banner-narrow-high-density-min-size%20(2).jpg?_&amp;d2lSessionVal=2WoRATrKWF5wIjzUwUN3n2zDO\" title=\"\" style=\"max-width: 100%;\" width=\"1\" height=\"1\"/>Onder deze module vind je de inleveropdrachten van deze course.</p>\n<p>Als je deze module open klikt zie je een directe link naar de inleveropdracht, het is ook mogelijk om via de navigatielint direct naar de inleveropdrachten te gaan:</p>\n<p>Klik op &#39;Assessment&#39; en kies &#39;Assignments&#39;/&#39;Opdrachten&#39;, je landt op de Assignments homepage. Hier zie je alle inleveropdrachten van deze course.&#160;</p>\n<p><img src=\"/content/enforced/9820-PREP-TN0001/Inleveropdrachten.PNG?_&amp;d2lSessionVal=Eb4H0YkebWZaN4EOxO4Aqrz7x&amp;_&amp;d2lSessionVal=2WoRATrKWF5wIjzUwUN3n2zDO\" alt=\"\" title=\"\" width=\"943\" height=\"382\" style=\"max-width: 100%;\"/></p>\n<p>Klik op de naam van een assignment om deze in te leveren. Je kan je ingeleverde opdracht altijd openen, ook als de einddatum is verstreken.</p>\n<p></p>\n<p></p>\n<p><img src=\"/content/enforced/9820-PREP-TN0001/inleveren.PNG?_&amp;d2lSessionVal=9SHUIUk0fUp8ePw8y5Cznpzfa&amp;_&amp;d2lSessionVal=Eb4H0YkebWZaN4EOxO4Aqrz7x&amp;_&amp;d2lSessionVal=2WoRATrKWF5wIjzUwUN3n2zDO\" alt=\"Inleveren\" title=\"Inleveren\" width=\"780\" height=\"392\" style=\"max-width: 100%;\"/></p>\n<p>Bij het inleveren van een opdracht kun je kiezen voor het uploaden van een bestand, audio opnemen of video opnemen.</p>\n\n"
        },
        "ParentModuleId": null,
        "ModuleDueDate": null,
        "Structure": [
            {
                "Id": 6365,
                "Title": "Inleveropdracht 1",
                "ShortTitle": "",
                "Type": 1,
                "LastModifiedDate": "2021-09-23T11:58:41.287Z"
            },
            {
                "Id": 6366,
                "Title": "Inleveropdracht 2",
                "ShortTitle": "",
                "Type": 1,
                "LastModifiedDate": "2021-06-21T13:30:03.460Z"
            }
        ],
        "ModuleStartDate": null,
        "ModuleEndDate": null,
        "IsHidden": false,
        "IsLocked": false,
        "Id": 5743,
        "Title": "Opdrachten",
        "ShortTitle": "",
        "Type": 0,
        "LastModifiedDate": "2021-06-23T11:20:31.167Z"
    }
]
```

## Getting PDF from a powerpoint on Brightspace

Find url like this: `https://leren.windesheim.nl/d2l/api/hm/sequences/24534/activity/121876`
Find the `d2l-converted-doc` and get the href of it. With the href you can download a pdf file of the powerpoint
```json
{
    "class": [
        "release-condition-fix",
        "sequenced-activity"
    ],
    "properties": {
        "title": "Les 0. Introductie",
        "courseName": "Server technology",
        "canDownload": true,
        "canPrint": true
    },
    "entities": [
        {
            "class": [
                "icon",
                "tier1"
            ],
            "rel": [
                "icon"
            ],
            "properties": {
                "iconSetKey": "tier1:file-presentation",
                "imagePath": "https://s.brightspace.com/lib/bsi/20.22.7-212/images/tier1/file-presentation.svg"
            }
        },
        {
            "class": [
                "icon",
                "tier2"
            ],
            "rel": [
                "icon"
            ],
            "properties": {
                "iconSetKey": "tier2:file-presentation",
                "imagePath": "https://s.brightspace.com/lib/bsi/20.22.7-212/images/tier2/file-presentation.svg"
            }
        },
        {
            "class": [
                "activity",
                "file-activity"
            ],
            "rel": [
                "about"
            ],
            "properties": {
                "name": "Les 0. Introductie.pptx",
                "title": "Les 0. Introductie.pptx",
                "canDownload": true,
                "canPrint": true
            },
            "entities": [
                {
                    "class": [
                        "file"
                    ],
                    "rel": [
                        "about"
                    ],
                    "properties": {
                        "name": "Les 0. Introductie.pptx",
                        "title": "Les 0. Introductie.pptx",
                        "type": "application/vnd.openxmlformats-officedocument.presentationml.presentation",
                        "canDownload": true,
                        "canPrint": true
                    },
                    "entities": [
                        {
                            "class": [
                                "last-modified",
                                "date"
                            ],
                            "rel": [
                                "item"
                            ],
                            "properties": {
                                "date": "2022-03-15T06:06:58.360Z"
                            }
                        }
                    ],
                    "links": [
                        {
                            "rel": [
                                "alternate"
                            ],
                            "type": "application/vnd.openxmlformats-officedocument.presentationml.presentation",
                            "href": "https://leren.windesheim.nl/d2l/api/le/1.12/24534/content/topics/121876/file?stream=true"
                        },
                        {
                            "class": [
                                "embed"
                            ],
                            "rel": [
                                "alternate"
                            ],
                            "type": "application/vnd.openxmlformats-officedocument.presentationml.presentation",
                            "href": "https://leren.windesheim.nl/content/enforced/24534-ICT.SE.SRVR.V20/Les%200.%20Introductie.pptx"
                        },
                        {
                            "class": [
                                "view"
                            ],
                            "rel": [
                                "alternate"
                            ],
                            "type": "application/vnd.openxmlformats-officedocument.presentationml.presentation",
                            "href": "https://leren.windesheim.nl/d2l/le/content/24534/viewContent/121876/View"
                        },
                        {
                            "class": [
                                "fullscreen"
                            ],
                            "rel": [
                                "alternate"
                            ],
                            "type": "application/vnd.openxmlformats-officedocument.presentationml.presentation",
                            "href": "https://leren.windesheim.nl/d2l/le/content/24534/fullscreen/121876/View?asv=False&skipHeader=True"
                        },
                        {
                            "class": [
                                "docreader"
                            ],
                            "rel": [
                                "alternate"
                            ],
                            "type": "application/vnd.openxmlformats-officedocument.presentationml.presentation",
                            "href": "https://leren.windesheim.nl/d2l/api/readspeaker/docreader/getDocReaderFileUrl/24534/topic/121876?preformRedirect=1"
                        },
                        {
                            "class": [
                                "download"
                            ],
                            "rel": [
                                "alternate"
                            ],
                            "type": "application/vnd.openxmlformats-officedocument.presentationml.presentation",
                            "href": "https://leren.windesheim.nl/d2l/api/le/1.12/24534/content/topics/121876/file?stream=false"
                        },
                        {
                            "class": [
                                "pdf",
                                "d2l-converted-doc"
                            ],
                            "rel": [
                                "alternate"
                            ],
                            "type": "application/pdf",
                            "href": "https://d2l-docbuilder-prod-eu-west-1-converted.s3.eu-west-1.amazonaws.com/295785a6-7922-4ff5-b94f-71dc1e77ffc8/3d852b0be813167a71aeb13eb8972e68.pdf?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=ASIA5AF533RDSLCBFOVM%2F20220729%2Feu-west-1%2Fs3%2Faws4_request&X-Amz-Date=20220729T133628Z&X-Amz-Expires=5460&X-Amz-Security-Token=IQoJb3JpZ2luX2VjELz%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCWV1LXdlc3QtMSJGMEQCIBfL6JbL5WbEH5FYCCKP1GJ8E4iqzJ%2B4l0hkQubgkX7%2FAiASJHAT%2FIbkLT5s713SPIsFF0iznD7SX5VQHHR9Vk3e9ir%2FAwgVEAMaDDg5Mzc1MTM4NTE1OSIMrWqKCmCiilOXbTs8KtwDtXsZS7KmMAUoae0bwOGGDuHp3H7anFyk0j9rEwMdSg0evuG8QL4yyot9ZcnW4d37SCXniMYj%2BEhUFQp6RQYQGCiAAy17Wj6nxPy5VHXEGL8ffSmGJqGpoLpDMM2BaiaijDBZSHOTZpa90%2FAx9xYiV9C16Lda5Z9zM6b%2BZ65rlOBTUeFnSVf9eIfwgx4YRfmbEqL8%2FWO6gMYsT9bxJqjcbJYFKXknV0FhdlD%2BxsGLZrLE1i8WvMHqXGXfAXxPGaGu%2Fcj0s9fub%2Bn0sfFYCXt9gre%2FvJiYA5m9FonjFUR1ngXM91Tvk58Y5HyEZZTEgVK3l6legX8BSdqG5KsuGPuW1lgG%2FPXC16%2FG5SQFdGgvwFAjdR%2ByLOWT3ooQv6Mo6pPN5xVjQ9tUuHjFBYfcnKVk8Ek%2BeZXEPYLiQvEoUkaDoKG%2FbvZZH8MugvZmLSntqr9zT8DHG6DfPDFH%2BfQQCCfkAZ0mdRp%2BuMOGRIqkVtFIJW4p4cKPN0JpRClni2OgTZQ5pQeyV%2FZv7i7ylicDXyF6Wb7UisGzfyeChudRbEJjCUNaSuOp5TotSYTN%2BQ5mkdx1P9KJFwRL6NnGB6ms2dpvJfy%2BO%2BzE7ZOSZz%2Bl5kJEtGabaCHUOBtmEuOVFO0wmI2PlwY6pgEGHR4MyaS%2BMuGDMTFnUO28rxVmvMQx5oZ3fBXnoLEXZn46dHquy9Kkeu4abP4tGCku8oYLx8Tu%2FXwFiuHVCAeWV%2FX83LmjALgEee50ItNnAxLYFAj1UpUwqOIiOo7XuCIq27oJaLdVpyrcBr9JO2HesjBkCnrPHS%2B8HnqNEJnh80gdD0m2H%2FRsjd3iu7WerGATlKr%2BYw0vA350cBKIdLVSrRANXJkM&X-Amz-Signature=f24a8562d5ad7ece9facdb93368e840c58554896fbd95d0731904c053adb7b20&X-Amz-SignedHeaders=host"
                        }
                    ]
                },
                {
                    "class": [
                        "last-viewed",
                        "date"
                    ],
                    "rel": [
                        "item"
                    ],
                    "properties": {
                        "date": "2022-07-29T13:51:42.467Z"
                    }
                },
                {
                    "class": [
                        "completion",
                        "completed"
                    ],
                    "rel": [
                        "item",
                        "https://api.brightspace.com/rels/completion"
                    ],
                    "entities": [
                        {
                            "class": [
                                "auto",
                                "completion",
                                "date"
                            ],
                            "rel": [
                                "item"
                            ],
                            "properties": {
                                "date": "2022-07-13T14:10:50.317Z"
                            }
                        }
                    ],
                    "links": [
                        {
                            "rel": [
                                "alternate"
                            ],
                            "href": "https://295785a6-7922-4ff5-b94f-71dc1e77ffc8.sequences.api.brightspace.com/24534/activity/121876/completion"
                        }
                    ]
                }
            ],
            "actions": [
                {
                    "href": "https://295785a6-7922-4ff5-b94f-71dc1e77ffc8.sequences.api.brightspace.com/24534/activity/121876/view?hasStateChanged=0&hasBeenViewed=1&filterOnDatesAndDepth=1",
                    "name": "view-activity",
                    "method": "POST"
                },
                {
                    "href": "https://295785a6-7922-4ff5-b94f-71dc1e77ffc8.sequences.api.brightspace.com/24534/activity/121876/view?hasStateChanged=0&hasBeenViewed=1&filterOnDatesAndDepth=1",
                    "name": "view-activity-duration",
                    "method": "PUT"
                },
                {
                    "href": "https://295785a6-7922-4ff5-b94f-71dc1e77ffc8.sequences.api.brightspace.com/24534/activity/121876/set-last-viewed-content-object",
                    "name": "set-last-viewed-content-object",
                    "method": "POST"
                }
            ]
        }
    ],
    "links": [
        {
            "rel": [
                "https://api.brightspace.com/rels/organization"
            ],
            "href": "https://295785a6-7922-4ff5-b94f-71dc1e77ffc8.organizations.api.brightspace.com/24534"
        },
        {
            "class": [
                "default-user-return-location"
            ],
            "rel": [
                "https://sequences.api.brightspace.com/rels/default-return-url"
            ],
            "type": "text/html",
            "href": "https://leren.windesheim.nl/d2l/le/enhancedSequenceViewer/24534/backToContent"
        },
        {
            "rel": [
                "https://sequences.api.brightspace.com/rels/sequence-viewer-application"
            ],
            "type": "text/html",
            "href": "https://leren.windesheim.nl/d2l/le/enhancedSequenceViewer/24534?redirect=true&url=https%3a%2f%2f295785a6-7922-4ff5-b94f-71dc1e77ffc8.sequences.api.brightspace.com%2f24534%2factivity%2f121876%3ffilterOnDatesAndDepth%3d1"
        },
        {
            "rel": [
                "alternate"
            ],
            "type": "text/html",
            "href": "https://leren.windesheim.nl/d2l/le/content/24534/viewContent/121876/View"
        },
        {
            "rel": [
                "up"
            ],
            "href": "https://295785a6-7922-4ff5-b94f-71dc1e77ffc8.sequences.api.brightspace.com/24534/activity/121875?filterOnDatesAndDepth=1"
        },
        {
            "class": [
                "sequenced-activity"
            ],
            "rel": [
                "self",
                "describes"
            ],
            "href": "https://295785a6-7922-4ff5-b94f-71dc1e77ffc8.sequences.api.brightspace.com/24534/activity/121876?filterOnDatesAndDepth=1"
        }
    ],
    "rel": [
        "item"
    ]
}
```