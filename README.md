# carrot-lang

A simple templating language that can be embedded into HTML. Using this for image uploader for custom user pages. Use file extension `.html.crt`.

## Usage

Embed carrot in html between `{{ }}`. Note, this does not work at all yet. Like, not even a little bit.

```html
<body>
  {{ name="Matt" }}
  <p>Hi, This is {{ name }}'s website.</p>

  {{ photos }}
  <image>{{ photo.path }}</image>
  {{ photos }}
</body>
```
