Simple website showing todays event in Ljubljana.

# Development

Make sure you create `kamdanes.cfg` with following contents:

    kamdanes {
      accesstoken = "<facebook access token>"
      connstr = "dbname=kamdanes user=myuser"
    }


- $ bash <(curl https://nixos.org/nix/install)
- $ nix-shell
- $ reserve

# Deployment

- $ nix-build
- $ result/bin/kamdanes-serve
- $ result/bin/kamdanes-getevents


# Material read for learning haskell pieces

- https://github.com/hspec/hspec-wai
- http://www.serpentine.com/wreq/
- http://www.yesodweb.com/book/persistent
- https://developers.facebook.com/docs/graph-api/reference/v2.2/event/picture?locale=en_GB
- http://taylor.fausak.me/2014/10/21/building-a-json-rest-api-in-haskell/
- http://www.cs.nott.ac.uk/~gmh/monads
- http://blog.raynes.me/blog/2012/11/27/easy-json-parsing-in-haskell-with-aeson/
- http://adit.io/posts/2012-03-10-building_a_concurrent_web_scraper_with_haskell.html


# Restful API

`GET /events`
    
    {
      "events": [
        {
          title: "..",
          location: "..",
          description: "..",
          image: "..",
          price: "..",
          time: "..",
          link: "..",
        },
      ]
    }

# TODO

- handle paid events
- use async http://hackage.haskell.org/package/async-2.0.2/docs/Control-Concurrent-Async.html#v%3amapConcurrently
- https://hackage.haskell.org/package/raven-haskell-scotty
- SPDY
- remove JSX Transformer in production
