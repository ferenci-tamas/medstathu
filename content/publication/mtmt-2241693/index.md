---
# Documentation: https://wowchemy.com/docs/managing-content/

title: Statisztikai tesztek robusztusságának vizsgálata GP-GPU számítási módszerrel
subtitle: ''
summary: ''
authors:
- Tamás Ferenci
- Balázs Gyula Kotosz
tags: []
categories: []
date: '2010-01-01'
lastmod: 2023-04-10T20:23:13+02:00
featured: false
draft: false

# Featured image
# To use, add an image named `featured.jpg/png` to your page's folder.
# Focal points: Smart, Center, TopLeft, Top, TopRight, Left, Right, BottomLeft, Bottom, BottomRight.
image:
  caption: ''
  focal_point: ''
  preview_only: false

# Projects (optional).
#   Associate this post with one or more of your projects.
#   Simply enter your project's folder or file name without extension.
#   E.g. `projects = ["internal-project"]` references `content/project/deep-learning/index.md`.
#   Otherwise, set `projects = []`.
projects: []
publishDate: '2023-04-10T18:23:12.835653Z'
publication_types:
- '0'
abstract: Egy statisztikai teszt robusztussága azt jelenti, hogy érvényes (valid)
  marad akkor is, ha alkalmazásának feltételei nem teljesülnek. Tanulmányunkban számítógép
  segítségével nagyon sok mintát generálunk (amelyek beállításunk szerint az alkalmazási
  feltételeknek megfelelő, vagy azt irányítottan megsértő sokaságból származnak),
  elvégezzük a teszteket, és összehasonlítjuk a tapasztalt elsőfajú hibaarányt a választott
  szignifikancia-szinttel. A robosztusság vizsgálatának ez az ún. Monte Carlo szimulációs
  módszere (főképp a nagyszámú véletlenszám-generálás miatt) rendkívül számításigényes,
  hagyományosan csak szuperszámítógépekkel hajtható végre hatékonyan. Ugyanakkor egy
  új megközelítés, a GP-GPU módszer lehetővé teszi, hogy mindezt szokásos, bárki számára
  elérhető grafikus kártyák segítségével nagyságrendekkel rövidebb idő alatt elvégezzük.
publication: ''
links:
- name: URL
  url: https://m2.mtmt.hu/api/publication/2241693
---
