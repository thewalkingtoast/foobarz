# README

Run `docker-compose up` and notice that the single `css` service exits with:

```shell
yarn run v1.22.17
$ tailwindcss -i ./app/assets/stylesheets/application.tailwind.css -o ./app/assets/builds/application.css --minify --watch
css_1  | /bin/sh: 1: tailwindcss: not found
error Command failed with exit code 127.
```

Then run `docker run -ti mbp bash` followed by `yarn build:css --watch` and notice it works.
