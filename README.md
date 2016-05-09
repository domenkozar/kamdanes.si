Simple website showing todays event in Ljubljana.

# Development

Make sure you create `kamdanes.cfg` with following contents:

    kamdanes {
      accesstoken = "<facebook access token>"
      connstr = "dbname=kamdanes user=myuser"
      places = [ "123123/events",
                 "myfavoritebar/events" ]
    }


- $ bash <(curl https://nixos.org/nix/install)
- $ nix-shell
- $ reserve

# Bootstrap

To bootstrap default.nix

- $ nix-shell -p haskellPackages.cabal2nix
- $ cabal2nix --shell . > default.nix

# Running tests

- $ cabal test

# Deployment

- $ nix-build
- $ result/bin/kamdanes-serve
- $ result/bin/kamdanes-getevents

# Build frontend

- $ cd frontend
- $ nix-shell --run "npm i && npm run dev"


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
