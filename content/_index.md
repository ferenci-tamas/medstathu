---
# Leave the homepage title empty to use the site title
title: 'Ferenci Tamás honlapja'
summary: 'Ferenci Tamás honlapja: biostatisztika, orvosi kutatások kritikus értékelése, tananyagok, esszék, hobbi projektek.'
type: landing

sections:
  - block: resume-biography-3
    id: about
    content:
      # Choose a user profile to display (a folder name within `content/authors/`)
      username: ferenci-tamas
      text: |-
        Klinikai biostatisztikus vagyok, abból a fajtából, akinek fontos, hogy ugyanannyira lássák egészségügyi dolgozónak mint statisztikusnak. Számomra a statisztika nem csak számok feldolgozását jelenti, mert a biostatisztikában minden szám mögött betegek sorsai vannak, és munkánktól ezen sorsok alakulása függ. Meggyőződésem, hogy az orvosi kutatások módszertanának ismerete nem csak az orvosoknak, hanem minden tájékozódni vágyó állampolgárnak fontos, ezért a munkámon felül szívügyem az ilyen ismeretek terjesztése is. A transzparencia és a nyílt tudomány feltétlen híve vagyok, szeretek másokkal vitatkozni, és azt is szeretem, ha velem vitatkoznak. Foglalkoztatnak a magyar egészségügy rendszerszintű kérdései is. Szeretek esszéket írni, a legkülönfélébb hobbi-projektekkel elszúrni az időmet, és eljárni teljesítménytúrázni.
        {style="text-align: justify;"}

        <hr>

        <div class="flex-container">
            <div class="left-text">
                <p>"A valószínűségszámítás nem más...</p>
                <p>...mint számokra átváltott józan ész."</p>
                <p>(Pierre-Simon de Laplace, 1749-1827)</p>
            </div>
            <div class="right-text">
                <p>"Statisztikával hazudni könnyű...</p>
                <p>...de statisztika nélkül még könnyebb."</p>
                <p>(Charles Frederick Mosteller, 1916-2006)</p>
            </div>
        </div>

        <style>
        .flex-container {
            display: flex;
            justify-content: space-between;
            width: 100%;
        }
        .right-text {
            text-align: right;
        }

        @media (max-width: 800px) {
            .flex-container {
                flex-direction: column;
                justify-content: center;
                align-items: center;
            }
          .left-text {
                margin-bottom: 50px;
            }
            .right-text {
                text-align: left;
            }
        }
        </style>
      # Show a call-to-action button under your biography? (optional)
      # button:
      #   text: Download CV
      #   url: uploads/resume.pdf
      # headings:
      #   about: ''
      #   education: ''
      #   interests: ''
    design:
      # Use the new Gradient Mesh which automatically adapts to the selected theme colors
      background:
        gradient_mesh:
          enable: false

      # Name heading sizing to accommodate long or short names
      name:
        size: md # Options: xs, sm, md, lg (default), xl

      # Avatar customization
      avatar:
        size: large # Options: small (150px), medium (200px, default), large (320px), xl (400px), xxl (500px)
        shape: circle # Options: circle (default), square, rounded
  - block: portfolio
    id: oktatas    
    content:
      title: Oktatás
      sort_by: 'Weight'
      filters:
        folders:
          - oktatas    
      # Default filter index (e.g. 0 corresponds to the first `filter_button` instance below).
      default_button_index: 0
      # Filter toolbar (optional).
      # Add or remove as many filters (`filter_button` instances) as you like.
      # To show all items, set `tag` to "*".
      # To filter by a specific tag, set `tag` to an existing tag name.
      # To remove the toolbar, delete the entire `filter_button` block.
      buttons:
        - name: Összes
          tag: '*'
        - name: Orvostudomány
          tag: Orvostudomány
        - name: Matematika
          tag: Matematika
        - name: Statisztika
          tag: Statisztika
        - name: R nyelv
          tag: R nyelv
    design:
      columns: 2
      view: card
  - block: portfolio
    id: projektek
    content:
      title: 'Projektjeim'      
      subtitle: "Hobbi-projektek, különféle vegyes (tudományos és nem annyira tudományos) cikkeim és egyéb írásaim."
      filters:
        folders:
          - projektek
      sort_by: 'Date'
      sort_ascending: false
      count: 0
    design:
      columns: 4
      view: card
  - block: collection
    id: esszek
    content:
      title: 'Esszéim'      
      text: "Az esszé a tudományos munkák, a szépirodalmi művek, valamint a szónoki beszédek közötti átmeneti műfaj. Jellemzően elmélkedő, gondolkodtató szövegek: olyan kérdéseket, problémákat fogalmaznak meg, amelyek foglalkoztatják az embereket, és gyakran tartalmaznak javaslatot a megoldásra is. ... Az esszé témáját merítheti az irodalomból, a tudományos felfedezésekből, a politikai életből vagy a mindennapi élet megfigyeléséből. Az esszé erősen tükrözi írója véleményét ... az író személyes véleményét tudományos igényességgel fogalmazza meg. ... Az esszé olyan prózát takar, ami egy adott témával kapcsolatban párbeszédet generál."
      filters:
        folders:
          - esszek
      sort_by: 'Date'
      sort_ascending: true
      count: 0
    design:
      columns: 1
      view: date-title-summary
  - block: markdown
    id: contact
    content:
      title: Kapcsolat
      text: 'E-mail címem: <tamas.ferenci@medstat.hu>.'
---
