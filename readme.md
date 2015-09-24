# Hyprtxt Hapi

Cool stuff!

### Dependencies

* Chrome with [LiveReload Extension](https://chrome.google.com/webstore/detail/livereload/jnihajbhpnppcggbcgedagnkighmdlei?hl=en)

### Configuration

** Server Secrets **

1. Rename `./config/_secret.coffee` to `./config/secret.coffee`
2. Add your social auth secrets

`./config/secret.coffee` is ignored by `git`, don't commit your secrets!

** View Config **

`./config/frontend.coffee` is passed to all Jade templates. Use it for global front-end configuration values.

# Hyprtxt Gulp

* SASS (Source Mapping, AutoPrefixing)
* CoffeeScript (Source Mapping)
* LiveReload (Via Chrome Extension)

files in the `./src` directory are compiled and output to the `./static_generated` directory

Install NVM

```
sudo apt-get install build-essential
forever start --uid "auth.hyprtxt.com" --append -c ./node_modules/coffee-script/bin/coffee index.coffee
```
