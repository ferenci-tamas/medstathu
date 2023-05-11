---
# Leave the homepage title empty to use the site title
title: Ferenci Tamás honlapja
type: landing

sections:
  - block: about.avatar
    id: about
    content:
      # Choose a user profile to display (a folder name within `content/authors/`)
      username: admin
      # Override your bio text from `authors/admin/_index.md`?
      text:
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
      # Choose how many columns the section has. Valid values: '1' or '2'.
      columns: '1'
      view: showcase
      # For Showcase view, flip alternate rows?
      flip_alt_rows: false
  - block: portfolio
    id: projektek
    content:
      title: 'Projektjeim'      
      text: "Hobbi-projektek, különféle vegyes (tudományos és nem annyira tudományos) cikkeim és egyéb írásaim.<hr>"
      filters:
        folders:
          - projektek
      sort_by: 'Date'
      sort_ascending: false
      count: 0
    design:
      columns: '1'
      view: 3
  - block: collection
    id: esszek
    content:
      title: 'Esszéim'      
      text: "\"Az esszé a tudományos munkák, a szépirodalmi művek, valamint a szónoki beszédek közötti átmeneti műfaj. Jellemzően elmélkedő, gondolkodtató szövegek: olyan kérdéseket, problémákat fogalmaznak meg, amelyek foglalkoztatják az embereket, és gyakran tartalmaznak javaslatot a megoldásra is. ... Az esszé témáját merítheti az irodalomból, a tudományos felfedezésekből, a politikai életből vagy a mindennapi élet megfigyeléséből. Az esszé erősen tükrözi írója véleményét ... az író személyes véleményét tudományos igényességgel fogalmazza meg. ... Az esszé olyan prózát takar, ami egy adott témával kapcsolatban párbeszédet generál.\" <hr>"
      filters:
        folders:
          - esszek
      sort_by: 'Date'
      sort_ascending: true
      count: 0
    design:
      columns: '2'
      view: compact
  - block: collection
    id: publications
    content:
      title: Tudományos közlemények
      filters:
        folders:
          - publication
    design:
      columns: '2'
      view: citation
  - block: contact
    id: contact
    content:
      title: Kapcsolat
      subtitle:
      # Contact (add or remove contact options as necessary)
      email: tamas.ferenci@medstat.hu
      # Automatically link email and phone or display as text?
      autolink: true
    design:
      columns: '2'
---
