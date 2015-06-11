Changelogs are included with commits as text .yml files created individually by the committer. If you want to create a changelog entry you create a .yml file in the /changelogs directory; nothing else needs to be touched unless you are a maintainer.

#######################################################

TO MAKE A CHANGELOG .YML ENTRRY

1. Make a copy of the file example.yml in html/changelogs and rename it to [YOUR USERNAME]-PR-[YOUR PR NUMBER].yml or [YOUR USERNAME]-[YOUR BRANCH NAME]. Only the username is strictly required, anything else is organizational and can be ignored if you so wish.

2. Change the author to yourself

3. Replace the changes text with a description of the changes in your PR, keep the double quotes to avoid errors (your changelog can be written ICly or OOCly, it doesn't matter)

4. (Optional) set the change prefix (rscadd) to a different one listed above in example.yml (this affects what icon is used for your changelog entry)

5. When commiting make sure your .yml file is included in the commit (it will usually be unticked as an unversioned file)

#######################################################

VALID PREFIXES

bugfix       for fixes
wip          for works in progress
tweak        for tweak to existing functionality
soundadd     added media files
sounddel     removed media files
rscadd       general deleting of nice things
rscdel       general adding of nice things
imageadd     added image or sprite file
imagedel     removed image or sprite file
maptweak     for tweaks to the map
spellcheck   for fixes of spelling
experiment   for experimental features

#######################################################

If you have trouble ask for help in #codershuttle on irc.sorcery.net or read https://tgstation13.org/wiki/Guide_to_Changelogs
