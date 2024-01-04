echo on
git add . && git commit -m "end of day auto-commit" && git push -u origin master && flutter build web && firebase deploy --only functions
