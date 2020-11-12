const { environment } = require('@rails/webpacker')

//Make jQuery available in our app by editing Webpack’s environment file and add content
const webpack = require('webpack')
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery'
  })
)

module.exports = environment
