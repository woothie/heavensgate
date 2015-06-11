@echo off
rem Cheridan asked for this. - N3X
call python ss13_genchangelog.py ../../html/changelog.html ../../html/changelogs
rem use the following example for custom changelogs:
rem python ss13_genchangelog.py ../../html/changelog.html ../../html/changelogs -changelogCache ".baystation_changelog.yml .nullstation_changelog.yml .custom_changelog.yml"
pause
